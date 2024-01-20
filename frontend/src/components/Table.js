import React from 'react';
import { TrashIcon } from '@heroicons/react/24/outline';

const Table = ({data, onRowClick, onDeleteClick}) => {
    return (<table className="table-auto w-full">
        <thead>
        <tr>
            {Object.keys(data[0]).map((key, index) => (<th key={index} className="px-4 py-2">{key}</th>))}
            <th className="px-4 py-2">Actions</th>
        </tr>
        </thead>
        <tbody>
        {data.map((row, index) => (
            <tr key={index} onClick={() => onRowClick(row)}
                className={`cursor-pointer hover:bg-apache ${index % 2 === 0 ? 'bg-gray-200' : ''}`}>
                {Object.values(row).map((cell, index) => (<td key={index} className="border px-4 py-2">{cell}</td>))}
                <td className="border min-h-20 px-4 py-2 grid place-items-center">
                    <TrashIcon onClick={() => onDeleteClick(row)} className="h-5 w-5 text-red-500" />
                </td>
            </tr>
        ))}
        </tbody>
    </table>);
};

export default Table;