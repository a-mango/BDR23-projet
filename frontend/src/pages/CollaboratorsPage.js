import React, { useEffect, useState } from 'react';
import useCollaborators from '../hooks/useCollaborators';
import Page from "../components/Page";

const CollaboratorsPage = () => {
    const {data, fetch, fetchSingle, create, update, remove, error} = useData();

    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetch().then(() => setIsLoading(false));
    }, [fetch]);

    if (isLoading) {
        return <div>Loading...</div>;
    }

    return (
        <Page>
            <h2>Collaborators</h2>
            {error && <div>Error: {error}</div>}
            {data && data.length > 0 ? (
                data.map((collaborator, index) => (
                    <div key={index}>
                        <h3>{collaborator.name}</h3>
                        <p>{collaborator.role}</p>
                    </div>
                ))
            ) : (
                <p>No collaborators found.</p>
            )}
        </Page>
    );
};

export default CollaboratorsPage;