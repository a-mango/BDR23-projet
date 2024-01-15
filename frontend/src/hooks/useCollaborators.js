import {useCreate, useDelete, useFetch, useFetchSingle, useUpdate} from './useFetch';

const useCollaborators = () => {
    const fetchCollaborators = useFetch('collaborators');
    const fetchCollaborator = useFetchSingle('collaborators');
    const createCollaborator = useCreate('collaborators');
    const updateCollaborator = useUpdate('collaborators');
    const deleteCollaborator = useDelete('collaborators');

    return {fetchCollaborators, fetchSingleCollaborator: fetchCollaborator, createCollaborator, updateCollaborator, deleteCollaborator};
};

export default useCollaborators;