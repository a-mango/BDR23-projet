import React, { useContext } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import { GlobalStateContext } from '../providers/GlobalState';
import Title from '../components/Title';

/**
 * Technician page component.
 *
 * @returns {Element} The technician page.
 */
const TechnicianPage = () => {
    const { state } = useContext(GlobalStateContext);

    return (<Page>
        <Title title="Technicians" />
        {state.technicians && state.technicians.length > 0 ? (<Table data={state.technicians} />) :
         (<p>No technicians found.</p>)}
    </Page>);
};

export default TechnicianPage;