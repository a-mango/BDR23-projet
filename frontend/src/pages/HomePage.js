import React, { useContext } from 'react';
import Page from '../components/Page';
import Title from '../components/Title';
import { GlobalStateContext } from '../providers/GlobalState';
import BarChart from '../components/BarChart';
import PieChart from '../components/PieChart';

/**
 * Home page component.
 *
 * @returns {Element} The home page.
 */
const HomePage = () => {
    const { state } = useContext(GlobalStateContext);

    return (<Page>
        <Title title={'Dashboard'} />
        <div className="stats-container">
            {state.statistics && Object.keys(state.statistics).length > 0 ? (
                Object.entries(state.statistics).map(([key, statistic]) => (
                    statistic.type === 'Bar' ?
                        <BarChart key={key} title={statistic.name} data={statistic.data} />
                    : statistic.type === 'Pie' ?
                        <PieChart key={key} title={statistic.name} data={statistic.data} /> : null)))
                    : (<p>No statistics found.</p>)
            }
        </div>
    </Page>);
};

export default HomePage;