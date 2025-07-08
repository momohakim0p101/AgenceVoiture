package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.service.LocationService;
import com.agence.agencevoiture.service.VoitureService;
import com.agence.agencevoiture.service.ClientService;
import com.agence.agencevoiture.entity.*;

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
    private final VoitureService voitureService = new VoitureService();
    private final ClientService clientService = new ClientService(); // Si nécessaire
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate now = LocalDate.now();

        // --- 1. Données pour graphiques financiers ---
        List<BigDecimal> revenusMensuels = new ArrayList<>();
        List<String> moisLabels = new ArrayList<>();
        int annee = 0;
        int mois = 0;
        for (int i = 5; i >= 0; i--) {
            LocalDate date = now.minusMonths(i);
            annee = date.getYear();
            mois = date.getMonthValue();
            revenusMensuels.add(locationService.bilanFinancierMensuel(annee, mois));
            moisLabels.add(date.getMonth().name().substring(0, 3));
        }

        List<String> joursLabels = new ArrayList<>();
        List<BigDecimal> revenusJournaliers = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = now.minusDays(i);
            joursLabels.add(date.format(dateFormatter));
            revenusJournaliers.add(locationService.bilanFinancierJournalier(date));
        }

        List<String> semainesLabels = new ArrayList<>();
        List<BigDecimal> revenusHebdomadaires = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            LocalDate debutSemaine = now.minusWeeks(i).with(java.time.DayOfWeek.MONDAY);
            LocalDate finSemaine = debutSemaine.plusDays(6);
            semainesLabels.add("S" + debutSemaine.get(java.time.temporal.WeekFields.ISO.weekOfYear()));
            revenusHebdomadaires.add(locationService.bilanFinancierHebdomadaire(debutSemaine, finSemaine));
        }

        // --- 2. Statistiques principales ---
        List<Voiture> voituresDisponibles = voitureService.listerVoituresDisponibles();
        List<Location> locationsEnCours = locationService.listerLocationsEnCours();
        List<Location> locationsHistoriques = locationService.listerLocationsTerminees();
        Long totalVoitures = voitureService.totalVoitures();
        BigDecimal revenuMois = locationService.bilanFinancierMensuel(now.getYear(), now.getMonthValue());

        // --- 3. Clients actifs ---
        long clientsActifs = locationService.compterClientsAyantLoué();
        int totalClients = clientService.totalClients(); // méthode dans ClientService
        int pourcentageClientsMois = totalClients > 0 ? (int) ((double) clientsActifs * 100 / totalClients) : 0;



        // --- 4. Objectif et évolution ---
        BigDecimal objectifMensuel = locationService.objectifDuMois(); // méthode que tu dois définir ou hardcoder
        BigDecimal revenuMoisDernier = locationService.bilanFinancierMensuel(now.minusMonths(1).getYear(), now.minusMonths(1).getMonthValue());
        BigDecimal evolutionRevenu = revenuMois.subtract(revenuMoisDernier);

        // --- 5. Voitures populaires ---
        List<Object[]> voituresPopulaires = voitureService.voituresLesPlusLouees(5); // Top 5

        // --- 6. Transfert vers JSP ---
        request.setAttribute("labelsJson", toJsonArray(moisLabels));
        request.setAttribute("dataJson", toJsonArray(revenusMensuels));
        request.setAttribute("joursLabelsJson", toJsonArray(joursLabels));
        request.setAttribute("revenusJournaliersJson", toJsonArray(revenusJournaliers));
        request.setAttribute("semainesLabelsJson", toJsonArray(semainesLabels));
        request.setAttribute("revenusHebdomadairesJson", toJsonArray(revenusHebdomadaires));

        request.setAttribute("voituresDisponibles", voituresDisponibles);
        request.setAttribute("locationsEnCours", locationsEnCours);
        request.setAttribute("locationsHistoriques", locationsHistoriques);
        request.setAttribute("totalVoitures", totalVoitures);
        request.setAttribute("revenuMois", revenuMois);
        request.setAttribute("clientsActifs", clientsActifs);
        request.setAttribute("pourcentageClientsMois", pourcentageClientsMois);
        request.setAttribute("objectifMensuel", objectifMensuel);
        request.setAttribute("evolutionRevenu", evolutionRevenu);
        request.setAttribute("voituresPopulaires", voituresPopulaires);

        request.setAttribute("locationsEnCours", locationService.listerLocationsEnCours());
        request.setAttribute("locationsHistoriques", locationService.listerLocationsTerminees());
        request.setAttribute("clientsActifs", locationService.nombreClientsActifsDuMois(annee, mois));
        request.setAttribute("voituresPopulaires", voitureService.voituresLesPlusLouees(5));
        request.setAttribute("totalClients", locationService.totalClients());


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
