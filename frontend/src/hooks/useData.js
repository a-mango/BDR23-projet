import { useCallback, useEffect, useState } from 'react';
import axios from 'axios';
import { BASE_URL } from '../config';
import { useGlobalError } from '../GlobalErrorProvider';

const useData = (resource) => {
    const { setGlobalError } = useGlobalError();
    const [data, setData] = useState([]);

    useEffect(() => {
        axios.defaults.baseURL = BASE_URL;
        axios.defaults.headers.common['Content-Type'] = 'application/json';
        axios.defaults.headers.common['Accept'] = 'application/json';
    }, []);


    const getAll = useCallback(async () => {
        try {
            const response = await axios.get(`/${resource}`);
            setData(response.data);
        } catch (error) {
            setGlobalError({ message: `An error occurred while getting the ${resource}.`, type: 'error' });
        }
    }, [resource]);

    const get = useCallback(async (id) => {
        try {
            const response = await axios.get(`/${resource}/${id}`);
            return response.data;
        } catch (error) {
            setGlobalError({ message: `An error occurred while getting the ${resource}.`, type: 'error' });
        }
    }, [resource]);

    const create = useCallback(async (newItem) => {
        try {
            const response = await axios.post(`/${resource}`, newItem);
            setData(prevData => [...prevData, response.data]);
        } catch (error) {
            setGlobalError({ message: `An error occurred while creating the ${resource}.`, type: 'error' });
        }
    }, [resource]);

    const update = useCallback(async (id, updatedItem) => {
        try {
            const response = await axios.patch(`/${resource}/${id}`, updatedItem);
            setData(prevData => prevData.map(item => item.id === id ? response.data : item));
        } catch (error) {
            setGlobalError({ message: `An error occurred while updating the ${resource}.`, type: 'error' });
        }
    }, [resource]);

    const remove = useCallback(async (id) => {
        try {
            await axios.delete(`/${resource}/${id}`);
            setData(prevData => prevData.filter(item => item.id !== id));
        } catch (error) {
            setGlobalError({ message: `An error occurred while deleting the ${resource}.`, type: 'error' });
        }
    }, [resource]);

    return { data, fetch: getAll, fetchSingle: get, create, update, remove };
};

export default useData;