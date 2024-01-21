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

    /**
     * Create a sms.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void create(@NotNull Context ctx) {
        Sms sms = ctx.bodyAsClass(Sms.class);
        smsService.createSms(sms);
        ctx.status(201);
    }

    /**
     * Delete a sms.
     *
     * @param ctx The context of the request.
     * @param id  The sms id.
     */
    @Override
    public void delete(@NotNull Context ctx, @NotNull String id) {
        smsService.deleteSms(id);
        ctx.status(204);
    }

    /**
     * Get all sms.
     *
     * @param ctx The context of the request.
     */
    @Override
    public void getAll(@NotNull Context ctx) {
        ArrayList<Sms> sms = smsService.getSms();
        if (sms == null) throw new NullPointerException();
        ctx.json(sms);
    }

    /**
     * Get a sms.
     *
     * @param ctx The context of the request.
     * @param id  The sms id.
     */
    @Override
    public void getOne(@NotNull Context ctx, @NotNull String id) {
        Sms sms = smsService.getSmsById(id);
        if (sms == null) throw new NullPointerException();
        ctx.json(sms);
    }

    /**
     * Update a sms.
     *
     * @param ctx The context of the request.
     * @param id  The sms id.
     */
    @Override
    public void update(@NotNull Context ctx, @NotNull String id) {
        Sms updatedSms = ctx.bodyAsClass(Sms.class);
        if (updatedSms == null) throw new NullPointerException();
        smsService.updateSms(id, updatedSms);
        ctx.status(200);
    }

    /**
     * Get all sms for a repair.
     *
     * @param ctx The context of the request.
     */
    public void getAllByRepairId(@NotNull Context ctx) {
        String repairId = ctx.pathParam("repairId");
        ArrayList<Sms> sms = smsService.getSmsForRepairId(repairId);
        if (sms == null) throw new NullPointerException();
        ctx.json(sms);
    }
}
