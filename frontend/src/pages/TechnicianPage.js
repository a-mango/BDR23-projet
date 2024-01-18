import React, {useState} from 'react';
import SubNavigation from "../components/SubNavigation";
import CustomerPage from "./CustomerPage";
import CustomersPage from "./CustomersPage";
import RepairsPage from "./RepairsPage";
import RepairPage from "./RepairPage";

const items = [
    {text: 'Repairs', link: 'repairs'},
    {text: 'Repair Form', link: 'repair'},
];

const TechnicianPage = () => {
    const [subPage, setSubPage] = useState('');

    const renderSubPage = () => {
        switch (subPage) {
            case 'repair':
                return <RepairsPage/>;
            case 'repairs':
            default:
                return <RepairPage/>;
        }
    }

    return (
        <>
            <SubNavigation items={items} setSubPage={setSubPage}/>
            {renderSubPage()}
        </>
    );
}

export default TechnicianPage;