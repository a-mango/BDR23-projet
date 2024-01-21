import React, { useContext, useState } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import { GlobalStateContext } from '../providers/GlobalState';
import Title from '../components/Title';

const TechnicianPage = () => {
    const { state, dispatch, addTechnician, updateTechnician, removeTechnician } = useContext(GlobalStateContext);
    const [selectedTechnician, setSelectedTechnician] = useState(null);

    const handleAddTechnician = (technician) => {
        try {
            addTechnician(dispatch, technician);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleSetTechnician = (technician) => {
        setSelectedTechnician(technician);
    };

    const handleDeleteClick = (technician) => {
        try {
            removeTechnician(dispatch, technician.id);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleUpdateTechnician = (technician) => {
        try {
            updateTechnician(dispatch, technician);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleCloseForm = () => {
        setSelectedTechnician(null);
    };

    return (<Page>
            <Title title="Technicians" />
            {state.technicians && state.technicians.length > 0 ? (
                <Table data={state.technicians} hideDelete={true} onRowClick={handleSetTechnician} onDeleteClick={handleDeleteClick}
                       onUpdateTechnician={handleUpdateTechnician} onClose={handleCloseForm} />) : (
                <p>No technicians found.</p>)}
        </Page>);
};

export default TechnicianPage;