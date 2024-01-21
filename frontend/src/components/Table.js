import React from 'react';
import { TrashIcon } from '@heroicons/react/24/outline';

const Table = ({ data, onRowClick, onDeleteClick }) => {
    const onDelete = (event, row) => {
        event.stopPropagation();
        onDeleteClick(row);
    };

    const formatHeader = (header) => {
        return header.split(/(?=[A-Z])/).map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
    };

    const flattenArray = (array) => {
        if (array === null) {
            return '';
        } else if (Array.isArray(array)) {
            return array.map(flattenArray).join(', ');
        } else if (typeof array === 'object') {
            return Object.values(array).map(flattenArray).join(', ');
        }

        return array;
    }

    const sortedData = [...data].sort((a, b) => a.id - b.id);


    return (<table className="table-auto w-full">
        <thead>
        <tr>
            {Object.keys(sortedData[0]).map((key, index) => (
                <th key={index} className="px-4 py-2">{formatHeader(key)}</th>))}
            <th className="px-4 py-2">Actions</th>
        </tr>
        </thead>
        <tbody>
            {sortedData.map((row, index) => (
                <tr key={index} onClick={() => onRowClick(row)}
                    className={`cursor-pointer hover:bg-apache ${index % 2 === 0 ? 'bg-gray-200' : ''}`}>
                    {Object.values(row).map((cell, index) => (
                        <td key={index} className="border px-4 py-2">
                            {Array.isArray(cell) ? flattenArray(cell) : cell}
                        </td>
                    ))}
                    <td className="h-20 px-4 py-2 grid place-items-center">
                        <TrashIcon onClick={(event) => onDelete(event, row)} className="h-5 w-5 text-red-500" />
                    </td>
                </tr>
            ))}
        </tbody>
    </table>);
};

export default Table;