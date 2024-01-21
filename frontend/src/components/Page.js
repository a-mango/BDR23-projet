import React, { useContext } from 'react';
import { GlobalStateContext } from '../providers/GlobalState';
import SubNav from './SubNav';
import Alert from './Alert';

/**
 * Page component. Displays a sub-navigation bar and an alert message.
 * @param children The children of the page.
 * @returns {Element} The page component.
 */
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