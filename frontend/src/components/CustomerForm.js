import { useForm } from 'react-hook-form';
import { CheckIcon, XMarkIcon } from '@heroicons/react/24/solid';
import useData from '../hooks/useData';

const CustomerForm = () => {
    const {
        register,
        handleSubmit,
        watch,
        formState: { errors },
    } = useForm();

    const { create } = useData('customer');

    const onSubmit = (data) => {
        data.phoneNumber = data.phoneNumber.replace(/\s/g, '');
        console.log("Create customer", data);
        create(data);
    };

    return (
        <form onSubmit={handleSubmit(onSubmit)}>
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