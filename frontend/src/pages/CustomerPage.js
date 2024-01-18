import React, { useEffect, useState } from 'react';
import useData from '../hooks/useData';
import Page from "../components/Page";
import CustomerForm from "../components/CustomerForm";

const CustomerPage = () => {
    return (
        <Page>
            <h2>Customer Form</h2>
            <CustomerForm />
        </Page>
    );
};

export default CustomerPage;