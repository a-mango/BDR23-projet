import React, { useContext, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { CheckIcon, XCircleIcon, XMarkIcon } from '@heroicons/react/24/solid';
import { GlobalStateContext } from '../GlobalState';

const RepairForm = ({ selectedRepair, onClose }) => {
    const { dispatch, addRepair, updateRepair } = useContext(GlobalStateContext);
    const {
        register, handleSubmit, watch, formState: { errors }, setValue,
    } = useForm();

    useEffect(() => {
        if (selectedRepair) {
            setValue('id', selectedRepair.id);
            setValue('dateCreated', selectedRepair.dateCreated);
            setValue('dateModified', selectedRepair.dateModified);
            setValue('quote', selectedRepair.quote);
            setValue('description', selectedRepair.description);
            setValue('estimatedDuration', selectedRepair.estimatedDuration);
            setValue('reparationState', selectedRepair.reparationState);
            setValue('quoteState', selectedRepair.quoteState);
            setValue('receptionist_id', selectedRepair.receptionist_id);
            setValue('customer_id', selectedRepair.customer_id);
            setValue('object_id', selectedRepair.object_id);
        }
    }, [selectedRepair, setValue]);

    const onSubmit = (data) => {
        console.log('Submit repair', data);
        if (selectedRepair && selectedRepair.id) {
            updateRepair(dispatch, { ...selectedRepair, ...data });
        } else {
            addRepair(dispatch, data);
        }
    };

    return (<form onSubmit={handleSubmit(onSubmit)}>
        {selectedRepair && selectedRepair.id && <h2>Details for repair #{selectedRepair.id}</h2>}
        <div className="col-1">
            <div className="row">
                <div>
                    <label>Date created</label>
                    <input {...register('dateCreated')} readOnly />
                </div>
                <div>
                    <label>Date modified</label>
                    <input {...register('dateModified')} readOnly />
                </div>
            </div>

            <div className="row">
                <div>
                    <label>Quote</label>
                    <input {...register('quote', { required: true })} />
                    {errors.quote && <span>This field is required</span>}
                </div>
                <div>
                    <label>Estimated duration</label>
                    <input type="number" {...register('estimatedDuration', { required: true })} />
                </div>
            </div>

            <div className="row">
                <label>Description</label>
                <textarea {...register('description', { required: true })} />
            </div>
        </div>

        <div className="col-2">
            <div>
                <label>Reparation state</label>
                <select {...register('reparationState', { required: true })}>
                    <option value="waiting">Waiting</option>
                    <option value="ongoing">Ongoing</option>
                    <option value="done">Done</option>
                    <option value="abandoned">Abandoned</option>
                </select>
            </div>
            <div>
                <label>Quote state</label>
                <select {...register('quoteState',{ required: true })}>
                    <option value="accepted">Accepted</option>
                    <option value="declined">Declined</option>
                    <option value="waiting">Waiting</option>
                </select>
            </div>
        </div>
        <div className="form-controls">
            <button type="submit">Submit<CheckIcon className="h-5 w-5" /></button>
            <button type="reset">Reset<XMarkIcon className="h-5 w-5" /></button>
            <button type="button" onClick={onClose}>Close<XCircleIcon className="h-5 w-5" /></button>
        </div>
    </form>);
};

export default RepairForm;