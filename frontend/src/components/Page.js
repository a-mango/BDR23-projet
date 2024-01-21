import React, { useContext } from 'react';
import { GlobalStateContext } from '../providers/GlobalState';
import SubNav from './SubNav';
import Alert from './Alert';

const Page = ({ children }) => {
    const { state } = useContext(GlobalStateContext);
    const { alert } = state;

    return (<>
            <SubNav />
            <main className="container mx-auto">
                {alert.message && <Alert type={alert.type} message={alert.message} />}
                {children}
            </main>
        </>);
};

export default Page;