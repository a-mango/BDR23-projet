/**
 * @fileoverview Specialization related actions.
 */

import { SET_ALERT, SET_SPECIALIZATIONS } from '../config/actionTypes';
import axios from 'axios';

const fetchSpecializations = async (dispatch) => {
    try {
        const response = await axios.get('/specialization');
        dispatch({ type: SET_SPECIALIZATIONS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export {
    fetchSpecializations,
};