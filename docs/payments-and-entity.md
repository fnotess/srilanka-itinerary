# Payments and entity: first pass (2026-10-10)

**Not legal advice.** This is what public sources say, so you know what to ask a lawyer.
Each point is marked **source** (what a cited page says) or **inference** (my reading).

## Bottom line
Structure decides licensing more than the payment gateway does.

- **Phase 1: charge only for the itinerary.** Take the USD 15–30 fee for a planning
  document. The tourist pays the driver or guide directly, and you take a referral cut
  from the driver. This is the arrangement least likely to need a travel-agent licence in
  either country (**inference**: neither law's text I found covers selling an information
  product, but neither excludes it explicitly).
- **The markup model (you collect for the trip and pay the driver) almost certainly makes
  you a travel agent.** In Sri Lanka that means SLTDA registration, and the business has to
  operate from Sri Lanka. In Singapore, an STB licence might be needed too. Plan for that
  in Phase 2, not before you have paying customers.

## Sri Lanka: SLTDA travel agency registration
Source: [SLTDA travel agency registration requirements 2026 (PDF)](https://www.sltda.gov.lk/storage/common_media/TRAVEL%20AGENCY%20(NEW)%20REGISTRATION%20REQUIREMENTS_2026.pdf).
The PDF has no publication date, but the filename says 2026.

- Entity: a sole proprietorship, partnership or limited company registered in Sri Lanka.
  The business must do travel agency work only. **source**
- **"The agency must operate from Sri Lanka and cannot operate from overseas."** A
  Sri Lankan citizen must hold the majority, or 60% of a partnership with foreigners.
  **source**
  - You're a Sri Lankan citizen, so ownership is fine. Living in Singapore is the problem:
    someone on the ground (family or a partner) would need to be the operating presence.
    **inference**
- Home-based offices are allowed. They need a Grama Niladhari residence certificate plus
  two recommendation letters from SLTDA-registered hotels. **source**
- Capital for a sole proprietorship is LKR 1.2M (about USD 4k), or an asset declaration with
  insurance. There's also an LKR 120k bank guarantee in SLTDA's name. A company needs LKR 1M
  paid-up plus an LKR 100k guarantee. **source**
- Fees are about LKR 15–18k (the source's own figures conflict). Registration takes a
  6-month provisional period, then an inspection. The Tourism Development Levy is due
  annually. **source**
- Agencies that run everything through an app or booking engine register under a
  **"Tourism App" category**. That's your Phase 2 product. **source**
- You must use SLTDA-licensed guides. **source**

## Singapore: STB travel agent licence
Source: [STB Travel Agent Licence](https://www.stb.gov.sg/licensing-support/licenses/travel-agent-licence/).

- The Travel Agents Act covers supplying travel on a conveyance, travel plus
  accommodation, reserving travel for resale, and supplying tours. **source**
- The page says it applies to "transactions conducted within Singapore." A Singapore
  company taking payment online for Sri Lanka driver packages is plausibly inside that
  scope. **inference: ask STB at stb_ta@stb.gov.sg.**
- A General licence needs **S$100,000 paid-up capital**, a key executive and an operating
  address. The application fee is S$200 and the licence fee S$400. **source**
- This is the weak point in the "Singapore entity + Stripe" plan. Stripe is easy, but if
  that entity sells trips rather than PDFs, the S$100k capital requirement may apply.
  **inference**

## Gateways
| | PayHere (Sri Lanka) | Stripe via a Singapore entity |
|---|---|---|
| Who can sign up | Sole proprietorships, companies, and home-based/freelance businesses with proof of business ([source](https://support.payhere.lk/application-process)) | A Singapore-registered entity (ACRA) |
| USD payout | Registered businesses on the Plus/Premium plans only ([source](https://support.payhere.lk/application-process)) | Native |
| Foreign cards | Visa/Mastercard supported; foreign-card pricing not confirmed | Yes |
| Travel category | "Outbound tour services" is listed as unsupported; inbound isn't mentioned ([source](https://support.payhere.lk/application-process)) | No issue for a PDF; licensing question for tours |
| Fees | Not confirmed; general Sri Lanka card range is 2.5–4% ([payatlas](https://payatlas.com/countries/sri-lanka-lk)) | Not checked |

## Recommendation for Phase 1 (inference)
1. Sell the itinerary as a planning product through a payment link from whatever entity
   your employment contract allows. A Singapore sole proprietorship or your existing
   freelance entity with Stripe is fastest.
2. Drivers and guides get paid by the tourist directly, in cash or by bank transfer in
   Sri Lanka. Get your cut as a referral commission from the driver, written into a
   one-page agreement.
3. Before Phase 2's markup model, pay for one hour with a Sri Lankan tourism lawyer, and
   email STB, with these questions:
   - Does an itinerary-only product need SLTDA registration?
   - Can a family member in Sri Lanka be the registered operator, with you as a minority
     partner?
   - Does the Tourism App category have different capital rules?
   - Does a Singapore entity collecting for Sri Lanka ground services need an STB licence?
