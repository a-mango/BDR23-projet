package ch.heig.bdr.projet.api;

import ch.heig.bdr.projet.api.brand.BrandController;
import ch.heig.bdr.projet.api.category.CategoryController;
import ch.heig.bdr.projet.api.collaborator.CollaboratorController;
import ch.heig.bdr.projet.api.customer.CustomerController;
import ch.heig.bdr.projet.api.customer.CustomerService;
import ch.heig.bdr.projet.api.language.LanguageController;
import ch.heig.bdr.projet.api.manager.ManagerController;
import ch.heig.bdr.projet.api.object.ObjectController;
import ch.heig.bdr.projet.api.person.PersonController;
import ch.heig.bdr.projet.api.person.PersonService;
import ch.heig.bdr.projet.api.receptionist.ReceptionistController;
import ch.heig.bdr.projet.api.reparation.ReparationController;
import ch.heig.bdr.projet.api.reparation.ReparationService;
import ch.heig.bdr.projet.api.sms.SmsController;
import ch.heig.bdr.projet.api.sms.SmsService;
import ch.heig.bdr.projet.api.specialization.SpecializationController;
import ch.heig.bdr.projet.api.technician.TechnicianController;
import io.javalin.Javalin;
import io.javalin.plugin.bundled.CorsPluginConfig;

import static io.javalin.apibuilder.ApiBuilder.crud;
import static io.javalin.apibuilder.ApiBuilder.get;

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
        Javalin app = Javalin.create(config -> {
            config.plugins.enableDevLogging();
            config.plugins.enableCors(cors -> cors.add(CorsPluginConfig::anyHost));
        }).start(7000);

        app.before(ctx -> {
            ctx.header("Access-Control-Allow-Origin", "*");
            ctx.header("Access-Control-Allow-Methods", "GET, POST, PATCH, PUT, DELETE, OPTIONS");
            ctx.header("Access-Control-Allow-Headers", "content-type");
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
            crud("api/collaborator/{id}", new CollaboratorController());
            crud("api/technician/{id}", new TechnicianController());
            crud("api/receptionist/{id}", new ReceptionistController());
            crud("api/manager/{id}", new ManagerController());
            crud("api/object/{id}", new ObjectController());
            get("api/reparation/{repairId}/sms", new SmsController()::getAllByRepairId);
            get("api/language", new LanguageController()::getAll);
            get("api/brand", new BrandController()::getAll);
            get("api/category", new CategoryController()::getAll);
            get("api/specialization", new SpecializationController()::getAll);
        });
    }
}
