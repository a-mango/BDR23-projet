package ch.heig.bdr.projet.api.controllers;

import java.util.ArrayList;

import ch.heig.bdr.projet.api.models.Brand;
import ch.heig.bdr.projet.api.services.BrandService;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

/**
 * BrandController class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class BrandController {

    private final BrandService brandService;

    /**
     * Default constructor.
     */
    public BrandController() {
        this.brandService = new BrandService();
    }

    /**
     * Get all brands.
     *
     * @param ctx The context of the request.
     */
    public void getAll(@NotNull Context ctx){
        ArrayList<Brand> brands = brandService.getBrands();
        if (brands == null)
            throw new NullPointerException();
        ctx.json(brands);
    }
}

