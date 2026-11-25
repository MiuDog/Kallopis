import { KlpThemeProvider } from '@kallopis/react';
import MicroElevatedPillTabs from './component';
import '@kallopis/react/styles.css';
import './styles.css';

export function Example() {
	return (
		<KlpThemeProvider mode="dark">
			<MicroElevatedPillTabs />
		</KlpThemeProvider>
	);
}
