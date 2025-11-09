with base as (
  select
    date_trunc('month', cast(exposure_month as date)) as month,
    country_code,
    country_name,
    sum(coalesce(total_exposure_usd, 0)) as exposure
  from metrics_exposure_timeseries
  where 1=1
    and (fund_id = '${inputs.fund.value}' or '${inputs.fund.value}' = 'ALL')
    and (stage_id = '${inputs.stage.value}' or '${inputs.stage.value}' = 'ALL' or stage_id is null)
  group by 1, 2, 3
), selected as (
  select date_trunc('month', cast(date '1899-12-30' + (${inputs.month} * interval 1 day) as date)) as selected_month
)
select 
  b.country_code, 
  b.country_name,
  b.exposure
from base b
where b.month = (select selected_month from selected)
  and b.exposure > 0


