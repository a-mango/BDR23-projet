import {useCreate, useDelete, useFetch, useFetchSingle, useUpdate} from './useFetch';

const useRepairs = () => {
    const fetchRepairs = useFetch('repairs');
    const fetchRepair = useFetchSingle('repairs');
    const createRepair = useCreate('repairs');
    const updateRepair = useUpdate('repairs');
    const deleteRepair = useDelete('repairs');

    return {fetchRepairs, fetchRepair, createRepair, updateRepair, deleteRepair};
};

export default useRepairs;