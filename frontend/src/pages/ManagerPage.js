import React from 'react';
import SubNavigation from "../SubNavigation";

const items = [
    {text: 'Collaborators', link: '/collaborators'},
];

const ManagerPage = () => {
    return (
        <>
            <SubNavigation items={items}/>
            <p>Hello Manager!</p>
        </>
    );
}

export default ManagerPage;