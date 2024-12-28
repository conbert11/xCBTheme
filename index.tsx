import React from 'react';
import { createRoot } from 'react-dom/client';
import App from '@/components/App';
import { setConfig } from 'react-hot-loader';
import './xCBTheme.css';
import './i18n';

setConfig({ reloadHooks: false });

const rootElement = document.getElementById('app');
if (!rootElement) {
    throw new Error("Root element with id 'app' not found.");
}

const root = createRoot(rootElement); 
root.render(<App />);
