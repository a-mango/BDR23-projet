import React, { useEffect, useState } from 'react';
import useData from '../hooks/useData';
import Page from "../components/Page";

const RepairPage = () => {
    const {data, fetch, fetchSingle, create, update, remove, error} = useData("collaborator");

    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetch().then(() => setIsLoading(false));
    }, [fetch]);

    if (isLoading) {
        return <div>Loading...</div>;
    }

    return (
        <Page>
            <h2>Repair</h2>

        </Page>
    );
};

export default RepairPage;