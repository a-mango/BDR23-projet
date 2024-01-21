import { Route, Routes } from 'react-router-dom';
import RepairsPage from '../pages/RepairsPage';
import React from 'react';

function TechnicianRouter() {
    return (
        <Routes>
            <Route index element={<RepairsPage />} />
            <Route path="reparations" element={<RepairsPage />} />
        </Routes>
    );
}

export default TechnicianRouter;