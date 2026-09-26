with plans as (

    select *
    from {{ ref("int_cms_plan_cty_yr") }}

),

market_counts as (

    select
        year,

        state_code,
        state_fips,
        county_name,
        county_fips,

        count(distinct issuer_id) as carrier_count,

        count(distinct standard_component_id) as plan_count,

        count(distinct case
            when metal_level = 'Silver'
                then standard_component_id
        end) as silver_plan_count,

        count(distinct case
            when metal_level = 'Gold'
                then standard_component_id
        end) as gold_plan_count,

        bool_or(is_kp) as kp_offered,

        count(distinct case
            when is_kp
                then standard_component_id
        end) as kp_plan_count

    from plans

    group by
        year,
        state_code,
        state_fips,
        county_name,
        county_fips
),

silver_plans as (

    select
        year,
        county_fips,
        standard_component_id,

        min(individual_rate_age_40) as individual_rate_age_40

    from plans

    where metal_level = 'Silver'
      and individual_rate_age_40 is not null

    group by
        year,
        county_fips,
        standard_component_id
),

ranked_silver_plans as (

    select
        year,
        county_fips,
        standard_component_id,
        individual_rate_age_40,

        row_number() over (
            partition by
                year,
                county_fips
            order by
                individual_rate_age_40,
                standard_component_id
        ) as premium_rank

    from silver_plans
),

premium_metrics as (

    select
        year,
        county_fips,

        min(
            case
                when premium_rank = 1
                    then individual_rate_age_40
            end
        ) as lowest_cost_silver_premium,

        min(
            case
                when premium_rank = 2
                    then individual_rate_age_40
            end
        ) as benchmark_silver_premium

    from ranked_silver_plans

    group by
        year,
        county_fips
),

carrier_presence as (

    select distinct
        year,
        county_fips,
        issuer_id

    from plans
),

carrier_entries as (

    select
        current.year,
        current.county_fips,

        count(*) as carrier_entry_count

    from carrier_presence current

    left join carrier_presence prior
        on current.county_fips = prior.county_fips
        and current.issuer_id = prior.issuer_id
        and current.year = prior.year + 1

    where prior.issuer_id is null

    group by
        current.year,
        current.county_fips
),

carrier_exits as (

    select
        prior.year + 1 as year,
        prior.county_fips,

        count(*) as carrier_exit_count

    from carrier_presence prior

    left join carrier_presence current
        on prior.county_fips = current.county_fips
        and prior.issuer_id = current.issuer_id
        and current.year = prior.year + 1

    where current.issuer_id is null

    group by
        prior.year + 1,
        prior.county_fips
),

year_bounds as (

    select
        min(year) as min_year
    from plans

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key([
            'mc.county_fips',
            'mc.year'
        ]) }} as county_year_sk,

        mc.year,

        mc.state_code,
        mc.state_fips,
        mc.county_name,
        mc.county_fips,

        mc.carrier_count,
        mc.plan_count,
        mc.silver_plan_count,
        mc.gold_plan_count,

        pm.lowest_cost_silver_premium,
        pm.benchmark_silver_premium,

        case
            when mc.year = yb.min_year then null
            else coalesce(ce.carrier_entry_count, 0)
        end as carrier_entry_count,

        case
            when mc.year = yb.min_year then null
            else coalesce(cx.carrier_exit_count, 0)
        end as carrier_exit_count,

        mc.kp_offered,
        mc.kp_plan_count

    from market_counts mc

    left join premium_metrics pm
        on mc.year = pm.year
        and mc.county_fips = pm.county_fips

    left join carrier_entries ce
        on mc.year = ce.year
        and mc.county_fips = ce.county_fips

    left join carrier_exits cx
        on mc.year = cx.year
        and mc.county_fips = cx.county_fips

    cross join year_bounds yb
)

select *
from final