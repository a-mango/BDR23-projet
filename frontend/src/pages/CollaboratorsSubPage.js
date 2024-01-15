import React, { useEffect, useState } from 'react';
import useCollaborators from '../hooks/useCollaborators';
import Page from "../components/Page";

const CollaboratorsSubPage = () => {
    const {
        collaborators,
        fetchCollaborators,
        fetchCollaborator,
        createCollaborator,
        updateCollaborator,
        deleteCollaborator,
        error
    } = useCollaborators();

    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetchCollaborators().then(() => setIsLoading(false));
    }, [fetchCollaborators]);

    if (isLoading) {
        return <div>Loading...</div>;
    }

    return (
        <Page>
            <h2>Collaborators</h2>
            {error && <div>Error: {error}</div>}
            {collaborators && collaborators.length > 0 ? (
                collaborators.map((collaborator, index) => (
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

export default CollaboratorsSubPage;