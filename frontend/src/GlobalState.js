import React, { createContext, useEffect, useReducer } from 'react';
import axios from 'axios';
import { BASE_URL } from './config';

const initialState = { customers: [], alert: { type: '', message: '' } };
const GlobalStateContext = createContext(initialState);
const { Provider } = GlobalStateContext;

axios.defaults.baseURL = BASE_URL;
axios.defaults.headers.common['Content-Type'] = 'application/json';
axios.defaults.headers.common['Accept'] = 'application/json';

const fetchCustomers = async (dispatch) => {
    try {
        const response = await axios.get('/customer');
        dispatch({ type: 'SET_CUSTOMERS', payload: response.data });
    } catch (error) {
        dispatch({ type: 'SET_ALERT', payload: { type: 'error', message: error.message } });
    }
};

const addCustomer = async (dispatch, customer) => {
    try {
        const response = await axios.post('/customer', customer);
        dispatch({ type: 'ADD_CUSTOMER', payload: response.data });
        dispatch({ type: 'SET_ALERT', payload: { type: 'success', message: 'Customer added successfully' } });
    } catch (error) {
        dispatch({ type: 'SET_ALERT', payload: { type: 'error', message: error.message || 'An error occurred while adding the customer' } });
    }
};

const updateCustomer = async (dispatch, customer) => {
    try {
        const response = await axios.patch(`/customer/${customer.id}`, customer);
        dispatch({ type: 'UPDATE_CUSTOMER', payload: response.data });
        dispatch({ type: 'SET_ALERT', payload: { type: 'success', message: 'Customer updated successfully' } });
    } catch (error) {
        dispatch({ type: 'SET_ALERT', payload: { type: 'error', message: error.message || 'An error occurred while updating the customer' } });
    }
};

const removeCustomer = async (dispatch, customerId) => {
    try {
        await axios.delete(`/customer/${customerId}`);
        dispatch({ type: 'REMOVE_CUSTOMER', payload: customerId });
        dispatch({ type: 'SET_ALERT', payload: { type: 'success', message: 'Customer removed successfully' } });
    } catch (error) {
        dispatch({ type: 'SET_ALERT', payload: { type: 'error', message: error.message } });
    }
};

const GlobalStateProvider = ({ children }) => {
    const [state, dispatch] = useReducer((state, action) => {
        switch (action.type) {
            case 'SET_CUSTOMERS':
                return { ...state, customers: action.payload };
            case 'ADD_CUSTOMER':
                return { ...state, customers: [...state.customers, action.payload] };
            case 'UPDATE_CUSTOMER':
                return {
                    ...state, customers: state.customers.map(c => c.id === action.payload.id ? action.payload : c),
                };
            case 'REMOVE_CUSTOMER':
                return {
                    ...state, customers: state.customers.filter(c => c.id !== action.payload),
                };
            case 'SET_ALERT':
                return { ...state, alert: action.payload };
            case 'CLEAR_ALERT':
                return { ...state, alert: { type: '', message: '' } };
            default:
                return state;
        }
    }, initialState, state => {
        console.log('State updated:', state);
        return state;
    });

    useEffect(() => {
        fetchCustomers(dispatch);
    }, [dispatch]);

    return (<Provider value={{ state, dispatch, addCustomer, updateCustomer, removeCustomer }}>
        {children}
    </Provider>);
};

export { GlobalStateContext, GlobalStateProvider };