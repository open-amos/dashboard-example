select distinct
  country_code,
  country_name
from metrics_exposure_timeseries
where country_code is not null
  and country_name is not null
  and (region = '${inputs.region.value}' or '${inputs.region.value}' = 'ALL')
order by country_name


