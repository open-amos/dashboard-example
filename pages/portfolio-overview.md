---
title: Portfolio Overview
queries:
  - portfolio_metrics: metrics/portfolio_metrics.sql
  - latest_metrics: metrics/latest_portfolio_metrics.sql
  - sector_exposure: metrics/sector_exposure.sql
  - country_exposure: metrics/country_exposure.sql
  - top_contributors: metrics/top_contributors.sql
  - top_detractors: metrics/top_detractors.sql
---

# Portfolio Performance

## Key Performance Indicators

<Grid cols=4>
  <BigValue 
    data={latest_metrics} 
    value=total_nav
    fmt="usd0"
    title="Total NAV"
  />
  <BigValue 
    data={latest_metrics} 
    value=total_commitments
    fmt="usd0"
    title="Total Commitments"
  />
  <BigValue 
    data={latest_metrics} 
    value=total_unfunded_commitment
    fmt="usd0"
    title="Total Unfunded"
  />
  <BigValue 
    data={latest_metrics} 
    value=dpi_portfolio
    fmt="num2"
    title="DPI"
  />
</Grid>

<Grid cols=3>
  <BigValue 
    data={latest_metrics} 
    value=tvpi_portfolio
    fmt="num2"
    title="TVPI"
  />
  <BigValue 
    data={latest_metrics} 
    value=number_of_funds
    fmt="num0"
    title="Number of Funds"
  />
  <BigValue 
    data={latest_metrics} 
    value=number_of_companies
    fmt="num0"
    title="Portfolio Companies"
  />
</Grid>

## NAV Trend

<LineChart 
  data={portfolio_metrics} 
  x=period_end_date 
  y=total_nav
  yFmt="usd0"
  title="Total NAV Over Time"
/>

## Net Cashflow

<AreaChart 
  data={portfolio_metrics} 
  x=period_end_date 
  y=net_cash_contributions_period
  yFmt="usd0"
  title="Net Cash Contributions by Period"
/>

## Exposure Analysis

<Grid cols=2>
  <div>
    ### Sector Exposure
    <BarChart 
      data={sector_exposure} 
      x=industry_name 
      y=exposure_usd
      yFmt="usd0"
      swapXY=true
    />
  </div>
  <div>
    ### Country Exposure
    <BarChart 
      data={country_exposure} 
      x=country_name 
      y=exposure
      yFmt="usd0"
      swapXY=true
    />
  </div>
</Grid>

## Top Contributors & Detractors

<Grid cols=2>
  <div>
    ### Top 10 Contributors
    <DataTable 
      data={top_contributors}
      rows=10
      link=company_link
    >
      <Column id=company_name title="Company" />
      <Column id=fund_name title="Fund" />
      <Column id=total_return title="Total Return" fmt="usd0" />
      <Column id=moic title="MOIC" fmt="num2" />
      <Column id=irr title="IRR" fmt="pct1" />
    </DataTable>
  </div>
  <div>
    ### Top 10 Detractors
    <DataTable 
      data={top_detractors}
      rows=10
      link=company_link
    >
      <Column id=company_name title="Company" />
      <Column id=fund_name title="Fund" />
      <Column id=total_return title="Total Return" fmt="usd0" />
      <Column id=moic title="MOIC" fmt="num2" />
      <Column id=irr title="IRR" fmt="pct1" />
    </DataTable>
  </div>
</Grid>
