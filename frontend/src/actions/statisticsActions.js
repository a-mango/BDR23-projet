/**
 * @fileoverview Statistics related actions.
 */

import { SET_ALERT, SET_STATISTICS } from '../config/actionTypes';
import axios from 'axios';

const fetchStatistics = async (dispatch) => {
    try {
        const response = await axios.get('/statistics');
        dispatch({ type: SET_STATISTICS, payload: response.data });
    } catch (error) {
        dispatch({ type: SET_ALERT, payload: { type: 'error', message: error.message } });
    }
};

export { fetchStatistics };