---
title: Cashflows
queries:
  - equity_cashflows: metrics/equity_cashflows_timeseries.sql
  - credit_cashflows: metrics/credit_cashflows_timeseries.sql
  - equity_funds: dimensions/equity_funds.sql
  - credit_funds: dimensions/credit_funds.sql
---

# Cashflow Analysis

<Tabs color=primary>

<Tab label="Equity Cashflows">

## Equity Cashflows

Equity investment lifecycle: contributions (investments) and distributions (exits, dividends, return of capital).

<Dropdown data={equity_funds} name=fund_id value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Equity Funds" />
</Dropdown>

<DateRange 
  name=date_range
/>

### Cashflows Over Time

<AreaChart 
  data={equity_cashflows}
  x=cashflow_date
  y=cashflow_amount
  series=direction
  type="stacked"
  yFmt="usd0"
  title="Equity Cashflows Over Time (J-Curve)"
/>

### Cashflow Breakdown by Type

<BarChart 
  data={equity_cashflows}
  x=cashflow_type
  y=cashflow_amount
  yFmt="usd0"
  title="Equity Cashflow Breakdown"
  swapXY=true
/>

### Cumulative Cashflows

```sql equity_cumulative
select
  cashflow_date,
  sum(case when direction = 'outflow' then cashflow_amount else 0 end) 
    over (order by cashflow_date rows between unbounded preceding and current row) as cumulative_contributions,
  sum(case when direction = 'inflow' then cashflow_amount else 0 end) 
    over (order by cashflow_date rows between unbounded preceding and current row) as cumulative_distributions
from ${equity_cashflows}
order by cashflow_date
```

<LineChart 
  data={equity_cumulative}
  x=cashflow_date
  y={['cumulative_contributions', 'cumulative_distributions']}
  yFmt="usd0"
  title="Cumulative Contributions vs Distributions"
  labels={{
    cumulative_contributions: 'Cumulative Contributions',
    cumulative_distributions: 'Cumulative Distributions'
  }}
/>

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
  <Column id=cashflow_amount title="Amount" fmt="usd0" />
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

### Cashflows Over Time

<AreaChart 
  data={credit_cashflows}
  x=cashflow_date
  y=cashflow_amount
  series=direction
  type="stacked"
  yFmt="usd0"
  title="Credit Cashflows Over Time"
/>

### Cashflow Breakdown by Type

<BarChart 
  data={credit_cashflows}
  x=cashflow_type
  y=cashflow_amount
  yFmt="usd0"
  title="Credit Cashflow Breakdown"
  swapXY=true
/>

### Repayment Profile

```sql credit_repayment
select
  cashflow_date,
  sum(case when cashflow_type = 'DRAW' then cashflow_amount else 0 end) as draws,
  sum(case when cashflow_type = 'PRINCIPAL' then cashflow_amount else 0 end) as principal_repayments,
  sum(case when cashflow_type = 'PREPAYMENT' then cashflow_amount else 0 end) as prepayments,
  sum(case when cashflow_type = 'INTEREST' then cashflow_amount else 0 end) as interest_income
from ${credit_cashflows}
group by cashflow_date
order by cashflow_date
```

<LineChart 
  data={credit_repayment}
  x=cashflow_date
  y={['draws', 'principal_repayments', 'prepayments', 'interest_income']}
  yFmt="usd0"
  title="Credit Cashflow Components"
  labels={{
    draws: 'Draws',
    principal_repayments: 'Principal Repayments',
    prepayments: 'Prepayments',
    interest_income: 'Interest Income'
  }}
/>

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
  <Column id=cashflow_amount title="Amount" fmt="usd0" />
  <Column id=direction title="Direction" />
</DataTable>

</Tab>

</Tabs>
