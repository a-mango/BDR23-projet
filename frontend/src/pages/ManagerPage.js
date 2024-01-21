import React, { useContext, useState } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import { GlobalStateContext } from '../providers/GlobalState';
import Title from '../components/Title';

const ManagerPage = () => {
    const { state, dispatch, addManager, updateManager, removeManager } = useContext(GlobalStateContext);
    const [selectedManager, setSelectedManager] = useState(null);

    const handleSetManager = (manager) => {
        setSelectedManager(manager);
    };

    const handleDeleteClick = (manager) => {
        try {
            removeManager(dispatch, manager.id);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleUpdateManager = (manager) => {
        try {
            updateManager(dispatch, manager);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleCloseForm = () => {
        setSelectedManager(null);
    };

    return (<Page>
            <Title title="Managers" />
            {state.managers && state.managers.length > 0 ? (
                <Table data={state.managers} hideDelete={true} onRowClick={handleSetManager} onDeleteClick={handleDeleteClick}
                       onUpdateManager={handleUpdateManager} onClose={handleCloseForm} />) : (
                <p>No managers found.</p>)}
        </Page>);
};

export default ManagerPage;