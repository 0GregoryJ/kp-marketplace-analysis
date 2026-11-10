# Analysis Notes

Detail behind the README's Results section. Each notebook in `notebooks/` regenerates its own tables and figures; figures are also saved to `outputs/figures/`.

## Common Setup

- **Unit:** one row per offered county, using the mean of 2016–2024 for each measure, unless a section says otherwise.
- **Offered:** `kp_offered` in `mart_cty_yr_market`. Kaiser's individual-market service area is `CAS002` (issuer `40513`). It covers only some ZIP codes in 21 counties in 2016 and in 23 of 33 counties in 2025.
- **Outcome:** `kp_market_share`, which is Kaiser enrollment divided by total Covered California enrollment in the county. Coefficients are in percentage points of share.
- **Sample:** 31 counties. Los Angeles has no county benchmark premium because it spans two rating areas. Monterey enters in 2025, after the estimation years.
- **Inference:** OLS with HC1 standard errors. The within-county model clusters by county.
- **Premium:** the age-40 individual Silver rate. The benchmark is the second-lowest-cost Silver plan in the county.

## 01 — Exploratory Analysis

- Kaiser is offered in 33 counties in 2025, and nearly all Kaiser members live in them.
- Across offered counties, share rises with income (Spearman 0.65) and the benchmark premium (0.49). It falls with poverty (−0.55), the uninsured rate (−0.57), and unemployment (−0.60). It shows no relationship with carrier count (0.12).
- Where prior Kaiser enrollment is at least 100, share rose about 1.4 points a year on average.

Figures: `01_kp_share_2025_ranked`, `01_enrollment_and_median_share_2016_2025`, `01_share_vs_conditions_scatter`.

## 02 — Joint Models

| Model | Terms | Counties | R² | Adjusted R² |
|---|---|---|---|---|
| 1 | Log population, income, poverty, uninsured, unemployment | 32 | 0.61 | 0.53 |
| 2 | Model 1 + carrier count + benchmark premium | 31 | 0.68 | 0.59 |
| 3 | Model 2 + Kaiser premium minus benchmark | 31 | 0.69 | 0.57 |

Model 2 is the working specification. Its 95% intervals exclude zero for four terms:

- Population: +8.7 per doubling.
- Uninsured rate: −8.1 per point.
- Unemployment rate: −2.4 per point.
- Benchmark premium: +1.7 per $10.

Income, poverty, and carrier count include zero once the other terms are in the model.

Kaiser's premium gap to the benchmark lines up with share on its own (−4.9 per $10). It correlates −0.88 with the benchmark, so Model 3 cannot separate the two. Read together, they describe Kaiser's price position: share is higher where other carriers' Silver plans are expensive relative to Kaiser.

In 2025, offered counties at or above the median share (34%) average 4.6% uninsured, 4.8% unemployment, and a $624 benchmark. Counties below it average 7.1%, 7.3%, and $533.

Figures: `02_model2_standardized_coefficients`, `02_share_groups_2025_conditions`.

## 03 — Scenario Projection

This is a continuation of recent relative change, not an enrollment forecast.

- Each county's 2019–2024 slope is extended for the uninsured rate, log population, and the benchmark premium. The 2019 start avoids the 2016–2018 drop in the uninsured rate.
- Unemployment is held at its 2024 rate, because the 2019–2024 window runs through the 2020 spike.
- Each measure is expressed relative to the cross-county mean, so a change shared by every county has no effect. The relative changes are run through Model 2.

Results over five years:

- The median high-share county moves −0.2 points and the median low-share county +0.8. The roughly 45-point gap between the groups does not close.
- The middle half of counties falls between −6.3 and +5.8 points.

Monterey scores 61% on Model 2 against an actual 29% in its opening year.

Figures: `03_offered_county_medians_2016_2024`, `03_implied_share_change_5yr`.

## 04 — Stability of the Profile

The four terms that held in Model 2 make up the profile:

`kp_market_share ~ log_population + uninsured_rate + unemployment_rate + benchmark_silver_premium`

Its adjusted R² is 0.60 (Model 2: 0.59). Coefficients: population +5.9 per doubling, uninsured −5.0 per point, unemployment −1.5 per point, benchmark +1.5 per $10.

| Check | Result |
|---|---|
| Single years 2016–2024 | Adjusted R² 0.50–0.66. Signs match in 9 of 9 years. Intervals exclude zero for population in 9 of 9 years and for each other term in 6 of 9 |
| 2016–2019 vs 2020–2024 averages | Adjusted R² 0.57 vs 0.60. Every interval excludes zero in the later window |
| One region left out | Without Southern California, the uninsured sign flips. Without Sacramento and the foothills, population flips. Without the Bay Area, adjusted R² falls to 0.48 |
| Kaiser's Northern vs Southern California | Region alone: adjusted R² 0.17. Four terms plus region: 0.63; Southern counties sit 19 points below Northern counties with the same conditions, and only population stays clear of zero. Northern California only (24 counties): 0.71, with population +, unemployment −12.3, and uninsured +6.0 |
| One county left out | No sign flips. Adjusted R² 0.55–0.63 |

The Southern California counties are Imperial, Kern, Orange, Riverside, San Bernardino, San Diego, and Ventura. Kern is placed there because Kaiser serves it from its Southern California region; moving it north changes little.

The profile has two parts. One is a large Northern/Southern gap. The other is a population and unemployment pattern within Northern California.

Figures: `04_coefficients_by_year`, `04_coefficients_region_left_out`, `04_northern_southern_california`, `04_coefficients_county_left_out`.

## 05 — Departures, Within-County Change, Openings, Non-Offered Counties

**Departures.** A departure is actual share minus the share the profile implies (an in-sample residual). Counties at least one residual standard error away are flagged: 16.4 points on the four-term profile, 15.6 with region.

| County | Footprint | Departure | With region | Members at 2025 size |
|---|---|---|---|---|
| Sutter | ZIP-limited | −25.3 | −26.2 | −1,579 |
| Orange | Whole county | −22.6 | −16.2 | −41,153 (−29,600 with region) |
| San Francisco | Whole county | −20.2 | −19.5 | −7,837 |
| Santa Clara | ZIP-limited | −19.7 | −23.4 | −15,921 |
| Tulare | ZIP-limited | −18.0 | −27.3 | −2,127 |
| Napa | ZIP-limited | +27.2 | +28.3 | +1,753 |
| Solano | Whole county | +27.8 | +27.0 | +4,191 |
| San Joaquin | Whole county | +28.3 | +21.3 | +12,059 |

Amador (−19.6), Stanislaus (+19.6), and Madera (+22.4) are flagged on the four-term profile only. The median departure is +3.2 points for whole-county service areas and −0.5 for ZIP-limited ones. Members at 2025 size is the departure times the county's 2025 Covered California enrollment. It sets the size of a gap; it is not members Kaiser could add.

**Within-county change.** The same four terms with county and year fixed effects, on 278 county-years:

- Only 3% of year-adjusted variation in share happens inside a county.
- The benchmark premium keeps its direction: +0.6 per $10 within a county (p 0.002), against +1.5 between counties.
- The uninsured rate and unemployment do not keep their direction.

**Openings.** Santa Cruz opened in 2017 at 41% share, then rose to 56%, then 60%, and holds near 65%. Monterey opened in 2025 at 29%. At opening, Monterey's conditions compared with the footprint median were:

- Benchmark premium: $744 vs $588.
- Uninsured rate: 9.6% vs 5.7%.
- Unemployment: 7.3% vs 5.1%.

**Counties not offered.** The 25 counties outside the footprint are each matched to their nearest offered county on z-scored log population, uninsured rate, and unemployment. A match counts as close when it is within the 75th percentile of offered counties' own nearest-neighbor distances (0.66), and loose within the 90th (0.87).

- San Luis Obispo resembles Napa (close), and its $660 benchmark falls within the footprint's $412–$744 range.
- Nevada resembles Napa, Humboldt resembles Yolo, and Merced resembles Tulare. All three are close matches, and all three are priced above the footprint range.
- 23 of the 25 counties are priced above the footprint range.

A resemblance says nothing about provider network or facility access.

Figures: `05_departures_from_profile`, `05_share_and_departure_map`, `05_share_after_opening`.

## 06 — Where the Model Works

Notebook 5 flags large **signed** departures. Notebook 6 asks where absolute residual `|e|` is low or high, and what that means for using the socioeconomic / market profile as a tool.

**Reliability vs direction.** Absolute residual measures how close the four-term score sits to actual share. Signed residual keeps the shortfall / outperformer story. Counties are cut into absolute-error tertiles and into bands at 0.5 and 1.0 residual SE (16.4 pp).

- Median `|error|` is about **12** points.
- **14** counties sit within 0.5 SE; **11** sit beyond 1 SE.
- The beyond-1-SE set is essentially the notebook 5 shortfalls and outperformers (including Orange, Sutter, San Francisco, Santa Clara, Napa, Solano, San Joaquin).

**What low- and high-error counties share.** Continuous predictors do **not** strongly sort absolute error (Spearman of `|e|` with population, uninsured, unemployment, and premium is near zero). Mean `|e|` also barely differs between lower and upper halves of each predictor. Absolute error is therefore not “the model fails in poor counties” or “works only in rich counties.” It fails where Kaiser share sits far from what conditions imply — the same counties notebook 5 already named.

Region and footprint still matter for interpretation:

- Southern California is a larger share of the **low**-error tertile than of the high-error tertile: many Southern counties have conditions that imply lower share and hold near that implication. Orange is the clear Southern exception.
- ZIP-limited vs whole-county footprint does not separate low from high absolute error on its own.

**Tool framing for the Kaiser audience.**

1. The profile is a **between-county screening score**, not a year-to-year lever (only ~3% of share variation is within-county).
2. Use it where historical `|error|` is low (Higher confidence tag). Treat Lower-confidence counties as needing ops / network review before acting on the score.
3. Do not read a high fitted share as what Kaiser will achieve without checking signed departure, Northern/Southern context, and footprint.

Figures: `06_abs_error_by_predictor_half`, `06_abs_error_map`.

## 07 — 2027 Share Forecasts

Notebook 3 remains a **relative ranking** scenario. Notebook 7 scores **2027 levels**:

`share_2027 = profile(X_2027) + departure_carry`

- `profile(X_2027)` uses the frozen four-term coefficients on forecast covariates.
- `departure_carry` is the county’s 2016–2024 mean residual (sticky Kaiser-specific gap). A shrunk-departure companion and a Southern-region companion sit beside the base path.
- Uncertainty is reported two ways: ±1 residual SE (~16.4 pp) around the sticky path, and a scenario range across bridge stresses.

**Forecast inputs.** Values live in `mart_cty_forecast_inputs` (seed `forecast_cty_inputs` → `stg_forecast_cty_inputs`), separate from historical `mart_cty_yr_*` tables.

| Measure | 2027 source |
|---|---|
| `population_total` | CA DOF Report P-2A (Baseline 2024, Vintage 2026), July 1 2027 |
| `unemployment_rate` | CA DOF / Caltrans long-run county economic forecasts (Jan 2026), 2027 |
| `benchmark_silver_premium` | Covered California 2027 QHP rates (age-40 Silver, second-lowest among issuers present in the county via 2027 plans-by-ZIP) |
| `carrier_count` | Covered California 2027 plans-by-ZIP (distinct issuers with any ZIP presence) |
| `uninsured_rate`, income, poverty | Still ACS 2024 holds (no official county 2027 uninsured forecast) |

| Scenario | What changes |
|---|---|
| `base` | Official 2027 population, unemployment, premium, and carrier count as above |
| `higher_uninsured` | Uninsured rate +1 pp |
| `softer_labor` | DOF 2027 unemployment +1 pp |
| `premium_up` | 2027 benchmark Silver premium +$50 |

**Results on the official base (32 scoreable counties; Los Angeles unscored).** 2027 Covered California Silver benchmarks run roughly **$35–$130** above the 2026 CMS bridge values used earlier, so the between-county profile scores higher. Median sticky 2027 share is about **87%** (profile alone ~86%; median departure −0.3 pp). Displayed shares are clipped to 0–100%; many high-premium Northern counties hit the cap. The median span across the four scenarios remains about **13** pp — still smaller than the model residual SE (~16.4 pp). Lower-confidence counties from notebook 6 keep that tag on the forecast table.

Read the premium-driven lift carefully: the historical profile associates higher benchmark premiums with higher Kaiser share (price-position story). It is not a claim that raising every county’s premium causes higher Kaiser enrollment.

**Special flags.** Los Angeles has no county premium. Monterey is scored as an **opening** (profile only, no sticky residual) and should be read against the Santa Cruz path, not as a mature-footprint forecast. Southern California should be screened with the region companion. Headline remains **share**, not enrollment headcount.

Figures: `07_share_2025_vs_2027_base`.
