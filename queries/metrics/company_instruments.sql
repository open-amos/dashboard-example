-- Show all instruments for a company, including both equity and credit positions
-- For instruments without snapshots, performance metrics will be null

select
    i.instrument_id,
    i.name as instrument_name,
    i.instrument_type,
    f.name as fund_name,
    f.type as fund_type,
    i.inception_date as initial_investment_date,
    coalesce(i.termination_date::text, '') as exit_date,
    
    -- Equity metrics
    mpp.initial_cost,
    mpp.cumulative_invested,
    mpp.cumulative_distributions,
    mpp.fair_value,
    mpp.moic,
    mpp.equity_irr,
    mpp.ownership_pct_current,
    
    -- Credit metrics
    mpp.principal_outstanding,
    mpp.undrawn_commitment,
    mpp.accrued_interest,
    mpp.commitment_amount,
    mpp.spread_bps,
    mpp.interest_index,
    mpp.maturity_date,
    mpp.security_rank,
    mpp.all_in_yield,
    
    -- Common metrics
    mpp.holding_period_years,
    
    -- Calculate total exposure (fair_value for equity, principal_outstanding for credit)
    case
        when i.instrument_type = 'EQUITY' then coalesce(mpp.fair_value, 0)
        when i.instrument_type = 'CREDIT' then coalesce(mpp.principal_outstanding, 0)
        else 0
    end as exposure
    
from dim_instruments i
inner join dim_funds f on i.fund_id = f.fund_id
left join (
    select 
        mpp.*,
        row_number() over (partition by instrument_id order by period_end_date desc) as rn
    from metrics_position_performance mpp
) mpp on i.instrument_id = mpp.instrument_id and mpp.rn = 1
where i.company_id = '${params.id}'
order by i.inception_date desc
