---
queries:
  - fund_key_metrics: metrics/fund_key_metrics.sql
  - fund_metrics_timeseries: metrics/fund_metrics_timeseries.sql
  - fund_instruments: metrics/fund_instruments.sql
---

# {fund_key_metrics[0].fund_name}

## Key Metrics

<Grid cols=4>

<BigValue 
  data={fund_key_metrics} 
  value=fund_nav
  fmt="usd0"
  title="Fund NAV"
/>

<BigValue 
  data={fund_key_metrics} 
  value=tvpi
  fmt="num1"
  title="TVPI"
/>

<BigValue 
  data={fund_key_metrics} 
  value=dpi
  fmt="num1"
  title="DPI"
/>

<BigValue 
  data={fund_key_metrics} 
  value=rvpi
  fmt="num1"
  title="RVPI"
/>

</Grid>

<Grid cols=4>

<BigValue 
  data={fund_key_metrics} 
  value=total_commitments
  fmt="usd0"
  title="Total Commitments"
/>

<BigValue 
  data={fund_key_metrics} 
  value=unfunded_commitment
  fmt="usd0"
  title="Unfunded Commitment"
/>

<BigValue 
  data={fund_key_metrics} 
  value=total_distributions
  fmt="usd0"
  title="Total Distributions"
/>

<BigValue 
  data={fund_key_metrics} 
  value=number_of_portfolio_companies
  fmt="num0"
  title="Portfolio Companies"
/>

</Grid>

<hr class="my-4" />

## Performance Over Time

<Grid cols=2>

<LineChart
  data={fund_metrics_timeseries}
  title="Fund NAV Over Time"
  x=period_end_date
  y=fund_nav
  yFmt=usd0
/>

<LineChart
  data={fund_metrics_timeseries}
  title="TVPI Over Time"
  x=period_end_date
  y=tvpi
  yFmt=num1
/>

<LineChart
  data={fund_metrics_timeseries}
  title="DPI Over Time"
  x=period_end_date
  y=dpi
  yFmt=num1
/>

<LineChart
  data={fund_metrics_timeseries}
  title="Total Distributions Over Time"
  x=period_end_date
  y=total_distributions
  yFmt=usd0
/>

</Grid>

<hr class="my-4" />

## Fund Holdings

{#if fund_instruments.length}

### Holdings Performance Analysis

<ScatterPlot 
  data={fund_instruments}
  x=gross_irr
  y=gross_moic
  size=cumulative_invested
  series=instrument_type
  tooltipTitle=instrument_name
  xFmt="pct1"
  yFmt="num1"
  title="MOIC vs IRR by Position"
  xAxisTitle="Gross IRR"
  yAxisTitle="Gross MOIC"
/>

### Holdings Detail

<DataTable data={fund_instruments} rows=20 search=true>
  <Column id=instrument_name title="Instrument" />
  <Column id=company_name title="Company" />
  <Column id=instrument_type title="Type" />
  <Column id=initial_investment_date title="Investment Date" />
  <Column id=cumulative_invested title="Invested" fmt=usd0 />
  <Column id=current_fair_value title="Fair Value" fmt=usd0 />
  <Column id=total_value title="Total Value" fmt=usd0 />
  <Column id=gross_irr title="IRR" fmt=pct1 />
  <Column id=gross_moic title="MOIC" fmt=num1 contentType=bar />
</DataTable>

{:else}

No instruments found for this fund.

{/if}
