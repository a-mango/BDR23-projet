import React, { useContext, useState } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import { GlobalStateContext } from '../providers/GlobalState';
import Title from '../components/Title';

const ReceptionistPage = () => {
    const { state, dispatch, addReceptionist, updateReceptionist, removeReceptionist } = useContext(GlobalStateContext);
    const [selectedReceptionist, setSelectedReceptionist] = useState(null);

    const handleAddReceptionist = (receptionist) => {
        try {
            addReceptionist(dispatch, receptionist);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleSetReceptionist = (receptionist) => {
        setSelectedReceptionist(receptionist);
    };

    const handleDeleteClick = (receptionist) => {
        try {
            removeReceptionist(dispatch, receptionist.id);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleUpdateReceptionist = (receptionist) => {
        try {
            updateReceptionist(dispatch, receptionist);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleCloseForm = () => {
        setSelectedReceptionist(null);
    };

    return (<Page>
        <Title title="Receptionists" />
        {state.receptionists && state.receptionists.length > 0 ?
         (<Table data={state.receptionists} onRowClick={handleSetReceptionist} onDeleteClick={handleDeleteClick}
                 onUpdateReceptionist={handleUpdateReceptionist} onClose={handleCloseForm} />) :
         (<p>No receptionists found.</p>)}
    </Page>);
};

export default ReceptionistPage;