package ch.heig.bdr.projet.api.controllers;

import ch.heig.bdr.projet.api.services.StatisticsService;
import io.javalin.http.Context;

public class StatisticsController {
    private final StatisticsService statisticsService;

    /**
     * Default constructor.
     */
    public StatisticsController() {
        this.statisticsService = new StatisticsService();
    }

    public void getStatistics(Context ctx) {
        var statistics = statisticsService.getStatistics();
        if (statistics == null) throw new NullPointerException();
        ctx.json(statistics);
    }
}
