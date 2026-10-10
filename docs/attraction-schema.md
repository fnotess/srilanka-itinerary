# Attraction DB schema: design notes

Schema: [../db/schema.sql](../db/schema.sql). Sample rows: [../db/seed-sample.sql](../db/seed-sample.sql).
Loaded and checked against Postgres 16.x + PostGIS 3 on 2026-10-10 (schema, seed,
current-fee view, and the fee-overlap constraint rejecting a clashing row).

**This is Phase 2.** Phase 1 runs off 30–50 cards in a spreadsheet or CMS. Shape the
Phase 1 spreadsheet columns like these tables (slug, region, visit minutes min/max, fee
per visitor category with source and date) so it imports cleanly later.

## Decisions and why

1. **`place` supertype, `attraction` subtype.** The route engine travels between
   attractions, overnight towns, airports and rail stations. One `place` table means one
   `travel_leg` table and one spatial index instead of four.

2. **Fees are effective-dated and never overwritten.** Sri Lankan foreigner fees move
   every year or two (Sigiriya went USD 30 → 35; Dambulla moved to LKR 3,000 in 2025).
   A quote sent in March must be explainable in June. `attraction_fee.valid_during` is a
   `daterange` with an exclusion constraint so two prices can't overlap for the same
   place and visitor category.

3. **Every price carries `confidence` + `source_url` + `checked_on`.** Values are
   `verified` / `published` / `estimated`. The cost estimator should refuse to show an
   `estimated` fee to a customer without a human override. This is the same known vs
   guessed rule as the brief, enforced in data.

4. **Fees in their native currency (USD or LKR).** The Central Cultural Fund prices big
   sites in USD; temples and smaller sites charge LKR. Converting at write time bakes in
   a stale rate. Convert at quote time.

5. **SAARC is its own visitor category.** Indian and Maldivian visitors pay different
   rates from other foreigners at most CCF sites and national parks. India is one of the
   largest source markets, so this isn't an edge case.

6. **Season is per month, two levels.** `region_season` holds the monsoon default
   (south/west good Dec–Apr, east good Apr/May–Sep). `attraction_season` overrides where a
   site differs from its region (Minneriya elephant gathering Jul–Sep, Mirissa whales
   Nov–Apr, Trinco whales Mar–Aug). This is the data behind the "which coast in which
   month" pitch.

7. **Travel times are a cached table, not computed from geometry.** Straight-line
   distance is useless here: Kandy–Ella is about 95 km as the crow flies and 5+ hours by
   road. `travel_leg` is filled from a maps API, and `driver_override` lets your drivers
   correct it, which they will need to on hill-country roads.

8. **Disruptions are first-class.** `travel_disruption` and `attraction_closure` exist
   because the Kandy–Ella rail section has been cut since Cyclone Ditwah (Nov 2025) and
   Yala closes for part of each year. The route engine must stop offering a leg that a
   current disruption covers.

## Deliberately left out (add when there's a reason)
- Hotels: affiliates (Booking.com/Agoda) own that data. Store only the tier price bands
  per base town in the cost model.
- Drivers, guides, bookings, customers: separate operational schema. Different lifecycle
  and PII rules.
- Multilingual text: English only until a market asks.
- Opening hours exceptions for Poya days: use `attraction_closure` until it gets messy.
