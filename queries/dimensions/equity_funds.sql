-- Equity funds only for dropdown filter
select
    fund_id,
    name as fund_name
from dim_funds
where type = 'EQUITY'
order by name
