package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Object;
import ch.heig.bdr.projet.api.services.ObjectService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

/**
 * Object controller.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class ObjectController implements CrudHandler{

    private final ObjectService objectService;

    public ObjectController() {
        this.objectService = new ObjectService();
    }

        @Override
        public void create(@NotNull Context ctx) {
            Object object = ctx.bodyAsClass(Object.class);
            objectService.createObject(object);
            ctx.status(201);
        }

        @Override
        public void delete(@NotNull Context ctx, @NotNull String id) {
            objectService.deleteObject(id);
            ctx.status(204);
        }

        @Override
        public void getAll(@NotNull Context ctx) {
            ArrayList<Object> objects = objectService.getObjects();
            if (objects == null)
                throw new NullPointerException();
            ctx.json(objects);
        }

        @Override
        public void getOne(@NotNull Context ctx, @NotNull String id) {
            Object o = objectService.getObjectById(id);
            if (o == null)
                throw new NullPointerException();
            ctx.json(o);
        }

        @Override
        public void update(@NotNull Context ctx, @NotNull String id) {
            Object updatedObject = ctx.bodyAsClass(Object.class);
            if (updatedObject == null)
                throw new NullPointerException();
            objectService.updateObject(id, updatedObject);
            ctx.status(200);
        }


}
