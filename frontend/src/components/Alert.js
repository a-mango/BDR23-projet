import React, { useContext, useEffect } from 'react';
import { GlobalStateContext } from '../providers/GlobalState';
import { CheckIcon, ExclamationTriangleIcon } from '@heroicons/react/24/outline';

const Alert = ({ type, message }) => {
    const { dispatch } = useContext(GlobalStateContext);

    useEffect(() => {
        const timer = setTimeout(() => {
            // clear the alert after 10 seconds
            dispatch({ type: 'CLEAR_ALERT' });
        }, 10000);

        return () => clearTimeout(timer);
    }, [dispatch]);

    return (
        <div className={`alert alert-${type === 'error' ? 'error' : 'success'}`}>
            <div className="icon">
                {type === 'error' ? <ExclamationTriangleIcon className="w-6 h-6" /> : <CheckIcon className="w-6 h-6" />}
            </div>
            <div className="message">
                {message}
            </div>
        </div>
    );
};

export default Alert;