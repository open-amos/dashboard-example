---
title: AMOS Demo Dashboard
queries:
  - funds: dimensions/funds.sql
  - stages: dimensions/stages.sql
  - regions: dimensions/regions.sql
  - countries: dimensions/countries.sql
  - exposure_ts: metrics/exposure_ts.sql
  - industry_current_breakdown: metrics/industry_current_breakdown.sql
  - region_current_breakdown: metrics/region_current_breakdown.sql
---

Welcome to the Acme Capital's dashboard! Acme Capital is a fictional private equity and private credit firm. This dashboard is a showcase of the AMOS data platform, showing how it can be used to connect and model your private markets data.

<hr class="my-4" />

## Connected sources

<div class="mx-auto max-w-5xl p-0">

  <!-- Responsive grid: 1 column on small, 2 on md+ -->
  <div class="grid grid-cols-1 md:grid-cols-2 gap-3 mt-4 mb-4">
    <div class="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 shadow-sm px-5 py-4 flex items-center gap-3">
      <span class="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-50 text-indigo-600 dark:bg-indigo-900/30 dark:text-indigo-300">CRM</span>
      <div>
        <div class="font-semibold">Deal Pipeline</div>
        <div class="text-xs text-gray-500">25 deals</div>
      </div>
    </div>
    <div class="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 shadow-sm px-5 py-4 flex items-center gap-3">
      <span class="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-50 text-emerald-600 dark:bg-emerald-900/30 dark:text-emerald-300">PM</span>
      <div>
        <div class="font-semibold">Portfolio Management</div>
        <div class="text-xs text-gray-500">8 PE / 11 PC investments</div>
      </div>
    </div>
    <div class="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 shadow-sm px-5 py-4 flex items-center gap-3">
      <span class="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-amber-50 text-amber-600 dark:bg-amber-900/30 dark:text-amber-300">FA</span>
      <div>
        <div class="font-semibold">Fund Admin</div>
        <div class="text-xs text-gray-500">6 funds / 16 investors</div>
      </div>
    </div>
    <div class="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 shadow-sm px-5 py-4 flex items-center gap-3">
      <span class="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-sky-50 text-sky-600 dark:bg-sky-900/30 dark:text-sky-300">AC</span>
      <div>
        <div class="font-semibold">Accounting</div>
        <div class="text-xs text-gray-500">24 journal entries</div>
      </div>
    </div>
  </div>
</div>

<Modal title="Add New Source" buttonText='+ Add New Source'> 

Connect your own systems to the AMOS data platform. Add your ESG data, market data, and other data sources. AMOS is the central layer that connects your data and systems into a single, consistent layer of truth, providing ready-made pipelines, models, and metrics for your fund data.

</Modal>

<hr class="my-4" />

## Sample Charts

<Alert status="info">A use case: Acme Capital invests in multiple industries and regions, while having to comply with binding exposure limits based on total investor commitments. In order to stay on track and anticipate compliance risks, the Acme team has to reconcile data from their CRM, portfolio management system and fund administrator. Without AMOS, it's a manual, error-prone process that takes days to complete. With AMOS, they can just keep an eye on the built-in metrics to track and forecast exposure in real time, and report directly to their investors. They are gaining time, clarity and confidence in their investment decisions.</Alert>

<Dropdown data={funds} name=fund value=fund_id label=fund_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Funds" />
</Dropdown>
<Dropdown data={stages} name=stage value=stage_id label=stage_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Stages" />
</Dropdown>
<Dropdown data={regions} name=region value=region label=region defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Regions" />
</Dropdown>
<Dropdown data={countries} name=country value=country_code label=country_name defaultValue="ALL">
  <DropdownOption value="ALL" valueLabel="All Countries" />
</Dropdown>

<AreaChart
  data={exposure_ts}
  title="Forecast Exposure Over Time"
  subtitle="{inputs.fund.label || 'All Funds'} | Stage: {inputs.stage.label || 'All Stages'} | {inputs.region.value} | {inputs.country.label || 'All Countries'}"
  type="stacked"
  x=month 
  y=total_exposure_usd
  series=period_type
  seriesOrder={["Current","Forecast"]}
/>

<Grid cols=2>

  <ECharts config={
    {
      tooltip: {
        formatter: '{b}: {c} ({d}%)'
      },
      series: [
        {
          type: 'pie',
          data: industry_current_breakdown?.map(d => ({
            name: d.industry_name,
            value: d.total_exposure_usd
          })) || []
        }
      ]
    }
  } />

  <ECharts config={
    {
      tooltip: {
        formatter: '{b}: {c} ({d}%)'
      },
      series: [
        {
          type: 'pie',
          data: region_current_breakdown?.map(d => ({
            name: d.region,
            value: d.total_exposure_usd
          })) || []
        }
      ]
    }
  } />

</Grid>

<hr class="my-4" />

## AI Assistants

AMOS provides an AI-ready semantic layer through AMOS Core, allowing language models and assistants to query your private markets data directly through the MCP (Model Context Protocol). This creates a safe, structured interface for retrieval-augmented generation (RAG) and conversational analytics.

You can connect AI copilots or custom LLM applications to AMOS via MCP endpoints. These endpoints expose the same unified schema and metrics used across the dashboard. This ensures your assistants understand entities like funds, deals, exposures, and investors in consistent business terms, and provide verifiable answers backed by the data.

<LinkButton url='/portfolio'>
  Chat with an AI assistant
</LinkButton>

<hr class="my-4" />

## About this demo

This demo is powered by [AMOS Core](https://github.com/open-amos/core) for the data backbone (pipelines, models and metrics), [AMOS Source Example](https://github.com/open-amos/source-example) for sample connectors and data, and [AMOS Dashboard Example](https://github.com/open-amos/dashboard-example) for the demo dashboard. The codebase is fully open source. It can be deployed and customized by internal IT or data teams, or by AMOS for managed deployments.