select 
  country_code,
  region as country_name,
  sum(deployed_capital_usd) as exposure
from metrics_exposure_timeseries
where period_type = 'Current'
group by country_code, region
order by exposure desc
