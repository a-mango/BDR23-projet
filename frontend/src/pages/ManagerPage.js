import React, { useContext } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import { GlobalStateContext } from '../providers/GlobalState';
import Title from '../components/Title';

/**
 * Manager page component.
 *
 * @returns {Element} The manager page.
 */
const ManagerPage = () => {
    const { state } = useContext(GlobalStateContext);

    return (<Page>
        <Title title="Managers" />
        {state.managers && state.managers.length > 0 ? (<Table data={state.managers} hideDelete={true} />) :
         (<p>No managers found.</p>)}
    </Page>);
};

export default ManagerPage;