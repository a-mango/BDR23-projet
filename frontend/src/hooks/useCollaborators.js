import { useCallback, useEffect, useState } from 'react';
import useFetch from './useFetch';

const useCollaborators = () => {
    const { data, fetch, fetchSingle, create, update, remove, error } = useFetch('collaborators');
    const [collaborators, setCollaborators] = useState(data);

    const fetchCollaborators = useCallback(async () => {
        try {
            const data = await fetch();
            setCollaborators(data);
        } catch (error) {
            console.error(error);
        }
    }, [fetch]);

    const fetchCollaborator = useCallback(async (id) => {
        try {
            const data = await fetchSingle(id);
            return data;
        } catch (error) {
            console.error(error);
        }
    }, [fetchSingle]);

    const createCollaborator = useCallback(async (newCollaborator) => {
        try {
            const data = await create(newCollaborator);
            setCollaborators(prevCollaborators => [...prevCollaborators, data]);
        } catch (error) {
            console.error(error);
        }
    }, [create]);

    const updateCollaborator = useCallback(async (id, updatedCollaborator) => {
        try {
            const data = await update(id, updatedCollaborator);
            setCollaborators(prevCollaborators => prevCollaborators.map(collaborator => collaborator.id === id ? data : collaborator));
        } catch (error) {
            console.error(error);
        }
    }, [update]);

    const deleteCollaborator = useCallback(async (id) => {
        try {
            await remove(id);
            setCollaborators(prevCollaborators => prevCollaborators.filter(collaborator => collaborator.id !== id));
        } catch (error) {
            console.error(error);
        }
    }, [remove]);

    useEffect(() => {
        fetchCollaborators();
    }, [fetchCollaborators]);

    return {
        collaborators, fetchCollaborators, fetchCollaborator, createCollaborator, updateCollaborator, deleteCollaborator, error
    };
};

export default useCollaborators;