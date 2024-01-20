import React, { createContext, useState, useContext } from 'react';

const GlobalErrorContext = createContext();

export const GlobalErrorProvider = ({ children }) => {
    const [error, setError] = useState({ message: null, type: null });

    const setGlobalError = ({ message, type }) => {
        setError({ message, type });
    };

    const clearGlobalError = () => {
        setError({ message: null, type: null });
    };

    return (
        <GlobalErrorContext.Provider value={{ error, setGlobalError, clearGlobalError }}>
            {children}
        </GlobalErrorContext.Provider>
    );
};

export const useGlobalError = () => useContext(GlobalErrorContext);