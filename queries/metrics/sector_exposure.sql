select 
  industry_name,
  sum(deployed_capital_usd) as exposure_usd
from metrics_exposure_timeseries
where period_type = 'Current'
group by industry_name
order by exposure_usd desc
