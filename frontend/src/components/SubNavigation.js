import React from 'react';

const SubNavigation = ({ items, setSubPage }) => {
    return (
        <nav className="py-4 bg-gradient-to-r from-yellow-900 to-yellow-950 border-b text-xl">
            <ul className="flex space-x-10 px-10">
                {items.map((item, index) => (
                    <li key={index}>
                        <a
                            className="text-white hover:underline"
                            href={item.link}
                            onClick={(e) => {
                                e.preventDefault();
                                setSubPage(item.link);
                            }}
                        >
                            {item.text}
                        </a>
                    </li>
                ))}
            </ul>
        </nav>
    )
}

export default SubNavigation;