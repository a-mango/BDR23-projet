import React from 'react';

const Layout = ({children}) => {
    return (
        <div className="flex flex-col min-h-screen">
            <div className="w-full bg-amber-300">
                <header className="mx-auto py-4 text-xl">
                    <ul className="flex space-x-10 px-10">
                        <li>
                            <a className="text-black hover:text-red-800" href="/dashboard">Dashboard</a>
                        </li>
                        <li>
                            <a className="text-black hover:text-red-800" href="/receptionist">Receptionist</a>
                        </li>
                        <li>
                            <a className="text-black hover:text-red-800" href="/technician">Technician</a>
                        </li>
                        <li>
                            <a className="text-black hover:text-red-800" href="/manager">Manager</a>
                        </li>
                    </ul>
                </header>
            </div>
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