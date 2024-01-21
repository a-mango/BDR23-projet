package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Specialization;
import ch.heig.bdr.projet.api.services.SpecializationService;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

/**
 * Specialization controller class.
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class SpecializationController {

    private final SpecializationService specializationService;

    /**
     * Default constructor.
     */
    public SpecializationController() {
        this.specializationService = new SpecializationService();
    }

    /**
     * Get all specializations.
     *
     * @param ctx The context of the request.
     */
    public void getAll(@NotNull Context ctx) {
        ArrayList<Specialization> specializations = specializationService.getSpecializations();
        if (specializations == null) throw new NullPointerException();
        ctx.json(specializations);
    }
}
