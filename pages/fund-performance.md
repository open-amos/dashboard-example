---
title: Fund Performance
queries:
  - fund_performance_overview: metrics/fund_performance_overview.sql
  - funds: dimensions/funds.sql
---

## Fund-Level Performance Metrics

<Dropdown data={funds} name=fund_id value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Funds" />
</Dropdown>

### Key Metrics

<BigValue 
  data={fund_performance_overview} 
  value=total_commitments
  fmt="usd0"
  title="Total Commitments"
/>

<BigValue 
  data={fund_performance_overview} 
  value=unfunded_commitment
  fmt="usd0"
  title="Unfunded Commitment"
/>

<BigValue 
  data={fund_performance_overview} 
  value=total_distributions
  fmt="usd0"
  title="Total Distributions"
/>

### Fund Performance Overview

<DataTable 
  data={fund_performance_overview}
  rows=20
>
  <Column id=fund_name title="Fund Name" />
  <Column id=period_end_date title="Period End" fmt="mmm yyyy" />
  <Column id=fund_nav title="Fund NAV" fmt="usd0" />
  <Column id=tvpi title="TVPI" fmt="num1" />
  <Column id=dpi title="DPI" fmt="num1" />
  <Column id=rvpi title="RVPI" fmt="num1" />
  <Column id=number_of_portfolio_companies title="Portfolio Companies" />
</DataTable>

### TVPI Comparison Across Funds

<BarChart 
  data={fund_performance_overview}
  x=fund_name
  y=tvpi
  yFmt="num1"
  title="TVPI by Fund"
  swapXY=true
/>

### Fund NAV Over Time

<LineChart 
  data={fund_performance_overview}
  x=period_end_date
  y=fund_nav
  series=fund_name
  yFmt="usd0"
  title="Fund NAV Trend"
/>
