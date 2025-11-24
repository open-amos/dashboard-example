-- Capital Activity by Period for Equity Funds
-- Shows contributions and distributions separately to visualize J-curve

with instruments as (
    select
        instrument_id,
        fund_id,
        instrument_type
    from dim_instruments
    where instrument_type = 'EQUITY'
),

period_cashflows as (
    select
        (date_trunc('quarter', cf.cashflow_date) + interval '3 months' - interval '1 day')::date as period_end_date,
        -- Contributions (negative cashflows from LP perspective)
        sum(
            case 
                when cf.cashflow_type in ('INVESTMENT', 'CONTRIBUTION', 'PURCHASE') 
                then cf.cashflow_amount
                else 0
            end
        ) as period_contributions,
        -- Distributions (positive cashflows to LP)
        sum(
            case 
                when cf.cashflow_type in ('EXIT_PROCEEDS', 'DISTRIBUTION', 'DIVIDEND', 'SALE')
                then cf.cashflow_amount
                else 0
            end
        ) as period_distributions
    from metrics_returns_cashflows cf
    inner join instruments i on cf.instrument_id = i.instrument_id
    group by (date_trunc('quarter', cf.cashflow_date) + interval '3 months' - interval '1 day')::date
)

select
    period_end_date,
    sum(period_contributions) as contributions,
    sum(period_distributions) as distributions,
    sum(period_distributions) - sum(period_contributions) as net_cashflow
from period_cashflows
group by period_end_date
order by period_end_date
