---
title: Returns Analysis
queries:
  - returns_cashflows_timeseries: metrics/returns_cashflows_timeseries.sql
  - funds: dimensions/funds.sql
---

## Cashflow Analysis

<Dropdown data={funds} name=fund_id value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Funds" />
</Dropdown>

### Cashflows Over Time

<AreaChart 
  data={returns_cashflows_timeseries}
  x=cashflow_date
  y=cashflow_amount
  series=direction
  type="stacked"
  yFmt="usd0"
  title="Cashflows by Direction"
/>

### Cashflow Breakdown by Type

<BarChart 
  data={returns_cashflows_timeseries}
  x=cashflow_type
  y=cashflow_amount
  yFmt="usd0"
  title="Cashflow by Type"
  swapXY=true
/>

### Detailed Cashflow Transactions

<DataTable 
  data={returns_cashflows_timeseries}
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
