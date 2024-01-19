package ch.heig.bdr.projet.api;

import ch.heig.bdr.projet.api.brand.BrandController;
import ch.heig.bdr.projet.api.customer.CustomerController;
import ch.heig.bdr.projet.api.customer.CustomerService;
import ch.heig.bdr.projet.api.language.LanguageController;
import ch.heig.bdr.projet.api.person.PersonController;
import ch.heig.bdr.projet.api.person.PersonService;
import ch.heig.bdr.projet.api.reparation.ReparationController;
import ch.heig.bdr.projet.api.reparation.ReparationService;
import ch.heig.bdr.projet.api.sms.SmsController;
import ch.heig.bdr.projet.api.sms.SmsService;
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
        final SmsService smsService = new SmsService();
        final CustomerService customerService = new CustomerService();

        // Create the Javalin app
        Javalin app = Javalin.create(config -> config.plugins.enableDevLogging()).start(7000);

        // Enable CORS for all requests
        app.before(ctx -> {
            ctx.header("Access-Control-Allow-Origin", "*");
            ctx.header("Access-Control-Allow-Methods", "GET, POST, PATCH, PUT, DELETE, OPTIONS");
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
            crud("api/reparation/{id}", new ReparationController());
            crud("api/person/{id}", new PersonController());
            crud("api/sms/{id}", new SmsController());
            crud("api/customer/{id}", new CustomerController());
            get("api/reparation/{repairId}/sms", new SmsController()::getAllByRepairId);
            get("api/language", new LanguageController()::getAll);
            get("api/brand", new BrandController()::getAll);
        });
    }
}
