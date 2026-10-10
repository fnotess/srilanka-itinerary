-- Sample rows to sanity-check the schema. Not the real dataset.
-- Fee figures come from cost-model/rates-2026.csv; see that file for sources.

INSERT INTO region (slug, name, monsoon_zone) VALUES
  ('cultural-triangle', 'Cultural Triangle', 'northeast'),
  ('hill-country',      'Hill Country',      'mixed'),
  ('south-coast',       'South Coast',       'southwest'),
  ('western',           'Western Province',  'southwest');

INSERT INTO place (kind, slug, name, region_id, location, is_overnight_base, iata_code) VALUES
  ('airport',    'cmb',       'Bandaranaike International (Colombo)', 4, 'SRID=4326;POINT(79.8841 7.1808)', false, 'CMB'),
  ('town',       'sigiriya-town', 'Sigiriya',  1, 'SRID=4326;POINT(80.7550 7.9500)', true,  NULL),
  ('town',       'kandy',     'Kandy',         2, 'SRID=4326;POINT(80.6350 7.2906)', true,  NULL),
  ('town',       'ella',      'Ella',          2, 'SRID=4326;POINT(81.0466 6.8667)', true,  NULL),
  ('attraction', 'sigiriya',  'Sigiriya Rock Fortress', 1, 'SRID=4326;POINT(80.7603 7.9570)', false, NULL),
  ('attraction', 'temple-of-the-tooth', 'Temple of the Sacred Tooth Relic', 2, 'SRID=4326;POINT(80.6413 7.2936)', false, NULL),
  ('rail_station', 'kandy-station', 'Kandy station', 2, 'SRID=4326;POINT(80.6326 7.2900)', false, NULL),
  ('rail_station', 'ella-station',  'Ella station',  2, 'SRID=4326;POINT(81.0460 6.8730)', false, NULL);

INSERT INTO attraction (place_id, category, summary, visit_minutes_min, visit_minutes_max,
                        timing_note, physical_effort, nearest_base_id, last_reviewed_at, dress_code_note)
SELECT p.id, v.category::attraction_category, v.summary, v.vmin, v.vmax, v.timing, v.effort,
       (SELECT id FROM place WHERE slug = v.base), DATE '2026-10-10', v.dress
FROM (VALUES
  ('sigiriya', 'heritage', '5th-century rock fortress, 1,200 steps', 120, 210,
   'Start at opening (07:00) to beat heat and crowds', 4, 'sigiriya-town', NULL),
  ('temple-of-the-tooth', 'temple', 'Holds the sacred tooth relic of the Buddha', 60, 90,
   'Puja times ~05:30, 09:30, 18:30 are busiest and most atmospheric', 1, 'kandy',
   'Shoulders and knees covered, shoes off')
) AS v(slug, category, summary, vmin, vmax, timing, effort, base, dress)
JOIN place p ON p.slug = v.slug;

INSERT INTO attraction_fee (place_id, visitor_category, amount, currency, valid_during,
                            confidence, source_url, checked_on)
SELECT p.id, v.cat::visitor_category, v.amount, v.cur, daterange(DATE '2026-01-01', NULL),
       'published', v.src, DATE '2026-10-10'
FROM (VALUES
  ('sigiriya', 'foreign_adult', 35.00, 'USD', 'https://slvoyo.com/complete-guide-to-sri-lanka-entrance-fees-for-foreign-tourists-2026-updated-prices/'),
  ('sigiriya', 'foreign_child', 20.00, 'USD', 'https://slvoyo.com/complete-guide-to-sri-lanka-entrance-fees-for-foreign-tourists-2026-updated-prices/'),
  ('sigiriya', 'saarc_adult',   20.00, 'USD', 'https://slvoyo.com/complete-guide-to-sri-lanka-entrance-fees-for-foreign-tourists-2026-updated-prices/'),
  ('temple-of-the-tooth', 'foreign_adult', 2000, 'LKR', 'https://tuktukrental.com/sri-lanka-entrance-fees/')
) AS v(slug, cat, amount, cur, src)
JOIN place p ON p.slug = v.slug;

INSERT INTO travel_leg (from_place_id, to_place_id, mode, duration_minutes, distance_km, source)
SELECT a.id, b.id, 'road_car', 330, 140, 'estimate'
FROM place a, place b WHERE a.slug = 'kandy' AND b.slug = 'ella';

INSERT INTO travel_disruption (mode, from_place_id, to_place_id, during, description, source_url, checked_on)
SELECT 'rail', a.id, b.id, daterange(DATE '2025-11-28', NULL),
       'Upcountry line cut by Cyclone Ditwah. Nanu Oya–Ella reopened 2026-07-18; Kandy side '
       'still suspended, official target end-2026 / early 2027.',
       'https://byc.lk/colombo-kandy-ella-train-status-2026', DATE '2026-10-10'
FROM place a, place b WHERE a.slug = 'kandy-station' AND b.slug = 'ella-station';
