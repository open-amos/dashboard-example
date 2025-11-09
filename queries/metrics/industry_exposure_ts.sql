with filtered as (
  select
    date_trunc('month', cast(exposure_month as timestamp)) as month,
    deployed_capital_usd,
    closed_pipeline_usd,
    period_type
  from metrics_exposure_timeseries
  where 1=1
    and (fund_id = '${inputs.fund.value}' or '${inputs.fund.value}' = 'ALL')
    and (stage_id = '${inputs.stage.value}' or '${inputs.stage.value}' = 'ALL' or stage_id is null)
    and (industry_id = '${inputs.industry.value}' or '${inputs.industry.value}' = 'ALL')
), months as (
  select distinct month from filtered
), first_current_month as (
  select min(month) as min_month from filtered where period_type = 'Current'
), current_base as (
  select sum(coalesce(deployed_capital_usd, 0)) as current_value
  from filtered
  where period_type = 'Current'
    and month = (select min_month from first_current_month)
), current_series as (
  select m.month, 'Current' as period_type, coalesce(cb.current_value, 0) as total_exposure_usd
  from months m
  cross join current_base cb
), forecast_series as (
  select m.month, 'Forecast' as period_type, coalesce(fc.total_exposure_usd, 0) as total_exposure_usd
  from months m
  left join (
    select month, sum(coalesce(closed_pipeline_usd, 0)) as total_exposure_usd
    from filtered
    where period_type = 'Forecast'
    group by 1
  ) fc on fc.month = m.month
)
select * from forecast_series
union all
select * from current_series
order by month asc


