import React, {useEffect, useState} from 'react';
import Page from "../components/Page";
import Table from "../components/Table";
import useData from "../hooks/useData";

const RepairsPage = () => {
    const {data, fetch, fetchSingle, create, update, remove, error} = useData("repair");

    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetch();
        setIsLoading(false);
    }, [fetch]);

    if (isLoading) {
        return <div>Loading...</div>;
    }

    return (
        <Page>
            <h2>Repairs</h2>
            {error && <div>Error: {error}</div>}
            {data && data.length > 0 ? (<Table data={data}/>) : (<p>No repairs found.</p>)}
        </Page>
    );
};

export default RepairsPage;