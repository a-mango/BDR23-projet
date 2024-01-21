import { Route, Routes } from 'react-router-dom';
import CustomersPage from './CustomersPage';
import RepairsPage from './RepairsPage';
import React from 'react';

function ReceptionistRouter() {
    return (
        <Routes>
            <Route index element={<CustomersPage />} />
            <Route path="reparations" element={<RepairsPage />} />
        </Routes>
    );
}

export default ReceptionistRouter;