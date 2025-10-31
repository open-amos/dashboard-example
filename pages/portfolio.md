---
title: Portfolio
---

<Dropdown data={funds} name=fund value=fund_id label=fund_name defaultValue="ALL" />
<Dropdown data={stages} name=stage value=stage_id label=stage_name defaultValue="ALL" />
<Dropdown data={regions} name=region value=region label=region defaultValue="All Regions" />
<Dropdown data={countries} name=country value=country_code label=country_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Countries" />
</Dropdown>

<AreaChart
  data={exposure_ts}
  title="Current vs Forecast Exposure Over Time"
  subtitle="{inputs.fund.label || 'All Funds'} | Stage: {inputs.stage.label || 'All Stages'} | {inputs.region.value} | {inputs.country.label || 'All Countries'}"
  type="stacked"
  x=month 
  y=total_exposure_usd
  series=period_type
  seriesOrder={["Current","Forecast"]}
/>

<Slider
  name="month"
  title="Month"
  data={months_slider}
  range="excel_serial"
  defaultValue="min_serial"
  maxColumn="max_serial"
  minColumn="min_serial"
  fmt="mmm yyyy"
  size="large"
/>

<p class="text-[13px] text-base-content-muted mt-0 mb-2">
  Fund: {inputs.fund.label || 'All Funds'} | Stage: {inputs.stage.label || 'All Stages'} | Region: {inputs.region.value} | Country: {inputs.country.label || 'All Countries'}
</p>

<AreaMap
  data={exposure_map}
  title="Exposure by Country"
  description="{inputs.fund.label || 'All Funds'} | Stage: {inputs.stage.label || 'All Stages'} | {inputs.region.value} | {inputs.country.label || 'All Countries'}"
  legendType="scalar"
  areaCol="country_code"
  geoId="iso_a2"
  value=exposure_usd
  geoJsonUrl="https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_110m_admin_0_countries.geojson"
  height={480}
/>

```sql metrics
  select 
    *
  from mrt_exposure_by_region
  order by total_exposure_usd desc 
```

```sql months_slider
  with months as (
    select distinct date_trunc('month', cast(exposure_month as date)) as month
    from mrt_exposure_by_region
    where 1=1
      and cast(fund_id as varchar) = '${inputs.fund.value}'
      and cast(stage_id as varchar) = '${inputs.stage.value}'
      and region = '${inputs.region.value}'
      and country_code = '${inputs.country.value}'
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

```sql countries
  select distinct
    country_code,
    country_name
  from mrt_exposure_by_region
  where country_code is not null
    and country_name is not null
    and region = '${inputs.region.value}'
  order by country_name
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
      and country_code = '${inputs.country.value}'
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

```sql exposure_map
  with base as (
    select
      date_trunc('month', cast(exposure_month as date)) as month,
      country_code,
      sum(coalesce(total_exposure_usd,0)) as exposure_usd
    from mrt_exposure_by_region
    where 1=1
      and cast(fund_id as varchar) = '${inputs.fund.value}'
      and cast(stage_id as varchar) = '${inputs.stage.value}'
    group by 1,2
  ), selected as (
    select date_trunc('month', cast(date '1899-12-30' + (${inputs.month} * interval 1 day) as date)) as selected_month
  )
  select b.country_code, b.exposure_usd
  from base b
  where b.month = (select selected_month from selected)
```