package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Reparation;
import ch.heig.bdr.projet.api.services.ReparationService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

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
     */
    public ReparationController() {
        this.reparationService = new ReparationService();
    }

    @Override
    public void create(@NotNull Context ctx) {
        Reparation reparation = ctx.bodyAsClass(Reparation.class);
        reparationService.createReparation(reparation);
        ctx.status(201);
    }

    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Reparation r = reparationService.getReparationById(id);
        if (r == null)
            throw new NullPointerException();
        ctx.json(r);
    }

    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Reparation> reparations = reparationService.getReparations();
        if (reparations == null)
            throw new NullPointerException();
        ctx.json(reparations);
    }

    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Reparation updatedReparation = ctx.bodyAsClass(Reparation.class);
        if (updatedReparation == null)
            throw new NullPointerException();
        reparationService.updateReparation(id, updatedReparation);
        ctx.status(200);
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        reparationService.deleteReparation(id);
        ctx.status(204);
    }

}