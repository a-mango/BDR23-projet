import React from 'react';
import { PlusCircleIcon } from '@heroicons/react/24/outline';

const Title = ({ title, actionText, onAction }) => {
    return (
        <div className="title-container">
            <h1>{title}</h1>
            <button onClick={onAction}>
                <PlusCircleIcon className="h-8 w-8 text-white mr-2" />
                {actionText}</button>
        </div>
    );
};

export default Title;