select distinct
  stage_id,
  stage_name
from metrics_exposure_timeseries
where stage_id is not null
  and stage_name is not null
order by stage_name


