export const BASE_URL = 'http://localhost:7000/api';
export const HOME = '';
export const DASHBOARD = 'dashboard';
export const RECEPTIONIST = 'receptionist';
export const CUSTOMERS = 'customers';
export const MANAGER = 'manager';
export const COLLABORATORS = 'collaborators';
export const TECHNICIAN = 'technician';
export const REPAIRS = 'repairs';


export const routes = [
    { name: 'Home', path: HOME },
    {
        name: 'Receptionist', path: RECEPTIONIST, children: [
            { name: 'Customers', path: CUSTOMERS },
            { name: 'Repairs', path: CUSTOMERS },
        ],
    },
    {
        name: 'Manager', path: MANAGER, children: [
            { name: 'Dashboard', path: DASHBOARD },
            { name: 'Customers', path: CUSTOMERS },
            { name: 'Repairs', path: CUSTOMERS },
            { name: 'Collaborators', path: COLLABORATORS },
        ],
    },
    {
        name: 'Technician', path: TECHNICIAN, children: [
            { name: 'Repairs', path: COLLABORATORS },
        ],
    },
];
