import React from 'react';
import { PlusCircleIcon } from '@heroicons/react/24/outline';

/**
 * Title component. Displays a title and an action button.
 *
 * @param title The title.
 * @param actionText The text of the action button.
 * @param onAction The action to perform when the action button is clicked.
 * @returns {Element} The title component.
 */
const Title = ({ title, actionText, onAction }) => {
    return (<div className="title-container">
            <h1>{title}</h1>
            {actionText && onAction && (<button onClick={onAction}>
                    <PlusCircleIcon className="h-8 w-8 text-white mr-2" />
                    {actionText}
                </button>)}
        </div>);
};

export default Title;