import React from 'react';
import CustomersPage from "./CustomersPage";
import CustomerPage from "./CustomerPage";
import RepairPage from "./RepairPage";
import RepairsPage from "./RepairsPage";
import SubPage from "../components/SubPage";


class ReceptionistPage extends SubPage {
    items() {
        return [
            {text: 'Repairs', link: 'repairs'},
            {text: 'Customers', link: 'customers'},
            {text: 'Customer Form', link: 'customer'},
            {text: 'Repair Form', link: 'repair'},
        ];
    }

    renderSubPage() {
        switch (this.state.subPage) {
            case 'customer':
                return <CustomerPage/>;
            case 'customers':
                return <CustomersPage/>;
            case 'repairs':
                return <RepairsPage/>;
            case 'repair':
                return <RepairPage/>;
            default:
                return null;
        }
    }
}

export default ReceptionistPage;