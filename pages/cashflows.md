---
title: Cashflows
sidebar_position: 4
queries:
  - equity_cashflows: metrics/equity_cashflows_timeseries.sql
  - credit_cashflows: metrics/credit_cashflows_timeseries.sql
  - equity_cumulative_cashflows: metrics/equity_cumulative_cashflows.sql
  - equity_funds: dimensions/equity_funds.sql
  - credit_funds: dimensions/credit_funds.sql
  - credit_repayments: metrics/credit_repayments.sql
---

<Tabs color=primary>

<Tab label="Equity Cashflows">

## Equity Cashflows

Equity investment lifecycle: contributions (investments) and distributions (exits, dividends, return of capital).

<Dropdown data={equity_funds} name=fund_id value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Equity Funds" />
</Dropdown>

<DateRange 
  name=date_range
  defaultValue="Last 365 Days"
/>

<div class="section-highlight">

### Cashflows Over Time & Breakdown By Type

<Grid cols=2>

  <div class="section-highlight-chart">

    <AreaChart 
      data={equity_cashflows}
      x=cashflow_date
      y=cashflow_amount
      series=direction
      type="stacked"
      yFmt="usd2m"
      title="Equity Cashflows Over Time (J-Curve)"
    />

  </div>

  <div class="section-highlight-chart">

    <BarChart 
      data={equity_cashflows}
      x=cashflow_type
      y=cashflow_amount
      yFmt="usd2m"
      title="Equity Cashflow Breakdown"
      swapXY=true
    />

  </div>

</Grid>

</div>

<div class="section-highlight">

  ### Cumulative Cashflows

  <div class="section-highlight-chart">

    <LineChart 
      data={equity_cumulative_cashflows}
      x=cashflow_date
      y={['cumulative_contributions', 'cumulative_distributions']}
      yFmt="usd2m"
      title="Cumulative Contributions vs Distributions"
      labels={{
        cumulative_contributions: 'Cumulative Contributions',
        cumulative_distributions: 'Cumulative Distributions'
      }}
    />

  </div>

</div>

### Detailed Transactions

<DataTable 
  data={equity_cashflows}
  rows=20
>
  <Column id=cashflow_date title="Date" fmt="mmm dd, yyyy" />
  <Column id=fund_name title="Fund" />
  <Column id=instrument_name title="Instrument" />
  <Column id=company_name title="Company" />
  <Column id=cashflow_type title="Type" />
  <Column id=cashflow_amount title="Amount" fmt="usd2m" />
  <Column id=direction title="Direction" />
</DataTable>

</Tab>

<Tab label="Credit Cashflows">

## Credit Cashflows

Credit portfolio activity: draws, principal repayments, interest income, and prepayments.

<Dropdown data={credit_funds} name=fund_id value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Credit Funds" />
</Dropdown>

<DateRange 
  name=date_range
/>

<div class="section-highlight">

### Cashflows Over Time & Breakdown By Type

<Grid cols=2>

  <div class="section-highlight-chart">

    <AreaChart 
      data={credit_cashflows}
      x=cashflow_date
      y=cashflow_amount
      series=direction
      type="stacked"
      yFmt="usd2m"
      title="Credit Cashflows Over Time"
    />

  </div>

  <div class="section-highlight-chart">

    <BarChart 
      data={credit_cashflows}
      x=cashflow_type
      y=cashflow_amount
      yFmt="usd2m"
      title="Credit Cashflow Breakdown"
      swapXY=true
    />

  </div>

</Grid>

</div>

<div class="section-highlight">

  ### Repayment Profile

  <div class="section-highlight-chart">

    <BarChart 
      data={credit_repayments}
      x=cashflow_date
      y={['draws', 'principal_repayments', 'prepayments', 'interest_income']}
      yFmt="usd2m"
      title="Credit Cashflow Components"
      labels={{
        draws: 'Draws',
        principal_repayments: 'Principal Repayments',
        prepayments: 'Prepayments',
        interest_income: 'Interest Income'
      }}
    />

  </div>

</div>

### Detailed Transactions

<DataTable 
  data={credit_cashflows}
  rows=20
>
  <Column id=cashflow_date title="Date" fmt="mmm dd, yyyy" />
  <Column id=fund_name title="Fund" />
  <Column id=instrument_name title="Instrument" />
  <Column id=company_name title="Company" />
  <Column id=cashflow_type title="Type" />
  <Column id=cashflow_amount title="Amount" fmt="usd2m" />
  <Column id=direction title="Direction" />
</DataTable>

</Tab>

</Tabs>
