# Project Brief — Presenter’s Notes

Capstone for Kaiser Permanente: California individual Marketplace, county grain. This is what you need to walk the project without re-reading every notebook. Figures live in `outputs/figures/`.

---

## Elevator (30 seconds)

We built a **socioeconomic / market profile** of where Kaiser’s Covered California share is high, tested whether that profile is stable, found where Kaiser sits above or below it, and asked where the tool is trustworthy — then scored **2027 conditions** with official DOF / Covered California inputs. The product is a **county screening tool with confidence tags**, not an enrollment forecast.

---

## Key takeaways

1. **Kaiser share tracks a clear between-county profile.** Across offered counties, higher share goes with larger population, lower uninsured and unemployment rates, and a higher benchmark Silver premium. The premium result is best read as **price position** (other carriers’ Silver expensive relative to Kaiser), not a pure causal price lever. Four-term adj. R² ≈ 0.60.

2. **Southern California sits about 19 points below Northern peers with the same conditions.** The profile has two layers: a large N/S gap, and a population / unemployment pattern that is clearer in the North. Do not sell one statewide structural law.

3. **The model maps counties; it does not dial share year to year.** Only about 3% of year-adjusted share variation is within-county. Of the four terms, only the benchmark keeps its direction inside a county. SES/market conditions are a **first-pass screen** across places, not a lever you turn inside one market.

4. **Some counties do not match their conditions.** Shortfalls (with region): Sutter, Orange, San Francisco, Santa Clara, Tulare. Outperformers: Napa, Solano, San Joaquin. Orange is the largest gap at 2025 market size (~30–41k members’ worth of shortfall — a scale comparison, not addable enrollment). A ZIP-limited footprint alone does not explain the shortfalls.

5. **High model error is not about “poor” or “small” counties.** Absolute residual error concentrates in those same shortfall and outperformer places. Correlations of `|error|` with income, poverty, and the profile terms are near zero. Where historical fit is good, trust the screen more; where fit is bad, dig into ops / network / other non-SES factors.

6. **The county ranking is sticky.** Extending recent relative paces of conditions through the model barely reshuffles high- vs low-share groups over five years (median move ~1 pp).

7. **2027 is a conditions screen, not a precise share forecast.** Official DOF population and unemployment plus Covered California 2027 premiums, with each county’s historical departure carried forward. Model noise is about ±16 pp. Higher 2027 Silver benchmarks push many Northern scores to a 100% display cap — that is the linear score blowing the scale, not “Kaiser will own the market.” Use confidence tags and bands, not capped point estimates.

8. **Openings need their own story.** Monterey opened at 29% against a much higher steady-state score; Santa Cruz’s path (41% → ~65%) is the better reference than the mature-footprint profile.

**“Screen” means:** a first-pass filter that shortlists which counties’ conditions look like high-share places (and which need a deeper look) — not a final enrollment or share plan.

---

## Research questions → answers

| Question | Answer in one line |
|---|---|
| What conditions go with higher share? | Larger population, lower uninsured, lower unemployment, higher benchmark Silver (price position). |
| Where do we see that now? | High-share counties look like that pattern; Southern CA sits ~19 pp below Northern peers with the same conditions. |
| How might conditions / ranking move? | Relative 2019–24 paces barely reshuffle the ranking over 5 years; 2027 official inputs raise many profile scores via higher premiums. |
| What should future analysis do? | Screen with the profile + confidence tag; dig into shortfalls/outperformers (start with Orange); don’t treat SES as a within-county lever. |

---

## Setup you should say once

- **Outcome:** Kaiser share of Covered California enrollment in counties where KP is offered.
- **Main sample:** 31 counties, 2016–2024 means. LA out (no single-county premium). Monterey opens 2025 → out of estimation.
- **Offered:** 33 counties in 2025; many are ZIP-limited while share is whole-county.
- **Premium:** age-40 individual Silver; benchmark = second-lowest Silver in the county.
- **Stack:** raw CMS / Covered CA / ACS / BLS → DuckDB + dbt marts → 7 notebooks.

---

## Story arc (notebooks 01 → 07)

### 01 — Map and correlations
Kaiser is concentrated in its offered footprint. Share rises with income and benchmark premium; falls with poverty, uninsured, unemployment. Carrier count barely matters. Share has drifted up ~1.4 pp/year where KP already had members.

**Say:** Conditions and share move together across counties; next ask is whether that holds jointly.

### 02 — Joint models → working Model 2
Nested OLS. Model 2 (SES + carriers + benchmark) is the working spec (adj. R² ~0.59). Clear terms: population +, uninsured −, unemployment −, benchmark +. Income/poverty/carriers fade once those are in.

Kaiser–benchmark **gap** alone lines up with share but correlates **−0.88** with the benchmark → can’t separate them. Read as **price position**: share higher where other carriers’ Silver is expensive relative to Kaiser.

**2025 snapshot:** counties ≥ median share (~34%) average ~4.6% uninsured, ~4.8% unemployment, ~$624 benchmark vs ~7.1%, ~7.3%, ~$533 below median.

### 03 — Ranking scenario (not a level forecast)
Extend each county’s **relative** 2019–24 pace (uninsured, population, premium) through Model 2. Unemployment held at 2024.

**Result:** high/low groups don’t swap; median moves ~1 pp over five years. Monterey scores ~61% on Model 2 vs **29%** actual at opening → openings ≠ steady-state scores.

### 04 — The four-term profile + stability
Drop weak terms → profile:

`share ~ log_population + uninsured + unemployment + benchmark`

Adj. R² ~0.60. Coefs (rough): pop +5.9 / doubling; uninsured −5.0 / pp; unemployment −1.5 / pp; benchmark +1.5 / $10.

| Check | Takeaway |
|---|---|
| Year by year | Signs hold; fit stays in a band |
| Drop one county | No sign flips |
| Drop a whole region | Signs can flip; Bay Area matters for fit |
| N vs S | Region alone weak (adj. R² ~0.17); +region → South **−19 pp** vs North; North-only fit ~0.71 |

**Say:** Profile has two layers — a big N/S gap, and a pop/unemployment pattern especially in the North. Don’t sell it as a single statewide structural law.

### 05 — Departures, within-county, openings, non-offered
**Departure** = actual − profile (residual). Flag if \|dep\| ≥ 1 residual SE (~16.4 pp; ~15.6 with region).

| Direction | Counties (hold with region unless noted) |
|---|---|
| Shortfalls | Sutter, Orange, SF, Santa Clara, Tulare (+ Amador on four-term only) |
| Outperformers | Napa, Solano, San Joaquin (+ Stanislaus, Madera on four-term only) |

Orange is the biggest **member-scale** gap (~30–41k at 2025 market size) — scale for comparison, not “addable members.” ZIP-limited footprint does **not** explain shortfalls alone (Orange and SF are whole-county).

**Within county:** only ~**3%** of year-adjusted share variation is within-county. Of the four terms, only benchmark keeps direction inside a county. SES is a **between-county map**, not a dial you turn year to year.

**Openings:** Santa Cruz 2017: 41% → ~65%. Monterey 2025: 29%, tougher conditions than footprint median.

**Non-offered:** nearest-neighbor on pop/uninsured/unemployment — a few close matches (e.g. SLO↔Napa); most outside counties are priced above the footprint range. Resemblance ≠ network access.

### 06 — Where the tool works
Separate **reliability** (|error|) from **direction** (signed departure).

- Median \|error\| ~12 pp; 14 counties within 0.5 SE; 11 beyond 1 SE.
- High \|error\| ≈ same shortfall/outperformer list — **not** “poor counties” or “small counties.” Correlations of \|error\| with SES/premium ≈ 0.
- Many Southern counties are **well fit** (conditions imply lower share and they sit near it). Orange is the Southern exception.

**Decision rule:** screen with the profile; attach Higher / Lower confidence; don’t treat fitted share as a promise.

### 07 — 2027 share screen
Different from notebook 3:

`share_2027 = frozen profile(X_2027) + sticky departure`

**Sticky departure** = keep each county’s historical residual (Kaiser-specific gap the SES model doesn’t see).

**Inputs:** DOF P-2A pop 2027; DOF/Caltrans unemployment 2027; Covered CA 2027 Silver benchmark + carrier count; uninsured still ACS 2024 hold.

**Results:** 2027 benchmarks are ~$35–$130 above old 2026 bridge → many scores rise; median sticky ~**87%**; many Northern counties **clip at 100%**. That is the linear score blowing the scale + display clip — **not** “Kaiser owns the market.” Model band ±~16 pp still dominates scenario span (~13 pp).

| County | How to talk about it |
|---|---|
| Alameda | High 2025, Higher confidence, still screens high for 2027 |
| Orange | 2025 ~25% → 2027 screen ~55% with sticky −23 pp; Lower confidence — ops story |
| Sutter | Same shortfall logic |
| Solano / Napa | Outperformers; sticky + gap; don’t credit SES alone |
| Monterey | Opening score only — use Santa Cruz path, not mature forecast |
| LA | Unscored (no county premium) |

**Useful as:** screening which 2027 conditions still look high-share, with confidence tags.  
**Not useful as:** precise enrollment or share planning numbers.

---

## What “good tool use” means for Kaiser

1. **Between-county screen** — “Do this county’s conditions look like high-share places?”  
2. **Check departure + confidence** — shortfalls/outperformers need ops/network (or other) explanation.  
3. **Mind N/S** — South runs ~19 pp cooler after controls.  
4. **Don’t use as a within-county lever** — 3% within-county variation.  
5. **2027** — conditions + sticky gap + wide band; distrust clipped 100%s as point forecasts.

---

## Limitations to volunteer before you’re asked

- n ≈ 31, one state, wide intervals  
- ZIP-limited offer vs whole-county share  
- No facility / network distance in the data  
- LA dual rating areas  
- Premium = standardized age-40 Silver  
- Uninsured in 2027 still a 2024 hold  
- Sticky residual assumes Kaiser-specific gaps persist  
- Notebook 3 ≠ notebook 7 (ranking vs level screen)

---

## Suggested talk order (~10–12 min)

1. Question + data grain (1 min)  
2. Profile + price position (2) — figs `02_*`  
3. Stability + N/S gap (2) — figs `04_*`  
4. Departures + Orange / outperformers (2) — figs `05_*`  
5. Tool limits: within-county + where \|error\| is high (2) — figs `06_*`  
6. Outlook: ranking stable (03) + 2027 screen with caveats (07) — figs `03_*`, `07_*`  
7. Close: screening tool + next questions (network, Orange, Monterey path)

---

## Cheat sheet — numbers worth memorizing

| Fact | Number |
|---|---|
| Profile adj. R² | ~0.60 |
| Residual SE | ~16.4 pp (~15.6 with region) |
| South vs North, same conditions | ~−19 pp |
| Within-county share of variation | ~3% |
| Orange departure | ~−23 pp (~−16 with region); ~30–41k at 2025 size |
| Monterey open vs score | 29% actual vs ~61% Model 2 (nb3) |
| Santa Cruz path | 41% → ~65% |
| 2027 median sticky score | ~87% (many capped at 100%) |
| 2027 uncertainty | ±16 pp model; ~13 pp scenario span |

---

## File map

| Need | Where |
|---|---|
| Full numeric write-up | `docs/analysis.md` |
| Repo overview / setup | `README.md` |
| Notebooks | `notebooks/01` … `07` |
| Figures | `outputs/figures/` |
| 2027 inputs | `dbt/seeds/forecast_cty_inputs.csv` → `mart_cty_forecast_inputs` |
