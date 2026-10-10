-- Attraction database, Phase 2 draft.
-- Postgres 16 + PostGIS 3. See docs/attraction-schema.md for the reasoning.

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS btree_gist;  -- for the no-overlap constraint on fees

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

-- Which monsoon regime a place sits in. Drives "which coast in which month".
-- southwest: wet roughly May–Sep (west + south coasts, western hill slopes)
-- northeast: wet roughly Oct/Nov–Feb (east + north coasts, cultural triangle)
-- mixed: hill country and parts of the interior don't split cleanly either way
CREATE TYPE monsoon_zone AS ENUM ('southwest', 'northeast', 'mixed');

CREATE TYPE place_kind AS ENUM ('attraction', 'town', 'airport', 'rail_station');

CREATE TYPE attraction_category AS ENUM (
  'heritage', 'temple', 'wildlife', 'nature', 'beach', 'viewpoint_hike',
  'museum', 'experience', 'city'
);

-- Fees in Sri Lanka are tiered by nationality, not just age.
CREATE TYPE visitor_category AS ENUM (
  'foreign_adult', 'foreign_child', 'saarc_adult', 'saarc_child',
  'local_adult', 'local_child'
);

-- How sure we are of a figure. Every price in this DB carries one.
CREATE TYPE confidence AS ENUM (
  'verified',   -- checked against an official source or in person, with a date
  'published',  -- taken from a dated secondary source (blog, operator site)
  'estimated'   -- our guess; must be replaced before it reaches a customer quote
);

CREATE TYPE season_rating AS ENUM ('best', 'good', 'poor', 'avoid');

CREATE TYPE operating_status AS ENUM ('open', 'temporarily_closed', 'closed');

CREATE TYPE travel_mode AS ENUM ('road_car', 'road_van', 'rail', 'tuk_tuk', 'walk', 'domestic_flight');

-- ---------------------------------------------------------------------------
-- Geography
-- ---------------------------------------------------------------------------

CREATE TABLE region (
  id            smallserial PRIMARY KEY,
  slug          text NOT NULL UNIQUE,         -- 'cultural-triangle', 'hill-country', 'south-coast'
  name          text NOT NULL,
  monsoon_zone  monsoon_zone NOT NULL,
  boundary      geography(MultiPolygon, 4326) -- optional; fine to leave null in Phase 2
);

-- Everything the route engine can travel between: attractions, overnight towns,
-- airports, rail stations. Attraction-only detail lives in `attraction`.
CREATE TABLE place (
  id          serial PRIMARY KEY,
  kind        place_kind NOT NULL,
  slug        text NOT NULL UNIQUE,
  name        text NOT NULL,
  region_id   smallint NOT NULL REFERENCES region(id),
  location    geography(Point, 4326) NOT NULL,
  -- Towns that work as an overnight base (has hotels across tiers).
  is_overnight_base boolean NOT NULL DEFAULT false,
  iata_code   char(3) UNIQUE,                 -- airports only: CMB, HRI, JAF
  CHECK ((kind = 'airport') = (iata_code IS NOT NULL))
);
CREATE INDEX place_location_gix ON place USING gist (location);
CREATE INDEX place_region_idx ON place (region_id);

-- ---------------------------------------------------------------------------
-- Attractions
-- ---------------------------------------------------------------------------

CREATE TABLE attraction (
  place_id            integer PRIMARY KEY REFERENCES place(id) ON DELETE CASCADE,
  category            attraction_category NOT NULL,
  summary             text NOT NULL,          -- one-liner for the card
  description         text,
  hero_image_url      text,
  -- Time on site, excluding travel. Range because a 1-hour and a 3-hour Sigiriya
  -- visit are both normal.
  visit_minutes_min   smallint NOT NULL CHECK (visit_minutes_min > 0),
  visit_minutes_max   smallint NOT NULL,
  -- Best time-of-day hint the route engine respects (e.g. Sigiriya early, safaris
  -- 06:00 or 14:30 slots). Free text in Phase 2; structure later if the engine needs it.
  timing_note         text,
  physical_effort     smallint CHECK (physical_effort BETWEEN 1 AND 5),
  -- Nearest town to sleep in if this is the day's last stop.
  nearest_base_id     integer REFERENCES place(id),
  status              operating_status NOT NULL DEFAULT 'open',
  status_note         text,
  requires_guide      boolean NOT NULL DEFAULT false,  -- e.g. Sinharaja, some parks need a tracker
  requires_jeep       boolean NOT NULL DEFAULT false,  -- national parks: private 4x4 mandatory
  dress_code_note     text,                            -- temples: shoulders/knees covered
  last_reviewed_at    date NOT NULL,
  CHECK (visit_minutes_max >= visit_minutes_min)
);
CREATE INDEX attraction_category_idx ON attraction (category);

-- Opening hours. Effective-dated because they change and because some sites close
-- seasonally (Yala's annual closure, typically Sep–Oct).
CREATE TABLE attraction_hours (
  id            serial PRIMARY KEY,
  place_id      integer NOT NULL REFERENCES attraction(place_id) ON DELETE CASCADE,
  day_of_week   smallint NOT NULL CHECK (day_of_week BETWEEN 1 AND 7), -- ISO: 1 = Monday
  opens_at      time NOT NULL,
  closes_at     time NOT NULL,
  last_entry_at time,
  valid_from    date NOT NULL DEFAULT '2000-01-01',
  valid_to      date,                          -- null = open-ended
  CHECK (closes_at > opens_at),
  CHECK (valid_to IS NULL OR valid_to >= valid_from)
);
CREATE INDEX attraction_hours_place_idx ON attraction_hours (place_id, day_of_week);

-- Dated closures (poya-day exceptions, park closures, cyclone damage).
CREATE TABLE attraction_closure (
  id         serial PRIMARY KEY,
  place_id   integer NOT NULL REFERENCES attraction(place_id) ON DELETE CASCADE,
  during     daterange NOT NULL,
  reason     text NOT NULL,
  source_url text
);
CREATE INDEX attraction_closure_during_gix ON attraction_closure USING gist (during);

-- Entry fees. Effective-dated, one row per visitor category per period, each with its
-- source and confidence. Fees here change every year or two and quotes must be
-- reproducible, so we never overwrite a fee: close the old row and add a new one.
CREATE TABLE attraction_fee (
  id               serial PRIMARY KEY,
  place_id         integer NOT NULL REFERENCES attraction(place_id) ON DELETE CASCADE,
  visitor_category visitor_category NOT NULL,
  amount           numeric(10, 2) NOT NULL CHECK (amount >= 0),
  currency         char(3) NOT NULL CHECK (currency IN ('USD', 'LKR')),
  includes_taxes   boolean NOT NULL DEFAULT true,
  -- What the fee covers when it's not just the gate (e.g. Yala: entry + service + VAT,
  -- but not the jeep).
  note             text,
  valid_during     daterange NOT NULL DEFAULT daterange('2000-01-01', NULL),
  confidence       confidence NOT NULL,
  source_url       text,
  checked_on       date NOT NULL,
  -- No two fees for the same place + category may overlap in time.
  EXCLUDE USING gist (
    place_id WITH =, visitor_category WITH =, valid_during WITH &&
  )
);

-- Season suitability per month. Defaults come from the region's monsoon zone; rows
-- here are for attractions that differ from their region (e.g. Minneriya's elephant
-- gathering peaks Jul–Sep; whale season off Mirissa is Nov–Apr, Trinco Mar–Aug).
CREATE TABLE attraction_season (
  place_id  integer NOT NULL REFERENCES attraction(place_id) ON DELETE CASCADE,
  month     smallint NOT NULL CHECK (month BETWEEN 1 AND 12),
  rating    season_rating NOT NULL,
  reason    text,
  PRIMARY KEY (place_id, month)
);

CREATE TABLE region_season (
  region_id smallint NOT NULL REFERENCES region(id) ON DELETE CASCADE,
  month     smallint NOT NULL CHECK (month BETWEEN 1 AND 12),
  rating    season_rating NOT NULL,
  reason    text,
  PRIMARY KEY (region_id, month)
);

CREATE TABLE tag (
  id   smallserial PRIMARY KEY,
  slug text NOT NULL UNIQUE                   -- 'family-friendly', 'sunrise', 'lesser-known'
);
CREATE TABLE attraction_tag (
  place_id integer NOT NULL REFERENCES attraction(place_id) ON DELETE CASCADE,
  tag_id   smallint NOT NULL REFERENCES tag(id) ON DELETE CASCADE,
  PRIMARY KEY (place_id, tag_id)
);

-- ---------------------------------------------------------------------------
-- Travel times (route engine input)
-- ---------------------------------------------------------------------------

-- Cached real travel times between places. Straight-line distance is useless on
-- Sri Lankan roads (Kandy–Ella is ~95 km straight, 5+ hours by road), so the route
-- engine only trusts this table. Filled from a maps API, then hand-corrected by
-- drivers where the API is wrong (it often is on hill-country roads).
CREATE TABLE travel_leg (
  from_place_id     integer NOT NULL REFERENCES place(id) ON DELETE CASCADE,
  to_place_id       integer NOT NULL REFERENCES place(id) ON DELETE CASCADE,
  mode              travel_mode NOT NULL,
  duration_minutes  smallint NOT NULL CHECK (duration_minutes > 0),
  distance_km       numeric(6, 1),
  source            text NOT NULL,            -- 'google-routes', 'driver', 'rail-timetable'
  driver_override   boolean NOT NULL DEFAULT false,
  computed_at       timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (from_place_id, to_place_id, mode),
  CHECK (from_place_id <> to_place_id)
);

-- Network disruptions that affect legs rather than single attractions. Exists because
-- the Kandy-side upcountry rail line has been cut since Cyclone Ditwah (Nov 2025);
-- the route engine must stop offering a rail leg while a disruption covers it.
CREATE TABLE travel_disruption (
  id            serial PRIMARY KEY,
  mode          travel_mode NOT NULL,
  from_place_id integer REFERENCES place(id),
  to_place_id   integer REFERENCES place(id),
  during        daterange NOT NULL,            -- upper bound null = no confirmed end
  description   text NOT NULL,
  source_url    text,
  checked_on    date NOT NULL
);
CREATE INDEX travel_disruption_during_gix ON travel_disruption USING gist (during);

-- ---------------------------------------------------------------------------
-- Fees in force today. Currency conversion is left to the app.
-- ---------------------------------------------------------------------------

CREATE VIEW attraction_fee_current AS
SELECT f.*
FROM attraction_fee f
WHERE f.valid_during @> current_date;
