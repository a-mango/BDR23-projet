import React from 'react';
import SubNavigation from "../SubNavigation";

const items = [
    {text: 'Repairs', link: '/repairs'},
    {text: 'Repair Form', link: '/repair'},
];

const TechnicianPage = () => {
    return (
        <>
            <SubNavigation items={items}/>
            <div className="container mx-auto flex-grow">
                <p>Hello Technician!</p>
            </div>
        </>
    );
}

export default TechnicianPage;