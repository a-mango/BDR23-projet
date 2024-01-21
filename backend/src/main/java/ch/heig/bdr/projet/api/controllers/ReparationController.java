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
     * Default constructor.
     */
    public ReparationController() {
        this.reparationService = new ReparationService();
    }

    /**
     * Create a reparation.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void create(@NotNull Context ctx) {
        Reparation reparation = ctx.bodyAsClass(Reparation.class);
        reparation.id = reparationService.createReparation(reparation);
        ctx.json(reparation);
        ctx.status(201);
    }

    /**
     * Delete a reparation.
     *
     * @param ctx The context of the request.
     * @param id  The reparation id.
     */
    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Reparation r = reparationService.getReparationById(id);
        if (r == null) throw new NullPointerException();
        ctx.json(r);
    }

    /**
     * Get all reparations.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Reparation> reparations = reparationService.getReparations();
        if (reparations == null) throw new NullPointerException();
        ctx.json(reparations);
    }

    /**
     * Update a reparation.
     *
     * @param ctx The context of the request.
     * @param id  The reparation id.
     */
    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Reparation updatedReparation = ctx.bodyAsClass(Reparation.class);
        if (updatedReparation == null) throw new NullPointerException();
        updatedReparation.object.id = updatedReparation.object_id;
        reparationService.updateReparation(id, updatedReparation);
        ctx.json(updatedReparation);
        ctx.status(200);
    }

    /**
     * Delete a reparation.
     *
     * @param ctx The context of the request.
     * @param id  The reparation id.
     */
    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        reparationService.deleteReparation(id);
        ctx.status(204);
    }

}