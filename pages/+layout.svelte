<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	import { base } from '$app/paths';
	import { page } from '$app/stores';
	import { onMount } from 'svelte';
	import ExportToWordMenuItem from '$lib/ExportToWordMenuItem.svelte';
	export let data;

	// Mark active navigation links
	onMount(() => {
		const updateActiveLinks = () => {
			const currentPath = $page.url.pathname;
			
			// Try multiple selectors to find the nav links
			let navLinks = document.querySelectorAll('nav a');
			if (navLinks.length === 0) {
				navLinks = document.querySelectorAll('aside a');
			}
			if (navLinks.length === 0) {
				navLinks = document.querySelectorAll('a[href^="/"]');
			}
			
			navLinks.forEach(link => {
				link.classList.remove('active');
				const href = link.getAttribute('href');
				const linkText = link.textContent?.trim();
								
				if (href && (currentPath === href || currentPath.startsWith(href + '/'))) {
					// Check if this is the most specific match
					const isExactMatch = currentPath === href;
					const isParentMatch = currentPath.startsWith(href + '/');
					
					console.log(`    Match found! Exact: ${isExactMatch}, Parent: ${isParentMatch}`);
					
					if (isExactMatch || (isParentMatch && href !== base && href !== base + '/')) {
						link.classList.add('active');
						console.log(`    ✅ Added active class to "${linkText}"`);
					}
				}
			});
		};
		
		// Wait for DOM to be fully rendered
		setTimeout(() => {
			updateActiveLinks();
		}, 200);
		
		// Also try immediately
		updateActiveLinks();
		
		// Update on navigation
		const unsubscribe = page.subscribe(() => {
			setTimeout(updateActiveLinks, 100);
		});

		return unsubscribe;
	});
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

  /* Tab cursor fix */
  :global(button) {
    cursor: pointer !important;
  }
  
  :global(a) {
    cursor: pointer !important;
  }

  /* Modern SaaS Sidebar Styling */
  
  /* Sidebar navigation links - multiple selectors for specificity */
  :global(nav a:not(.top-0)),
  :global(aside nav a:not(.top-0)),
  :global(aside a:not(.top-0)) {
    position: relative !important;
    padding: 0.175rem 0.75rem !important;
    margin: 0.125rem !important;
    margin-right: 1rem !important;
    border-radius: 0.5rem !important;
    transition: all 0.15s ease !important;
    font-weight: 500 !important;
    color: #6b7280 !important;
    text-decoration: none !important;
  }

  :global(nav a:not(.top-0):hover),
  :global(aside nav a:not(.top-0):hover),
  :global(aside a:not(.top-0):hover) {
    background-color: #f3f4f6 !important;
    color: #111827 !important;
  }

  /* Active page styling - high specificity, excluding .top-0 */
  :global(nav a[aria-current="page"]:not(.top-0)),
  :global(nav a.active:not(.top-0)),
  :global(aside nav a[aria-current="page"]:not(.top-0)),
  :global(aside nav a.active:not(.top-0)),
  :global(aside a[aria-current="page"]:not(.top-0)),
  :global(aside a.active:not(.top-0)),
  :global(a.active:not(.top-0)) {
    background-color: #eff6ff !important;
    color: #2563eb !important;
    font-weight: 600 !important;
  }

  /* Active indicator bar - excluding .top-0 */
  :global(nav a[aria-current="page"]:not(.top-0)::before),
  :global(nav a.active:not(.top-0)::before),
  :global(aside nav a[aria-current="page"]:not(.top-0)::before),
  :global(aside nav a.active:not(.top-0)::before),
  :global(aside a[aria-current="page"]:not(.top-0)::before),
  :global(aside a.active:not(.top-0)::before),
  :global(a.active:not(.top-0)::before) {
    content: '' !important;
    position: absolute !important;
    left: 0 !important;
    top: 50% !important;
    transform: translateY(-50%) !important;
    width: 3px !important;
    height: 60% !important;
    border-radius: 0 2px 2px 0 !important;
  }

  /* Section headers in sidebar */
  :global(nav details summary) {
    font-weight: 600 !important;
    color: #374151 !important;
    padding: 0.5rem 0.75rem !important;
    margin: 0.25rem 0.5rem !important;
    font-size: 0.75rem !important;
    text-transform: uppercase !important;
    letter-spacing: 0.05em !important;
  }

  /* Nested navigation items */
  :global(nav details a) {
    padding-left: 1.5rem !important;
    font-size: 0.875rem !important;
  }

  /* Dark mode sidebar */
  :global(.dark nav a) {
    color: #9ca3af !important;
  }

  :global(.dark nav a:hover) {
    background-color: #374151 !important;
    color: #f3f4f6 !important;
  }

  :global(.dark nav a[aria-current="page"]),
  :global(.dark nav a.active) {
    background-color: #1e3a8a !important;
    color: #93c5fd !important;
  }

  :global(.dark nav a[aria-current="page"]::before),
  :global(.dark nav a.active::before) {
    background-color: #60a5fa;
  }

  :global(.dark nav details summary) {
    color: #d1d5db !important;
  }

  /* Sidebar container styling */
  :global(aside nav) {
    padding: 0.5rem 0 !important;
  }

  /* Remove default list styling */
  :global(nav ul) {
    list-style: none !important;
    padding: 0 !important;
    margin: 0 !important;
  }

  :global(nav li) {
    margin: 0 !important;
  }
</style>