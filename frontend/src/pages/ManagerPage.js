import React, {useState} from 'react';
import SubNavigation from "../SubNavigation";
import CollaboratorsSubPage from "./CollaboratorsSubPage";

const items = [{text: 'Collaborators', link: '/collaborators'},];

const ManagerPage = () => {
    const [subPage, setSubPage] = useState('');

    const renderSubPage = () => {
        switch (subPage) {
            case 'collaborators':
            default:
                return <CollaboratorsSubPage/>;
        }
    }

    return (
        <>
            <SubNavigation items={items} setSubPage={setSubPage}/>
            {renderSubPage()}
        </>
    );
}

export default ManagerPage;