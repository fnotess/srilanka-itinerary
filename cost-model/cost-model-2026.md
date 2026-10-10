# Cost model, first pass (2026-10-10)

Data: [rates-2026.csv](rates-2026.csv). Calculator: `python3 estimate.py`.

Every figure carries a status:
- **published**: taken from a dated 2026 secondary source (link in the CSV). Not official.
- **conflicting**: sources disagree; the range spans both.
- **guessed**: my estimate with no source. Treat as a placeholder.

**Nothing here is verified against an official source.** The Central Cultural Fund
(heritage sites), Department of Wildlife Conservation (parks) and Sri Lanka Railways
(eservices.railway.gov.lk) are where to check before any figure goes in a customer quote.

## Sample: 10-day classic loop, 2 adults, 1 room, off-peak, car + driver
Negombo → Sigiriya/Dambulla/Polonnaruwa → Kandy → Ella → Yala → south coast.

| Tier | Trip total (2 people) | Per person |
|---|---|---|
| Budget | $1,140 – $1,800 | $570 – $900 |
| Mid-range | $1,520 – $2,650 | $760 – $1,330 |
| Boutique | $1,970 – $3,280 | $980 – $1,640 |
| Luxury | $2,730 – $6,330 | $1,360 – $3,170 |

Driver ($500–700) and entries ($300–330 for two) are fixed across tiers, so for
budget travellers the driver is ~40% of the trip. That's the segment most likely to
skip a private driver for trains and buses.

## Figures you can lean on (two 2026 sources agree)
- Sigiriya USD 35 (child 20, SAARC 20)
- Polonnaruwa USD 30, Anuradhapura sacred area USD 30
- Lotus Tower USD 20
- National park base ticket USD 25, but the **all-in** cost is ~USD 42–45 at Yala once
  service charge and 15% VAT are added (operator blog), plus a mandatory jeep at
  USD 40–55 per half day. Most cost blogs quote the USD 25 and undercount.

## Figures that are guesses and matter most
1. **What you pay a licensed driver (USD 38–52/day, guessed).** Your whole margin is
   retail minus this. Retail is USD 50–70 for a car. If wholesale is USD 45, you make
   about USD 10–15/day, so ~USD 100–150 on a 10-day trip. Get 5 real quotes from your
   contacts before anything else; it decides whether revenue line 2 is a business.
2. **National guide day rate (USD 40–70, guessed).** No current published rate found.
3. **Hotel affiliate share (3–6% of booking value, guessed).** On a mid-range trip
   that's ~USD 10–45. Small. Don't plan around it.
4. **FX (LKR 290–310 per USD, guessed).**

## Pushback on the model
- **The ranges are too wide to sell.** "$1,520 – $2,650" doesn't help a customer
  decide. Tighten by pricing hotels per base town and season (Ella and Galle Fort cost
  more than Dambulla at the same tier) rather than one national band.
- **The itinerary fee earns nothing from your best customers.** It's credited back
  exactly when they book the driver. That's fine as a conversion tool, but it means
  per-trip revenue is the driver markup, ~USD 100–150 per booked trip at today's guesses.
  You'd need roughly 10 booked trips a month for USD 1,000–1,500 gross, before refunds,
  driver no-shows and your time on WhatsApp.
- **Train-booking fee is near-zero for now.** The Kandy side of the upcountry line has
  been suspended since Cyclone Ditwah (Nov 2025). Nanu Oya–Ella reopened 2026-07-18;
  Kandy–Nanu Oya has an official target of end-2026 / early 2027, with no timetable as
  of 2026-10-07 ([byc.lk](https://byc.lk/colombo-kandy-ella-train-status-2026)). Don't
  build the Phase 1 pitch around "we get you the Kandy–Ella train" until it's running.
- **Pinnawala** is on the fee list but carries animal-welfare criticism; a brand that
  positions as the thoughtful alternative probably shouldn't sell it.
