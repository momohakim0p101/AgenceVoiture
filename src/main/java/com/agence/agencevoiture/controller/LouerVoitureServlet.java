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
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/LouerVoitureServlet")
public class LouerVoitureServlet extends HttpServlet {

    private final ClientService clientService = new ClientService();
    private final VoitureService voitureService = new VoitureService();
    private final LocationService locationService = new LocationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Récupération des paramètres (toujours sous forme String depuis la requête)
            String voitureIdStr = request.getParameter("voitureId");
            String clientIdStr = request.getParameter("clientId");
            String dateDebutStr = request.getParameter("dateLocation");
            String dateFinStr = request.getParameter("dateRetourPrevue");

            // Validation simple
            if (voitureIdStr == null || clientIdStr == null || dateDebutStr == null || dateFinStr == null
                    || voitureIdStr.isEmpty() || clientIdStr.isEmpty() || dateDebutStr.isEmpty() || dateFinStr.isEmpty()) {
                request.setAttribute("erreur", "Tous les champs sont requis.");
                request.getRequestDispatcher("/location.jsp").forward(request, response);
                return;
            }

            // Parsing des IDs
            Long voitureId = null;
            try {
                voitureId = Long.parseLong(voitureIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("erreur", "ID voiture invalide.");
                request.getRequestDispatcher("/location.jsp").forward(request, response);
                return;
            }

            // Le CIN client est une chaîne (String), on le garde tel quel pour la recherche
            String clientCin = clientIdStr.trim();

            // Parsing des dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateDebut = sdf.parse(dateDebutStr);
            Date dateFin = sdf.parse(dateFinStr);

            if (!dateFin.after(dateDebut)) {
                request.setAttribute("erreur", "La date de retour doit être après la date de location.");
                request.getRequestDispatcher("/location.jsp").forward(request, response);
                return;
            }

            // Récupération des entités via les services
            Client client = clientService.trouverParCin(clientCin);
            Voiture voiture = voitureService.trouverVoitureImm(String.valueOf(voitureId));

            if (client == null) {
                request.setAttribute("erreur", "Client introuvable.");
                request.getRequestDispatcher("/location.jsp").forward(request, response);
                return;
            }

            if (voiture == null || !voiture.isDisponible()) {
                request.setAttribute("erreur", "Voiture introuvable ou non disponible.");
                request.getRequestDispatcher("/location.jsp").forward(request, response);
                return;
            }

            // Prix journalier récupéré depuis la voiture
            double prixParJour = voiture.getPrixLocationJour();

            // Création de la location via le service
            Location location = locationService.reserverVoiture(client, voiture, dateDebut, dateFin, prixParJour);

            request.setAttribute("message", "La voiture a été louée avec succès !");
            // Redirection vers la liste des locations ou la page d'accueil LocationServlet
            request.getRequestDispatcher("/LocationServlet").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Une erreur s'est produite lors de la location.");
            request.getRequestDispatcher("/location.jsp").forward(request, response);
        }
    }
}
