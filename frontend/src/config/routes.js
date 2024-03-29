/**
 * @fileoverview Routes configuration file.
 */

export const HOME = '';
export const TECHNICIAN = 'technician';
export const REPAIRS = 'reparations';
export const RECEPTIONIST = 'receptionist';
export const CUSTOMERS = 'customers';
export const MANAGER = 'manager';
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
            { name: 'Customers', path: CUSTOMERS },
            { name: 'Repairs', path: REPAIRS },
            { name: 'Technicians', path: TECHNICIANS },
            { name: 'Receptionists', path: RECEPTIONISTS },
            { name: 'Manager', path: MANAGERS },
        ],
    },
];
