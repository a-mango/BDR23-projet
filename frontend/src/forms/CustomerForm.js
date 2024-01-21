import React, { useContext, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { CheckIcon, XCircleIcon, XMarkIcon } from '@heroicons/react/24/solid';
import { GlobalStateContext } from '../providers/GlobalState';

/**
 * Customer form component.
 *
 * @param selectedCustomer The customer to edit.
 * @param setSelectedCustomer The function to set the selected customer.
 * @param onClose The function to close the form.
 * @returns {Element} The customer form.
 */
const CustomerForm = ({ selectedCustomer, setSelectedCustomer, onClose }) => {
    const { dispatch, addCustomer, updateCustomer } = useContext(GlobalStateContext);
    const {
        register, handleSubmit, formState: { errors }, setValue,
    } = useForm();

    useEffect(() => {
        if (selectedCustomer) {
            setValue('id', selectedCustomer.id || '');
            setValue('name', selectedCustomer.name || '');
            setValue('phoneNumber', selectedCustomer.phoneNumber || '');
            setValue('tosAccepted', selectedCustomer.tosAccepted || false);
            setValue('comment', selectedCustomer.comment || '');
            setValue('privateNote', selectedCustomer.privateNote || '');
        }
    }, [
        selectedCustomer,
        setValue,
    ]);

    const onSubmit = async (data) => {
        data.phoneNumber = data.phoneNumber.replace(/\s/g, '');
        data.tosAccepted = data.tosAccepted === 'on' || data.tosAccepted === true;
        if (selectedCustomer && selectedCustomer.id) {
            updateCustomer(dispatch, { ...selectedCustomer, ...data });
        } else {
            selectedCustomer.id = await addCustomer(dispatch, data);
        }
    };

    const resetForm = () => {
        setSelectedCustomer({});
    };

    return (<form onSubmit={handleSubmit(onSubmit)}>
        {selectedCustomer && selectedCustomer.id && <h2>Details for customer #{selectedCustomer.id}</h2>}
        <input type="hidden" {...register('id')} />

        <div className="col-1">
            <div className="row">
                <div className="item">
                    <label>Name</label>
                    <input {...register('name', { required: true })} />
                    {errors.name && <span>This field is required</span>}
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Phone</label>
                    <input {...register('phoneNumber', { required: true })} />
                    {errors.phone && <span>This field is required</span>}
                </div>
            </div>
            <div className="row">
                <div className="item form-tos">
                    <label>TOS Accepted</label>
                    <input type="checkbox" {...register('tosAccepted', { required: true })} />
                </div>
            </div>
        </div>

        <div className="col-2">
            <div className="row">
                <div className="item">
                    <label>Comment</label>
                    <textarea {...register('comment')} />
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Private Note</label>
                    <textarea {...register('privateNote')} />
                </div>
            </div>
        </div>

        <div className="form-controls">
            <button type="submit">Submit<CheckIcon className="h-5 w-5" /></button>
            <button type="reset" onClick={resetForm}>Reset<XMarkIcon className="h-5 w-5" /></button>
            <button type="button" onClick={onClose}>Close<XCircleIcon className="h-5 w-5" /></button>
        </div>
    </form>);
};

export default CustomerForm;