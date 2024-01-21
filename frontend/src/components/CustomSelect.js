import React from 'react';
import Select, { components } from 'react-select';
import { Controller } from 'react-hook-form';
import { ChevronDownIcon } from '@heroicons/react/24/outline';

/**
 * Dropdown indicator component for react-select.
 *
 * @param props The props.
 * @returns {Element} The dropdown indicator component.
 */
const DropdownIndicator = (props) => {
    return (<components.DropdownIndicator {...props}>
        <ChevronDownIcon className="w-4 h-4" />
    </components.DropdownIndicator>);
};

/**
 * Custom select component.
 *
 * @param control The react-form-hook control.
 * @param name The name of the select.
 * @param options The options of the select.
 * @param defaultValue The default value of the select.
 * @param rest The rest of the props.
 * @returns {React.JSX.Element} The custom select component.
 */
const CustomSelect = ({ control, name, options, defaultValue, ...rest }) => (<Controller
    control={control}
    name={name}
    render={({ field }) => (<Select
        components={{ DropdownIndicator }}
        {...field}
        options={options}
        value={options.find(option => option.value === field.value)} // set value to current field value
        isSearchable
        isClearable
        styles={{
            control: (base) => ({
                ...base, borderRadius: '0', display: 'flex', flexDirection: 'row',
            }), option: (base, { isFocused, isSelected }) => ({
                ...base, backgroundColor: isSelected ? 'lightgray' : isFocused ? 'lightblue' : 'white',
            }),
        }}
        className="select-custom"
        {...rest}
    />)}
/>);

export default CustomSelect;