export const BASE_URL = 'http://localhost:7000/api';
export const HOME = '';
export const TECHNICIAN = 'technician';
export const REPAIRS = 'reparations';
export const RECEPTIONIST = 'receptionist';
export const CUSTOMERS = 'customers';
export const MANAGER = 'manager';
export const DASHBOARD = 'dashboard';
export const TECHNICIANS = 'technicians';
export const RECEPTIONISTS = 'receptionists';
export const MANAGERS = 'managers';

export const routes = [
    { name: 'Home', path: HOME },
    {
        name: 'Receptionist', path: RECEPTIONIST, children: [
            { name: 'Customers', path: CUSTOMERS },
            { name: 'Repairs', path: REPAIRS },
        ],
    },
    {
        name: 'Technician', path: TECHNICIAN, children: [
            { name: 'Repairs', path: REPAIRS },
        ],
    },
    {
        name: 'Manager', path: MANAGER, children: [
            { name: 'Dashboard', path: DASHBOARD },
            { name: 'Customers', path: CUSTOMERS },
            { name: 'Repairs', path: CUSTOMERS },
            { name: 'Technicians', path: TECHNICIANS },
            { name: 'Receptionists', path: RECEPTIONISTS },
            { name: 'Manager', path: MANAGERS },
        ],
    },
];
