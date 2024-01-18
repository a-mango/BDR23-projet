import React, {useState} from 'react';
import SubNavigation from "../SubNavigation";
import CustomersPage from "./CustomersPage";
import CustomerPage from "./CustomerPage";
import RepairPage from "./RepairPage";
import RepairsPage from "./RepairsPage";

const items = [
    {text: 'Repairs', link: 'repairs'},
    {text: 'Customers', link: 'customers'},
    {text: 'Customer Form', link: 'customer'},
    {text: 'Repair Form', link: 'repair'},
];

const ReceptionistPage = () => {
    const [subPage, setSubPage] = useState('');

    const renderSubPage = () => {
        console.log("Rendering " + subPage);
        switch (subPage) {
            case 'customer':
                return <CustomerPage/>;
            case 'customers':
                return <CustomersPage/>;
            case 'repairs':
                return <RepairsPage/>;
            case 'repair':
                return <RepairPage />;
            default:
                return null;
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