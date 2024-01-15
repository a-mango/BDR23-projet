import {useEffect, useState} from 'react';
import axios from 'axios';
import {BASE_URL} from '../config';

const useFetch = (endpoint) => {
    const [data, setData] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await axios.get(`${BASE_URL}/${endpoint}`);
                setData(response.data);
            } catch (error) {
                setError(error);
            }
        };

        fetchData();
    }, [endpoint]);

    return {data, error};
};

const useFetchSingle = (endpoint, id) => {
    const [data, setData] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await axios.get(`${BASE_URL}/${endpoint}/${id}`);
                setData(response.data);
            } catch (error) {
                setError(error);
            }
        };

        fetchData();
    }, [endpoint, id]);

    return {data, error};
};

const useCreate = (endpoint, data) => {
    const [response, setResponse] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        const postData = async () => {
            try {
                const res = await axios.post(`${BASE_URL}/${endpoint}`, data);
                setResponse(res.data);
            } catch (error) {
                setError(error);
            }
        };

        postData();
    }, [endpoint, data]);

    return {response, error};
};

const useUpdate = (endpoint, data) => {
    const [response, setResponse] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        const updateData = async () => {
            try {
                const res = await axios.put(`${BASE_URL}/${endpoint}`, data);
                setResponse(res.data);
            } catch (error) {
                setError(error);
            }
        };

        updateData();
    }, [endpoint, data]);

    return {response, error};
};

const useDelete = (endpoint) => {
    const [response, setResponse] = useState(null);
    const [error, setError] = useState(null);

    useEffect(() => {
        const deleteData = async () => {
            try {
                const res = await axios.delete(`${BASE_URL}/${endpoint}`);
                setResponse(res.data);
            } catch (error) {
                setError(error);
            }
        };

        deleteData();
    }, [endpoint]);

    return {response, error};
};

export {useFetch, useFetchSingle, useCreate, useUpdate, useDelete};