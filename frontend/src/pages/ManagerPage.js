import React, {useState} from 'react';
import SubNavigation from "../components/SubNavigation";
import CollaboratorsPage from "./CollaboratorsPage";

const items = [
    {text: 'Collaborators', link: 'collaborators'},
    {text: 'Collaborator Form', link: 'collaborator'},
];

const ManagerPage = () => {
    const [subPage, setSubPage] = useState('');

    const renderSubPage = () => {
        switch (subPage) {
            case 'collaborators':
            default:
                return <CollaboratorsPage/>;
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