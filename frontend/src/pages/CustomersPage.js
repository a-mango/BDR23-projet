import React, { useContext, useState } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import CustomerForm from '../components/CustomerForm';
import { GlobalStateContext } from '../GlobalState';

const CustomersPage = () => {
    const { state, dispatch, addCustomer, updateCustomer, removeCustomer } = useContext(GlobalStateContext);
    const [selectedCustomer, setSelectedCustomer] = useState(null);

    const handleAddCustomer = (customer) => {
        try {
            addCustomer(dispatch, customer);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleRowClick = (customer) => {
        setSelectedCustomer(customer);
    };

    const handleDeleteClick = (customer) => {
        try {
            removeCustomer(dispatch, customer.id);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    const handleUpdateCustomer = (customer) => {
        try {
            updateCustomer(dispatch, customer);
        } catch (error) {
            dispatch({ type: 'SET_ERROR', payload: error.message });
        }
    };

    return (<Page title="Customers">
            {selectedCustomer && <CustomerForm selectedCustomer={selectedCustomer} onAddCustomer={handleAddCustomer}
                                               onUpdateCustomer={handleUpdateCustomer} />}
            {state.customers && state.customers.length > 0 ? (
                <Table data={state.customers} onRowClick={handleRowClick} onDeleteClick={handleDeleteClick} />) : (
                <p>No customers found.</p>)}
        </Page>);
};

export default CustomersPage;