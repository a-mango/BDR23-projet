import {
    SET_BRANDS,
    SET_ALERT,
} from '../config/actionTypes';
import axios from 'axios';

const fetchBrands = async (dispatch) => {
    try {
        const response = await axios.get('/brand');
        dispatch({ type: SET_BRANDS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchBrands,
}