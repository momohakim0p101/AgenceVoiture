package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Utilisateur;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.ClientService;
import com.agence.agencevoiture.service.LocationService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.YearMonth;
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
            // Exemple d'utilisateur connecté stocké en session
            Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");

            long totalVoitures = locationService.compterVoitures();
            List<Location> locationsEnCours = locationService.voituresEnLocation();
            List<Voiture> voituresDisponibles = locationService.voituresDisponibles();

            Calendar cal = Calendar.getInstance();
            int mois = cal.get(Calendar.MONTH) + 1;
            int annee = cal.get(Calendar.YEAR);
            BigDecimal revenuMois = locationService.bilanFinancierMensuel(annee, mois);

            // Injection des données dans la requête
            request.setAttribute("utilisateur", utilisateur);
            request.setAttribute("totalVoitures", totalVoitures);
            request.setAttribute("locationsEnCours", locationsEnCours);
            request.setAttribute("voituresDisponibles", voituresDisponibles);
            request.setAttribute("revenuMois", revenuMois);

            LocationService locationService = new LocationService();

            long totalClients = locationService.compterTotalClients();

            long clientsActifs = locationService.compterClientsAyantLoué();

            YearMonth now = YearMonth.now();
            long clientsActifsMois = locationService.compterClientsActifsMois(now.getYear(), now.getMonthValue());

            int pourcentageMois = 0;
            if (totalClients > 0) {
                pourcentageMois = (int) ((clientsActifsMois * 100) / totalClients);
            }

            request.setAttribute("clientsActifs", clientsActifs);
            request.setAttribute("pourcentageClientsMois", pourcentageMois);

            // Redirection vers la JSP
            request.getRequestDispatcher("dashboardManager.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du tableau de bord.");
            request.getRequestDispatcher("erreur.jsp").forward(request, response);
        }
        ClientService clientService = new ClientService();
        List<Client> clients = clientService.rechercherTousLesClients();

        request.setAttribute("clients", clients);
        RequestDispatcher dispatcher = request.getRequestDispatcher("GestionClient.jsp");
        dispatcher.forward(request, response);
    }
}
