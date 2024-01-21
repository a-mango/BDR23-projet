import React from 'react';
import { Controller } from 'react-hook-form';

const CustomSelect = ({ control, name, options, ...rest }) => (
    <Controller
        control={control}
        name={name}
        render={({ field }) => (
            <select {...field} {...rest}>
                {options.map((option, index) => (
                    <option key={index} value={option.value}>
                        {option.label}
                    </option>
                ))}
            </select>
        )}
    />
);

export default CustomSelect;