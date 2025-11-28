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

  <Grid cols=4>
    <BigValue 
      data={equity_portfolio_metrics} 
      value=total_nav
      fmt="usd2m"
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
      fmt="usd2m"
      title="Total Commitments"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=unfunded_commitment
      fmt="usd2m"
      title="Unfunded Commitment"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=total_distributions
      fmt="usd2m"
      title="Total Distributions"
    />
    <BigValue 
      data={equity_portfolio_metrics} 
      value=total_portfolio_companies
      fmt="num0"
      title="Portfolio Companies"
    />
  </Grid>

  <div class="section-highlight">

  ## Funds

  <Grid cols=3>

  {#each funds_list.filter(d => d.fund_type === 'EQUITY') as fund}

  <a href={fund.fund_link} class="fund-card-link mb-2">
    <div class="fund-card">
      <div class="fund-header">
        <h4>{fund.fund_name}</h4>
        <span class="fund-badge equity">EQUITY</span>
      </div>
      <div class="fund-metrics">
        <div class="metric">
          <span class="metric-label">NAV</span>
          <span class="metric-value">${(fund.fund_nav / 1000000).toFixed(2)}M</span>
        </div>
        <div class="metric">
          <span class="metric-label">TVPI</span>
          <span class="metric-value">{fund.tvpi?.toFixed(2) || 'N/A'}</span>
        </div>
        <div class="metric">
          <span class="metric-label">DPI</span>
          <span class="metric-value">{fund.dpi?.toFixed(2) || 'N/A'}</span>
        </div>
      </div>
      <div class="fund-metrics">
        <div class="metric">
          <span class="metric-label">Holdings: {fund.number_of_portfolio_companies || 0}</span>
        </div>
      </div>
      <div class="fund-action">
        View Fund →
      </div>
    </div>
  </a>

  {/each}

  </Grid>

  </div>

  <div class="section-highlight">

  ## Fund Comparison

  <Grid cols=2>

    <div class="section-highlight-chart">
      <BarChart 
        data={fund_performance_overview.filter(d => d.fund_type === 'EQUITY')}
        x=fund_name
        y=tvpi
        yFmt="num1"
        title="TVPI by Equity Fund"
        swapXY=true
      />
    </div>

    <div class="section-highlight-chart">

      <BarChart 
        data={fund_performance_overview.filter(d => d.fund_type === 'EQUITY')}
        x=period_end_date
        y=fund_nav
        series=fund_name
        yFmt="usd2m"
        title="Equity Fund NAV Trend"
      />

    </div>

  </Grid>

  </div>

  <div class="section-highlight">

  ## Portfolio Performance Overview

  <div class="section-highlight-chart">
    <LineChart 
      data={equity_portfolio_timeseries} 
      x=period_end_date 
      y=total_nav
      yFmt="usd2m"
      title="NAV by Period (Equity Portfolio)"
    />
  </div>

  </div>

  <div class="section-highlight">

  ## Portfolio Capital Activity

  <Grid cols=2>

    <div class="section-highlight-chart">
      <BarChart 
        data={equity_capital_activity} 
        x=period_end_date 
        y={['contributions', 'distributions']}
        yFmt="usd2m"
        title="Capital Activity by Period (Equity Portfolio)"
        labels={{
          contributions: 'Contributions',
          distributions: 'Distributions'
        }}
      />
    </div>
    
    <div class="section-highlight-chart">
      <LineChart 
        data={equity_capital_activity} 
        x=period_end_date 
        y=net_cashflow
        yFmt="usd2m"
        title="Net Cashflow by Period (Equity Portfolio)"
      />
    </div>

  </Grid>

  </div>

  <div class="section-highlight">

  ## Portfolio Exposure

  <Grid cols=2>
    <div class="section-highlight-chart">
      <BarChart 
        data={sector_exposure.filter(d => d.instrument_type === 'EQUITY')} 
        x=industry_name 
        y=exposure_usd
        yFmt="usd2m"
        swapXY=true
        title="Sector Exposure (Equity)"
      />
    </div>
    <div class="section-highlight-chart">
      <BarChart 
        data={country_exposure.filter(d => d.instrument_type === 'EQUITY')} 
        x=country_name 
        y=exposure
        yFmt="usd2m"
        swapXY=true
        title="Country Exposure (Equity)"
      />
    </div>
  </Grid>

  </div>

  <div class="section-highlight">

  ## Position Performance

  <Grid cols=2>

    <div class="section-highlight-chart">
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
    </div>

    <div class="section-highlight-chart">
      <BarChart 
        data={portfolio_positions.filter(d => d.instrument_type === 'EQUITY').sort((a, b) => b.gross_moic - a.gross_moic).slice(0, 10)}
        x=instrument_name
        y=gross_moic
        yFmt="num1"
        title="Top 10 Equity Positions by MOIC"
        swapXY=true
      />
    </div>

  </Grid>

  <Grid cols=2>
    <div class="section-highlight-chart">
      <DataTable 
        data={top_contributors.filter(d => d.instrument_type === 'EQUITY')}
        rows=10
        link=company_link
        title="Top 10 Contributors (Equity)"
      >
        <Column id=company_name title="Company" />
        <Column id=fund_name title="Fund" />
        <Column id=total_return title="Total Return" fmt="usd2m" />
        <Column id=moic title="MOIC" fmt="num2" />
        <Column id=irr_approx title="IRR (Approx)" fmt="pct1" />
      </DataTable>
    </div>
    <div class="section-highlight-chart">
      <DataTable 
        data={top_detractors.filter(d => d.instrument_type === 'EQUITY')}
        rows=10
        link=company_link
        title="Top 10 Detractors (Equity)"
      >
        <Column id=company_name title="Company" />
        <Column id=fund_name title="Fund" />
        <Column id=total_return title="Total Return" fmt="usd2m" />
        <Column id=moic title="MOIC" fmt="num2" />
        <Column id=irr_approx title="IRR (Approx)" fmt="pct1" />
      </DataTable>
    </div>
  </Grid>

  </div>

</Tab>

{/if}

{#if credit_portfolio_metrics.length > 0}

<Tab label="Credit">

  ## Credit Portfolio

  <Grid cols=4>
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_exposure
      fmt="usd2m"
      title="Total Exposure"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_principal_outstanding
      fmt="usd2m"
      title="Principal Outstanding"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_undrawn_commitment
      fmt="usd2m"
      title="Undrawn Commitment"
    />
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_interest_income
      fmt="usd2m"
      title="Interest Income"
    />
  </Grid>

  <Grid cols=4>
    <BigValue 
      data={credit_portfolio_metrics} 
      value=total_commitments
      fmt="usd2m"
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

  <div class="section-highlight">

  ## Funds

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

  </div>

  <div class="section-highlight">

  ## Fund Comparison

  <Grid cols=2>

    <div class="section-highlight-chart">
      <BarChart 
        data={fund_performance_overview.filter(d => d.fund_type === 'CREDIT')}
        x=fund_name
        y=principal_outstanding
        yFmt="usd2m"
        title="Principal Outstanding by Fund"
        swapXY=true
      />
    </div>

    <div class="section-highlight-chart">
      <BarChart 
        data={fund_performance_overview.filter(d => d.fund_type === 'CREDIT')}
        x=period_end_date
        y=principal_outstanding
        series=fund_name
        yFmt="usd2m"
        title="Principal Outstanding Trend by Fund"
      />
    </div>

  </Grid>

  </div>

  <div class="section-highlight">

  ## Portfolio Performance

  <Grid cols=2>

    <div class="section-highlight-chart">
      <LineChart 
        data={credit_portfolio_timeseries} 
        x=period_end_date 
        y=total_principal_outstanding
        yFmt="usd2m"
        title="Principal Outstanding Over Time (Credit Funds)"
      />
    </div>

    <div class="section-highlight-chart">
      <BarChart 
        data={credit_capital_activity} 
        x=period_end_date 
        y={['contributions', 'distributions']}
        yFmt="usd2m"
        title="Capital Activity Over Time (Credit Funds)"
        labels={{
          contributions: 'Draws',
          distributions: 'Repayments'
        }}
      />
    </div>

  </Grid>
  
  <div class="section-highlight-chart">
    <LineChart 
      data={credit_capital_activity} 
      x=period_end_date 
      y=net_cashflow
      yFmt="usd2m"
      title="Net Cashflow Over Time (Credit Funds)"
    />
  </div>

  </div>

  <div class="section-highlight">

  ## Portfolio Structure & Risk Profile

  <Grid cols=2>
    <div class="section-highlight-chart">
      <BarChart 
        data={credit_maturity_ladder} 
        x=maturity_year 
        y=principal_maturing
        xFmt="###"
        yFmt="usd2m"
        title="Maturity Ladder"
        xAxisTitle="Maturity Year"
        yAxisTitle="Principal Maturing"
      />
    </div>
    <div class="section-highlight-chart">
      <BarChart 
        data={credit_exposure_by_rank} 
        x=security_rank 
        y=total_principal_outstanding
        yFmt="usd2m"
        swapXY=true
        title="Exposure by Security Rank"
      />
    </div>
  </Grid>

  </div>

  <div class="section-highlight">

  ## Portfolio Exposure

  <Grid cols=2>
    <div class="section-highlight-chart">
      <BarChart 
        data={sector_exposure.filter(d => d.instrument_type === 'CREDIT')} 
        x=industry_name 
        y=exposure_usd
        yFmt="usd2m"
        swapXY=true
        title="Sector Exposure (Credit)"
      />
    </div>
    <div class="section-highlight-chart">
      <BarChart 
        data={country_exposure.filter(d => d.instrument_type === 'CREDIT')} 
        x=country_name 
        y=exposure
        yFmt="usd2m"
        swapXY=true
        title="Country Exposure (Credit)"
      />
    </div>
  </Grid>

  </div>

  <div class="section-highlight">

  ## Yield & Income Analysis

  <div class="section-highlight-chart">

  <DataTable 
    data={credit_yield_distribution}
    title="Credit Yield Distribution by Security Rank"
  >
    <Column id=security_rank title="Security Rank" />
    <Column id=interest_index title="Interest Index" />
    <Column id=yield_bucket title="Yield Bucket" />
    <Column id=number_of_loans title="# Loans" fmt="num0" />
    <Column id=total_principal_outstanding title="Principal Outstanding" fmt="usd2m" />
    <Column id=avg_yield title="Avg Yield" fmt="pct1" />
    <Column id=avg_spread_bps title="Avg Spread (bps)" fmt="num0" />
  </DataTable>

  </div>

  </div>

</Tab>

{/if}

</Tabs>
