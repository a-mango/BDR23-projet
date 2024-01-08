import React from 'react';
import {BrowserRouter as Router, Route, Routes} from 'react-router-dom';
import Layout from './Layout';
import HomePage from './HomePage';
import ReceptionistPage from "./ReceptionistPage";
import ManagerPage from "./ManagerPage";
import TechnicianPage from "./TechnicianPage";

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