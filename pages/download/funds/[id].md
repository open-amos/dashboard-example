---
queries:
  - fund_key_metrics: metrics/fund_key_metrics.sql
  - fund_metrics_timeseries: metrics/fund_metrics_timeseries.sql
  - fund_instruments: metrics/fund_instruments.sql
  - fund_credit_maturity_ladder: metrics/fund_credit_maturity_ladder.sql
  - fund_credit_yield_distribution: metrics/fund_credit_yield_distribution.sql
  - fund_sector_exposure: metrics/fund_sector_exposure.sql
  - fund_country_exposure: metrics/fund_country_exposure.sql
  - report_metadata: helpers/report_metadata.sql
  - next_quarter: helpers/next_quarter.sql
  - equity_metrics_table: metrics/fund_equity_metrics_table.sql
  - credit_metrics_table: metrics/fund_credit_metrics_table.sql
---

<ExportToWordButton pageTitle="Quarterly Report" buttonText="⬇️ Download Report"/>

<div class="report-content mt-12 p-6 border border-gray-300 rounded-lg">

  <Image url="https://placehold.co/150x150?text=Your+Logo" height=200 align=left></Image>

  <hr class="mt-16" />

  # Quarterly Report
  ## {fund_key_metrics[0].fund_name}
  ## {report_metadata[0].quarter_label}

  <hr class="mb-16" />

  <LineBreak/>

  **Report Date:** {report_metadata[0].report_date}

  <PageBreak/>

  <div class="start-report"></div>

  <script>
    export const prerender = false;
  </script>

  {#if fund_key_metrics[0].fund_type === 'EQUITY'}

  ## Key Metrics - Private Equity

  <DataTable data={equity_metrics_table} rows=all>
    <Column id=metric />
    <Column id=value fmt=id />
  </DataTable>

  <hr class="my-4" />

  ## Performance Over Time

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

  <hr class="my-4" />

  ## Portfolio Exposure

  <BarChart 
    data={fund_sector_exposure}
    x=industry_name
    y=exposure
    yFmt="usd0"
    title="Sector Exposure"
    swapXY=true
    limit=10
  />

  <BarChart 
    data={fund_country_exposure}
    x=country_name
    y=exposure
    yFmt="usd0"
    title="Country Exposure"
    swapXY=true
    limit=10
  />

  <hr class="my-4" />

  ## Fund Holdings

  {#if fund_instruments.filter(d => d.instrument_type === 'EQUITY').length > 0}

  ### Holdings Performance Analysis

  <BarChart 
    data={fund_instruments.filter(d => d.instrument_type === 'EQUITY')}
    x=instrument_name
    y=moic
    yFmt="num1"
    title="Top Positions by MOIC"
    swapXY=true
    limit=10
  />

  <ScatterPlot 
    data={fund_instruments.filter(d => d.instrument_type === 'EQUITY')}
    x=equity_irr_approx
    y=moic
    size=cost_basis
    tooltipTitle=instrument_name
    xFmt="pct1"
    yFmt="num1"
    title="MOIC vs IRR (Approx) by Position"
    xAxisTitle="Approx IRR"
    yAxisTitle="Gross MOIC"
  />

  ### Holdings Detail

  <DataTable data={fund_instruments.filter(d => d.instrument_type === 'EQUITY')} rows=20>
    <Column id=instrument_name title="Instrument" />
    <Column id=company_name title="Company" />
    <Column id=initial_investment_date title="Investment Date" />
    <Column id=cumulative_invested title="Invested" fmt=usd0 />
    <Column id=fair_value title="Fair Value" fmt=usd0 />
    <Column id=total_value title="Total Value" fmt=usd0 />
    <Column id=equity_irr_approx title="IRR (Approx)" fmt=pct1 />
    <Column id=moic title="MOIC" fmt=num1 contentType=bar />
    <Column id=ownership_pct_current title="Ownership %" fmt=pct1 />
  </DataTable>

  {:else}

  No equity holdings found for this fund.

  {/if}

  {:else if fund_key_metrics[0].fund_type === 'CREDIT'}

  ## Key Metrics - Private Credit

  <DataTable data={credit_metrics_table} rows=all>
    <Column id=metric />
    <Column id=value fmt=id />
  </DataTable>

  <hr class="my-4" />

  ## Performance Over Time

  <LineChart
    data={fund_metrics_timeseries}
    title="Total Exposure Over Time"
    x=period_end_date
    y=total_exposure
    yFmt=usd0
  />

  <LineChart
    data={fund_metrics_timeseries}
    title="Principal Outstanding Over Time"
    x=period_end_date
    y=principal_outstanding
    yFmt=usd0
  />

  <LineChart
    data={fund_metrics_timeseries}
    title="Undrawn Commitment Over Time"
    x=period_end_date
    y=undrawn_commitment
    yFmt=usd0
  />

  <LineChart
    data={fund_metrics_timeseries}
    title="Interest Income Over Time"
    x=period_end_date
    y=interest_income
    yFmt=usd0
  />

  <hr class="my-4" />

  ## Credit Portfolio Analysis

  {#if fund_credit_maturity_ladder.length > 0 && fund_credit_yield_distribution.length > 0}

  <BarChart 
    data={fund_credit_maturity_ladder}
    x=maturity_year
    y=principal_maturing
    yFmt="usd0"
    title="Maturity Ladder"
    xAxisTitle="Maturity Year"
    yAxisTitle="Principal Maturing"
  />

  <BarChart 
    data={fund_credit_yield_distribution}
    x=instrument_name
    y=all_in_yield
    yFmt="pct1"
    title="All-in Yield by Position"
    swapXY=true
    limit=10
  />

  {:else}

  No credit portfolio data available for analysis.

  {/if}

  <hr class="my-4" />

  ## Portfolio Exposure

  <BarChart 
    data={fund_sector_exposure}
    x=industry_name
    y=exposure
    yFmt="usd0"
    title="Sector Exposure"
    swapXY=true
    limit=10
  />

  <BarChart 
    data={fund_country_exposure}
    x=country_name
    y=exposure
    yFmt="usd0"
    title="Country Exposure"
    swapXY=true
    limit=10
  />

  <hr class="my-4" />

  ## Fund Holdings

  {#if fund_instruments.filter(d => d.instrument_type === 'CREDIT').length > 0}

  ### Holdings Detail

  <DataTable data={fund_instruments.filter(d => d.instrument_type === 'CREDIT')} rows=20>
    <Column id=instrument_name title="Instrument" />
    <Column id=company_name title="Company" />
    <Column id=principal_outstanding title="Principal Outstanding" fmt=usd0 />
    <Column id=undrawn_commitment title="Undrawn" fmt=usd0 />
    <Column id=spread_bps title="Spread (bps)" fmt=num0 />
    <Column id=interest_index title="Index" />
    <Column id=all_in_yield title="All-in Yield" fmt=pct1 />
    <Column id=maturity_date title="Maturity Date" />
    <Column id=security_rank title="Security Rank" />
    <Column id=days_to_maturity title="Days to Maturity" fmt=num0 />
  </DataTable>

  {:else}

  No credit holdings found for this fund.

  {/if}

  {/if}

</div>
