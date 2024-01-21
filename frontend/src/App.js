import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Layout from './components/Layout';
import HomePage from './pages/HomePage';
import ReceptionistRouter from './pages/ReceptionistRouter';
import TechnicianRouter from './pages/TechnicianRouter';
import ManagerRouter from './pages/ManagerRouter';

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