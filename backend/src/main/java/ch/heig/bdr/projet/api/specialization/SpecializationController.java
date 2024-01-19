package ch.heig.bdr.projet.api.specialization;

import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
public class SpecializationController {

    private final SpecializationService specializationService;

    /**
     * Default constructor.
     */
    public SpecializationController() {
        this.specializationService = new SpecializationService();
    }

    public void getAll(@NotNull Context ctx) {
        ArrayList<Specialization> specializations = specializationService.getSpecializations();
        if (specializations == null)
            throw new NullPointerException();
        ctx.json(specializations);
    }
}
