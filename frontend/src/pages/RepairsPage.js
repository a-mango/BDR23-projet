import React, { useContext, useEffect, useState } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import RepairForm from '../forms/RepairForm';
import Title from '../components/Title';
import { GlobalStateContext } from '../providers/GlobalState';

const RepairsPage = () => {
    const { state, dispatch, addRepair, updateRepair, removeRepair } = useContext(GlobalStateContext);
    const [selectedRepair, setSelectedRepair] = useState(null);

    const handleAddRepair = (repair) => {
        try {
            addRepair(dispatch, repair);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleSetRepair = (repair) => {
        setSelectedRepair(repair);
    };

    const handleDeleteClick = (repair) => {
        try {
            removeRepair(dispatch, repair.id);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleUpdateRepair = (repair) => {
        try {
            updateRepair(dispatch, repair);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleCloseForm = () => {
        setSelectedRepair(null);
    };

    return (
        <Page>
            <Title
                title="Repairs"
                actionText="New Repair"
                onAction={() => setSelectedRepair({})}
            />
            {selectedRepair && <RepairForm selectedRepair={selectedRepair} onAddRepair={handleAddRepair}
                                           onUpdateRepair={handleUpdateRepair} onClose={handleCloseForm} />}
            {state.repairs && state.repairs.length > 0 ? (
                <Table data={state.repairs} onRowClick={handleSetRepair} onDeleteClick={handleDeleteClick} />) : (
                <p>No repairs found.</p>)}
        </Page>
    );
};

export default RepairsPage;