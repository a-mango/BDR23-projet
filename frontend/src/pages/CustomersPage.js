import React, {useEffect, useState} from 'react';
import Page from "../components/Page";
import Table from "../components/Table";
import useData from "../hooks/useData";

const CustomersPage = () => {
    const {data, fetch, fetchSingle, create, update, remove, error} = useData("customer");

    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetch();
        setIsLoading(false);
    }, [fetch]);

    if (isLoading) {
        return <div>Loading...</div>;
    }

    return (
        <Page title={'Customers'}>
            {error && <div>Error: {error}</div>}
            {data && data.length > 0 ? (<Table data={data}/>) : (<p>No customers found.</p>)}
        </Page>
    );
};

export default CustomersPage;