import React from 'react';
import SubNavigation from './SubNavigation';
import { Outlet } from 'react-router-dom';

const Page = ({ title, children }) => {
    return (
        <>
            <SubNavigation />
            <main className="container mx-auto py-4">
                <h1>{title}</h1>
                {children}
            </main>
        </>
    );
};

export default Page;