import React from 'react';
import SubNavigation from "../SubNavigation";

const items = [
    {text: 'Repairs', link: '/repairs'},
    {text: 'Customers', link: '/customers'},
    {text: 'New', link: '/newRepair'},
];

const ReceptionistPage = () => {
    return (
        <>
            <SubNavigation items={items}/>
            <p>Hello Receptionist!</p>
        </>
    );
}

export default ReceptionistPage;