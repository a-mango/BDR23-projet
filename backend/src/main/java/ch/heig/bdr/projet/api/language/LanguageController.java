package ch.heig.bdr.projet.api.language;

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

    public LanguageController() {
        this.languageService = new LanguageService();
    }
    public void getAll(@NotNull Context ctx) {

        ArrayList<Language> languages = languageService.getLanguages();
        if (languages == null)
            throw new NullPointerException();
        ctx.json(languages);
    }


}

