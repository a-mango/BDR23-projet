package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Category;
import ch.heig.bdr.projet.api.services.CategoryService;
import io.javalin.http.Context;

import java.util.ArrayList;

/**
 * CategoryController class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class CategoryController {

    private final CategoryService categoryService;

    /**
     * Default constructor.
     */
    public CategoryController() {
        this.categoryService = new CategoryService();
    }

    public void getAll(Context ctx){
        ArrayList<Category> categories = categoryService.getCategories();
        if (categories == null)
            throw new NullPointerException();
        ctx.json(categories);
    }
}

