import React from 'react';
import Select, {
  components,
} from "react-select";
import { Controller } from 'react-hook-form';
import { ChevronDownIcon } from '@heroicons/react/24/outline';

const DropdownIndicator = (props) => {
  return (
    <components.DropdownIndicator {...props}>
      <ChevronDownIcon className="w-4 h-4" />
    </components.DropdownIndicator>
  );
};

const CustomSelect = ({ control, name, options, defaultValue, ...rest }) => (
    <Controller
        control={control}
        name={name}
        render={({ field }) => (
            <Select
                components={{ DropdownIndicator }}
                {...field}
                options={options}
                value={defaultValue}
                isSearchable
                isClearable
                styles={{
                    control: (base) => ({
                        ...base,
                        borderRadius: '0',
                        display: 'flex',
                        flexDirection: 'row',
                    }),
                    option: (base, { isFocused, isSelected }) => ({
                        ...base,
                        backgroundColor: isSelected
                            ? 'lightgray'
                            : isFocused
                            ? 'lightblue'
                            : 'white',
                    }),
                }}
                className="select-custom"
                {...rest}
            />
        )}
    />
);

export default CustomSelect;