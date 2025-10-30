<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	export let data;
</script>

<EvidenceDefaultLayout {data} logo="/amos.png" 
							  neverShowQueries={true}
							  hideTOC=true
							  githubRepo="https://github.com/open-amos"
							  fullWidth=true> 
	<slot slot="content" />
</EvidenceDefaultLayout> 
