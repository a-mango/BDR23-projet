import React, { useContext, useState } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import RepairForm from '../forms/RepairForm';
import Title from '../components/Title';
import { GlobalStateContext } from '../providers/GlobalState';

/**
 * Repairs page component.
 *
 * @returns {Element} The repairs page.
 */
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

    const handleSetRepair = (id) => {
        setSelectedRepair(state.repairs.find((repair) => repair.id === id));
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

    const filterColumns = (data) => {
        const columnDenyList = [
            'dateModified',
            'receptionist_id',
            'customer_id',
            'object_id',
            'sms',
        ];
        return data.map((row) => {
            return Object.keys(row).reduce((newRow, key) => {
                if (!columnDenyList.includes(key)) {
                    newRow[key] = row[key];
                }
                return newRow;
            }, {});
        });
    };

    return (<Page>
            <Title
                title="Repairs"
                actionText="New Repair"
                onAction={() => setSelectedRepair({})}
            />
            {selectedRepair && <RepairForm selectedRepair={selectedRepair} setSelectedRepair={setSelectedRepair}
                                           onAddRepair={handleAddRepair} onUpdateRepair={handleUpdateRepair}
                                           onClose={handleCloseForm} />}
            {state.repairs && state.repairs.length > 0 ? (
                <Table data={filterColumns(state.repairs)} onRowClick={handleSetRepair}
                       onDeleteClick={handleDeleteClick} />) : (<p>No repairs found.</p>)}
        </Page>);
};

export default RepairsPage;