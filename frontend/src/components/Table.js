import React from 'react';

const Table = ({data, onRowClick}) => {
    return (<table className="table-auto w-full">
        <thead>
        <tr>
            {Object.keys(data[0]).map((key, index) => (<th key={index} className="px-4 py-2">{key}</th>))}
        </tr>
        </thead>
        <tbody>
        {data.map((row, index) => (<tr key={index} onClick={() => onRowClick(row)} className={index % 2 === 0 ? 'bg-gray-200' : ''}>
            {Object.values(row).map((cell, index) => (<td key={index} className="border px-4 py-2">{cell}</td>))}
        </tr>))}
        </tbody>
    </table>);
};

export default Table;