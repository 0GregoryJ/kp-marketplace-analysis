with source as (
    select *
    from read_csv(
    '../data/raw/bls/LAUS/*.csv',
    union_by_name = true,
    filename = true,
    encoding = 'CP1252',
    all_varchar = true
    )
    where "State FIPS Code" = 06
),

renamed as (
    select
        Year::integer as year,

        trim("LAUS Code") as laus_code,

        "State FIPS Code" as state_fips,
        'CA' as state_code,
        concat('06',trim("County FIPS Code")) as county_fips,
        split_part(trim("County Name/State Abbreviation"), ',', 1) as county_name,

        "Labor Force"::numeric as labor_force_total,
        Employed::numeric as employed_total,
        Unemployed::numeric as unemployed_total,
        "Unemployment Rate (%)"::decimal(5,2) as unemployment_rate
    from source
)

select * from renamed
