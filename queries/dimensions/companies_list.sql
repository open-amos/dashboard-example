-- Purpose: List all companies with key attributes for the overview table
-- Returns all companies from dim_companies with fund names, exposure, and revenue

with all_companies as (
    select
        c.company_id,
        c.name as company_name,
        co.name as primary_country,
        co.country_iso2_code as country_code,
        i.name as primary_industry
    from dim_companies c
    left join (
        select distinct on (company_id) 
            company_id, 
            country_code
        from br_company_countries
        where primary_flag = true
        order by company_id, valid_from desc
    ) bcc on c.company_id = bcc.company_id
    left join dim_countries co on bcc.country_code = co.country_iso2_code
    left join (
        select distinct on (company_id)
            company_id, 
            industry_id
        from br_company_industries
        where primary_flag = true
        order by company_id, valid_from desc
    ) bci on c.company_id = bci.company_id
    left join dim_industries i on bci.industry_id = i.industry_id
),
company_funds as (
    select
        i.company_id,
        string_agg(distinct f.name, ', ' order by f.name) as fund_names,
        count(distinct i.instrument_id) as instrument_count
    from dim_instruments i
    inner join dim_funds f on i.fund_id = f.fund_id
    where i.company_id is not null
    group by i.company_id
),
company_exposure as (
    select
        i.company_id,
        sum(case 
            when i.instrument_type = 'EQUITY' then coalesce(mpp.fair_value, 0)
            when i.instrument_type = 'CREDIT' then coalesce(mpp.principal_outstanding, 0)
            else 0
        end) as total_exposure
    from dim_instruments i
    left join (
        select distinct on (instrument_id)
            instrument_id,
            fair_value,
            principal_outstanding
        from metrics_position_performance
        order by instrument_id, period_end_date desc
    ) mpp on i.instrument_id = mpp.instrument_id
    where i.company_id is not null
    group by i.company_id
),
company_revenue as (
    select distinct on (company_id)
        company_id,
        revenue
    from metrics_company_performance
    order by company_id, period_end_date desc
)
select
    ac.company_id,
    '/companies/' || ac.company_id as company_link,
    'https://ui-avatars.com/api/?background=random&size=20&rounded=true&bold=true&name=' || replace(ac.company_name, ' ', '+') as company_logo,
    'https://flagsapi.com/' || ac.country_code || '/flat/32.png' as country_flag,
    ac.company_name,
    ac.primary_country,
    ac.country_code,
    ac.primary_industry,
    coalesce(cf.fund_names, '') as fund_names,
    coalesce(cf.instrument_count, 0) as number_of_instruments,
    coalesce(ce.total_exposure, 0) as total_exposure,
    coalesce(cr.revenue, 0) as revenue
from all_companies ac
left join company_funds cf on ac.company_id = cf.company_id
left join company_exposure ce on ac.company_id = ce.company_id
left join company_revenue cr on ac.company_id = cr.company_id
order by ac.company_name
