import React from 'react';

const Navigation = () => {
    return (
        <nav className="py-4 bg-amber-300 border-b border-amber-500 text-xl">
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
        </nav>
    )
}

export default Navigation;