---
title: Deal Flow
queries:
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

## Active Opportunities by Stage

<DataTable
  data={opportunities_by_stage}
  rows=20
>
  <Column id=stage_name title="Stage" contentType=colorscale scaleColor={['#6db678','white','#bfbfbeff']} scaleColumn=stage_order />
  <Column id=opportunity_name title="Opportunity" />
  <Column id=company_name title="Company" />
  <Column id=primary_country title="Country" />
  <Column id=primary_industry title="Industry" />
  <Column id=expected_investment_amount title="Expected Investment" fmt=usd0 />
  <Column id=expected_close_date title="Expected Close" fmt=mmm-dd-yyyy />
  <Column id=fund_name title="Fund" />
  <Column id=stage_order title="Stage Order" hidden />
</DataTable>

## Forecast the impact of upcoming deals on your portfolio

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

<AreaChart
  data={exposure_forecasts}
  title="Forecast Exposure Over Time"
  subtitle="{inputs.fund.label || 'All Funds'} | Stage: {inputs.stage.label || 'All Stages'} | {inputs.region.value} | {inputs.country.label || 'All Countries'}"
  type="stacked"
  x=month 
  y=total_exposure_usd
  series=period_type
  seriesOrder={["Current","Forecast"]}
/>

<AreaMap
  data={exposure_map}
  title="Forecast Exposure by Country ({inputs.fund.label || 'All Funds'}, {inputs.stage.label || 'All Stages'}) — {$selected_month_label?.[0]?.label}"
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

## Monitor exposure by industry

<Dropdown data={funds} name=fund value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Funds" />
</Dropdown>
<Dropdown data={stages} name=stage value=stage_id label=stage_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Stages" />
</Dropdown>
<Dropdown data={industries} name=industry value=industry_id label=industry_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Industries" />
</Dropdown>

<AreaChart
  data={exposure_forecasts}
  title="Exposure by Industry Over Time"
  subtitle="{inputs.fund.label || 'All Funds'} | Stage: {inputs.stage.label || 'All Stages'} | {inputs.industry.label || 'All Industries'}"
  type="stacked"
  x=month 
  y=total_exposure_usd
  series=period_type
  seriesOrder={["Current","Forecast"]}
  height={360}
/>

 