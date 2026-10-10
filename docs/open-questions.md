# Open questions: status

Last updated 2026-10-10.

| # | Question | Status | Where |
|---|---|---|---|
| 1 | Social handles for the chosen name | **Blocked on you.** Platforms block automated checks. 2-minute manual check. | [social-handles.md](social-handles.md) |
| 2 | Final name | Open. See note below. | |
| 3 | Attraction DB schema | **Drafted** and tested on Postgres 16 + PostGIS. | [attraction-schema.md](attraction-schema.md) |
| 4 | 2026 cost model | **First pass done.** Each figure marked published / conflicting / guessed. | [../cost-model/cost-model-2026.md](../cost-model/cost-model-2026.md) |
| 5 | Payment / entity structure | **First pass done.** Key finding: SLTDA agencies must operate from Sri Lanka. | [payments-and-entity.md](payments-and-entity.md) |
| 6 | Social content strategy | Not started. | |

## 2. Name: my view
"Monsoon reads as rain" is a real risk for a cold audience on TikTok, but it's also the
only name on the list that says what's different about the product (which coast in
which month). A tagline fixes the skim problem ("the right coast for your month").
planmyceylon is safe but generic and sounds like every itinerary planner. My lean:
keep Monsoon Route **if** the handles are clean; that check is the real decider.
This is opinion, not research.

## New issue found: Kandy–Ella train
The Kandy-side upcountry rail line has been suspended since Cyclone Ditwah
(Nov 2025). Nanu Oya–Ella reopened 2026-07-18. Kandy–Nanu Oya: official target end-2026 /
early 2027, no timetable published as of 2026-10-07. Affects revenue line 5 and any
itinerary that assumes the Kandy–Ella train this winter. Source:
[byc.lk status page](https://byc.lk/colombo-kandy-ella-train-status-2026), plus
[news.lk](https://www.news.lk/current-affairs/train-services-resume-on-badulla-ambewela-section-after-23-days).

## 5. Payments / entity: what I'd check first (not yet researched)
- PayHere needs a Sri Lankan business registration; check whether it can settle to a
  sole proprietorship and what foreign-card acceptance looks like.
- A Singapore entity with Stripe is easy to set up but may not be allowed to sell
  Sri Lankan tour services without SLTDA-registered local partners. That's the legal
  question to put to a lawyer, together with the entity-level SLTDA requirement.
- For Phase 1, the lowest-friction option may be a payment link from a Singapore
  sole-prop / existing freelance entity for the itinerary fee only, with drivers paid
  directly in Sri Lanka. Depends on the employment contract.
