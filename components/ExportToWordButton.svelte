<script>
  import { exportPageToWord } from './exportToWordUtil.js';

  export let pageTitle = '';
  export let buttonText = '📄 Export to Word';
  export let includeCharts = true;
  export let maxTableRows = 100;

  let isExporting = false;

  async function handleExport() {
    if (isExporting) return;
    
    isExporting = true;
    
    try {
      await exportPageToWord({ includeCharts, maxTableRows, pageTitle });
    } catch (error) {
      alert('Failed to export to Word. Please try again.');
    } finally {
      isExporting = false;
    }
  }
</script>

<button 
  on:click={handleExport}
  disabled={isExporting}
  class="export-button"
  title="Export to Word"
>
  {#if isExporting}
    <span class="spinner"></span>
    <span>Exporting...</span>
  {:else}
    <svg class="download-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
      <polyline points="7 10 12 15 17 10"></polyline>
      <line x1="12" y1="15" x2="12" y2="3"></line>
    </svg>
    {buttonText}
  {/if}
</button>

<style>
  .export-button {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    background: #2563eb;
    color: white;
    border: none;
    border-radius: 0.375rem;
    cursor: pointer;
    font-size: 0.875rem;
    font-weight: 500;
    transition: background-color 0.2s;
    white-space: nowrap;
  }

  .export-button:hover:not(:disabled) {
    background: #1d4ed8;
  }

  .export-button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }

  .download-icon {
    width: 16px;
    height: 16px;
    flex-shrink: 0;
  }

  .spinner {
    width: 14px;
    height: 14px;
    border: 2px solid white;
    border-top-color: transparent;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
    flex-shrink: 0;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }
</style>
