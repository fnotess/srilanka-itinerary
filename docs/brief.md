# Brief: settled decisions

Copied from the founder's project brief of 2026-10-10. These are **settled**; don't
re-open them without the founder asking. Open items live in
[open-questions.md](open-questions.md).

## Builder constraints
- One senior backend engineer (Java/Spring Boot primary; also Python, Node, TS,
  React, Angular; AWS SA Pro; MSc Data Science; MBA Finance).
- Sri Lankan, based in Singapore, family/contacts on the ground in Sri Lanka.
- Full-time job: **evenings and weekends only.** Plans must fit that.
- Has a small partner team for freelance client work.

## Product
Foreign tourists browse attractions, tick the ones they want, enter dates, group size,
budget tier and arrival airport, and receive a **paid, customised day-by-day itinerary
with anticipated costs**.

Attached services (mostly referral/commission):
private vehicle + driver, hotel booking (Booking.com / Agoda affiliate), airport pickup,
licensed guides, railway ticket booking (notably Kandy–Ella).

Social (Facebook, Instagram, TikTok) is intended as the primary acquisition channel.

## Revenue model
1. Itinerary fee, ~USD 15–30, credited back if they book transport/guide through us
2. Markup on drivers and guides from a vetted network (best margin; the moat is the
   on-the-ground ops relationships, not the software)
3. Hotel and tour affiliate commissions
4. Airport pickup
5. "We book your train tickets" service fee

## Build sequence
**Phase 1: concierge MVP, 2–4 weekends.** Simple site (Framer/Webflow/Next.js),
30–50 attraction cards (photo, region, time needed, entry fee). Selection form creates a
lead. Itinerary built **by hand**, sent as a polished PDF. All comms over WhatsApp.
Purpose: prove people pay before writing real software.

**Phase 2: the real app, only after paying customers exist.**
- Attraction DB: location, hours, foreigner vs local fees, time needed, best season
  (SW vs NE monsoon), region
- Route engine: orders places by real travel time, flags impossible plans, suggests
  overnight stops
- Cost estimator: driver/day + hotel tier × nights + entry tickets + guide fees, as a
  low–high range
- LLM-drafted itinerary, human-reviewed before sending
- Stack: Next.js + Spring Boot or Node + Postgres/PostGIS + a maps API

## Hard constraints
- **SLTDA registration.** Tour operators, travel agents and guides generally need Sri
  Lanka Tourism Development Authority registration. Use only licensed chauffeur-guides
  and national guides. What the business entity itself needs is still to be confirmed.
- **Payments.** Stripe does not support Sri Lankan businesses. Options: Singapore entity
  with Stripe, or PayHere locally. Unresolved.
- **Day-job conflict.** Review the employment contract for side-business /
  conflict-of-interest clauses before any public launch.

## Naming research (done 2026-09-27, do not redo)
21 .com domains checked via Verisign RDAP, plus competitor searches.

Rejected:
- Tuk Tuk Trails: two active Sri Lankan businesses use it; tuktuktrails.com taken (2024).
- Anything "Serendib": the most crowded word in the market.
- hopperroute.com: Hopper Inc. holds a US trademark on HOPPER for travel booking.
- Taken: ceylonroute, lankaroute, ceylontrails, lankaloop, wanderlanka, roamlanka,
  twocoasts, theislandroute, pearlroute, srilankaitinerary, lankawayfinder.

Available as of 2026-09-27:
- **monsoonroute.com** (front-runner)
- planmyceylon.com (safe fallback)
- planmylanka.com
- wayfarelanka.com (wayfarers.lk is an active competitor)
- islandhoplanka.com (weak; "Island Hop" is a stock package name)

## Brand direction (placeholder "Monsoon Route")
- Logo: teardrop outline (island + "pearl of the Indian Ocean") with a route line
  through it. Legible at 16px.
- Palette: Deep Teal `#0F5F55` (primary), Clay `#C2622E` (accent), Ink `#14231F` (text),
  Sand `#FAF7F0` (ground, never pure white). Support: `#E2DCCE` line, `#5A6B64` muted,
  `#8F4318` clay-deep for small text, `#E8A46B` clay-light.
- Avoids the turquoise-and-palm-tree look competitors use.
- Type: Fraunces (display) over Karla (body). Avoid Inter / Poppins / Montserrat.
- Contrast: Clay `#C2622E` only at 24px+ or as a fill; `#8F4318` for small text on sand.
