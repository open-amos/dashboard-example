select
    company_id,
    company_name,
    case
        when website ~* '^https?://' then website
        when coalesce(website, '') <> '' then 'https://' || website
        else null
    end as website,
    description,
    primary_country,
    primary_industry
from metrics_company_performance
where company_id = '${params.id}'
limit 1
