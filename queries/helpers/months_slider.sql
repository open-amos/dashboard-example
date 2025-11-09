with months as (
  select distinct date_trunc('month', cast(exposure_month as date)) as month
  from metrics_exposure_timeseries
  where 1=1
    and (fund_id = '${inputs.fund.value}' or '${inputs.fund.value}' = 'ALL')
    and (stage_id = '${inputs.stage.value}' or '${inputs.stage.value}' = 'ALL' or stage_id is null)
    and (region = '${inputs.region.value}' or '${inputs.region.value}' = 'ALL')
    and (country_code = '${inputs.country.value}' or '${inputs.country.value}' = 'ALL')
), ordered as (
  select 
    month, 
    row_number() over (order by month) as month_idx,
    date_diff('day', date '1899-12-30', month) as excel_serial
  from months
)
select
  month,
  month_idx,
  excel_serial,
  max(excel_serial) over () as max_serial,
  min(excel_serial) over () as min_serial
from ordered
order by month


