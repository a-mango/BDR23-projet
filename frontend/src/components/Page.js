// frontend/src/components/Page.js
import React, { useContext } from 'react';
import { GlobalStateContext } from '../GlobalState';
import SubNavigation from './SubNavigation';
import Alert from './Alert';

const Page = ({ title, children }) => {
    const { state } = useContext(GlobalStateContext);
    const { alert } = state;


    return (<>
            <SubNavigation />
            <main className="container mx-auto">
                {alert.message && <Alert type={alert.type} message={alert.message} />}
                <h1>{title}</h1>
                {children}
            </main>
        </>);
};

export default Page;