import React, { createContext, useState, useContext } from 'react';

const GlobalErrorContext = createContext();

export const GlobalErrorProvider = ({ children }) => {
    const [error, setError] = useState(null);

    const setGlobalError = (err) => {
        setError(err);
    };

    const clearGlobalError = () => {
        setError(null);
    };

    return (
        <GlobalErrorContext.Provider value={{ error, setGlobalError, clearGlobalError }}>
            {children}
        </GlobalErrorContext.Provider>
    );
};

export const useGlobalError = () => useContext(GlobalErrorContext);