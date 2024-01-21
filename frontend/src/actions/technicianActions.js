/**
 * @fileoverview Technician related actions.
 */

import {
    ADD_TECHNICIAN,
    REMOVE_TECHNICIAN,
    SET_ALERT,
    SET_TECHNICIANS,
    UPDATE_TECHNICIAN,
} from '../config/actionTypes';
import axios from 'axios';

const fetchTechnicians = async (dispatch) => {
    try {
        const response = await axios.get('/technician');
        dispatch({ type: SET_TECHNICIANS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

const addTechnician = async (dispatch, technician) => {
    try {
        const response = await axios.post('/technician', technician);
        dispatch({ type: ADD_TECHNICIAN, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Technician added successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while adding the technician' },
        });
    }
};

const updateTechnician = async (dispatch, technician) => {
    try {
        const response = await axios.patch(`/technician/${technician.id}`, technician);
        dispatch({ type: UPDATE_TECHNICIAN, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Technician updated successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while updating the technician' },
        });
    }
};

const removeTechnician = async (dispatch, technicianId) => {
    try {
        await axios.delete(`/technician/${technicianId}`);
        dispatch({ type: REMOVE_TECHNICIAN, payload: technicianId });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Technician removed successfully' } });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchTechnicians, addTechnician, updateTechnician, removeTechnician,
};