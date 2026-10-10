# srilanka-itinerary

Working repo for a paid, customised Sri Lanka itinerary service for foreign tourists
(placeholder brand: "Monsoon Route"; name not locked).

Visitor ticks attractions, enters dates / group size / budget tier / arrival airport,
and gets back a day-by-day itinerary with a low–high cost range. Revenue comes mostly
from driver and guide markup, with affiliate and service fees around it.

## Where things are

| Path | What |
|---|---|
| [docs/brief.md](docs/brief.md) | Settled decisions: build sequence, constraints, naming research, brand |
| [docs/open-questions.md](docs/open-questions.md) | Open questions, current status of each, and pushback |
| [docs/social-handles.md](docs/social-handles.md) | Handle availability check (manual, platforms block automation) |
| [docs/attraction-schema.md](docs/attraction-schema.md) | Why the attraction DB is shaped the way it is |
| [db/schema.sql](db/schema.sql) | Postgres 16 + PostGIS schema draft (Phase 2) |
| [db/seed-sample.sql](db/seed-sample.sql) | A few rows to sanity-check the schema |
| [cost-model/cost-model-2026.md](cost-model/cost-model-2026.md) | First-pass 2026 cost model, each figure marked known vs guessed |
| [cost-model/rates-2026.csv](cost-model/rates-2026.csv) | The same figures as data |
| [cost-model/estimate.py](cost-model/estimate.py) | Tiny estimator that turns the CSV into a low–high trip range |

## Status

Phase 1 (concierge MVP) has not started. Nothing here should go public until the
employment-contract check in `docs/brief.md` is done.
