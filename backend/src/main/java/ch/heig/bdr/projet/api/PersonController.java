package ch.heig.bdr.projet.api;

import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.bson.Document;
import org.jetbrains.annotations.NotNull;

import java.sql.SQLException;
import java.util.List;

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
     *
     * @param personService The person service to use.
     */
    public PersonController(PersonService personService) {
        this.personService = personService;
    }


    @Override
    public void create(@NotNull Context ctx) {
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
    }

    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
    }
}
