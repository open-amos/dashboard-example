---
title: Funds
queries:
  - fund_performance_overview: metrics/fund_performance_overview.sql
  - fund_performance_aggregate: metrics/fund_performance_aggregate.sql
  - funds_list: metrics/funds_list.sql
  - funds: dimensions/funds.sql
---

## Key Metrics

<BigValue 
  data={fund_performance_aggregate} 
  value=total_commitments
  fmt="usd0"
  title="Total Commitments"
/>

<BigValue 
  data={fund_performance_aggregate} 
  value=unfunded_commitment
  fmt="usd0"
  title="Unfunded Commitment"
/>

<BigValue 
  data={fund_performance_aggregate} 
  value=total_distributions
  fmt="usd0"
  title="Total Distributions"
/>

## Funds Overview

<DataTable 
  data={funds_list}
  rows=20
  link=fund_link
>
  <Column id=fund_name title="Fund Name" />
  <Column id=fund_nav title="Fund NAV" fmt="usd0" />
  <Column id=tvpi title="TVPI" fmt="num1" />
  <Column id=dpi title="DPI" fmt="num1" />
  <Column id=rvpi title="RVPI" fmt="num1" />
  <Column id=total_commitments title="Total Commitments" fmt="usd0" />
  <Column id=unfunded_commitment title="Unfunded" fmt="usd0" />
  <Column id=number_of_portfolio_companies title="Portfolio Companies" />
</DataTable>

## TVPI Comparison Across Funds

<BarChart 
  data={fund_performance_overview}
  x=fund_name
  y=tvpi
  yFmt="num1"
  title="TVPI by Fund"
  swapXY=true
/>

## Fund NAV Over Time

<BarChart 
  data={fund_performance_overview}
  x=period_end_date
  y=fund_nav
  series=fund_name
  yFmt="usd0"
  title="Fund NAV Trend"
/>
