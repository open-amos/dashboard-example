---
title: Company Performance
queries:
  - company_performance_overview: metrics/company_performance_overview.sql
---

## Company-Level Financial Metrics

### Company Financials

<DataTable 
  data={company_performance_overview}
  rows=20
>
  <Column id=company_name title="Company Name" />
  <Column id=period_end_date title="Period End" fmt="mmm yyyy" />
  <Column id=revenue title="Revenue" fmt="usd0" />
  <Column id=ebitda title="EBITDA" fmt="usd0" />
  <Column id=ebitda_margin title="EBITDA Margin" fmt="pct1" />
  <Column id=ev_to_ebitda title="EV/EBITDA" fmt="num1" />
  <Column id=primary_industry title="Industry" />
</DataTable>

### Revenue by Company

<BarChart 
  data={company_performance_overview}
  x=company_name
  y=revenue
  yFmt="usd0"
  title="Revenue by Company"
  swapXY=true
/>

### Valuation Multiples Analysis

<ScatterPlot 
  data={company_performance_overview}
  x=ebitda_margin
  y=ev_to_ebitda
  series=primary_industry
  xFmt="pct1"
  yFmt="num1"
  title="EV/EBITDA vs EBITDA Margin"
  xAxisTitle="EBITDA Margin"
  yAxisTitle="EV/EBITDA Multiple"
/>
