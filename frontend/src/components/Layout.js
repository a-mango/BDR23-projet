import React from 'react';
import Navigation from './Navigation';
import Footer from "./Footer";

const Layout = ({children}) => {
    return (
        <div className="flex flex-col min-h-screen justify-between bg-acoustic-white">
            <div>
                <Navigation/>
                {children}
            </div>
            <Footer />
        </div>
    );
};

export default Layout;