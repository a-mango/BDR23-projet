import {
    SET_CUSTOMERS,
    ADD_CUSTOMER,
    UPDATE_CUSTOMER,
    REMOVE_CUSTOMER,
    SET_ALERT,
    CLEAR_ALERT,
    SET_COLLABORATORS,
    ADD_COLLABORATOR,
    UPDATE_COLLABORATOR,
    REMOVE_COLLABORATOR
} from './actionTypes';
import axios from 'axios';

const fetchCustomers = async (dispatch) => {
    try {
        const response = await axios.get('/customer');
        dispatch({ type: SET_CUSTOMERS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

const addCustomer = async (dispatch, customer) => {
    try {
        const response = await axios.post('/customer', customer);
        dispatch({ type: ADD_CUSTOMER, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Customer added successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while adding the customer' },
        });
    }
};

const updateCustomer = async (dispatch, customer) => {
    try {
        const response = await axios.patch(`/customer/${customer.id}`, customer);
        dispatch({ type: UPDATE_CUSTOMER, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Customer updated successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while updating the customer' },
        });
    }
};

const removeCustomer = async (dispatch, customerId) => {
    try {
        await axios.delete(`/customer/${customerId}`);
        dispatch({ type: REMOVE_CUSTOMER, payload: customerId });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Customer removed successfully' } });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

const fetchCollaborators = async (dispatch) => {
    try {
        const response = await axios.get('/collaborator');
        dispatch({ type: SET_COLLABORATORS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

const addCollaborator = async (dispatch, collaborator) => {
    try {
        const response = await axios.post('/collaborator', collaborator);
        dispatch({ type: ADD_COLLABORATOR, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Collaborator added successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while adding the collaborator' },
        });
    }
};

const updateCollaborator = async (dispatch, collaborator) => {
    try {
        const response = await axios.patch(`/collaborator/${collaborator.id}`, collaborator);
        dispatch({ type: UPDATE_COLLABORATOR, payload: response.data });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Collaborator updated successfully' } });
    } catch (error) {
        dispatch({
            type: SET_ALERT,
            payload: { type: 'error', message: error.message || 'An error occurred while updating the collaborator' },
        });
    }
};

const removeCollaborator = async (dispatch, collaboratorId) => {
    try {
        await axios.delete(`/collaborator/${collaboratorId}`);
        dispatch({ type: REMOVE_COLLABORATOR, payload: collaboratorId });
        dispatch({ type: SET_ALERT, payload: { type: 'success', message: 'Collaborator removed successfully' } });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchCustomers,
    addCustomer,
    updateCustomer,
    removeCustomer,
    fetchCollaborators,
    addCollaborator,
    updateCollaborator,
    removeCollaborator,
}