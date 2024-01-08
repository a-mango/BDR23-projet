import React from 'react';
import {BrowserRouter as Router, Route, Routes} from 'react-router-dom';
import Layout from './Layout';
import HomePage from './HomePage';

function App() {
    return (
        <Router>
            <Layout>
                <Routes>
                    <Route path="/" element={<HomePage/>}/>
                    {/*<Route path="/other" element={<OtherPage />} />*/}
                </Routes>
            </Layout>
        </Router>
    );
}

export default App;