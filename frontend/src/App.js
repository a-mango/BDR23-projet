import { BrowserRouter } from 'react-router-dom';
import { routes } from './routes';
import Navigation from './components/Navigation';
import Router from './Router';

function App() {
    return (
        <BrowserRouter>
            <Navigation />
            <Router />
        </BrowserRouter>
    );
}

export default App;