"""Low–high trip cost from rates-2026.csv, plus our margin on the trip.

Usage: python3 estimate.py            # prints the sample 10-day classic loop
Edit SAMPLE_TRIP below to try other trips. No dependencies.
"""

import csv
from pathlib import Path

RATES = {r["id"]: r for r in csv.DictReader(open(Path(__file__).with_name("rates-2026.csv")))}

TIERS = {
    "budget": ("htl_budget", "food_budget"),
    "mid": ("htl_mid", "food_mid"),
    "boutique": ("htl_boutique", "food_mid"),
    "luxury": ("htl_luxury", "food_luxury"),
}

# Classic first-timer loop: Negombo, Sigiriya/Dambulla, Kandy, Ella, Yala, south coast.
SAMPLE_TRIP = {
    "days": 10,
    "adults": 2,
    "rooms": 1,
    "vehicle": "drv_car",
    "peak": False,
    "entries": [
        "fee_sigiriya", "fee_dambulla", "fee_polonnaruwa", "fee_tooth",
        "fee_peradeniya", "fee_yala_allin", "fee_galle_fort", "fee_ella_free",
    ],
    "jeeps": ["jeep_half"],
    "guide_days": 0,
}


def rng(rate_id):
    r = RATES[rate_id]
    return float(r["low"]), float(r["high"])


def add(total, lo_hi, qty=1.0):
    return total[0] + lo_hi[0] * qty, total[1] + lo_hi[1] * qty


def estimate(trip, tier):
    hotel_id, food_id = TIERS[tier]
    nights = trip["days"] - 1
    lines = {}
    lines["vehicle + driver"] = add((0, 0), rng(trip["vehicle"]), trip["days"])
    h = rng(hotel_id)
    if trip["peak"]:
        up = rng("htl_peak_uplift")
        h = (h[0] * up[0], h[1] * up[1])
    lines["hotels"] = add((0, 0), h, nights * trip["rooms"])
    lines["food"] = add((0, 0), rng(food_id), trip["days"] * trip["adults"])
    t = (0, 0)
    for e in trip["entries"]:
        t = add(t, rng(e), trip["adults"])
    for j in trip["jeeps"]:
        t = add(t, rng(j))
    lines["entries + safari"] = t
    lines["guide"] = add((0, 0), rng("gde_national"), trip["guide_days"])
    lines["driver tips"] = add((0, 0), rng("drv_tip"), trip["days"])
    return lines


def our_margin(trip, tier, lines):
    """Gross margin if they book the driver through us and hotels via our affiliate link."""
    retail = rng(trip["vehicle"])
    wholesale = rng("drv_wholesale_car")
    # Pessimistic: low retail vs high wholesale. Optimistic: the reverse.
    drv = ((retail[0] - wholesale[1]) * trip["days"], (retail[1] - wholesale[0]) * trip["days"])
    aff = rng("aff_booking_commission")
    hotel = (lines["hotels"][0] * aff[0], lines["hotels"][1] * aff[1])
    return {"driver markup": drv, "hotel affiliate": hotel}


def usd(x):
    return f"${x:,.0f}"


if __name__ == "__main__":
    t = SAMPLE_TRIP
    print(f"{t['days']} days, {t['adults']} adults, {t['rooms']} room, peak={t['peak']}\n")
    for tier in TIERS:
        lines = estimate(t, tier)
        lo = sum(v[0] for v in lines.values())
        hi = sum(v[1] for v in lines.values())
        print(f"== {tier}: {usd(lo)} – {usd(hi)} total, {usd(lo / t['adults'])} – {usd(hi / t['adults'])} per person")
        for k, v in lines.items():
            print(f"   {k:<18} {usd(v[0]):>7} – {usd(v[1])}")
        m = our_margin(t, tier, lines)
        mlo = sum(v[0] for v in m.values())
        mhi = sum(v[1] for v in m.values())
        print(f"   our gross margin   {usd(mlo):>7} – {usd(mhi)}  "
              + ", ".join(f"{k} {usd(v[0])}–{usd(v[1])}" for k, v in m.items()))
        print()
