import React, { useContext, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { CheckIcon, XCircleIcon, XMarkIcon } from '@heroicons/react/24/solid';
import { GlobalStateContext } from '../providers/GlobalState';
import CustomSelect from '../components/CustomSelect';
import Table from '../components/Table';

const RepairForm = ({ selectedRepair, setSelectedRepair, onClose }) => {
    const { state, dispatch, addRepair, updateRepair } = useContext(GlobalStateContext);
    const { customers, receptionists, brands, categories } = state;
    const {
        register, control, handleSubmit, watch, formState: { errors }, setValue,
    } = useForm();

    const customerOptions = customers.map(customer => ({ value: customer.id, label: customer.name }));
    const receptionistOptions = receptionists.map(receptionist => ({ value: receptionist.id, label: receptionist.name }));
    const brandOptions = brands.map(brand => ({ value: brand.name, label: brand.name }));
    const categoryOptions = categories.map(category => ({ value: category.name, label: category.name }));
    const objectLocationOptions = [
        { value: 'in_stock', label: 'In Stock' },
        { value: 'for_sale', label: 'For Sale' },
        { value: 'returned', label: 'Returned' },
        { value: 'sold', label: 'Sold' },
    ];
    const reparationStateOptions = [
        { value: 'waiting', label: 'Waiting' },
        { value: 'ongoing', label: 'Ongoing' },
        { value: 'done', label: 'Done' },
        { value: 'abandoned', label: 'Abandoned' },
    ];
    const quoteStateOptions = [
        { value: 'accepted', label: 'Accepted' },
        { value: 'declined', label: 'Declined' },
        { value: 'waiting', label: 'Waiting' },
    ];

    const formattedNow = () => {
        const now = new Date();
        return `${now.getFullYear()}-${String(now.getMonth() + 1)
            .padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}T${String(now.getHours())
            .padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
    };

    const filterSmsColumns = (data) => {
        if (!data) {
            return [];
        }
        return data.map((row) => { return { message: row.message }; });
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
        console.log("Repair before transformation", data);

        data.object.id = data.object.objectId;
        delete data.object.objectId;
        delete data.objectId;

        data.dateCreated = new Date(data.dateCreated);
        data.dateModified = new Date(data.dateModified);


        // Un-nest enum properties where needed.
        data.receptionist_id = data?.receptionist_id?.value || data?.receptionist_id;
        data.customer_id = data?.customer_id?.value || data?.customer_id;
        data.quoteState = data?.quoteState?.value || data?.quoteState;
        data.reparationState = data?.reparationState?.value || data?.reparationState;
        data.object.location = data?.object?.location.value;
        const brandValue = data?.object?.brand?.name?.value || data?.object?.brand?.name;
        const categoryValue = data?.object?.category?.name?.value || data?.object?.category?.name;
        data.object.brand = { "name": brandValue };
        data.object.category = { "name": categoryValue };

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
            sms: [],
        });
    }

    const formatDate = (date) => {
        return date.slice(0, 16);
    };

    return (<form onSubmit={handleSubmit(onSubmit)}>
        {selectedRepair && selectedRepair.id && <h2>Details for repair #{selectedRepair.id}</h2>}
        <input type="hidden" {...register('id')} />
        <input type="hidden" {...register('object_id')} />

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
                    <CustomSelect control={control} name="customer_id" options={customerOptions}
                                  defaultValue={customerOptions.find(customer => customer.value === selectedRepair?.customer_id)} />
                </div>
                <div className="item">
                    <label>Receptionist</label>
                    <CustomSelect control={control} name="receptionist_id" options={receptionistOptions}
                                  defaultValue={receptionistOptions.find(receptionist => receptionist.value === selectedRepair?.receptionist_id)} />
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
                    <CustomSelect control={control} name="object.brand.name" options={brandOptions}
                                  defaultValue={brandOptions.find(option => option.value === selectedRepair?.object?.brand?.name)} />
                </div>
                <div className="item">
                    <label>Object Category</label>
                    <CustomSelect control={control} name="object.category.name" options={categoryOptions}
                                  defaultValue={categoryOptions.find(option => option.value === selectedRepair?.object?.category?.name)} />
                </div>
            </div>
            <div className="row">
                <div className="item">
                    <label>Object Fault Description</label>
                    <input {...register('object.faultDesc', { required: true })} />
                </div>
                <div className="item">
                    <label>Object Location</label>
                    <CustomSelect control={control} name="object.location" options={objectLocationOptions}
                                  defaultValue={objectLocationOptions.find(option => option.value === selectedRepair?.object?.location)} />
                </div>
            </div>
        </div>

        <div className="col-2">
            <div className="row">
                <div className="item">
                    <label>Reparation state</label>
                    <CustomSelect control={control} name="reparationState" options={reparationStateOptions}
                                  defaultValue={reparationStateOptions.find(option => option.value === selectedRepair?.reparationState)} />
                </div>
                <div className="item">
                    <label>Quote state</label>
                    <CustomSelect control={control} name="quoteState" options={quoteStateOptions}
                                  defaultValue={quoteStateOptions.find(option => option.value === selectedRepair?.quoteState)} />
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

        <div className="form-messages">
            <Table data={filterSmsColumns(selectedRepair?.sms || [])} hideDelete={true} />
        </div>

        <div className="form-controls">
            <button type="submit">Submit<CheckIcon className="h-5 w-5" /></button>
            <button type="reset" onClick={resetForm}>Reset<XMarkIcon className="h-5 w-5" /></button>
            <button type="button" onClick={onClose}>Close<XCircleIcon className="h-5 w-5" /></button>
        </div>
    </form>);
};

export default RepairForm;