---
title: Funds
sidebar_position: 2
queries:
  - fund_performance_overview: metrics/fund_performance_overview.sql
  - fund_performance_aggregate: metrics/fund_performance_aggregate.sql
  - equity_funds_aggregate: metrics/equity_funds_aggregate.sql
  - credit_funds_aggregate: metrics/credit_funds_aggregate.sql
  - funds_list: metrics/funds_list.sql
  - funds: dimensions/funds.sql
---

<Tabs color=primary>

{#if funds_list.filter(d => d.fund_type === 'EQUITY').length > 0}

<Tab label="Equity">

## Private Equity Funds

### Key Metrics

<Grid cols=4>
  <BigValue 
    data={equity_funds_aggregate} 
    value=total_commitments
    fmt="usd0"
    title="Total Commitments"
  />
  <BigValue 
    data={equity_funds_aggregate} 
    value=unfunded_commitment
    fmt="usd0"
    title="Unfunded Commitment"
  />
  <BigValue 
    data={equity_funds_aggregate} 
    value=total_distributions
    fmt="usd0"
    title="Total Distributions"
  />
  <BigValue 
    data={equity_funds_aggregate} 
    value=total_nav
    fmt="usd0"
    title="Total NAV"
  />
</Grid>

<hr class="my-6">

### Equity Funds Overview

<DataTable 
  data={funds_list.filter(d => d.fund_type === 'EQUITY')}
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
  <Column id=number_of_portfolio_companies title="Portfolio Companies" fmt="num0" />
</DataTable>

### TVPI Comparison

<BarChart 
  data={fund_performance_overview.filter(d => d.fund_type === 'EQUITY')}
  x=fund_name
  y=tvpi
  yFmt="num1"
  title="TVPI by Equity Fund"
  swapXY=true
/>

### Fund NAV Over Time

<BarChart 
  data={fund_performance_overview.filter(d => d.fund_type === 'EQUITY')}
  x=period_end_date
  y=fund_nav
  series=fund_name
  yFmt="usd0"
  title="Equity Fund NAV Trend"
/>

</Tab>

{/if}

{#if funds_list.filter(d => d.fund_type === 'CREDIT').length > 0}

<Tab label="Credit">

## Private Credit Funds

### Key Metrics

<Grid cols=4>
  <BigValue 
    data={credit_funds_aggregate} 
    value=total_exposure
    fmt="usd0"
    title="Total Exposure"
  />
  <BigValue 
    data={credit_funds_aggregate} 
    value=principal_outstanding
    fmt="usd0"
    title="Principal Outstanding"
  />
  <BigValue 
    data={credit_funds_aggregate} 
    value=undrawn_commitment
    fmt="usd0"
    title="Undrawn Commitment"
  />
  <BigValue 
    data={credit_funds_aggregate} 
    value=interest_income
    fmt="usd0"
    title="Interest Income"
  />
</Grid>

<hr class="my-6">

### Credit Funds Overview

<DataTable 
  data={funds_list.filter(d => d.fund_type === 'CREDIT')}
  rows=20
  link=fund_link
>
  <Column id=fund_name title="Fund Name" />
  <Column id=total_exposure title="Total Exposure" fmt="usd0" />
  <Column id=principal_outstanding title="Principal Outstanding" fmt="usd0" />
  <Column id=undrawn_commitment title="Undrawn" fmt="usd0" />
  <Column id=interest_income title="Interest Income" fmt="usd0" />
  <Column id=total_commitments title="Total Commitments" fmt="usd0" />
  <Column id=number_of_positions title="Positions" fmt="num0" />
</DataTable>

### Principal Outstanding Comparison

<BarChart 
  data={fund_performance_overview.filter(d => d.fund_type === 'CREDIT')}
  x=fund_name
  y=principal_outstanding
  yFmt="usd0"
  title="Principal Outstanding by Credit Fund"
  swapXY=true
/>

### Principal Outstanding Over Time

<BarChart 
  data={fund_performance_overview.filter(d => d.fund_type === 'CREDIT')}
  x=period_end_date
  y=principal_outstanding
  series=fund_name
  yFmt="usd0"
  title="Credit Fund Principal Outstanding Trend"
/>

</Tab>

{/if}

</Tabs>
