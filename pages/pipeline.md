---
title: Pipeline
sidebar_position: 4
queries:
  - pipeline_overview: metrics/pipeline_overview.sql
  - pipeline_funnel: metrics/pipeline_funnel.sql
  - pipeline_velocity: metrics/pipeline_stage_velocity.sql
  - pipeline_sector_forecast: metrics/pipeline_sector_forecast.sql
  - months_slider: helpers/months_slider.sql
  - funds: dimensions/funds.sql
  - stages: dimensions/stages.sql
  - industries: dimensions/industries.sql
  - regions: dimensions/regions.sql
  - countries: dimensions/countries.sql
  - selected_month_label: helpers/selected_month_label.sql
  - exposure_forecasts: metrics/exposure_forecasts.sql
  - exposure_map: metrics/exposure_map.sql
  - opportunities_by_stage: dimensions/opportunities_by_stage.sql
---

# Investment Pipeline

## Pipeline Overview

<Grid cols=5>
  <BigValue 
    data={pipeline_overview}
    value=total_opportunities
    fmt="num0"
    title="Total Opportunities"
  />
  <BigValue 
    data={pipeline_overview}
    value=total_forecasted_exposure
    fmt="usd0"
    title="Total Pipeline Value"
  />
  <BigValue 
    data={pipeline_overview}
    value=avg_ticket_size
    fmt="usd0"
    title="Avg Ticket Size"
  />
  <BigValue 
    data={pipeline_overview}
    value=expected_deployment_12m
    fmt="usd0"
    title="Expected Deployment (12M)"
  />
  <BigValue 
    data={pipeline_overview}
    value=ic_count
    fmt="num0"
    title="At IC Stage"
  />
</Grid>

<hr class="my-6">

## Pipeline Funnel

<Grid cols=2>

<div>
  <FunnelChart 
    data={pipeline_funnel}
    nameCol=stage_name
    valueCol=opportunity_count
    title="Deal Count by Stage"
  />
  <Note>Lost: {pipeline_overview[0].lost_count}</Note>
</div>
<div>
  <FunnelChart 
    data={pipeline_funnel}
    nameCol=stage_name
    valueCol=total_expected_investment
    valueFmt="usd0"
    title="Pipeline Value by Stage"
  />
</div>

</Grid>

<hr class="my-6">

## Active Opportunities

<DataTable
  data={opportunities_by_stage}
  rows=20
>
  <Column id=stage_name title="Stage" contentType=colorscale scaleColor={['#bfbfbeff','white','#6db678']} scaleColumn=stage_order />
  <Column id=opportunity_name title="Opportunity" />
  <Column id=company_name title="Company" />
  <Column id=primary_country title="Country" />
  <Column id=primary_industry title="Industry" />
  <Column id=expected_investment_amount title="Expected Ticket" fmt=usd0 />
  <Column id=expected_close_date title="Expected Close" fmt=mmm-dd-yyyy />
  <Column id=fund_name title="Fund" />
  <Column id=stage_order title="Stage Order" hidden />
</DataTable>

<hr class="my-6">

## Pipeline Velocity & Conversion

<Grid cols=3>
  <BigValue 
    data={pipeline_velocity.filter(d => d.stage_name === 'Sourced')}
    value=avg_days_in_stage
    fmt="num0"
    title="Avg Days in Sourced"
  />
  <BigValue 
    data={pipeline_velocity.filter(d => d.stage_name === 'Screening')}
    value=avg_days_in_stage
    fmt="num0"
    title="Avg Days in Screening"
  />
  <BigValue 
    data={pipeline_velocity.filter(d => d.stage_name === 'Investment Committee')}
    value=avg_days_in_stage
    fmt="num0"
    title="Avg Days in IC"
  />
</Grid>

<Grid cols=2>
  <BigValue 
    data={pipeline_velocity}
    value=sourced_to_ic_rate
    fmt="pct0"
    title="Sourced → IC Conversion"
  />
  <BigValue 
    data={pipeline_velocity}
    value=ic_to_closed_rate
    fmt="pct0"
    title="IC → Closed Conversion"
  />
</Grid>

<hr class="my-6">

## Forecast Impact on Portfolio

<Dropdown data={funds} name=fund value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Funds" />
</Dropdown>
<Dropdown data={stages} name=stage value=stage_id label=stage_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Stages" />
</Dropdown>
<Dropdown data={regions} name=region value=region label=region defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Regions" />
</Dropdown>
<Dropdown data={countries} name=country value=country_code label=country_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Countries" />
</Dropdown>
<Dropdown data={industries} name=industry value=industry_id label=industry_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Industries" />
</Dropdown>

<AreaChart
  data={exposure_forecasts}
  title="Current vs Forecast Exposure"
  subtitle="{inputs.fund.label} | {inputs.stage.label} | {inputs.region.label} | {inputs.country.label}"
  type="stacked"
  x=month 
  y=total_exposure_usd
  series=period_type
  seriesOrder={["Current","Forecast"]}
/>

<AreaMap
  data={exposure_map}
  title="Forecast Exposure by Country — {$selected_month_label?.[0]?.label}"
  subtitle="{inputs.fund.label || 'All Funds'} | {inputs.stage.label || 'All Stages'}"
  legendType="scalar"
  areaCol="country_code"
  geoId="iso_a2"
  value=exposure
  valueFmt="usd0k"
  name=country_name
  tooltip={[
    {id: 'country_name', fmt: 'str', showColumnName: false},
    {id: 'exposure', fmt: 'usd0', showColumnName: false}
  ]}
  geoJsonUrl="https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_110m_admin_0_countries.geojson"
  height={480}
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