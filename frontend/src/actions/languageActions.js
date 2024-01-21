/**
 * @fileoverview Language related actions.
 */

import { SET_ALERT, SET_LANGUAGES } from '../config/actionTypes';
import axios from 'axios';

const fetchLanguages = async (dispatch) => {
    try {
        const response = await axios.get('/language');
        dispatch({ type: SET_LANGUAGES, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchLanguages,
};