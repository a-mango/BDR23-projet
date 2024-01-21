import {
    SET_REPAIRS,
    ADD_REPAIR,
    UPDATE_REPAIR,
    REMOVE_REPAIR,
    SET_ALERT,
} from '../config/actionTypes';
import axios from 'axios';

const fetchRepairs = async (dispatch) => {
    try {
        const response = await axios.get('/reparation');
        dispatch({ type: SET_REPAIRS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

const addRepair = async (dispatch, repair) => {
    try {
        const response = await axios.post('/reparation', repair);
        dispatch({ type: ADD_REPAIR, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Repair added successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while adding the repair' },
        });
    }
};

const updateRepair = async (dispatch, repair) => {
    try {
        const response = await axios.patch(`/reparation/${repair.id}`, repair);
        dispatch({ type: UPDATE_REPAIR, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Repair updated successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while updating the repair' },
        });
    }
};

const removeRepair = async (dispatch, repairId) => {
    try {
        await axios.delete(`/reparation/${repairId}`);
        dispatch({ type: REMOVE_REPAIR, payload: repairId });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Repair removed successfully' } });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchRepairs,
    addRepair,
    updateRepair,
    removeRepair,
}