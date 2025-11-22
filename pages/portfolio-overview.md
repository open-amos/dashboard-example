---
title: Portfolio Overview
queries:
  - equity_portfolio_metrics: metrics/equity_portfolio_metrics.sql
  - equity_portfolio_timeseries: metrics/equity_portfolio_timeseries.sql
  - credit_portfolio_metrics: metrics/credit_portfolio_metrics.sql
  - credit_portfolio_timeseries: metrics/credit_portfolio_timeseries.sql
  - sector_exposure: metrics/sector_exposure.sql
  - country_exposure: metrics/country_exposure.sql
  - top_contributors: metrics/top_contributors.sql
  - top_detractors: metrics/top_detractors.sql
  - portfolio_positions: metrics/portfolio_positions.sql
  - credit_maturity_ladder: metrics/credit_maturity_ladder.sql
  - credit_yield_distribution: metrics/credit_yield_distribution.sql
  - credit_exposure_by_rank: metrics/credit_exposure_by_rank.sql
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

  ### NAV Trend

  <LineChart 
    data={equity_portfolio_timeseries} 
    x=period_end_date 
    y=total_nav
    yFmt="usd0"
    title="Equity Portfolio NAV Over Time"
  />

  ### Net Cashflow

  <AreaChart 
    data={equity_portfolio_timeseries} 
    x=period_end_date 
    y=net_cash_contributions_period
    yFmt="usd0"
    title="Net Cash Contributions by Period (Equity)"
  />

  ### Exposure Analysis

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

  ### Position Performance Analysis

  <Grid cols=2>

  <BarChart 
    data={portfolio_positions.filter(d => d.instrument_type === 'EQUITY')}
    x=instrument_name
    y=gross_moic
    yFmt="num1"
    title="Top Equity Positions by MOIC"
    swapXY=true
    limit=10
  />

  <ScatterPlot 
    data={portfolio_positions.filter(d => d.instrument_type === 'EQUITY')}
    x=gross_irr
    y=gross_moic
    size=cumulative_invested
    series=fund_name
    tooltipTitle=instrument_name
    xFmt="pct1"
    yFmt="num1"
    title="MOIC vs IRR (Equity)"
    xAxisTitle="Gross IRR"
    yAxisTitle="Gross MOIC"
  />

  </Grid>

  ### Top Contributors & Detractors

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
        <Column id=irr title="IRR" fmt="pct1" />
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
        <Column id=irr title="IRR" fmt="pct1" />
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

  ### Principal Outstanding Trend

  <LineChart 
    data={credit_portfolio_timeseries} 
    x=period_end_date 
    y=total_principal_outstanding
    yFmt="usd0"
    title="Principal Outstanding Over Time"
  />

  ### Net Cashflow

  <AreaChart 
    data={credit_portfolio_timeseries} 
    x=period_end_date 
    y=net_cash_contributions_period
    yFmt="usd0"
    title="Net Cash Contributions by Period (Credit)"
  />

  ### Credit Portfolio Analysis

  <Grid cols=2>
    <div>
      <BarChart 
        data={credit_maturity_ladder} 
        x=maturity_year 
        y=principal_maturing
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

  ### Yield Distribution

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

  ### Exposure Analysis

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
