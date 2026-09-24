with source as (
    select * 
    from read_csv(
            '../data/raw/census/*.csv',
            union_by_name = true,
            filename = true,
            encoding = 'CP1252',
            all_varchar = true
    )
),

renamed as (
    select
        year::integer as year,

        'CA' as state_code,
        '06' as state_fips,
        split_part(trim(NAME), ',', 1) as county_name,
        right(trim(GEO_ID), 5) as county_fips,

        B01003_001E::integer as population_total,
        B19013_001E::integer as median_household_income,
        S1701_C03_001E::decimal(5, 2) as poverty_rate,
        S2701_C05_001E::decimal(5, 2) as uninsured_rate
    from source
)

select * from renamed