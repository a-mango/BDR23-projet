import {
    SET_CUSTOMERS,
    ADD_CUSTOMER,
    UPDATE_CUSTOMER,
    REMOVE_CUSTOMER,
    SET_ALERT,
} from '../config/actionTypes';
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

export {
    fetchCustomers,
    addCustomer,
    updateCustomer,
    removeCustomer,
}