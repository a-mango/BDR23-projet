import React from 'react';
import { WrenchIcon } from '@heroicons/react/24/solid';
import { Link } from 'react-router-dom';

/**
 * Link component. Displays a link.
 * @param text
 * @param link
 * @returns {Element}
 * @constructor
 */
const Item = ({ text, link }) => {
    return (<li>
            <Link className="text-black hover:text-black hover:underline" to={link}>{text}</Link>
        </li>);
};

/**
 * Nav component. Displays a navigation bar.
 *
 * @returns {Element} The navigation bar component.
 */
const Nav = () => {
    return (<nav className="w-full mx-auto bg-atomic-tangerine py-4 border-amber-500 text-xl">
            <ul className="flex space-x-10 px-10">
                <WrenchIcon className="h-8 w-8 text-gray-800 hover:text-black" />
                <Item text="Home" link="/" />
                <Item text="Receptionist" link="/receptionist" />
                <Item text="Technician" link="/technician" />
                <Item text="Manager" link="/manager" />
            </ul>
        </nav>);
};

export default Nav;