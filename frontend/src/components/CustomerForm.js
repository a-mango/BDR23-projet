import { useForm } from 'react-hook-form';

const CustomerForm = () => {
    const {
        register,
        handleSubmit,
        watch,
        formState: { errors },
    } = useForm();

    const onSubmit = (data) => console.log(data);

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
                    <input {...register('phone', { required: true })} />
                    {errors.phone && <span>This field is required</span>}
                </div>

                <div>
                    <label>TOS Accepted</label>
                    <input type="checkbox" {...register('tosAccepted')} />
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
            <button type="submit">Submit</button>
        </form>
    );
};

export default CustomerForm;