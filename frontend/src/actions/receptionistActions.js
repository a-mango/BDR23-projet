/**
 * @fileoverview Receptionist related actions.
 */

import {
    ADD_RECEPTIONIST,
    REMOVE_RECEPTIONIST,
    SET_ALERT,
    SET_RECEPTIONISTS,
    UPDATE_RECEPTIONIST,
} from '../config/actionTypes';
import axios from 'axios';

const fetchReceptionists = async (dispatch) => {
    try {
        const response = await axios.get('/receptionist');
        dispatch({ type: SET_RECEPTIONISTS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

const addReceptionist = async (dispatch, receptionist) => {
    try {
        const response = await axios.post('/receptionist', receptionist);
        dispatch({ type: ADD_RECEPTIONIST, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Receptionist added successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while adding the receptionist' },
        });
    }
};

const updateReceptionist = async (dispatch, receptionist) => {
    try {
        const response = await axios.patch(`/receptionist/${receptionist.id}`, receptionist);
        dispatch({ type: UPDATE_RECEPTIONIST, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Receptionist updated successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while updating the receptionist' },
        });
    }
};

const removeReceptionist = async (dispatch, receptionistId) => {
    try {
        await axios.delete(`/receptionist/${receptionistId}`);
        dispatch({ type: REMOVE_RECEPTIONIST, payload: receptionistId });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Receptionist removed successfully' } });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchReceptionists, addReceptionist, updateReceptionist, removeReceptionist,
};