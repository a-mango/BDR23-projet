import React, { useContext, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { CheckIcon, XMarkIcon } from '@heroicons/react/24/solid';
import { GlobalStateContext } from '../GlobalState';

const CustomerForm = ({ selectedCustomer }) => {
    const { dispatch, addCustomer, updateCustomer } = useContext(GlobalStateContext);
    const {
        register,
        handleSubmit,
        watch,
        formState: { errors },
        setValue,
    } = useForm();

    useEffect(() => {
        if (selectedCustomer) {
            setValue('id', selectedCustomer.id);
            setValue('name', selectedCustomer.name);
            setValue('phoneNumber', selectedCustomer.phoneNumber);
            setValue('tosAccepted', selectedCustomer.tosAccepted);
            setValue('comment', selectedCustomer.comment);
            setValue('privateNote', selectedCustomer.privateNote);
        }
    }, [selectedCustomer, setValue]);

    const onSubmit = (data) => {
        data.phoneNumber = data.phoneNumber.replace(/\s/g, '');
        if (selectedCustomer && selectedCustomer.id) {
            updateCustomer(dispatch, { ...selectedCustomer, ...data });
        } else {
            addCustomer(dispatch, data);
        }
    };

    return (
        <form onSubmit={handleSubmit(onSubmit)}>
            {selectedCustomer && selectedCustomer.personId &&
                <h2>Details for customer #{selectedCustomer.personId}</h2>}
            <div>
                <div>
                    <label>Name</label>
                    <input {...register('name', { required: true })} />
                    {errors.name && <span>This field is required</span>}
                </div>

                <div>
                    <label>Phone</label>
                    <input {...register('phoneNumber', { required: true })} />
                    {errors.phone && <span>This field is required</span>}
                </div>
                <div className="form-tos">
                    <label>TOS Accepted</label>
                    <input type="checkbox" {...register('tosAccepted', { required: true })} />
                </div>
            </div>

            <div>
                <div>
                    <label>Comment</label>
                    <textarea {...register('comment')} />
                </div>
                <div>
                    <label>Private Note</label>
                    <textarea {...register('privateNote')} />
                </div>
            </div>
            <div className="form-controls">
                <button type="submit">Submit<CheckIcon className="h-5 w-5" /></button>
                <button type="reset">Reset<XMarkIcon className="h-5 w-5" /></button>
            </div>
        </form>
    );
};

export default CustomerForm;