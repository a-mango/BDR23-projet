import React from 'react';
import { TrashIcon } from '@heroicons/react/24/outline';

/**
 * Table component. Displays a table with the given data.
 *
 * @param data The data to display.
 * @param onRowClick The action to perform when a row is clicked. Defaults to no action.
 * @param onDeleteClick The action to perform when the delete icon is clicked. Default to no action.
 * @param hideDelete Whether to hide the delete column.
 * @returns {Element} The table component.
 */
const Table = ({
    data,
    onRowClick = () => {},
    onDeleteClick = () => {},
    hideDelete,
}) => {
    const onDelete = (event, row) => {
        event.stopPropagation();
        onDeleteClick(row);
    };

    const formatHeader = (header) => {
        return header.split(/(?=[A-Z])/).map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
    };

    const formatCell = (array) => {
        if (array === null) {
            return '';
        } else if (Array.isArray(array)) {
            return array.map(formatCell).join(', ');
        } else if (typeof array === 'object') {
            return Object.values(array).map(formatCell).join(', ');
        } else if (!isNaN(Date.parse(array))) {
            const date = new Date(array);
            return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
        }

        return array;
    };

    const sortedData = [...data].sort((a, b) => a.id + b.id);

    if (sortedData.length === 0) {
        return <></>;
    }

    return (<table className="table-auto w-full">
        <thead>
        <tr>
            {Object.keys(sortedData[0]).map((key, index) => (
                <th key={index} className="px-4 py-2">{formatHeader(key)}</th>))}
            {!hideDelete && <th className="px-4 py-2">Delete</th>}
        </tr>
        </thead>
        <tbody>
        {sortedData.map((row, index) => (<tr key={index} onClick={() => onRowClick(row.id)}
                                             className={`cursor-pointer hover:bg-apache ${index % 2 === 0 ?
                                                                                          'bg-gray-200' : ''}`}>
            {Object.values(row).map((cell, index) => (<td key={index} className="border px-4 py-2">
                {formatCell(cell)}
            </td>))}
            {!hideDelete && (<td className="h-20 px-4 py-2 grid place-items-center">
                <TrashIcon onClick={(event) => onDelete(event, row)} className="h-5 w-5 text-red-500" />
            </td>)}
        </tr>))}
        </tbody>
    </table>);
};

export default Table;