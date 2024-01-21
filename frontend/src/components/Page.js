import React, { useContext } from 'react';
import { GlobalStateContext } from '../providers/GlobalState';
import SubNavigation from './SubNavigation';
import Alert from './Alert';

const Page = ({ children }) => {
    const { state } = useContext(GlobalStateContext);
    const { alert } = state;

    return (<>
            <SubNavigation />
            <main className="container mx-auto">
                {alert.message && <Alert type={alert.type} message={alert.message} />}
                {children}
            </main>
        </>);
};

export default Page;