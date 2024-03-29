import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Layout from './components/Layout';
import HomePage from './pages/HomePage';
import ReceptionistRouter from './routers/ReceptionistRouter';
import TechnicianRouter from './routers/TechnicianRouter';
import ManagerRouter from './routers/ManagerRouter';

/**
 * App component. This is the main component of the application. The router includes the layout and sub-routers.
 *
 * @returns {Element} The app component.
 */
function App() {
    return (
        <Router>
            <Layout>
                <Routes>
                    <Route path="/" element={<HomePage />} />
                    <Route path="technician/*" element={<TechnicianRouter/>} />
                    <Route path="receptionist/*" element={<ReceptionistRouter/>} />
                    <Route path="manager/*" element={<ManagerRouter/>} />
                </Routes>
            </Layout>
        </Router>
    );
}

export default App;