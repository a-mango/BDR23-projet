import React, { useContext } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import { GlobalStateContext } from '../providers/GlobalState';
import Title from '../components/Title';

/**
 * Receptionists page component.
 *
 * @returns {Element} The receptionists page.
 */
const ReceptionistPage = () => {
    const { state } = useContext(GlobalStateContext);

    return (<Page>
        <Title title="Receptionists" />
        {state.receptionists && state.receptionists.length > 0 ? (<Table data={state.receptionists} />) :
         (<p>No receptionists found.</p>)}
    </Page>);
};

export default ReceptionistPage;