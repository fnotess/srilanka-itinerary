# Phase 1 attraction cards

[attractions-phase1.csv](attractions-phase1.csv) has 45 cards: the classic route plus a
few lesser-known spots for social content (Ritigala, Yapahuwa, Mulkirigala, Knuckles,
Kumana). Columns mirror `db/schema.sql`, so the file imports cleanly in Phase 2.

| Column | Meaning | Confidence |
|---|---|---|
| `fee_foreign_adult`, `fee_currency` | Non-SAARC adult gate fee, in the currency the source quotes | See `fee_status` |
| `fee_status` | `published` (2026 secondary source), `conflicting` (sources disagree; check before quoting), `guessed`, `unknown` (not researched) | |
| `fee_source` | `slvoyo` = [slvoyo.com 2026 list](https://slvoyo.com/complete-guide-to-sri-lanka-entrance-fees-for-foreign-tourists-2026-updated-prices/), `tuktukrental` = [tuktukrental.com list](https://tuktukrental.com/sri-lanka-entrance-fees/), `yalawildlife blog` = [Yala fees 2026](https://www.yalawildlife.com/blog/yala-national-park-entrance-fees-2026-taxes) | |
| `lat`, `lon` | **Approximate**, from general knowledge. Fine for a map pin; replace with a maps API lookup before computing routes | guessed |
| `visit_min`, `visit_max` | Minutes on site, excluding travel | guessed |
| `best_months` | Month range, wrapping over the year (`12-4` = Dec to Apr). Based on the two-monsoon pattern plus known wildlife seasons | general knowledge, not sourced |
| `nearest_base` | Town to sleep in | guessed |

## What to fix before this goes on a site
1. The 7 `conflicting` fees: check Dambulla, Temple of the Tooth, Mihintale, Ambuluwawa,
   Udawalawe, Wilpattu and Kumana at the gate, or with family in Sri Lanka.
2. National park fees are **base fees**. The real cost to the tourist is about
   USD 40–45 all-in, plus a jeep. Show the all-in figure on the card.
3. The 5 `unknown` fees.
4. Photos: none yet. Your own or licensed; don't lift them from Google.
