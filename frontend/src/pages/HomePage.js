import React from 'react';
import Page from "../components/Page";
import Title from '../components/Title';
import FakeBarChart from '../components/FakeBarChart';

const HomePage = () => {
    return (
        <Page>
            <Title title={"Dashboard"} />
            <div className="stats-container">
                <FakeBarChart />
                <FakeBarChart />
            </div>
        </Page>
    );
};

export default HomePage;