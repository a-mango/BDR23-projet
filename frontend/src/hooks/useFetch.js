import {useCallback, useEffect, useState} from 'react';
import axios from 'axios';

const useFetch = (resource) => {
    const [data, setData] = useState([]);
    const [error, setError] = useState(null);

    const fetch = useCallback(async () => {
        try {
            const response = await axios.get(`/api/${resource}`);
            setData(response.data);
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    const fetchSingle = useCallback(async (id) => {
        try {
            const response = await axios.get(`/api/${resource}/${id}`);
            return response.data;
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    const create = useCallback(async (newItem) => {
        try {
            const response = await axios.post(`/api/${resource}`, newItem);
            setData(prevData => [...prevData, response.data]);
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    const update = useCallback(async (id, updatedItem) => {
        try {
            const response = await axios.put(`/api/${resource}/${id}`, updatedItem);
            setData(prevData => prevData.map(item => item.id === id ? response.data : item));
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    const remove = useCallback(async (id) => {
        try {
            await axios.delete(`/api/${resource}/${id}`);
            setData(prevData => prevData.filter(item => item.id !== id));
        } catch (error) {
            setError(error.message);
        }
    }, [resource]);

    useEffect(() => {
        fetch();
    }, [fetch]);

    return {data, fetch, fetchSingle, create, update, remove, error};
};

export default useFetch;