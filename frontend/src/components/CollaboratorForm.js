import React, { useContext, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { CheckIcon, XMarkIcon, XCircleIcon } from '@heroicons/react/24/solid';
import { GlobalStateContext } from '../GlobalState';

const CollaboratorForm = ({ selectedCollaborator, onClose }) => {
    const { dispatch, addCollaborator, updateCollaborator } = useContext(GlobalStateContext);
    const {
        register,
        handleSubmit,
        watch,
        formState: { errors },
        setValue,
    } = useForm();

    useEffect(() => {
        if (selectedCollaborator) {
            setValue('id', selectedCollaborator.id);
            setValue('name', selectedCollaborator.name);
            setValue('phoneNumber', selectedCollaborator.phoneNumber);
            setValue('comment', selectedCollaborator.comment);
            setValue('privateNote', selectedCollaborator.privateNote);
        }
    }, [selectedCollaborator, setValue]);

    const onSubmit = (data) => {
        data.phoneNumber = data.phoneNumber.replace(/\s/g, '');
        if (selectedCollaborator && selectedCollaborator.id) {
            updateCollaborator(dispatch, { ...selectedCollaborator, ...data });
        } else {
            addCollaborator(dispatch, data);
        }
    };

    return (
        <form onSubmit={handleSubmit(onSubmit)}>
            {selectedCollaborator && selectedCollaborator.personId &&
                <h2>Details for collaborator #{selectedCollaborator.personId}</h2>}
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
                <button type="button" onClick={onClose}>Close<XCircleIcon className="h-5 w-5" /></button>
            </div>
        </form>
    );
};

export default CollaboratorForm;