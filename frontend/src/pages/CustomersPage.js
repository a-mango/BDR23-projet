import React, { useContext, useState } from 'react';
import Page from '../components/Page';
import Table from '../components/Table';
import CustomerForm from '../forms/CustomerForm';
import { GlobalStateContext } from '../providers/GlobalState';
import Title from '../components/Title';

/**
 * Customers page component.
 *
 * @returns {Element} The customers page.
 */
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

    const handleSetCustomer = (id) => {
        setSelectedCustomer(state.customers.find((customer) => customer.id === id));
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

    const handleCloseForm = () => {
        setSelectedCustomer(null);
    };

    return (<Page>
        <Title title="Customers" actionText="New Customer" onAction={() => setSelectedCustomer({})} />
        {selectedCustomer && <CustomerForm selectedCustomer={selectedCustomer} setSelectedCustomer={setSelectedCustomer}
                                           onAddCustomer={handleAddCustomer} onUpdateCustomer={handleUpdateCustomer}
                                           onClose={handleCloseForm} />}
        {state.customers && state.customers.length > 0 ?
         (<Table data={state.customers} onRowClick={handleSetCustomer} onDeleteClick={handleDeleteClick} />) :
         (<p>No customers found.</p>)}
    </Page>);
};

export default CustomersPage;