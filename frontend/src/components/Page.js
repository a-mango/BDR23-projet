import React, { useEffect } from 'react';
import SubNavigation from './SubNavigation';
import { useGlobalError } from '../GlobalErrorProvider';

const Page = ({ title, children }) => {
    const { error, clearGlobalError } = useGlobalError();

    useEffect(() => {
        if (error) {
            const timer = setTimeout(() => {
                clearGlobalError();
            }, 10000);

            return () => clearTimeout(timer);
        }
    }, [error, clearGlobalError]);

    return (<>
            <SubNavigation />
            <main className="container mx-auto">
                {error.message &&
                    <div className={`${error.type === 'error' ? 'error' : 'success'}`}>{error.message}</div>}
                <h1>{title}</h1>
                {children}
            </main>
        </>);
};

export default Page;