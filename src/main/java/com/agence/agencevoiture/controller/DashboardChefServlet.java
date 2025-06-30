package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.service.LocationService;
import com.agence.agencevoiture.service.VoitureService;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/DashboardChefServlet")
public class DashboardChefServlet extends HttpServlet {

    private final LocationService locationService = new LocationService();
    private final VoitureService voitureService = new VoitureService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate now = LocalDate.now();

        long totalVoitures = voitureService.listerToutesLesVoitures().size();
        List<Voiture> voituresDisponibles = voitureService.listerVoituresDisponibles();
        List<Location> locationsEnCours = locationService.voituresEnLocation();
        BigDecimal revenuMois = locationService.bilanFinancierMensuel(now.getYear(), now.getMonthValue());

        long clientsActifs = locationService.compterClientsActifsMois(now.getYear(), now.getMonthValue());
        long totalClients = locationService.compterTotalClients();
        long pourcentageClientsMois = (totalClients > 0)
                ? (clientsActifs * 100) / totalClients
                : 0;

        List<Object[]> voituresPopulaires = locationService.voituresLesPlusLoueés(5);

        // ➕ Bilan mensuel sur 6 derniers mois
        List<BigDecimal> revenusMensuels = new ArrayList<>();
        List<String> moisLabels = new ArrayList<>();

        for (int i = 5; i >= 0; i--) {
            LocalDate date = now.minusMonths(i);
            int annee = date.getYear();
            int mois = date.getMonthValue();

            revenusMensuels.add(locationService.bilanFinancierMensuel(annee, mois));
            moisLabels.add(date.getMonth().name().substring(0, 3)); // ex: JAN, FEV...
        }

        // Conversion JS-friendly (alternatif à Gson)
        request.setAttribute("labelsJson", toJsonArray(moisLabels));
        request.setAttribute("dataJson", toJsonArray(revenusMensuels));

        // Attributs pour le JSP
        request.setAttribute("totalVoitures", totalVoitures);
        request.setAttribute("voituresDisponibles", voituresDisponibles);
        request.setAttribute("locationsEnCours", locationsEnCours);
        request.setAttribute("revenuMois", revenuMois);
        request.setAttribute("clientsActifs", clientsActifs);
        request.setAttribute("pourcentageClientsMois", pourcentageClientsMois);
        request.setAttribute("voituresPopulaires", voituresPopulaires);

        request.getRequestDispatcher("/dashboardChef.jsp").forward(request, response);
    }

    // Alternative simple à Gson pour tableaux JSON
    private String toJsonArray(List<?> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            Object val = list.get(i);
            if (val instanceof String) {
                sb.append("\"").append(val).append("\"");
            } else {
                sb.append(val);
            }
            if (i < list.size() - 1) sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }
}
