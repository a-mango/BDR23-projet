import React, { useContext, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { CheckIcon, XCircleIcon, XMarkIcon } from '@heroicons/react/24/solid';
import { GlobalStateContext } from '../providers/GlobalState';

const ReceptionistForm = ({ selectedRepair, setSelectedRepair, onClose }) => {
    const { dispatch, addRepair, updateRepair } = useContext(GlobalStateContext);
    const {
        register, handleSubmit, watch, formState: { errors }, setValue,
    } = useForm();

    const formattedNow = () => {
        const now = new Date();
        return `${now.getFullYear()}-${String(now.getMonth() + 1)
            .padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}T${String(now.getHours())
            .padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
    };

    useEffect(() => {
        if (new Date(selectedRepair?.dateCreated).toString() !== 'Invalid Date') {
            setValue('dateCreated', formatDate(selectedRepair.dateCreated));
        } else {
            setValue('dateCreated', formattedNow());
        }

        if (selectedRepair) {
            setValue('id', selectedRepair.id || '');
            setValue('quote', selectedRepair.quote || '0');
            setValue('description', selectedRepair.description || '');
            setValue('estimatedDuration', selectedRepair.estimatedDuration || '00:00');
            setValue('reparationState', selectedRepair.reparationState || 'waiting');
            setValue('quoteState', selectedRepair.quoteState || 'waiting');
            setValue('receptionist_id', selectedRepair.receptionist_id || '');
            setValue('customer_id', selectedRepair.customer_id || '');
            setValue('object_id', selectedRepair.object_id || '');
        }
    }, [selectedRepair, setValue]);

    const onSubmit = (data) => {
        data.dateCreated = new Date(data.dateCreated).toISOString().split('.')[0] + 'Z';
        data.dateModified = new Date(data.dateModified).toISOString().split('.')[0] + 'Z';

        if (selectedRepair && selectedRepair.id) {
            updateRepair(dispatch, { ...selectedRepair, ...data });
        } else {
            addRepair(dispatch, data);
        }
    };

    const resetForm = () => {
        setSelectedRepair({});
    }

    const formatDate = (date) => {
        return date.slice(0, 16);
    };

    return (<form onSubmit={handleSubmit(onSubmit)}>
        {selectedRepair && selectedRepair.id && <h2>Details for repair #{selectedRepair.id}</h2>}
        <div className="col-1">
            <div className="row">
                <div>
                    <label>Date created</label>
                    <input type="datetime-local" {...register('dateCreated')} />
                </div>
                <div>
                    <label>Date modified</label>
                    <input type="datetime-local" {...register('dateModified')} />
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
                    <input type="time" {...register('estimatedDuration', { required: true })} />
                </div>
            </div>

            <div className="row">
                <div>
                    <label>Description</label>
                    <textarea {...register('description', { required: true })} rows={5} />
                </div>
            </div>
        </div>

        <div className="col-2">
            <div className="row">
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
                    <select {...register('quoteState', { required: true })}>
                        <option value="accepted">Accepted</option>
                        <option value="declined">Declined</option>
                        <option value="waiting">Waiting</option>
                    </select>
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

export default ReceptionistForm;