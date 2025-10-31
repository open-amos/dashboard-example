---
title: Portfolio
---

<Dropdown data={funds} name=fund value=fund_id label=fund_name defaultValue="ALL" />
<Dropdown data={stages} name=stage value=stage_id label=stage_name defaultValue="ALL" />
<Dropdown data={regions} name=region value=region label=region defaultValue="All Regions" />

<AreaChart
  data={exposure_ts}
  title="Current vs Forecast Exposure Over Time"
  type="stacked"
  x=month
  y=total_exposure_usd
  series=period_type
  seriesOrder={["Current","Forecast"]}
/>

```sql metrics
  select
    *
  from mrt_exposure_by_region
  order by total_exposure_usd desc 
```

```sql funds
  select distinct
    fund_id,
    fund_name
  from mrt_exposure_by_region
  order by fund_name
```

```sql stages
  select distinct
    stage_id,
    stage_name
  from mrt_exposure_by_region
  order by stage_name
```
```sql regions
  select distinct
    region
  from mrt_exposure_by_region
  order by region
```

```sql exposure_ts
  with filtered as (
    select
      date_trunc('month', cast(exposure_month as timestamp)) as month,
      deployed_capital_usd,
      closed_pipeline_usd,
      total_exposure_usd,
      period_type
    from mrt_exposure_by_region
    where 1=1
      and cast(fund_id as varchar) = '${inputs.fund.value}'
      and cast(stage_id as varchar) = '${inputs.stage.value}'
      and region = '${inputs.region.value}'
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
```