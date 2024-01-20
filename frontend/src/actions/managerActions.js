import {
    SET_MANAGERS,
    ADD_MANAGER,
    UPDATE_MANAGER,
    REMOVE_MANAGER,
    SET_ALERT,
} from '../actionTypes';
import axios from 'axios';

const fetchManagers = async (dispatch) => {
    try {
        const response = await axios.get('/manager');
        dispatch({ type: SET_MANAGERS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

const addManager = async (dispatch, manager) => {
    try {
        const response = await axios.post('/manager', manager);
        dispatch({ type: ADD_MANAGER, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Manager added successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while adding the manager' },
        });
    }
};

const updateManager = async (dispatch, manager) => {
    try {
        const response = await axios.patch(`/manager/${manager.id}`, manager);
        dispatch({ type: UPDATE_MANAGER, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Manager updated successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while updating the manager' },
        });
    }
};

const removeManager = async (dispatch, managerId) => {
    try {
        await axios.delete(`/manager/${managerId}`);
        dispatch({ type: REMOVE_MANAGER, payload: managerId });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Manager removed successfully' } });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchManagers,
    addManager,
    updateManager,
    removeManager,
}