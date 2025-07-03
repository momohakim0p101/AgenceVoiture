package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Location.StatutLocation;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Utilisateur;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.LocationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

@WebServlet("/DashboardManagerServlet")
public class DashboardManagerServlet extends HttpServlet {

    private LocationService locationService;

    @Override
    public void init() throws ServletException {
        locationService = new LocationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");

            long totalVoitures = locationService.compterVoitures();
            List<Location> locationsEnCours = locationService.getLocationsEnCours();
            List<Voiture> voituresDisponibles = locationService.voituresDisponibles();

            List<Location> locationsHistoriques = locationService.listerLocationsHistoriques();
            if (locationsHistoriques == null) {
                locationsHistoriques = new ArrayList<>();
            }
            request.setAttribute("locationsHistoriques", locationsHistoriques);

            Calendar cal = Calendar.getInstance();
            int mois = cal.get(Calendar.MONTH) + 1;
            int annee = cal.get(Calendar.YEAR);
            BigDecimal revenuMois = locationService.bilanFinancierMensuel(annee, mois);

            long totalClients = locationService.compterTotalClients();
            long clientsActifs = locationService.compterClientsAyantLoué();

            YearMonth now = YearMonth.now();
            long clientsActifsMois = locationService.compterClientsActifsMois(now.getYear(), now.getMonthValue());

            int pourcentageMois = 0;
            if (totalClients > 0) {
                pourcentageMois = (int) ((clientsActifsMois * 100) / totalClients);
            }

            request.setAttribute("utilisateur", utilisateur);
            request.setAttribute("totalVoitures", totalVoitures);
            request.setAttribute("locationsEnCours", locationsEnCours);
            request.setAttribute("voituresDisponibles", voituresDisponibles);
            request.setAttribute("revenuMois", revenuMois);
            request.setAttribute("clientsActifs", clientsActifs);
            request.setAttribute("pourcentageClientsMois", pourcentageMois);

            request.getRequestDispatcher("dashboardManager.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du tableau de bord.");
            request.getRequestDispatcher("erreur.jsp").forward(request, response);
        }
    }
}
