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
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/DashboardChefServlet")
public class DashboardChefServlet extends HttpServlet {

    private final LocationService locationService = new LocationService();
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate now = LocalDate.now();

        // Bilan mensuel sur 6 derniers mois
        List<BigDecimal> revenusMensuels = new ArrayList<>();
        List<String> moisLabels = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            LocalDate date = now.minusMonths(i);
            int annee = date.getYear();
            int mois = date.getMonthValue();
            revenusMensuels.add(locationService.bilanFinancierMensuel(annee, mois));
            moisLabels.add(date.getMonth().name().substring(0, 3));
        }

        // Bilan journalier (7 derniers jours)
        List<String> joursLabels = new ArrayList<>();
        List<BigDecimal> revenusJournaliers = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = now.minusDays(i);
            joursLabels.add(date.format(dateFormatter));
            revenusJournaliers.add(locationService.bilanFinancierJournalier(date));
        }

        // Bilan hebdomadaire (6 dernières semaines)
        List<String> semainesLabels = new ArrayList<>();
        List<BigDecimal> revenusHebdomadaires = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            LocalDate debutSemaine = now.minusWeeks(i).with(java.time.DayOfWeek.MONDAY);
            LocalDate finSemaine = debutSemaine.plusDays(6);
            semainesLabels.add("S" + debutSemaine.get(java.time.temporal.WeekFields.ISO.weekOfYear()));
            revenusHebdomadaires.add(locationService.bilanFinancierHebdomadaire(debutSemaine, finSemaine));
        }

        // Envoyer les données au JSP
        request.setAttribute("labelsJson", toJsonArray(moisLabels));
        request.setAttribute("dataJson", toJsonArray(revenusMensuels));
        request.setAttribute("joursLabelsJson", toJsonArray(joursLabels));
        request.setAttribute("revenusJournaliersJson", toJsonArray(revenusJournaliers));
        request.setAttribute("semainesLabelsJson", toJsonArray(semainesLabels));
        request.setAttribute("revenusHebdomadairesJson", toJsonArray(revenusHebdomadaires));

        request.getRequestDispatcher("/dashboardChef.jsp").forward(request, response);
    }

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
