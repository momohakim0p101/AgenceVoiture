package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.ClientService;
import com.agence.agencevoiture.service.LocationService;
import com.agence.agencevoiture.service.VoitureService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private final VoitureService voitureService = new VoitureService();
    private final ClientService clientService = new ClientService();
    private final LocationService locationService = new LocationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String query = request.getParameter("q");

        if (query == null || query.trim().isEmpty()) {
            // Rediriger vers le dashboard sans résultats si recherche vide
            response.sendRedirect("DashboardChef.jsp");
            return;
        }

        query = query.toLowerCase().trim();

        switch (type) {
            case "voiture":
                List<Voiture> voitures = voitureService.rechercherVoitures(query);
                request.setAttribute("searchResultsVoitures", voitures);
                break;

            case "client":
                List<Client> clients = clientService.rechercherParNomPrenomOuCin(query);
                request.setAttribute("searchResultsClients", clients);
                break;

            case "location":
                List<Location> locations = locationService.rechercherParMarqueEtDate(query, LocalDate.now());
                request.setAttribute("searchResultsLocations", locations);
                break;
        }

        request.getRequestDispatcher("/DashboardChef.jsp").forward(request, response);
    }
}