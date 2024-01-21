import React, { createContext, useEffect, useReducer } from 'react';
import axios from 'axios';
import { BASE_URL } from '../config/config';
import * as actionTypes from '../config/actionTypes';
import {
    fetchCustomers,
    addCustomer,
    updateCustomer,
    removeCustomer,
} from '../actions/customerActions';
import {
    fetchTechnicians,
    addTechnician,
    updateTechnician,
    removeTechnician,
} from '../actions/technicianActions';
import {
    fetchReceptionists,
    addReceptionist,
    updateReceptionist,
    removeReceptionist,
} from '../actions/receptionistActions';
import {
    fetchManagers,
    addManager,
    updateManager,
    removeManager,
} from '../actions/managerActions';
import {
    fetchRepairs,
    addRepair,
    updateRepair,
    removeRepair,
} from '../actions/repairActions';

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
            case actionTypes.SET_TECHNICIANS:
                return { ...state, technicians: action.payload };
            case actionTypes.ADD_TECHNICIAN:
                return { ...state, technicians: [...state.technicians, action.payload] };
            case actionTypes.UPDATE_TECHNICIAN:
                return {
                    ...state,
                    technicians: state.technicians.map(c => c.id === action.payload.id ? action.payload : c),
                };
            case actionTypes.REMOVE_TECHNICIAN:
                return {
                    ...state, technicians: state.technicians.filter(c => c.id !== action.payload),
                };
            case actionTypes.SET_RECEPTIONISTS:
                return { ...state, receptionists: action.payload };
            case actionTypes.ADD_RECEPTIONIST:
                return { ...state, receptionists: [...state.receptionists, action.payload] };
            case actionTypes.UPDATE_RECEPTIONIST:
                return {
                    ...state,
                    receptionists: state.receptionists.map(c => c.id === action.payload.id ? action.payload : c),
                };
            case actionTypes.REMOVE_RECEPTIONIST:
                return {
                    ...state, receptionists: state.receptionists.filter(c => c.id !== action.payload),
                };
            case actionTypes.SET_MANAGERS:
                return { ...state, managers: action.payload };
            case actionTypes.ADD_MANAGER:
                return { ...state, managers: [...state.managers, action.payload] };
            case actionTypes.UPDATE_MANAGER:
                return {
                    ...state, managers: state.managers.map(c => c.id === action.payload.id ? action.payload : c),
                };
            case actionTypes.REMOVE_MANAGER:
                return {
                    ...state, managers: state.managers.filter(c => c.id !== action.payload),
                };
            case actionTypes.SET_REPAIRS:
                return { ...state, repairs: action.payload };
            case actionTypes.ADD_REPAIR:
                return { ...state, repairs: [...state.repairs, action.payload] };
            case actionTypes.UPDATE_REPAIR:
                return {
                    ...state, repairs: state.repairs.map(c => c.id === action.payload.id ? action.payload : c),
                };
            case actionTypes.REMOVE_REPAIR:
                return {
                    ...state, repairs: state.repairs.filter(c => c.id !== action.payload),
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
        fetchRepairs(dispatch);
        fetchReceptionists(dispatch);
    }, [dispatch]);

    return (<Provider value={{
        state,
        dispatch,
        addCustomer,
        updateCustomer,
        removeCustomer,
        fetchTechnicians,
        addTechnician,
        updateTechnician,
        removeTechnician,
        fetchReceptionists,
        addReceptionist,
        updateReceptionist,
        removeReceptionist,
        fetchManagers,
        addManager,
        updateManager,
        removeManager,
        fetchRepairs,
        addRepair,
        updateRepair,
        removeRepair,
    }}>
        {children}
    </Provider>);
};

export { GlobalStateContext, GlobalStateProvider };