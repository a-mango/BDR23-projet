import {useCreate, useDelete, useFetch, useFetchSingle, useUpdate} from './useFetch';

const useMessages = () => {
    const fetchMessages = useFetch('customers');
    const fetchMessage = useFetchSingle('customers');
    const createMessage = useCreate('customers');
    const updateMessage = useUpdate('customers');
    const deleteMessage = useDelete('customers');

    return {fetchMessages, fetchMessage, createMessage, updateMessage, deleteMessage};
};

export default useMessages;