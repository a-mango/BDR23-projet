import { Route, Routes } from 'react-router-dom';
import CustomersPage from '../pages/CustomersPage';
import RepairsPage from '../pages/RepairsPage';
import React from 'react';

function ReceptionistRouter() {
    return (
        <Routes>
            <Route index element={<CustomersPage />} />
            <Route path="customers" element={<CustomersPage />} />
            <Route path="reparations" element={<RepairsPage />} />
        </Routes>
    );
}

export default ReceptionistRouter;