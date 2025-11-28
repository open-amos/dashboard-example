---
title: Quality Monitoring
sidebar_position: 2
queries:
  - variance_check: data_quality/fund_variance_check.sql
---

This dashboard tracks variances between reported values (from fund administrators) and calculated values (from instrument-level cashflows) to identify potential data quality issues.

## Variance Summary

<Alert status="info">
  **Acceptable Thresholds:**
  - NAV: ±2%
  - Called Capital: ±0.1%
  - Distributions: ±0.1%
</Alert>

### Funds with Significant Variances

<DataTable data={variance_check.filter(d => d.variance_flag !== 'OK')}>
  <Column id=fund_name title="Fund" />
  <Column id=period_end_date title="Period" />
  <Column id=variance_flag title="Issue" />
  <Column id=nav_variance_pct title="NAV Var %" fmt="pct2" />
  <Column id=called_capital_variance_pct title="Called Capital Var %" fmt="pct2" />
  <Column id=distributions_variance_pct title="Distributions Var %" fmt="pct2" />
</DataTable>

{#if variance_check.filter(d => d.variance_flag !== 'OK').length === 0}
<Alert status="positive">
  ✅ No significant variances detected. All metrics are within acceptable thresholds.
</Alert>
{/if}

---

## NAV Variance Analysis

### NAV: Reported vs Calculated

<LineChart 
  data={variance_check}
  x=period_end_date
  y={['fund_nav_reported', 'fund_nav_calculated']}
  series=fund_name
  yFmt="usd2m"
  title="NAV: Reported vs Calculated by Fund"
/>

### NAV Variance Over Time

<LineChart 
  data={variance_check}
  x=period_end_date
  y=nav_variance_pct
  series=fund_name
  yFmt="pct2"
  title="NAV Variance % by Fund"
/>

---

## Called Capital Variance Analysis

### Called Capital: Reported vs Calculated

<LineChart 
  data={variance_check}
  x=period_end_date
  y={['called_capital_reported', 'called_capital_calculated']}
  series=fund_name
  yFmt="usd2m"
  title="Called Capital: Reported vs Calculated by Fund"
/>

### Called Capital Variance Over Time

<LineChart 
  data={variance_check}
  x=period_end_date
  y=called_capital_variance_pct
  series=fund_name
  yFmt="pct2"
  title="Called Capital Variance % by Fund"
/>

---

## Distributions Variance Analysis

### Distributions: Reported vs Calculated

<LineChart 
  data={variance_check}
  x=period_end_date
  y={['total_distributions_reported', 'total_distributions_calculated']}
  series=fund_name
  yFmt="usd2m"
  title="Distributions: Reported vs Calculated by Fund"
/>

### Distributions Variance Over Time

<LineChart 
  data={variance_check}
  x=period_end_date
  y=distributions_variance_pct
  series=fund_name
  yFmt="pct2"
  title="Distributions Variance % by Fund"
/>

---

## Detailed Variance Data

<DataTable data={variance_check}>
  <Column id=fund_name title="Fund" />
  <Column id=period_end_date title="Period" />
  <Column id=fund_nav_reported title="NAV (Reported)" fmt="usd2m" />
  <Column id=fund_nav_calculated title="NAV (Calculated)" fmt="usd2m" />
  <Column id=nav_variance title="NAV Variance" fmt="usd2m" />
  <Column id=nav_variance_pct title="NAV Var %" fmt="pct2" />
  <Column id=called_capital_reported title="Called Capital (Reported)" fmt="usd2m" />
  <Column id=called_capital_calculated title="Called Capital (Calculated)" fmt="usd2m" />
  <Column id=called_capital_variance title="Called Capital Variance" fmt="usd2m" />
  <Column id=called_capital_variance_pct title="Called Capital Var %" fmt="pct2" />
  <Column id=total_distributions_reported title="Distributions (Reported)" fmt="usd2m" />
  <Column id=total_distributions_calculated title="Distributions (Calculated)" fmt="usd2m" />
  <Column id=distributions_variance title="Distributions Variance" fmt="usd2m" />
  <Column id=distributions_variance_pct title="Distributions Var %" fmt="pct2" />
  <Column id=variance_flag title="Status" />
</DataTable>

---

## Interpretation Guide

**What do these variances mean?**

- **Small variances (less than 0.1%)**: Normal rounding differences or timing differences between systems
- **Medium variances (0.1-2%)**: May indicate data entry errors or reconciliation issues - investigate
- **Large variances (greater than 2%)**: Likely data quality issues - requires immediate attention

**Common causes of variances:**

1. **Timing differences**: Fund admin reports on different dates than instrument snapshots
2. **Currency conversion**: Different FX rates used in different systems
3. **Data entry errors**: Incorrect values entered in one system
4. **Missing transactions**: Cashflows not recorded in instrument system
5. **Methodology differences**: Different calculation methods between systems

**Action items when variances are detected:**

1. Review source data in both systems
2. Check for missing or duplicate transactions
3. Verify FX rates and currency conversions
4. Reconcile with fund administrator
5. Update data as needed and re-run pipeline
