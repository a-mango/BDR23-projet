import React from 'react';
import Navigation from './Navigation';

const Layout = ({children}) => {
    return (
        <div className="flex flex-col min-h-screen">
            <header className="w-full mx-auto">
                <Navigation/>
            </header>
            <div className="container mx-auto flex-grow">
                <main>
                    {children}
                </main>
            </div>
            <footer className="w-full bg-gray-200 flex items-center justify-center">
                <p>(c) 2024</p>
            </footer>
        </div>
    );
};

export default Layout;