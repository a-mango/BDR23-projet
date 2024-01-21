package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Technician;
import ch.heig.bdr.projet.api.services.TechnicianService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class TechnicianController implements CrudHandler {
    /**
     * The technician service.
     */
    private final TechnicianService technicianService;

    /**
     * Constructor.
     */
    public TechnicianController() {
        this.technicianService = new TechnicianService();
    }


    /**
     * Create a technician.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void create(@NotNull Context ctx) {
        Technician technician = ctx.bodyAsClass(Technician.class);
        technician.id = technicianService.createTechnician(technician);
        ctx.status(201);
    }

    /**
     * Get a technician.
     *
     * @param ctx The context of the request.
     * @param id  The technician id.
     */
    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Technician t = technicianService.getTechnicianById(id);
        if (t == null) throw new NullPointerException();
        ctx.json(t);
    }

    /**
     * Get all technicians.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void getAll(@NotNull Context ctx) {

        ArrayList<Technician> technicians = technicianService.getTechnicians();
        if (technicians == null) throw new NullPointerException();
        ctx.json(technicians);
    }

    /**
     * Update a technician.
     *
     * @param ctx The context of the request.
     * @param id  The technician id.
     */
    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Technician updatedTechnician = ctx.bodyAsClass(Technician.class);
        if (updatedTechnician == null) throw new NullPointerException();
        technicianService.updateTechnician(id, updatedTechnician);
        ctx.status(200);
    }

    /**
     * Delete a technician.
     *
     * @param ctx The context of the request.
     * @param id  The technician id.
     */
    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        technicianService.deleteTechnician(id);
        ctx.status(204);
    }

}
