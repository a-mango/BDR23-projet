import {useFetch} from './useFetch';

const useCategories = () => {
    const fetchCategories = useFetch('categories');

    return {fetchCategories};
};

export default useCategories;