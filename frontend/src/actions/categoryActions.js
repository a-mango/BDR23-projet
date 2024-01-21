/**
 * @fileoverview Category related actions.
 */

import { SET_ALERT, SET_CATEGORIES } from '../config/actionTypes';
import axios from 'axios';

const fetchCategories = async (dispatch) => {
    try {
        const response = await axios.get('/category');
        dispatch({ type: SET_CATEGORIES, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchCategories,
};