---
title: Portfolio
sidebar_position: 1
queries:
  - equity_portfolio_metrics: metrics/equity_portfolio_metrics.sql
  - equity_portfolio_timeseries: metrics/equity_portfolio_timeseries.sql
  - equity_capital_activity: metrics/equity_capital_activity.sql
  - credit_portfolio_metrics: metrics/credit_portfolio_metrics.sql
  - credit_portfolio_timeseries: metrics/credit_portfolio_timeseries.sql
  - credit_capital_activity: metrics/credit_capital_activity.sql
  - sector_exposure: metrics/sector_exposure.sql
  - country_exposure: metrics/country_exposure.sql
  - top_contributors: metrics/top_contributors.sql
  - top_detractors: metrics/top_detractors.sql
  - portfolio_positions: metrics/portfolio_positions.sql
  - credit_maturity_ladder: metrics/credit_maturity_ladder.sql
  - credit_yield_distribution: metrics/credit_yield_distribution.sql
  - credit_exposure_by_rank: metrics/credit_exposure_by_rank.sql
  - fund_performance_overview: metrics/fund_performance_overview.sql
  - fund_performance_aggregate: metrics/fund_performance_aggregate.sql
  - equity_funds_aggregate: metrics/equity_funds_aggregate.sql
  - credit_funds_aggregate: metrics/credit_funds_aggregate.sql
  - funds_list: metrics/funds_list.sql
  - funds: dimensions/funds.sql
---

<Tabs color=primary>


{#if equity_portfolio_metrics.length > 0}

<Tab label="Equity">

  ## Equity Portfolio

  ### Key Performance Indicators

  <Grid cols=4>
    <BigValue 
      data={equity_portfolio_metrics} 
      value=total_nav
      fmt="usd0"
      title="Total NAV"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=tvpi_portfolio
      fmt="num1"
      title="TVPI"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=dpi_portfolio
      fmt="num1"
      title="DPI"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=rvpi_portfolio
      fmt="num1"
      title="RVPI"
    />
  </Grid>

  <Grid cols=4>
    <BigValue 
      data={equity_portfolio_metrics} 
      value=total_commitments
      fmt="usd0"
      title="Total Commitments"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=unfunded_commitment
      fmt="usd0"
      title="Unfunded Commitment"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=total_distributions
      fmt="usd0"
      title="Total Distributions"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=total_portfolio_companies
      fmt="num0"
      title="Portfolio Companies"
    />
  </Grid>

  <hr class="my-6">

  ### Funds in This Portfolio

  <Grid cols=3>

  {#each funds_list.filter(d => d.fund_type === 'EQUITY') as fund}

  <a href={fund.fund_link} class="fund-card-link">
    <div class="fund-card">
      <div class="fund-header">
        <h4>{fund.fund_name}</h4>
        <span class="fund-badge equity">EQUITY</span>
      </div>
      <div class="fund-metrics">
        <div class="metric">
          <span class="metric-label">NAV</span>
          <span class="metric-value">${(fund.fund_nav / 1000000).toFixed(1)}M</span>
        </div>
        <div class="metric">
          <span class="metric-label">TVPI</span>
          <span class="metric-value">{fund.tvpi?.toFixed(2) || 'N/A'}</span>
        </div>
        <div class="metric">
          <span class="metric-label">DPI</span>
          <span class="metric-value">{fund.dpi?.toFixed(2) || 'N/A'}</span>
        </div>
        <div class="metric">
          <span class="metric-label">Holdings</span>
          <span class="metric-value">{fund.number_of_portfolio_companies || 0}</span>
        </div>
      </div>
      <div class="fund-action">
        View Fund →
      </div>
    </div>
  </a>

  {/each}

  </Grid>

  <hr class="my-6">

  ### Fund Comparison

  <BarChart 
    data={fund_performance_overview.filter(d => d.fund_type === 'EQUITY')}
    x=fund_name
    y=tvpi
    yFmt="num1"
    title="TVPI by Equity Fund"
    swapXY=true
  />

  <BarChart 
    data={fund_performance_overview.filter(d => d.fund_type === 'EQUITY')}
    x=period_end_date
    y=fund_nav
    series=fund_name
    yFmt="usd0"
    title="Equity Fund NAV Trend"
  />

  <hr class="my-6">

  ### Portfolio Performance Overview

  <LineChart 
    data={equity_portfolio_timeseries} 
    x=period_end_date 
    y=total_nav
    yFmt="usd0"
    title="NAV by Period (Equity Portfolio)"
  />

  <hr class="my-6">

  ### Portfolio Capital Activity

  <BarChart 
    data={equity_capital_activity} 
    x=period_end_date 
    y={['contributions', 'distributions']}
    yFmt="usd0"
    title="Capital Activity by Period (Equity Portfolio)"
    labels={{
      contributions: 'Contributions',
      distributions: 'Distributions'
    }}
  />
  
  <LineChart 
    data={equity_capital_activity} 
    x=period_end_date 
    y=net_cashflow
    yFmt="usd0"
    title="Net Cashflow by Period (Equity Portfolio)"
  />

  <hr class="my-6">

  ### Portfolio Exposure

  <Grid cols=2>
    <div>
      <BarChart 
        data={sector_exposure.filter(d => d.instrument_type === 'EQUITY')} 
        x=industry_name 
        y=exposure_usd
        yFmt="usd0"
        swapXY=true
        title="Sector Exposure (Equity)"
      />
    </div>
    <div>
      <BarChart 
        data={country_exposure.filter(d => d.instrument_type === 'EQUITY')} 
        x=country_name 
        y=exposure
        yFmt="usd0"
        swapXY=true
        title="Country Exposure (Equity)"
      />
    </div>
  </Grid>

  <hr class="my-6">

  ### Position Performance

  <ScatterPlot 
    data={portfolio_positions.filter(d => d.instrument_type === 'EQUITY')}
    x=gross_irr_approx
    y=gross_moic
    size=cost_basis
    series=fund_name
    tooltipTitle=instrument_name
    xFmt="pct1"
    yFmt="num1"
    title="MOIC vs IRR (Approx) - Equity"
    xAxisTitle="Approx IRR"
    yAxisTitle="Gross MOIC"
  />

  <BarChart 
    data={portfolio_positions.filter(d => d.instrument_type === 'EQUITY')}
    x=instrument_name
    y=gross_moic
    yFmt="num1"
    title="Top Equity Positions by MOIC"
    swapXY=true
    limit=10
  />

  <Grid cols=2>
    <div>
      <DataTable 
        data={top_contributors.filter(d => d.instrument_type === 'EQUITY')}
        rows=10
        link=company_link
        title="Top 10 Contributors (Equity)"
      >
        <Column id=company_name title="Company" />
        <Column id=fund_name title="Fund" />
        <Column id=total_return title="Total Return" fmt="usd0" />
        <Column id=moic title="MOIC" fmt="num2" />
        <Column id=irr_approx title="IRR (Approx)" fmt="pct1" />
      </DataTable>
    </div>
    <div>
      <DataTable 
        data={top_detractors.filter(d => d.instrument_type === 'EQUITY')}
        rows=10
        link=company_link
        title="Top 10 Detractors (Equity)"
      >
        <Column id=company_name title="Company" />
        <Column id=fund_name title="Fund" />
        <Column id=total_return title="Total Return" fmt="usd0" />
        <Column id=moic title="MOIC" fmt="num2" />
        <Column id=irr_approx title="IRR (Approx)" fmt="pct1" />
      </DataTable>
    </div>
  </Grid>

</Tab>

{/if}

{#if credit_portfolio_metrics.length > 0}

<Tab label="Credit">

  ## Credit Portfolio

  ### Key Performance Indicators

  <Grid cols=4>
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_exposure
      fmt="usd0"
      title="Total Exposure"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_principal_outstanding
      fmt="usd0"
      title="Principal Outstanding"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_undrawn_commitment
      fmt="usd0"
      title="Undrawn Commitment"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_interest_income
      fmt="usd0"
      title="Interest Income"
    />
  </Grid>

  <Grid cols=4>
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_commitments
      fmt="usd0"
      title="Total Commitments"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=number_of_credit_funds
      fmt="num0"
      title="Credit Funds"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_positions
      fmt="num0"
      title="Credit Positions"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_portfolio_companies
      fmt="num0"
      title="Portfolio Companies"
    />
  </Grid>

  <hr class="my-6">

  ### Funds in This Portfolio

  <Grid cols=3>

  {#each funds_list.filter(d => d.fund_type === 'CREDIT') as fund}

  <a href={fund.fund_link} class="fund-card-link">
    <div class="fund-card">
      <div class="fund-header">
        <h4>{fund.fund_name}</h4>
        <span class="fund-badge credit">CREDIT</span>
      </div>
      <div class="fund-metrics">
        <div class="metric">
          <span class="metric-label">Exposure</span>
          <span class="metric-value">${(fund.total_exposure / 1000000).toFixed(1)}M</span>
        </div>
        <div class="metric">
          <span class="metric-label">Principal</span>
          <span class="metric-value">${(fund.principal_outstanding / 1000000).toFixed(1)}M</span>
        </div>
        <div class="metric">
          <span class="metric-label">Undrawn</span>
          <span class="metric-value">${(fund.undrawn_commitment / 1000000).toFixed(1)}M</span>
        </div>
        <div class="metric">
          <span class="metric-label">Positions</span>
          <span class="metric-value">{fund.number_of_positions || 0}</span>
        </div>
      </div>
      <div class="fund-action">
        View Fund →
      </div>
    </div>
  </a>

  {/each}

  </Grid>

  <hr class="my-6">

  ### Fund Comparison

  <BarChart 
    data={fund_performance_overview.filter(d => d.fund_type === 'CREDIT')}
    x=fund_name
    y=principal_outstanding
    yFmt="usd0"
    title="Principal Outstanding by Fund"
    swapXY=true
  />

  <BarChart 
    data={fund_performance_overview.filter(d => d.fund_type === 'CREDIT')}
    x=period_end_date
    y=principal_outstanding
    series=fund_name
    yFmt="usd0"
    title="Principal Outstanding Trend by Fund"
  />

  <hr class="my-6">

  ### Portfolio Performance

  <LineChart 
    data={credit_portfolio_timeseries} 
    x=period_end_date 
    y=total_principal_outstanding
    yFmt="usd0"
    title="Principal Outstanding Over Time (Credit Funds)"
  />

  <BarChart 
    data={credit_capital_activity} 
    x=period_end_date 
    y={['contributions', 'distributions']}
    yFmt="usd0"
    title="Capital Activity Over Time (Credit Funds)"
    labels={{
      contributions: 'Draws',
      distributions: 'Repayments'
    }}
  />
  
  <LineChart 
    data={credit_capital_activity} 
    x=period_end_date 
    y=net_cashflow
    yFmt="usd0"
    title="Net Cashflow Over Time (Credit Funds)"
  />

  <hr class="my-6">

  ### Portfolio Structure & Risk Profile

  <Grid cols=2>
    <div>
      <BarChart 
        data={credit_maturity_ladder} 
        x=maturity_year 
        y=principal_maturing
        xFmt="####"
        yFmt="usd0"
        title="Maturity Ladder"
        xAxisTitle="Maturity Year"
        yAxisTitle="Principal Maturing"
      />
    </div>
    <div>
      <BarChart 
        data={credit_exposure_by_rank} 
        x=security_rank 
        y=total_principal_outstanding
        yFmt="usd0"
        swapXY=true
        title="Exposure by Security Rank"
      />
    </div>
  </Grid>

  <hr class="my-6">

  ### Yield & Income Analysis

  <DataTable 
    data={credit_yield_distribution}
    title="Credit Yield Distribution by Security Rank"
  >
    <Column id=security_rank title="Security Rank" />
    <Column id=interest_index title="Interest Index" />
    <Column id=yield_bucket title="Yield Bucket" />
    <Column id=number_of_loans title="# Loans" fmt="num0" />
    <Column id=total_principal_outstanding title="Principal Outstanding" fmt="usd0" />
    <Column id=avg_yield title="Avg Yield" fmt="pct1" />
    <Column id=avg_spread_bps title="Avg Spread (bps)" fmt="num0" />
  </DataTable>

  <hr class="my-6">

  ### Portfolio Exposure

  <Grid cols=2>
    <div>
      <BarChart 
        data={sector_exposure.filter(d => d.instrument_type === 'CREDIT')} 
        x=industry_name 
        y=exposure_usd
        yFmt="usd0"
        swapXY=true
        title="Sector Exposure (Credit)"
      />
    </div>
    <div>
      <BarChart 
        data={country_exposure.filter(d => d.instrument_type === 'CREDIT')} 
        x=country_name 
        y=exposure
        yFmt="usd0"
        swapXY=true
        title="Country Exposure (Credit)"
      />
    </div>
  </Grid>

</Tab>

{/if}

</Tabs>

<style>
  .fund-card-link {
    text-decoration: none;
    color: inherit;
    display: block;
  }

  .fund-card {
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
    padding: 1.25rem;
    transition: all 0.2s;
    background: white;
    height: 100%;
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  .fund-card:hover {
    border-color: #3b82f6;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    transform: translateY(-2px);
  }

  .fund-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 0.75rem;
  }

  .fund-header h4 {
    margin: 0;
    font-size: 1rem;
    font-weight: 600;
    line-height: 1.4;
  }

  .fund-badge {
    padding: 0.25rem 0.625rem;
    border-radius: 9999px;
    font-size: 0.625rem;
    font-weight: 700;
    text-transform: uppercase;
    white-space: nowrap;
    flex-shrink: 0;
  }

  .fund-badge.equity {
    background-color: #dbeafe;
    color: #1e40af;
  }

  .fund-badge.credit {
    background-color: #d1fae5;
    color: #065f46;
  }

  .fund-metrics {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.75rem;
  }

  .metric {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  .metric-label {
    font-size: 0.75rem;
    color: #6b7280;
    font-weight: 500;
  }

  .metric-value {
    font-size: 1rem;
    font-weight: 600;
    color: #111827;
  }

  .fund-action {
    margin-top: auto;
    color: #3b82f6;
    font-weight: 500;
    font-size: 0.875rem;
  }

  .fund-card:hover .fund-action {
    color: #2563eb;
  }

  :global(.dark) .fund-card {
    background: #1f2937;
    border-color: #374151;
  }

  :global(.dark) .fund-card:hover {
    border-color: #3b82f6;
  }

  :global(.dark) .fund-badge.equity {
    background-color: #1e3a8a;
    color: #93c5fd;
  }

  :global(.dark) .fund-badge.credit {
    background-color: #064e3b;
    color: #6ee7b7;
  }

  :global(.dark) .metric-label {
    color: #9ca3af;
  }

  :global(.dark) .metric-value {
    color: #f9fafb;
  }

  :global(.dark) .fund-action {
    border-top-color: #374151;
    color: #60a5fa;
  }

  :global(.dark) .fund-card:hover .fund-action {
    color: #93c5fd;
  }
</style>
