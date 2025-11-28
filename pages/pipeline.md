---
title: Pipeline
sidebar_position: 3
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

<Dropdown data={funds} name=fund value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Funds" />
</Dropdown>

## Pipeline Overview 
<Note>{inputs.fund.label}</Note>

<Grid cols=5>
  <BigValue 
    data={pipeline_overview}
    value=total_opportunities
    fmt="num0"
    title="Total Opportunities"
    emptySet="pass"
    emptyMessage="-"
  />
  <BigValue 
    data={pipeline_overview}
    value=total_forecasted_exposure
    fmt="usd2m"
    title="Total Pipeline Value"
    emptySet="pass"
    emptyMessage="-"
  />
  <BigValue 
    data={pipeline_overview}
    value=avg_ticket_size
    fmt="usd2m"
    title="Avg Ticket Size"
    emptySet="pass"
    emptyMessage="-"
  />
  <BigValue 
    data={pipeline_overview}
    value=expected_deployment_12m
    fmt="usd2m"
    title="Expected Deployment (12M)"
    emptySet="pass"
    emptyMessage="-"
  />
  <BigValue 
    data={pipeline_overview}
    value=ic_count
    fmt="num0"
    title="At IC Stage"
    emptySet="pass"
    emptyMessage="-"
  />
</Grid>

<div class="section-highlight">

  ## Pipeline Funnel

  <Grid cols=3>

  <div class="section-highlight-chart">
    <FunnelChart 
      data={pipeline_funnel}
      nameCol=stage_name
      valueCol=opportunity_count
      title="Deal Count by Stage"
      subtitle="{inputs.fund.label}"
    />
    <Note>Lost: {pipeline_overview[0].lost_count}</Note>
  </div>
  <div class="section-highlight-chart">
    <FunnelChart 
      data={pipeline_funnel}
      nameCol=stage_name
      valueCol=total_expected_investment
      valueFmt="usd2m"
      title="Pipeline Value by Stage"
      subtitle="{inputs.fund.label}"
    />
  </div>

  <div class="section-highlight-chart">
    <DataTable
      title="Velocity & Conversion"
      subtitle="{inputs.fund.label}"
      data={pipeline_velocity}
      rows=all
    >
      <Column id=stage_name title="Stage" />
      <Column id=avg_days_in_stage title="Avg Days in Stage" contentType=bar fmt="num0" />
      <Column id=conversion_to_next_stage title="Conversion to Next Stage" contentType=bar barColor=#ffe08a fmt="pct1" />
    </DataTable>

    <Note>
    Note: Conversion rates exclude {pipeline_overview[0].lost_count} lost deals, as the dataset doesn't track which stage they were lost from. To calculate accurate conversion rates that account for lost deals, implement stage transition history tracking.
    </Note>
  </div>

  </Grid>

</div>

<div class="section-highlight">

  ## Forecast Impact on Portfolio

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

  <Grid cols=1>

  <div class="section-highlight-chart">
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
  </div>

  <div class="section-highlight-chart">
    <AreaMap
      data={exposure_map}
      title="Forecast Exposure by Country — {$selected_month_label?.[0]?.label}"
      subtitle="{inputs.fund.label || 'All Funds'} | {inputs.stage.label || 'All Stages'}"
      legendType="scalar"
      areaCol="country_code"
      geoId="iso_a2"
      value=exposure
      valueFmt="usd2m"
      name=country_name
      tooltip={[
        {id: 'country_name', fmt: 'str', showColumnName: false},
        {id: 'exposure', fmt: 'usd2m', showColumnName: false}
      ]}
      geoJsonUrl="https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_110m_admin_0_countries.geojson"
      height={400}
    />
    <Note>{inputs.fund.label}</Note>

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
  </div>

  </Grid>

</div>

## Active Opportunities

<Note>{inputs.fund.label}</Note>

<DataTable
  data={opportunities_by_stage}
  rows=20
>
  <Column id=stage_name title="Stage" contentType=colorscale scaleColor={['#bfbfbeff','white','#6db678']} scaleColumn=stage_order />
  <Column id=opportunity_name title="Opportunity" />
  <Column id=company_name title="Company" />
  <Column id=primary_country title="Country" />
  <Column id=primary_industry title="Industry" />
  <Column id=expected_investment_amount title="Expected Ticket" fmt=usd2m />
  <Column id=expected_close_date title="Expected Close" fmt=mmm-dd-yyyy />
  <Column id=fund_name title="Fund" />
  <Column id=stage_order title="Stage Order" hidden />
</DataTable>