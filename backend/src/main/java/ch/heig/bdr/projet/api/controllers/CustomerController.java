package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Customer;
import ch.heig.bdr.projet.api.services.CustomerService;
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


    private CustomerService customerService;

    /**
     * Default constructor.
     */
    public CustomerController() {
        this.customerService = new CustomerService();
    }

    /**
     * Create a customer.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void create(@NotNull Context ctx) {
        Customer c = ctx.bodyAsClass(Customer.class);
        c.id = customerService.createCustomer(c);
        ctx.json(c);
        ctx.status(201);
    }

    /**
     * Delete a customer.
     *
     * @param ctx The context of the request.
     * @param id  The customer id.
     */
    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        final var customer = customerService.getCustomerById(id);
        customerService.deleteCustomer(id);
        ctx.json(customer);
        ctx.status(204);
    }

    /**
     * Get all customers.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Customer> customers = customerService.getCustomers();
        if (customers == null) throw new NullPointerException();

        ctx.json(customers);
    }

    /**
     * Get a customer.
     *
     * @param ctx The context of the request.
     * @param id  The customer id.
     */
    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Customer customer = customerService.getCustomerById(id);
        if (customer == null) throw new NullPointerException();

        ctx.json(customer);
    }

    /**
     * Update a customer.
     *
     * @param ctx The context of the request.
     * @param id  The customer id.
     */
    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Customer updatedCustomer = ctx.bodyAsClass(Customer.class);
        if (updatedCustomer == null) throw new NullPointerException();
        customerService.updateCustomer(id, updatedCustomer);

        ctx.json(updatedCustomer);
        ctx.status(200);
    }
}

