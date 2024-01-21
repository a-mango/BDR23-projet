package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Sms;
import ch.heig.bdr.projet.api.services.SmsService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class SmsController implements CrudHandler {
    private final SmsService smsService;

    /**
     * Constructor.
     */
    public SmsController() {
        this.smsService = new SmsService();
    }

    @Override
    public void create(@NotNull Context ctx) {
        Sms sms = ctx.bodyAsClass(Sms.class);
        smsService.createSms(sms);
        ctx.status(201);
    }

    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        smsService.deleteSms(id);
        ctx.status(204);
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

    public void getAllByRepairId(@NotNull Context ctx) {
        String repairId = ctx.pathParam("repairId");
        ArrayList<Sms> sms = smsService.getSmsForRepairId(repairId);
        if (sms == null)
            throw new NullPointerException();
        ctx.json(sms);
    }
}
