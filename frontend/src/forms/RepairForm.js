import React, { useContext, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { CheckIcon, XCircleIcon, XMarkIcon } from '@heroicons/react/24/solid';
import { GlobalStateContext } from '../providers/GlobalState';
import CustomSelect from '../components/CustomSelect';

const RepairForm = ({ selectedRepair, setSelectedRepair, onClose }) => {
    const { state, dispatch, addRepair, updateRepair } = useContext(GlobalStateContext);
    const { customers, receptionists, brands, categories } = state;
    const {
        register, control, handleSubmit, watch, formState: { errors }, setValue,
    } = useForm();

    const brandOptions = brands.map(brand => ({ value: brand.name, label: brand.name }));
    const categoryOptions = categories.map(category => ({ value: category.name, label: category.name }));

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

        if (new Date(selectedRepair?.dateModified).toString() !== 'Invalid Date') {
            setValue('dateModified', formatDate(selectedRepair.dateModified));
        } else {
            setValue('dateModified', formattedNow());
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

            // Object properties
            setValue('object.brand.name', selectedRepair.object?.brand?.name || '');
            setValue('object.category.name', selectedRepair.object?.category?.name || '');
            setValue('object.customerId', selectedRepair.object?.customerId || '');
            setValue('object.faultDesc', selectedRepair.object?.faultDesc || '');
            setValue('object.id', selectedRepair.object?.id || '');
            setValue('object.location', selectedRepair.object?.location || 'in_stock');
            setValue('object.name', selectedRepair.object?.name || '');
            setValue('object.remark', selectedRepair.object?.remark || '');
            setValue('object.serialNo', selectedRepair.object?.serialNo || '');
        }
    }, [selectedRepair, setValue]);

    const onSubmit = (data) => {
        data.dateCreated = new Date(data.dateCreated).toISOString().split('.')[0] + 'Z';
        data.dateModified = new Date(data.dateModified).toISOString().split('.')[0] + 'Z';
        console.log("Adding repair", data);
        if (selectedRepair && selectedRepair.id) {
            updateRepair(dispatch, { ...selectedRepair, ...data });
        } else {
            addRepair(dispatch, data);
        }
    };

    const resetForm = () => {
        setSelectedRepair({
            object: {},
        });
    }

    const formatDate = (date) => {
        return date.slice(0, 16);
    };

    return (<form onSubmit={handleSubmit(onSubmit)}>
        {selectedRepair && selectedRepair.id && <h2>Details for repair #{selectedRepair.id}</h2>}
        <input type="hidden" {...register('id')} />
        <input type="hidden" {...register('objectId')} />

        <div className="col-1">
            <div className="row">
                <div className="item">
                    <label>Date created</label>
                    <input type="datetime-local" {...register('dateCreated')} />
                </div>
                <div className="item">
                    <label>Date modified</label>
                    <input type="datetime-local" {...register('dateModified')} />
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Customer</label>
                    <input {...register('customer_id', { required: true })} />
                </div>
                <div className="item">
                    <label>Receptionist</label>
                    <input {...register('receptionist_id', { required: true })} />
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Object Name</label>
                    <input {...register('object.name', { required: true })} />
                </div>
                <div className="item">
                    <label>Object Serial Number</label>
                    <input {...register('object.serialNo')} />
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Object Brand</label>
                    <CustomSelect control={control} name="object.brand.name" options={brandOptions} defaultValue={{ label: selectedRepair?.object?.brand?.name, value: selectedRepair?.object?.brand?.name }} />
                </div>
                <div className="item">
                    <label>Object Category</label>
                    <CustomSelect control={control} name="object.category.name" options={categoryOptions} defaultValue={{ label: selectedRepair?.object?.category?.name, value: selectedRepair?.object?.category?.name }} />                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Object Fault Description</label>
                    <input {...register('object.faultDesc', { required: true })} />
                </div>
                <div className="item">
                    <label>Object Location</label>
                    <select {...register('object.location', { required: true })}>
                        <option value="in_stock">In Stock</option>
                        <option value="for_sale">For Sale</option>
                        <option value="returned">Returned</option>
                        <option value="sold">Sold</option>
                    </select>
                </div>
            </div>
        </div>

        <div className="col-2">
            <div className="row">
                <div className="item">
                    <label>Reparation state</label>
                    <select {...register('reparationState', { required: true })}>
                        <option value="waiting">Waiting</option>
                        <option value="ongoing">Ongoing</option>
                        <option value="done">Done</option>
                        <option value="abandoned">Abandoned</option>
                    </select>
                </div>
                <div className="item">
                    <label>Quote state</label>
                    <select {...register('quoteState', { required: true })}>
                        <option value="accepted">Accepted</option>
                        <option value="declined">Declined</option>
                        <option value="waiting">Waiting</option>
                    </select>
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Quote</label>
                    <input type="number" {...register('quote')} />
                    {errors.quote && <span>This field is required</span>}
                </div>
                <div className="item">
                    <label>Estimated duration</label>
                    <input type="time" {...register('estimatedDuration', { required: true })} />
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Description</label>
                    <textarea {...register('description', { required: true })} rows={5} />
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Object Remark</label>
                    <textarea {...register('object.remark')} />
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

export default RepairForm;