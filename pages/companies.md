---
title: Companies
sidebar_position: 2
queries:
  - companies_list: dimensions/companies_list.sql
  - companies_breakdown: metrics/companies_breakdown.sql
  - company_performance_overview: metrics/company_performance_overview.sql
---

<style>
  :global(.company-name-cell) {
    font-weight: 700;
  }
  
  :global(.country-flag) {
    font-size: 20px;
    margin-right: 6px;
  }
  
  :global(.data-table tbody tr:nth-child(odd)) {
    background-color: rgba(0, 0, 0, 0.02);
  }
  
  :global(.data-table tbody tr:hover) {
    background-color: rgba(59, 130, 246, 0.05);
  }
</style>

<Tabs>
  <Tab label="Portfolio ({companies_list.filter(d => d.fund_names && d.fund_names.length > 0).length})">

## Portfolio Companies  

Active investments across our funds.

<DataTable 
  data={companies_list.filter(d => d.fund_names && d.fund_names.length > 0)}
  rows=20
  rowShading=true
>
  <Column id=country_flag title="-" contentType=image />
  <Column id=company_link linkLabel=company_name title="Company Name" contentType=link />
  <Column id=primary_industry title="Industry" />
  <Column id=fund_names title="Funds" />
  <Column id=total_exposure title="Exposure" fmt="usd1m" contentType=bar barColor=#ffe08a />
  <Column id=revenue title="Revenue" fmt="usd1m" contentType=bar barColor=#aecfaf />
</DataTable>

  </Tab>
  <Tab label="Pipeline ({companies_list.filter(d => !d.fund_names || d.fund_names.length === 0).length})">

## Pipeline Companies  

Companies being tracked in CRM without active investments.

<DataTable 
  data={companies_list.filter(d => !d.fund_names || d.fund_names.length === 0)}
  rows=20
  rowShading=true
>
  <Column id=country_flag title="-" contentType=image />
  <Column id=company_link linkLabel=company_name title="Company Name" contentType=link />
  <Column id=primary_industry title="Industry" />
</DataTable>

  </Tab>
  <Tab label="All ({companies_list.length})">

## All Companies 

Complete view of portfolio and pipeline companies.

<DataTable 
  data={companies_list}
  rows=20
  rowShading=true
>
  <Column id=country_flag title="-" contentType=image />
  <Column id=company_link linkLabel=company_name title="Company Name" contentType=link />
  <Column id=primary_industry title="Industry" />
  <Column id=fund_names title="Funds" />
  <Column id=total_exposure title="Exposure" fmt="usd1m" contentType=bar barColor=#ffe08a />
  <Column id=revenue title="Revenue" fmt="usd1m" contentType=bar barColor=#aecfaf />
</DataTable>

  </Tab>
</Tabs>

<div class="section-highlight">

## Portfolio Company Composition

<Grid cols=2>

<div class="section-highlight-chart">
  <ECharts config={{
    title: { text: 'Portfolio Companies by Country' },
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    series: [{
      type: 'pie',
      radius: '70%',
      data: (companies_breakdown || [])
        .filter(d => d.dimension_type === 'country' && d.is_portfolio)
        .map(d => ({ name: d.dimension, value: d.company_count }))
    }]
  }} />
</div>

<div class="section-highlight-chart">
  <ECharts config={{
    title: { text: 'Portfolio Companies by Industry' },
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    series: [{
      type: 'pie',
      radius: '70%',
      data: (companies_breakdown || [])
        .filter(d => d.dimension_type === 'industry' && d.is_portfolio)
        .map(d => ({ name: d.dimension, value: d.company_count }))
    }]
  }} />
</div>

</Grid>

<div class="section-highlight-chart">
  <BarChart 
    data={company_performance_overview}
    x=company_name
    y=revenue
    yFmt="usd0"
    title="Revenue by Company"
    swapXY=true
  />
</div>

</div>
