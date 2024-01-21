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


    @Override
    public void create(@NotNull Context ctx) {
        Technician technician = ctx.bodyAsClass(Technician.class);
        technicianService.createTechnician(technician);
        ctx.status(201);
    }

    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Technician t = technicianService.getTechnicianById(id);
        if (t == null)
            throw new NullPointerException();
        ctx.json(t);
    }

    @Override
    public void getAll(@NotNull Context ctx) {

        ArrayList<Technician> technicians = technicianService.getTechnicians();
        if (technicians == null)
            throw new NullPointerException();
        ctx.json(technicians);
    }

    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Technician updatedTechnician = ctx.bodyAsClass(Technician.class);
        if (updatedTechnician == null)
            throw new NullPointerException();
        technicianService.updateTechnician(id, updatedTechnician);
        ctx.status(200);
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        technicianService.deleteTechnician(id);
        ctx.status(204);
    }

}
