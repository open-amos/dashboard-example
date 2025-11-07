---
title: Welcome to your fund's dashboard
---


This example dashboard is built on top of AMOS, the open-source data platform for private markets. It uses the sample data provided in the AMOS Source Example project:

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

## Unified data model, 360° metrics

The AMOS Core project provides a canonical model for private markets that defines the standard entities and relationships between them. It includes a set of metrics and KPIs that are common to all funds. This allows you to use the same metrics and KPIs across all your funds, regardless of the data source or system.

## Customize and extend

Connect your own systems to the AMOS data platform. Add your ESG data, market data, and other data sources. AMOS is the central layer that connects your data and systems into a single, consistent layer of truth, providing ready-made pipelines, models, and metrics for your fund data.

## Next steps

- Explore the [AMOS documentation](https://docs.amos.tech) to learn more about the AMOS data platform.
- Explore the [AMOS Source Example](https://github.com/open-amos/source-example) to learn more about the sample data and models.
- Explore the [AMOS Core](https://github.com/open-amos/core) to learn more about the canonical model.
- Explore the [AMOS Starter](https://github.com/open-amos/starter) to learn more about the orchestrator.