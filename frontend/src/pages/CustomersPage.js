import React, {useEffect, useState} from 'react';
import Page from "../components/Page";
import Table from "../components/Table";
import useData from "../hooks/useData";
import CustomerForm from '../components/CustomerForm';

const CustomersPage = () => {
    const {data: customers, fetch, fetchSingle, create, update, remove, error} = useData("customer");
    const [selectedCustomer, setSelectedCustomer] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetch();
        setIsLoading(false);
    }, [fetch]);

    const handleRowClick = (customer) => {
        setSelectedCustomer(customer);
    };

    if (isLoading) {
        return <div>Loading...</div>;
    }

    return (
        <Page title={'Customers'}>
            {selectedCustomer && <CustomerForm selectedCustomer={selectedCustomer} />}
            {error && <div>Error: {error}</div>}
            {customers && customers.length > 0 ? (<Table data={customers} onRowClick={handleRowClick}/>) : (<p>No customers found.</p>)}
        </Page>
    );
};

export default CustomersPage;