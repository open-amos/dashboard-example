---
queries:
  - company_info: dimensions/company_info.sql
  - company_financials: metrics/company_financials_timeseries.sql
  - company_financials_table: metrics/company_financials_table.sql
  - company_instruments: metrics/company_instruments.sql
  - company_opportunities: dimensions/company_opportunities.sql
---

<script>
  export const prerender = false;
</script>

```sql is_portfolio_company
select case when count(*) > 0 then true else false end as is_portfolio
from ${company_instruments}
```

```sql equity_instruments
select * from ${company_instruments}
where instrument_type = 'EQUITY'
```

```sql credit_instruments
select * from ${company_instruments}
where instrument_type = 'CREDIT'
```

```sql total_exposure
select
  sum(exposure) as total_exposure,
  sum(case when instrument_type = 'EQUITY' then exposure else 0 end) as equity_exposure,
  sum(case when instrument_type = 'CREDIT' then exposure else 0 end) as credit_exposure
from ${company_instruments}
```

<Grid cols=2>

# {company_info[0].company_name}

<Image 
    url={company_info[0].country_flag} 
    description="Country flag"
    height=40
    align=right
/> 

</Grid>

<div style="margin-top: 1rem; margin-bottom: 1rem;">

{company_info[0].primary_country} | {company_info[0].primary_industry}  | <Link url={company_info[0].website} label={company_info[0].website} />

</div>

{#if company_info[0].description}
<div style="margin-bottom: 2rem;">
{company_info[0].description}
</div>
{/if}

{#if is_portfolio_company[0].is_portfolio}

<hr class="my-6">

## Investment Summary

<Grid cols=3>
  <BigValue 
    data={total_exposure} 
    value=total_exposure 
    fmt=usd2m 
    title="Total Exposure"
  />
  <BigValue 
    data={total_exposure} 
    value=equity_exposure 
    fmt=usd2m 
    title="Equity Exposure"
  />
  <BigValue 
    data={total_exposure} 
    value=credit_exposure 
    fmt=usd2m 
    title="Credit Exposure"
  />
</Grid>

<div class="section-highlight">

## Equity Positions

{#if equity_instruments.length > 0}

<div class="section-highlight-chart">

<DataTable data={equity_instruments}>
  <Column id=instrument_name title="Instrument" />
  <Column id=fund_name title="Fund" />
  <Column id=initial_investment_date title="Investment Date" />
  <Column id=exit_date title="Exit Date" />
  <Column id=cumulative_invested title="Invested" fmt=usd2m />
  <Column id=fair_value title="Fair Value" fmt=usd2m />
  <Column id=realized_proceeds title="Realized Proceeds" fmt=usd2m />
  <Column id=moic title="MOIC" fmt=num1 />
  <Column id=equity_irr_approx title="IRR (Approx)" fmt=pct1 />
  <Column id=ownership_pct_current title="Ownership %" fmt=pct1 />
</DataTable>

</div>

{:else}

No equity positions.

{/if}

</div>

<div class="section-highlight">

## Credit Positions

{#if credit_instruments.length > 0}

<div class="section-highlight-chart">

<DataTable data={credit_instruments}>
  <Column id=instrument_name title="Instrument" />
  <Column id=fund_name title="Fund" />
  <Column id=initial_investment_date title="Investment Date" />
  <Column id=maturity_date title="Maturity Date" />
  <Column id=principal_outstanding title="Principal Outstanding" fmt=usd2m />
  <Column id=undrawn_commitment title="Undrawn Commitment" fmt=usd2m />
  <Column id=accrued_interest title="Accrued Interest" fmt=usd2m />
  <Column id=spread_bps title="Spread (bps)" fmt=num0 />
  <Column id=interest_index title="Index" />
  <Column id=all_in_yield title="All-in Yield" fmt=pct1 />
  <Column id=security_rank title="Security Rank" />
</DataTable>

</div>

{:else}

No credit positions.

{/if}

</div>

<div class="section-highlight">

## Financial Performance

{#if company_financials.length}

  <Grid cols=2>

  <div class="section-highlight-chart">
    <LineChart
      data={company_financials}
      title="Revenue Over Time"
      x=period_end_date
      y=revenue
      yFmt=usd2m
    />
  </div>

  <div class="section-highlight-chart">
    <LineChart
      data={company_financials}
      title="EBITDA Over Time"
      x=period_end_date
      y=ebitda
      yFmt=usd2m
    />
  </div>

  </Grid>

  <div class="section-highlight-chart">
    <LineChart
      data={company_financials}
      title="EBITDA Margin"
      x=period_end_date
      y=ebitda_margin
      yFmt=pct1
    />
  </div>

{:else}

  No financial data available.

{/if}

</div>

<div class="section-highlight">

## Company Financials

{#if company_financials_table.length}

<div class="section-highlight-chart">

<DataTable data={company_financials_table}>
  <Column id=period_end_date title="Period End Date" />
  <Column id=revenue title="Revenue" fmt=usd2m />
  <Column id=ebitda title="EBITDA" fmt=usd2m />
  <Column id=ebitda_margin title="EBITDA Margin" fmt=pct1 />
  <Column id=cash title="Cash" fmt=usd2m />
  <Column id=total_assets title="Total Assets" fmt=usd2m />
  <Column id=total_liabilities title="Total Liabilities" fmt=usd2m />
  <Column id=equity title="Equity" fmt=usd2m />
  <Column id=net_debt title="Net Debt" fmt=usd2m />
  <Column id=enterprise_value title="Enterprise Value" fmt=usd2m />
  <Column id=ev_to_ebitda title="EV/EBITDA" fmt=num1 />
  <Column id=ev_to_revenue title="EV/Revenue" fmt=num1 />
  <Column id=reporting_currency title="Currency" />
</DataTable>

</div>

{:else}

No financial data available.

{/if}

</div>

{:else}

<div class="section-highlight">

## CRM Opportunities

{#if company_opportunities.length > 0}

{#each company_opportunities as opp}

<Alert status="info">

### {opp.opportunity_name}

**Fund:** {opp.fund_name}  
**Stage:** {opp.stage_name}  
**Expected Close:** {opp.expected_close_date}  
**Deal Size:** ${opp.deal_size?.toLocaleString() || 'N/A'}  
**Lead Source:** {opp.lead_source}  
**Owner:** {opp.owner_name}  
**Created:** {opp.created_date}  
**Last Modified:** {opp.last_modified_date}

</Alert>

{/each}

{:else}

No CRM opportunities found for this company.

{/if}

</div>

{/if}