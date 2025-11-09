---
title: Position Performance
queries:
  - position_performance_overview: metrics/position_performance_overview.sql
  - funds: dimensions/funds.sql
---

## Investment-Level Performance Metrics

<Dropdown data={funds} name=fund_id value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Funds" />
</Dropdown>

<Dropdown name=instrument_type defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Instrument Types" />
  <DropdownOption value="EQUITY" valueLabel="Equity" />
  <DropdownOption value="LOAN" valueLabel="Loan" />
  <DropdownOption value="CONVERTIBLE" valueLabel="Convertible" />
</Dropdown>

### Position Performance Overview

<DataTable 
  data={position_performance_overview}
  rows=20
>
  <Column id=instrument_name title="Instrument" />
  <Column id=company_name title="Company" />
  <Column id=fund_name title="Fund" />
  <Column id=gross_moic title="Gross MOIC" fmt="num1" />
  <Column id=gross_irr title="Gross IRR" fmt="pct1" />
  <Column id=cumulative_invested title="Invested" fmt="usd0" />
  <Column id=total_value title="Total Value" fmt="usd0" />
  <Column id=holding_period_years title="Holding Period (Years)" fmt="num1" />
</DataTable>

### Top 10 Positions by MOIC

<BarChart 
  data={position_performance_overview}
  x=instrument_name
  y=gross_moic
  yFmt="num1"
  title="Top Positions by MOIC"
  swapXY=true
  limit=10
/>

### MOIC vs IRR Analysis

<ScatterPlot 
  data={position_performance_overview}
  x=gross_irr
  y=gross_moic
  size=cumulative_invested
  xFmt="pct1"
  yFmt="num1"
  title="MOIC vs IRR"
  xAxisTitle="Gross IRR"
  yAxisTitle="Gross MOIC"
/>
