import React, {useEffect, useState} from 'react';
import Page from "../components/Page";
import Table from "../components/Table";
import useData from "../hooks/useData";
import CustomerForm from '../components/CustomerForm';
import { useGlobalError } from '../GlobalErrorProvider';

const CustomersPage = () => {
    const { setGlobalError } = useGlobalError();    const {data: customers, fetch, fetchSingle, create, update, remove} = useData("customer");
    const [selectedCustomer, setSelectedCustomer] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetch();
        setIsLoading(false);
    }, [fetch]);

    const handleRowClick = (customer) => {
        setSelectedCustomer(customer);
    };

    const handleDeleteClick = (customer) => {
        remove(customer.id).then(() => {
            fetch();
            setGlobalError({ message: 'Customer deleted successfully.', type: 'success' });
        });
    }

    if (isLoading) {
        return <div>Loading...</div>;
    }

    return (
        <Page title="Customers">
            {selectedCustomer && <CustomerForm selectedCustomer={selectedCustomer} />}
            {customers && customers.length > 0 ? (<Table data={customers} onRowClick={handleRowClick} onDeleteClick={handleDeleteClick}/>) : (<p>No customers found.</p>)}
        </Page>
    );
};

export default CustomersPage;