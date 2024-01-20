import React, { createContext, useEffect, useReducer } from 'react';
import axios from 'axios';
import { BASE_URL } from './config';
import * as actionTypes from './actionTypes';
import {
    fetchCustomers,
    addCustomer,
    updateCustomer,
    removeCustomer,
    fetchCollaborators,
    addCollaborator,
    updateCollaborator,
    removeCollaborator,
} from './actions';

const initialState = { customers: [], alert: { type: '', message: '' } };
const GlobalStateContext = createContext(initialState);
const { Provider } = GlobalStateContext;

axios.defaults.baseURL = BASE_URL;
axios.defaults.headers.common['Content-Type'] = 'application/json';
axios.defaults.headers.common['Accept'] = 'application/json';

const GlobalStateProvider = ({ children }) => {
    const [state, dispatch] = useReducer((state, action) => {
        switch (action.type) {
            case actionTypes.SET_CUSTOMERS:
                return { ...state, customers: action.payload };
            case actionTypes.ADD_CUSTOMER:
                return { ...state, customers: [...state.customers, action.payload] };
            case actionTypes.UPDATE_CUSTOMER:
                return {
                    ...state, customers: state.customers.map(c => c.id === action.payload.id ? action.payload : c),
                };
            case actionTypes.REMOVE_CUSTOMER:
                return {
                    ...state, customers: state.customers.filter(c => c.id !== action.payload),
                };
            case actionTypes.SET_ALERT:
                return { ...state, alert: action.payload };
            case actionTypes.CLEAR_ALERT:
                return { ...state, alert: { type: '', message: '' } };
            case actionTypes.SET_COLLABORATORS:
                return { ...state, collaborators: action.payload };
            case actionTypes.ADD_COLLABORATOR:
                return { ...state, collaborators: [...state.collaborators, action.payload] };
            case actionTypes.UPDATE_COLLABORATOR:
                return {
                    ...state,
                    collaborators: state.collaborators.map(c => c.id === action.payload.id ? action.payload : c),
                };
            case actionTypes.REMOVE_COLLABORATOR:
                return {
                    ...state, collaborators: state.collaborators.filter(c => c.id !== action.payload),
                };
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

    return (<Provider value={{
        state,
        dispatch,
        addCustomer,
        updateCustomer,
        removeCustomer,
        fetchCollaborators,
        addCollaborator,
        updateCollaborator,
        removeCollaborator,
    }}>
        {children}
    </Provider>);
};

export { GlobalStateContext, GlobalStateProvider };