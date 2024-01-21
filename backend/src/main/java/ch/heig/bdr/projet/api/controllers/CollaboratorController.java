package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Collaborator;
import ch.heig.bdr.projet.api.services.CollaboratorService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

/**
 * CollaboratorController class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class CollaboratorController implements CrudHandler {
    private CollaboratorService collaboratorService;

    /**
     * Default constructor.
     */
    public CollaboratorController() {
        collaboratorService = new CollaboratorService();
    }

    /**
     * Create a collaborator.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void create(@NotNull Context ctx) {
        Collaborator c = ctx.bodyAsClass(Collaborator.class);
        c.id = collaboratorService.createCollaborator(c);
        ctx.status(201);
    }

    /**
     * Delete a collaborator.
     *
     * @param ctx The context of the request.
     * @param id  The collaborator id.
     */
    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        collaboratorService.deleteCollaborator(id);
        ctx.status(204);
    }

    /**
     * Get all collaborators.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Collaborator> collaborators = collaboratorService.getCollaborators();
        if (collaborators == null) throw new NullPointerException();
        ctx.json(collaborators);
    }

    /**
     * Get a collaborator.
     *
     * @param ctx The context of the request.
     * @param id  The collaborator id.
     */
    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Collaborator collaborator = collaboratorService.getCollaboratorById(id);
        if (collaborator == null) throw new NullPointerException();
        ctx.json(collaborator);
    }

    /**
     * Update a collaborator.
     *
     * @param ctx The context of the request.
     * @param id  The collaborator id.
     */
    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Collaborator updatedCollaborator = ctx.bodyAsClass(Collaborator.class);
        if (updatedCollaborator == null) throw new NullPointerException();
        collaboratorService.updateCollaborator(id, updatedCollaborator);
        ctx.status(200);
    }

}

