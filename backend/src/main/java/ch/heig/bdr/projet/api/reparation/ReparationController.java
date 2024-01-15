package ch.heig.bdr.projet.api.reparation;

import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

/**
 * Reparation controller class.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class ReparationController implements CrudHandler {
    /**
     * The reparation service to use.
     */
    private final ReparationService reparationService;

    /**
     * Constructor.
     *
     * @param reparationService The reparation service to use.
     */
    public ReparationController() {
        this.reparationService = new ReparationService();
    }

    @Override
    public void create(@NotNull Context ctx) {
    }

    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
    }

    @Override
    public void getAll(@NotNull Context ctx) {
    }

    @Override
    public void update(Context ctx, @NotNull String id) {
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
    }

}