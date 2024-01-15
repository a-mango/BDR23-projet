package ch.heig.bdr.projet.api.sms;

import ch.heig.bdr.projet.api.person.Person;
import ch.heig.bdr.projet.api.person.PersonService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class SmsController implements CrudHandler {

    private final SmsService smsService;

    /**
     * Constructor.
     *
     * @param smsService The person service to use.
     */
    public SmsController(SmsService smsService) {
        this.smsService = smsService;
    }

    @Override
    public void create(@NotNull Context context) {
        Sms sms = context.bodyAsClass(Sms.class);
        smsService.createSms(sms);
        context.status(201);
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        Sms sms = smsService.getSmsById(id);
        if (sms == null)
            throw new NullPointerException();

        ctx.json(sms);
    }

    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Sms> sms = smsService.getSms();
        if (sms == null)
            throw new NullPointerException();
        ctx.json(sms);
    }

    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Sms sms = smsService.getSmsById(id);
        if (sms == null)
            throw new NullPointerException();

        ctx.json(sms);
    }

    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Sms updatedSms = ctx.bodyAsClass(Sms.class);
        if (updatedSms == null)
            throw new NullPointerException();
        smsService.updateSms(id, updatedSms);
        ctx.status(200);
    }
}
