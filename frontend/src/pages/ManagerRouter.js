import React from 'react';
import { Route, Routes } from 'react-router-dom';
import RepairsPage from './RepairsPage';
import CustomersPage from './CustomersPage';
import ReceptionistPage from './ReceptionistPage';
import TechnicianPage from './TechnicianPage';
import ManagerPage from './ManagerPage';

function ManagerRouter() {
    return (
        <Routes>
            <Route index element={<CustomersPage />} />
            <Route path="customers" element={<CustomersPage />} />
            <Route path="reparations" element={<RepairsPage />} />
            <Route path="receptionists" element={<ReceptionistPage />} />
            <Route path="technicians" element={<TechnicianPage />} />
            <Route path="managers" element={<ManagerPage />} />
        </Routes>
    );
}

export default ManagerRouter;