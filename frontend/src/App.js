import React from 'react';
import {BrowserRouter as Router, Route, Routes} from 'react-router-dom';
import Layout from './components/Layout';
import HomePage from './pages/HomePage';
import ReceptionistPage from "./pages/ReceptionistPage";
import ManagerPage from "./pages/ManagerPage";
import TechnicianPage from "./pages/TechnicianPage";

function App() {
    return (
        <Router>
            <Layout>
                <Routes>
                    <Route path="/" element={<HomePage/>}/>
                    <Route path="/receptionist" element={<ReceptionistPage/>}/>
                    <Route path="/manager" element={<ManagerPage/>}/>
                    <Route path="/technician" element={<TechnicianPage/>}/>
                </Routes>
            </Layout>
        </Router>
    );
}

export default App;