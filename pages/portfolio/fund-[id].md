---
queries:
  - fund_key_metrics: metrics/fund_key_metrics.sql
  - fund_metrics_timeseries: metrics/fund_metrics_timeseries.sql
  - fund_instruments: metrics/fund_instruments.sql
  - fund_credit_maturity_ladder: metrics/fund_credit_maturity_ladder.sql
  - fund_credit_yield_distribution: metrics/fund_credit_yield_distribution.sql
  - fund_sector_exposure: metrics/fund_sector_exposure.sql
  - fund_country_exposure: metrics/fund_country_exposure.sql
  - equity_companies_count: metrics/fund_equity_companies_count.sql
  - credit_positions_count: metrics/fund_credit_positions_count.sql
---

<script>
  export const prerender = false;
</script>

# {fund_key_metrics[0].fund_name}

{#if fund_key_metrics[0].fund_type === 'EQUITY'}

## Key Metrics - Private Equity

<Grid cols=4>

<BigValue 
  data={fund_key_metrics} 
  value=fund_nav
  fmt="usd2m"
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
  fmt="usd2m"
  title="Total Commitments"
/>

<BigValue 
  data={fund_key_metrics} 
  value=unfunded_commitment
  fmt="usd2m"
  title="Unfunded Commitment"
/>

<BigValue 
  data={fund_key_metrics} 
  value=total_distributions
  fmt="usd2m"
  title="Total Distributions"
/>

<BigValue 
  data={equity_companies_count} 
  value=company_count
  fmt="num0"
  title="Portfolio Companies"
/>

</Grid>

<div class="section-highlight">

  ## Performance Over Time

  <Grid cols=2>

    <div class="section-highlight-chart">

      <LineChart
        data={fund_metrics_timeseries}
        title="Fund NAV Over Time"
        x=period_end_date
        y=fund_nav
        yFmt=usd2m
      />

    </div>

    <div class="section-highlight-chart">

      <LineChart
        data={fund_metrics_timeseries}
        title="TVPI Over Time"
        x=period_end_date
        y=tvpi
        yFmt=num1
      />

    </div>

    <div class="section-highlight-chart">

      <LineChart
        data={fund_metrics_timeseries}
        title="DPI Over Time"
        x=period_end_date
        y=dpi
        yFmt=num1
      />

    </div>

    <div class="section-highlight-chart">

      <LineChart
        data={fund_metrics_timeseries}
        title="Total Distributions Over Time"
        x=period_end_date
        y=total_distributions
        yFmt=usd2m
      />

    </div>

  </Grid>

</div>

<div class="section-highlight">

  ## Portfolio Exposure

  <Grid cols=2>

    <div class="section-highlight-chart">

      <BarChart 
        data={fund_sector_exposure}
        x=industry_name
        y=exposure
        yFmt="usd2m"
        title="Sector Exposure"
        swapXY=true
        limit=10
      />

    </div>

    <div class="section-highlight-chart">

      <BarChart 
        data={fund_country_exposure}
        x=country_name
        y=exposure
        yFmt="usd2m"
        title="Country Exposure"
        swapXY=true
        limit=10
      />

    </div>

  </Grid>

</div>

<div class="section-highlight">

  ## Fund Holdings

  {#if fund_instruments.filter(d => d.instrument_type === 'EQUITY').length > 0}

  ### Holdings Performance Analysis

  <Grid cols=2>

    <div class="section-highlight-chart">

      <BarChart 
        data={fund_instruments.filter(d => d.instrument_type === 'EQUITY')}
        x=instrument_name
        y=moic
        yFmt="num1"
        title="Top Positions by MOIC"
        swapXY=true
        limit=10
      />

    </div>

    <div class="section-highlight-chart">

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

    </div>

  </Grid>

  ### Holdings Detail

  <div class="section-highlight-chart">

    <DataTable data={fund_instruments.filter(d => d.instrument_type === 'EQUITY')} rows=20>
      <Column id=instrument_name title="Instrument" />
      <Column id=company_name title="Company" />
      <Column id=initial_investment_date title="Investment Date" />
      <Column id=cumulative_invested title="Invested" fmt=usd2m />
      <Column id=fair_value title="Fair Value" fmt=usd2m />
      <Column id=total_value title="Total Value" fmt=usd2m />
      <Column id=equity_irr_approx title="IRR (Approx)" fmt=pct1 />
      <Column id=moic title="MOIC" fmt=num1 contentType=bar />
      <Column id=ownership_pct_current title="Ownership %" fmt=pct1 />
    </DataTable>

  </div>

  {:else}

  No equity holdings found for this fund.

  {/if}

</div>

{:else if fund_key_metrics[0].fund_type === 'CREDIT'}

## Key Metrics - Private Credit

<Grid cols=4>

<BigValue 
  data={fund_key_metrics} 
  value=total_exposure
  fmt="usd2m"
  title="Total Exposure"
/>

<BigValue 
  data={fund_key_metrics} 
  value=principal_outstanding
  fmt="usd2m"
  title="Principal Outstanding"
/>

<BigValue 
  data={fund_key_metrics} 
  value=undrawn_commitment
  fmt="usd2m"
  title="Undrawn Commitment"
/>

<BigValue 
  data={fund_key_metrics} 
  value=interest_income
  fmt="usd2m"
  title="Interest Income"
/>

</Grid>

<Grid cols=4>

<BigValue 
  data={fund_key_metrics} 
  value=total_commitments
  fmt="usd2m"
  title="Total Commitments"
/>

<BigValue 
  data={fund_key_metrics} 
  value=total_called_capital
  fmt="usd2m"
  title="Total Called Capital"
/>

<BigValue 
  data={fund_key_metrics} 
  value=total_distributions
  fmt="usd2m"
  title="Total Distributions"
/>

<BigValue 
  data={credit_positions_count} 
  value=position_count
  fmt="num0"
  title="Number of Positions"
/>

</Grid>

<div class="section-highlight">

  ## Performance Over Time

  <Grid cols=2>

    <div class="section-highlight-chart">

      <LineChart
        data={fund_metrics_timeseries}
        title="Total Exposure Over Time"
        x=period_end_date
        y=total_exposure
        yFmt=usd2m
      />

    </div>

    <div class="section-highlight-chart">

      <LineChart
        data={fund_metrics_timeseries}
        title="Principal Outstanding Over Time"
        x=period_end_date
        y=principal_outstanding
        yFmt=usd2m
      />

    </div>

    <div class="section-highlight-chart">

      <LineChart
        data={fund_metrics_timeseries}
        title="Undrawn Commitment Over Time"
        x=period_end_date
        y=undrawn_commitment
        yFmt=usd2m
      />

    </div>

    <div class="section-highlight-chart">

      <LineChart
        data={fund_metrics_timeseries}
        title="Interest Income Over Time"
        x=period_end_date
        y=interest_income
        yFmt=usd2m
      />

    </div>

  </Grid>

</div>

<div class="section-highlight">

## Credit Portfolio Analysis

{#if fund_credit_maturity_ladder.length > 0 && fund_credit_yield_distribution.length > 0}

<Grid cols=2>

<div class="section-highlight-chart">

<BarChart 
  data={fund_credit_maturity_ladder}
  x=maturity_year
  y=principal_maturing
  yFmt="usd2m"
  title="Maturity Ladder"
  xAxisTitle="Maturity Year"
  yAxisTitle="Principal Maturing"
/>

</div>

<div class="section-highlight-chart">

<BarChart 
  data={fund_credit_yield_distribution}
  x=instrument_name
  y=all_in_yield
  yFmt="pct1"
  title="All-in Yield by Position"
  swapXY=true
  limit=10
/>

</div>

</Grid>

{:else}

No credit portfolio data available for analysis.

{/if}

</div>

<div class="section-highlight">

## Portfolio Exposure

<Grid cols=2>

<div class="section-highlight-chart">

<BarChart 
  data={fund_sector_exposure}
  x=industry_name
  y=exposure
  yFmt="usd2m"
  title="Sector Exposure"
  swapXY=true
  limit=10
/>

</div>

<div class="section-highlight-chart">

<BarChart 
  data={fund_country_exposure}
  x=country_name
  y=exposure
  yFmt="usd2m"
  title="Country Exposure"
  swapXY=true
  limit=10
/>

</div>

</Grid>

</div>

<div class="section-highlight">

## Fund Holdings

{#if fund_instruments.filter(d => d.instrument_type === 'CREDIT').length > 0}

<div class="section-highlight-chart">

  <DataTable data={fund_instruments.filter(d => d.instrument_type === 'CREDIT')} rows=20>
    <Column id=instrument_name title="Instrument" />
    <Column id=company_name title="Company" />
    <Column id=principal_outstanding title="Principal Outstanding" fmt=usd2m />
    <Column id=undrawn_commitment title="Undrawn" fmt=usd2m />
    <Column id=spread_bps title="Spread (bps)" fmt=num0 />
    <Column id=interest_index title="Index" />
    <Column id=all_in_yield title="All-in Yield" fmt=pct1 />
    <Column id=maturity_date title="Maturity Date" />
    <Column id=security_rank title="Security Rank" />
    <Column id=days_to_maturity title="Days to Maturity" fmt=num0 />
  </DataTable>

</div>

{:else}

No credit holdings found for this fund.

{/if}

</div>

{/if}
