-- Credit Maturity Ladder
-- Shows principal outstanding by maturity year for credit instruments
-- Provides visibility into loan maturity concentration and refinancing risk

select
    maturity_year,
    sum(principal_outstanding) as principal_maturing,
    count(distinct instrument_id) as number_of_loans,
    count(distinct company_id) as number_of_companies
from public_metrics.metrics_position_performance
where instrument_type = 'CREDIT'
    and maturity_year is not null
    and period_end_date = (
        select max(period_end_date) 
        from public_metrics.metrics_position_performance
    )
group by maturity_year
order by maturity_year
