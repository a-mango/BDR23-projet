package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Manager;
import ch.heig.bdr.projet.api.services.ManagerService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

/**
 * ManagerController class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class ManagerController implements CrudHandler {

    private final ManagerService managerService;

    public ManagerController() {
        this.managerService = new ManagerService();
    }

    @Override
    public void create(@NotNull Context ctx) {
        Manager manager = ctx.bodyAsClass(Manager.class);
        managerService.createManager(manager);
        ctx.status(201);
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        managerService.deleteManager(id);
        ctx.status(204);
    }

    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Manager> managers = managerService.getManagers();
        if (managerService.getManagers() == null)
            throw new NullPointerException();
        ctx.json(managers);
    }

    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Manager m = managerService.getManagerById(id);
        if (m == null)
            throw new NullPointerException();
        ctx.json(m);
    }

    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Manager updatedManager = ctx.bodyAsClass(Manager.class);
        if (updatedManager == null)
            throw new NullPointerException();
        managerService.updateManager(id, updatedManager);
        ctx.status(200);
    }
}

