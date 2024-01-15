import React from 'react';
import Page from "../components/Page";
import Table from "../components/Table";

const HomePage = () => {
    const demoData = [
        {Name: 'John Doe', Age: 30, Occupation: 'Engineer'},
        {Name: 'Jane Doe', Age: 28, Occupation: 'Doctor'},
        {Name: 'Bob Smith', Age: 35, Occupation: 'Designer'},
    ];

    return (
        <Page title={"Demo page"}>
            <Table data={demoData} />
        </Page>
    );
};

export default HomePage;