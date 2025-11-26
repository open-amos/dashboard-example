---
title: Reports
queries:
  - funds_list: metrics/funds_list.sql
  - report_metadata: helpers/report_metadata.sql
---

Create, customize and export fully automated reports for funds, portfolios, and internal analysis. All reports are generated in Word format so teams can refine the content, add commentary, and tailor the final document to their audience.

<hr class="my-6" />

## Fund Reports (Quarterly)

Select a fund to view and download its most recent report for LPs:

<Grid cols=3>

{#each funds_list as fund}

<a href={fund.report_link} class="card-link">
  <div class="fund-card">
    <div class="fund-header">
      <h3>{fund.fund_name}</h3>
      <span class="fund-type {fund.fund_type}">{fund.fund_type}</span>
    </div>
    <div class="report-quarter">
      {report_metadata[0].quarter_label}
    </div>
    <div class="fund-action">
      View Report →
    </div>
  </div>
</a>

{/each}

</Grid>

<style>
  .card-link {
    text-decoration: none;
    color: inherit;
    display: block;
  }

  .fund-card {
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
    padding: 1.5rem;
    transition: all 0.2s;
    background: white;
    height: 100%;
    display: flex;
    flex-direction: column;
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
    gap: 1rem;
    margin-bottom: 0.75rem;
  }

  .fund-header h3 {
    margin: 0;
    font-size: 1.125rem;
    font-weight: 600;
    line-height: 1.4;
  }

  .fund-type {
    padding: 0.25rem 0.75rem;
    border-radius: 9999px;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    white-space: nowrap;
    flex-shrink: 0;
  }

  .fund-type.equity, .fund-type.EQUITY {
    background-color: #dbeafe;
    color: #1e40af;
  }

  .fund-type.credit, .fund-type.CREDIT {
    background-color: #d1fae5;
    color: #065f46;
  }

  .report-quarter {
    color: #6b7280;
    font-size: 0.875rem;
    margin-bottom: 1rem;
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

  :global(.dark) .fund-type.equity {
    background-color: #1e3a8a;
    color: #93c5fd;
  }

  :global(.dark) .fund-type.credit {
    background-color: #064e3b;
    color: #6ee7b7;
  }
</style>
