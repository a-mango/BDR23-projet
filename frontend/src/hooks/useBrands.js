import {useFetch} from './useFetch';

const useBrands = () => {
    const fetchBrands = useFetch('brands');

    return {fetchBrands};
};

export default useBrands;