import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { routes } from '../config/routes';

/**
 * Sub navigation component.
 *
 * @returns {React.JSX.Element|null} The sub navigation component if the current path is valid, null otherwise.
 */
const SubNav = () => {
    const { pathname } = useLocation();
    const currentPath = pathname.split('/')[1] || null;
    const items = routes.filter(route => route.path === currentPath)[0]?.children || [];

    if (currentPath === null) {
        return null;
    }

    return (<>
        <nav className="py-4 bg-apache text-xl">
            <ul className="flex space-x-10 px-10">
                {items.map((item, index) => (<li key={index}>
                    <Link
                        className="text-white hover:underline"
                        to={`/${currentPath}/${item.path}`}
                    >
                        {item.name}
                    </Link>
                </li>))}
            </ul>
        </nav>
    </>);
};

export default SubNav;