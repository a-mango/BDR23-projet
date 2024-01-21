package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Person;
import ch.heig.bdr.projet.api.services.PersonService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

/**
 * Person controller.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class PersonController implements CrudHandler {
    /**
     * The person service.
     */
    private final PersonService personService;

    /**
     * Constructor.
     */
    public PersonController() {
        this.personService = new PersonService();
    }


    @Override
    public void create(@NotNull Context ctx) {
        Person person = ctx.bodyAsClass(Person.class);
        personService.createPerson(person);
        ctx.status(201);
    }

    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Person p = personService.getPersonById(id);
        if (p == null)
            throw new NullPointerException();
        ctx.json(p);
    }

    @Override
    public void getAll(@NotNull Context ctx) {

        ArrayList<Person> persons = personService.getPersons();
        if (persons == null)
            throw new NullPointerException();
        ctx.json(persons);
    }

    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Person updatedPerson = ctx.bodyAsClass(Person.class);
        if (updatedPerson == null)
            throw new NullPointerException();
        personService.updatePerson(id, updatedPerson);
        ctx.status(200);
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        personService.deletePerson(id);
        ctx.status(204);
    }
}
