package ch.heig.bdr.projet.api;

import io.javalin.Javalin;

import static io.javalin.apibuilder.ApiBuilder.*;

/**
 * Main class for the Javalin server.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class Main {
    /**
     * Entry point for the Javalin server.
     *
     * @param args Command line arguments, not used.
     */
    public static void main(String[] args) {
        final ReparationService reparationService = new ReparationService();
        final PersonService personService = new PersonService();

        // Create the Javalin app
        Javalin app = Javalin.create(config -> config.plugins.enableDevLogging()).start(7000);

        // Enable CORS for all requests
        app.before(ctx -> {
            ctx.header("Access-Control-Allow-Origin", "*");
            ctx.header("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS");
        });

        // Register 404
        app.error(404, ctx -> {
            ctx.result("Page not found");
            ctx.contentType("text/plain");
        });

        // Exception handling
        app.exception(Exception.class, (e, ctx) -> ctx.status(500).result("Internal server error"));

        // Register routes
        app.routes(() -> {
            crud("api/reparation/{id}", new ReparationController(reparationService));
            crud("api/person/{id}", new PersonController(personService));
        });
    }
}
