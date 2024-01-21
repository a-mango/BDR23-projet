package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Language;
import ch.heig.bdr.projet.api.services.LanguageService;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

/**
 * LanguageController class
 *
 * @author Aubry Mangold <aubry.mangold@heig-vd.ch>
 * @author Eva Ray <eva.ray@heig-vd.ch>
 * @author Vitòria Cosmo De Oliviera <maria.cosmodeoliveira@heig-vd.ch>
 */
public class LanguageController {

    private final LanguageService languageService;

    /**
     * Default constructor.
     */
    public LanguageController() {
        this.languageService = new LanguageService();
    }

    /**
     * Get all languages.
     *
     * @param ctx The context of the request.
     */
    public void getAll(@NotNull Context ctx) {

        ArrayList<Language> languages = languageService.getLanguages();
        if (languages == null)
            throw new NullPointerException();
        ctx.json(languages);
    }


}

