import HomePage from './pages/HomePage';
import ReceptionistPage from './pages/ReceptionistPage';
import ManagerPage from './pages/ManagerPage';
import CollaboratorsPage from './pages/CollaboratorsPage';
import TechnicianPage from './pages/TechnicianPage';

export const BASE_URL = 'http://localhost:7000/api';
export const HOME = '/';
export const DASHBOARD = '/dashboard';
export const RECEPTIONIST = '/receptionist';
export const MANAGER = '/manager';
export const COLLABORATORS = '/manager/collaborators';
export const TECHNICIAN = '/technician';


const routesMap = [
    { name: 'Home', path: HOME, element: <HomePage /> },
    { name: 'Dashboard', path: DASHBOARD, element: <HomePage /> },
    { name: 'Receptionist', path: RECEPTIONIST, element: <ReceptionistPage /> },
    {
        name: 'Manager', path: MANAGER, element: <ManagerPage />, children: [
            { name: 'Collaborators', path: COLLABORATORS, element: <CollaboratorsPage /> },
        ],
    },
    { name: 'Technician', path: TECHNICIAN, element: <TechnicianPage /> },
];

export const routes = routesMap.map((route) => {
    return {
        path: route.path,
        element: route.element,
        children: route.children ? route.children.map((child) => {
            return {
                path: child.path,
                element: child.element,
            };
        }) : null,
    };
});