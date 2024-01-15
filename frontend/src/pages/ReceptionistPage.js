import React, {useState} from 'react';
import SubNavigation from "../SubNavigation";
import CollaboratorsSubPage from "./CollaboratorsSubPage";
import CustomersSubPage from "./CustomersSubPage";

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
                return <CustomersSubPage/>;
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