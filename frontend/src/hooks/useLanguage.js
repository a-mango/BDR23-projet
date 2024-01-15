import {useFetch} from './useFetch';

const useLanguage = () => {
    const fetchLanguages = useFetch('languages');

    return {fetchLanguages};
};

export default useLanguage;