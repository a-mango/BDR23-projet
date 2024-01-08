import React from 'react';

const Link = ({text, link}) => {
    return (
        <li>
            <a className="text-gray-800 hover:text-black" href={link}>{text}</a>
        </li>
    )
}

const Navigation = () => {
    return (
        <nav className="py-4 bg-amber-300 border-b border-amber-500 text-xl">
            <ul className="flex space-x-10 px-10">
                <Link text="Dashboard" link="/dashboard"/>
                <Link text="Receptionist" link="/receptionist"/>
                <Link text="Technician" link="/technician"/>
                <Link text="Manager" link="/manager"/>
            </ul>
        </nav>
    )
}

export default Navigation;