import React from 'react';
import { Routes, Route } from 'react-router-dom';
import CollaboratorsPage from './CollaboratorsPage';
import SubNavigation from '../components/SubNavigation';
import Page from '../components/Page';

const ManagerPage = () => {


    const routes = [
        { path: '/collaborators', element: <CollaboratorsPage /> },
    ];

    return (
        <Page>
            <h1>Manager</h1>
        </Page>
    );
};

export default ManagerPage;