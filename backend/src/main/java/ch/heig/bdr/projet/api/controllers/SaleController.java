package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.models.Sale;
import ch.heig.bdr.projet.api.services.SaleService;
import io.javalin.apibuilder.CrudHandler;
import io.javalin.http.Context;
import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
public class SaleController implements CrudHandler {

    private final SaleService saleService;

    public SaleController() {
        this.saleService = new SaleService();
    }

    @Override
    public void create(@NotNull Context context) {
        Sale sale = context.bodyAsClass(Sale.class);
        saleService.createSale(sale);
        context.status(201);
    }

    @Override
    public void delete(@NotNull Context context, @NotNull String s) {
        saleService.deleteSale(s);
        context.status(204);
    }

    @Override
    public void getAll(@NotNull Context context) {
        ArrayList<Sale> sales = saleService.getSales();
        if (sales == null)
            throw new NullPointerException();
        context.json(sales);
    }

    @Override
    public void getOne(@NotNull Context context, @NotNull String s) {
        Sale sale = saleService.getSaleById(s);
        if (sale == null)
            throw new NullPointerException();
        context.json(sale);
    }

    @Override
    public void update(@NotNull Context context, @NotNull String s) {
        Sale updatedSale = context.bodyAsClass(Sale.class);
        if (updatedSale == null)
            throw new NullPointerException();
        saleService.updateSale(s, updatedSale);
        context.status(200);
    }
}
