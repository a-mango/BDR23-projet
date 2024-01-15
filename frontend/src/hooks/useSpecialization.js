import {useFetch} from './useFetch';

const useSpecialization = () => {
    const fetchSpecializations = useFetch('specializations');

    return {fetchSpecializations};
};

export default useSpecialization;