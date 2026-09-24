with source as (
    select *
    from read_csv(
    '../data/raw/bls/QCEW/*.csv',
    union_by_name = true,
    filename = true,
    encoding = 'CP1252',
    all_varchar = true
    )
    where agglvl_code = '70'
),

renamed as (
    select
        year::integer as year,

        'CA' as state_code,
        '06' as state_fips,
        trim(area_fips) as county_fips,
        split_part(trim(area_title), ',', 1) as county_name,

        annual_avg_estabs_count::integer as establishment_count,
        annual_avg_emplvl::integer as employment_total,
        avg_annual_pay::integer as avg_annual_pay,

        oty_annual_avg_estabs_count_pct_chg::decimal(8, 2) as establishment_yoy_pct_change,
        oty_annual_avg_emplvl_pct_chg::decimal(8, 2) as employment_yoy_pct_change,
        oty_avg_annual_pay_pct_chg::decimal(8, 2) as avg_annual_pay_yoy_pct_change
    from source
)

select * 
from renamed
where county_fips <> '06999'