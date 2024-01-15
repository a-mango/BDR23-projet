import React from 'react';
import Navigation from '../Navigation';

const Layout = ({children}) => {
    return (
        <div className="flex flex-col min-h-screen justify-between bg-stone-100">
            <div>
                <header className="w-full mx-auto">
                    <Navigation/>
                </header>
                {children}
            </div>
            <footer className="w-full bg-gray-200 flex items-center justify-center">
                <p>(c) 2024</p>
            </footer>
        </div>
    );
};

export default Layout;