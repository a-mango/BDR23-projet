import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Layout from './components/Layout';
import HomePage from './pages/HomePage';
import CollaboratorsPage from './pages/CollaboratorsPage';
import Page from './components/Page';
import RepairsPage from './pages/RepairsPage';
import CustomersPage from './pages/CustomersPage';

function App() {
    return (
        <Router>
            <Layout>
                <Routes>
                    <Route path="/" element={<HomePage />} />
                    <Route path="technician" element={<RepairsPage/>} />
                    <Route path="receptionist" element={<CustomersPage/>}>
                        <Route index path="customers" element={<CustomersPage/>} />
                        <Route path="reparations" element={<RepairsPage/>} />
                    </Route>
                    <Route path="manager" element={<Page/>}>
                        <Route index path="collaborators" element={<CollaboratorsPage/>} />
                    </Route>
                </Routes>
            </Layout>
        </Router>
    );
}

export default App;