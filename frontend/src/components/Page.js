import React from 'react';

const Page = ({title, children}) => {
    return (
        <main className="w-10/12 mx-auto py-4">
            <h1 className="text-2xl">{title}</h1>
            {children}
        </main>
    );
};

export default Page;