with source as (
    select *
    from read_csv(
    '../data/raw/covered_ca/*.csv',
    union_by_name = true,
    filename = true,
    encoding = 'CP1252',
    all_varchar = true
    )
),

renamed as (
    select
        year::integer as year,
        concat(trim(county), ' ', 'County') as county_name,

        trim(issuer) as issuer,

        enrollees::numeric as enrollees_total,
        percentage::decimal(8, 2) as enrollees_pct
    from source
)

select * from renamed