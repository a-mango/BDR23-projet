import { useCallback, useEffect, useState } from 'react';
import useFetch from './useFetch';

const useCustomer = () => {
    const { data, fetch, fetchSingle, create, update, remove, error } = useFetch('customers');
    const [customers, setCustomers] = useState(data);

    const fetchCustomers = useCallback(async () => {
        try {
            const data = await fetch();
            setCustomers(data);
        } catch (error) {
            console.error(error);
        }
    }, [fetch]);

    const fetchCustomer = useCallback(async (id) => {
        try {
            const data = await fetchSingle(id);
            return data;
        } catch (error) {
            console.error(error);
        }
    }, [fetchSingle]);

    const createCustomer = useCallback(async (newCustomer) => {
        try {
            const data = await create(newCustomer);
            setCustomers(prevCustomers => [...prevCustomers, data]);
        } catch (error) {
            console.error(error);
        }
    }, [create]);

    const updateCustomer = useCallback(async (id, updatedCustomer) => {
        try {
            const data = await update(id, updatedCustomer);
            setCustomers(prevCustomers => prevCustomers.map(customer => customer.id === id ? data : customer));
        } catch (error) {
            console.error(error);
        }
    }, [update]);

    const deleteCustomer = useCallback(async (id) => {
        try {
            await remove(id);
            setCustomers(prevCustomers => prevCustomers.filter(customer => customer.id !== id));
        } catch (error) {
            console.error(error);
        }
    }, [remove]);

    useEffect(() => {
        fetchCustomers();
    }, [fetchCustomers]);

    return {
        customers, fetchCustomers, fetchCustomer, createCustomer, updateCustomer, deleteCustomer, error
    };
};

export default useCustomer;