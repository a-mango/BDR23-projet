package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Receptionist;
import ch.heig.bdr.projet.api.services.ReceptionistService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class ReceptionistController implements CrudHandler {

    private final ReceptionistService receptionistService;

    public ReceptionistController() {
        this.receptionistService = new ReceptionistService();
    }

    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Receptionist> receptionists = receptionistService.getReceptionists();
        if (receptionists == null) throw new NullPointerException();
        ctx.json(receptionists);
    }

    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Receptionist r = receptionistService.getReceptionistById(id);
        if (r == null) throw new NullPointerException();
        ctx.json(r);
    }

    @Override
    public void create(@NotNull Context context) {
        Receptionist receptionist = context.bodyAsClass(Receptionist.class);
        receptionistService.createReceptionist(receptionist);
        context.status(201);
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        receptionistService.deleteReceptionist(id);
        ctx.status(204);
    }

    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Receptionist r = ctx.bodyAsClass(Receptionist.class);
        if (r == null) throw new NullPointerException();
        receptionistService.updateReceptionist(id, r);
        ctx.status(200);
    }
}
