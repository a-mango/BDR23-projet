import React, {useState} from 'react';
import SubNavigation from "../SubNavigation";
import CustomersPage from "./CustomersPage";

const items = [
    {text: 'Repairs', link: '/repairs'},
    {text: 'Customers', link: '/customers'},
    {text: 'New', link: '/newRepair'},
];

const ReceptionistPage = () => {
    const [subPage, setSubPage] = useState('');

    const renderSubPage = () => {
        switch (subPage) {
            case 'customers':
            default:
                return <CustomersPage/>;
        }
    }

    return (
        <>
            <SubNavigation items={items} setSubPage={setSubPage}/>
            {renderSubPage()}
        </>
    );
}

export default ReceptionistPage;