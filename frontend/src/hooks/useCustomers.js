import {useCreate, useDelete, useFetch, useFetchSingle, useUpdate} from './useFetch';

const useCustomers = () => {
    const fetchCustomers = useFetch('customers');
    const fetchCustomer = useFetchSingle('customers');
    const createCustomer = useCreate('customers');
    const updateCustomer = useUpdate('customers');
    const deleteCustomer = useDelete('customers');

    return {fetchCustomers, fetchCustomer, createCustomer, updateCustomer, deleteCustomer};
};

export default useCustomers;