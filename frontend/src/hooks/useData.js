import { useCallback, useEffect, useState } from 'react';
import axios from 'axios';
import { BASE_URL } from '../config';

const useData = (resource) => {
    axios.defaults.baseURL = BASE_URL;
    axios.defaults.headers.common['Content-Type'] = 'application/json';
    axios.defaults.headers.common['Accept'] = 'application/json';

    const [data, setData] = useState([]);
    const [error, setError] = useState(null);

    const getAll = useCallback(async () => {
        try {
            const response = await axios.get(`/${resource}`);
            setData(response.data);
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    const get = useCallback(async (id) => {
        try {
            const response = await axios.get(`/${resource}/${id}`);
            return response.data;
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    const create = useCallback(async (newItem) => {
        try {
            const response = await axios.post(`/${resource}`, newItem);
            setData(prevData => [...prevData, response.data]);
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    const update = useCallback(async (id, updatedItem) => {
        try {
            const response = await axios.patch(`/${resource}/${id}`, updatedItem);
            setData(prevData => prevData.map(item => item.id === id ? response.data : item));
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    const remove = useCallback(async (id) => {
        try {
            await axios.delete(`/${resource}/${id}`);
            setData(prevData => prevData.filter(item => item.id !== id));
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    return { data, fetch: getAll, fetchSingle: get, create, update, remove, error };
};

export default useData;