package ch.heig.bdr.projet.api.customer;

import ch.heig.bdr.projet.api.person.Person;
import ch.heig.bdr.projet.api.person.PersonService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

/**
 * CustomerController class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class CustomerController implements CrudHandler {

    CustomerService customerService;

    public CustomerController() {
        this.customerService = new CustomerService();
    }
    @Override
    public void create(@NotNull Context ctx) {
        Customer c = ctx.bodyAsClass(Customer.class);
        customerService.createCustomer(c);
        ctx.json(c);
        ctx.status(201);
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        final var customer = customerService.getCustomerById(id);
        customerService.deleteCustomer(id);
        ctx.json(customer);
        ctx.status(204);
    }

    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Customer> customers = customerService.getCustomers();
        if (customers == null)
            throw new NullPointerException();

        ctx.json(customers);
    }

    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Customer customer = customerService.getCustomerById(id);
        if (customer == null)
            throw new NullPointerException();

        ctx.json(customer);
    }

    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Customer updatedCustomer = ctx.bodyAsClass(Customer.class);
        if (updatedCustomer == null)
            throw new NullPointerException();
        customerService.updateCustomer(id, updatedCustomer);

        ctx.json(updatedCustomer);
        ctx.status(200);
    }
}

