import React from 'react';

const SubNavigation = ({ items, setSubPage }) => {
    return (
        <nav className="py-4 bg-purple-300 border-b border-purple-600 text-xl">
            <ul className="flex space-x-10 px-10">
                {items.map((item, index) => (
                    <li key={index}>
                        <a
                            className="text-gray-800 hover:text-black"
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