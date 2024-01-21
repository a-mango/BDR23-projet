import React from 'react';
import { Route, Routes } from 'react-router-dom';
import RepairsPage from '../pages/RepairsPage';
import CustomersPage from '../pages/CustomersPage';
import ReceptionistPage from '../pages/ReceptionistPage';
import TechnicianPage from '../pages/TechnicianPage';
import ManagerPage from '../pages/ManagerPage';

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