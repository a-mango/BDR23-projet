import React, { useEffect, useState } from 'react';
import useCustomers from "../hooks/useCustomers";
import Page from "../components/Page";

const CustomersSubPage = () => {
    const {
        customers,
        fetchCustomers,
        fetchCustomer,
        createCustomer,
        updateCustomer,
        deleteCustomer,
        error
    } = useCustomers();

    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetchCustomers().then(() => setIsLoading(false));
    }, [fetchCustomers]);

    if (isLoading) {
        return <div>Loading...</div>;
    }

    return (
        <Page>
            <h2>Customers</h2>
            {error && <div>Error: {error}</div>}
            {customers && customers.length > 0 ? (
                customers.map((customer, index) => (
                    <div key={index}>
                        <h3>{customer.name}</h3>
                        <p>{customer.role}</p>
                    </div>
                ))
            ) : (
                <p>No customers found.</p>
            )}
        </Page>
    );
};

export default CustomersSubPage;