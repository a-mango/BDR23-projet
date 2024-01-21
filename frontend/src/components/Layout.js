import React from 'react';
import Nav from './Nav';
import Footer from "./Footer";

const Layout = ({children}) => {
    return (
        <div className="flex flex-col min-h-screen justify-between bg-acoustic-white">
            <div>
                <Nav/>
                {children}
            </div>
            <Footer />
        </div>
    );
};

export default Layout;