<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	import { base } from '$app/paths';
	import ExportToWordMenuItem from '$lib/ExportToWordMenuItem.svelte';
	export let data;
</script>

<EvidenceDefaultLayout
	{data}
	logo={`${base}/amos.png`}
	neverShowQueries={true}
	fullWidth=true
	hideTOC=true
	githubRepo="https://github.com/open-amos">
	<slot slot="content" />
</EvidenceDefaultLayout>

<style>
  :global(.fund-card-link) {
    text-decoration: none;
    color: inherit;
    display: block;
  }

  :global(.fund-card) {
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
    padding: 1.25rem;
    transition: all 0.2s;
    background: white;
    height: 100%;
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  :global(.fund-card:hover) {
    border-color: #3b82f6;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    transform: translateY(-2px);
  }

  :global(.fund-header) {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 0.75rem;
  }

  :global(.fund-header h4) {
    margin: 0;
    font-size: 1rem;
    font-weight: 600;
    line-height: 1.4;
  }

  :global(.fund-badge) {
    padding: 0.25rem 0.625rem;
    border-radius: 9999px;
    font-size: 0.625rem;
    font-weight: 700;
    text-transform: uppercase;
    white-space: nowrap;
    flex-shrink: 0;
  }

  :global(.fund-badge.equity) {
    background-color: #dbeafe;
    color: #1e40af;
  }

  :global(.fund-badge.credit) {
    background-color: #d1fae5;
    color: #065f46;
  }

  :global(.fund-metrics) {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 0.75rem;
  }

  :global(.metric) {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  :global(.metric-label) {
    font-size: 0.75rem;
    color: #6b7280;
    font-weight: 500;
  }

  :global(.metric-value) {
    font-size: 1rem;
    font-weight: 600;
    color: #111827;
  }

  :global(.fund-action) {
    margin-top: auto;
    color: #3b82f6;
    font-weight: 500;
    font-size: 0.875rem;
  }

  :global(.fund-card:hover .fund-action) {
    color: #2563eb;
  }

  :global(.dark .fund-card) {
    background: #1f2937;
    border-color: #374151;
  }

  :global(.dark .fund-card:hover) {
    border-color: #3b82f6;
  }

  :global(.dark .fund-badge.equity) {
    background-color: #1e3a8a;
    color: #93c5fd;
  }

  :global(.dark .fund-badge.credit) {
    background-color: #064e3b;
    color: #6ee7b7;
  }

  :global(.dark .metric-label) {
    color: #9ca3af;
  }

  :global(.dark .metric-value) {
    color: #f9fafb;
  }

  :global(.dark .fund-action) {
    border-top-color: #374151;
    color: #60a5fa;
  }

  :global(.dark .fund-card:hover .fund-action) {
    color: #93c5fd;
  }

  :global(.section-highlight) {
    background: #F5F6F8;
    padding: 10px 20px;
    border-radius: 5px;
    margin-top: 20px;
    margin-bottom: 20px;
  }

  :global(.section-highlight-chart) {
    background: white;
    padding: 5px 10px;
    border-radius: 5px;
    margin-top: 10px;
    margin-bottom: 10px;
  }

  /* Tab cursor fix - must be last to override other styles */
  :global(button) {
    cursor: pointer !important;
  }
  
  :global(a) {
    cursor: pointer !important;
  }
</style>