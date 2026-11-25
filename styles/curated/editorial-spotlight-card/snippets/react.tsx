import { KlpThemeProvider } from '@kallopis/react';
import EditorialSpotlightCard from './component';
import '@kallopis/react/styles.css';
import './styles.css';

export function Example() {
	return (
		<KlpThemeProvider mode="light">
			<EditorialSpotlightCard title="Quietly Editorial Workspace" initialOrb="peach" />
		</KlpThemeProvider>
	);
}
