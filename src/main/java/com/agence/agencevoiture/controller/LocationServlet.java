package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.dao.ClientDAO;
import com.agence.agencevoiture.dao.VoitureDAO;
import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.LocationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/location")
public class LocationServlet extends HttpServlet {

    private final LocationService locationService = new LocationService();
    private final ClientDAO clientDAO = new ClientDAO();
    private final VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Location> locations = locationService.listerToutesLesLocations();
        request.setAttribute("locations", locations);
        request.getRequestDispatcher("location.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "ajouter":
                ajouterLocation(request, response);
                break;
            case "supprimer":
                supprimerLocation(request, response);
                break;
            case "modifier":
                modifierLocation(request, response);
                break;
            default:
                request.setAttribute("erreur", "Action non reconnue.");
                doGet(request, response);
        }
    }

    private void ajouterLocation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Location location = extraireLocationDepuisRequete(request);
            locationService.ajouterLocation(location);
            request.setAttribute("message", "Location ajoutée avec succès.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de l'ajout de la location.");
        }
        doGet(request, response);
    }

    private void supprimerLocation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            boolean success = locationService.supprimerLocation(id);
            request.setAttribute(success ? "message" : "erreur", success ? "Location supprimée." : "Location introuvable.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de la suppression.");
        }
        doGet(request, response);
    }

    private void modifierLocation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Location location = extraireLocationDepuisRequete(request);
            locationService.mettreAJourLocation(location);
            request.setAttribute("message", "Location mise à jour avec succès.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de la mise à jour.");
        }
        doGet(request, response);
    }

    private Location extraireLocationDepuisRequete(HttpServletRequest request) throws Exception {
        Long id = request.getParameter("id") != null ? Long.parseLong(request.getParameter("id")) : null;
        String immatriculation = request.getParameter("immatriculation");
        String cinClient = request.getParameter("cin_client");
        Date debut = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("dateDebut"));
        Date fin = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("dateFin"));
        double montant = Double.parseDouble(request.getParameter("montant"));
        String statut = request.getParameter("statut");

        // Récupération de la voiture et du client
        Voiture voiture = voitureDAO.trouverVoiture(immatriculation);
        Client client = clientDAO.trouverClient(cinClient);

        Location location = new Location();
        location.setIdReservation(id);
        location.setVoiture(voiture);
        location.setClient(client);
        location.setDateDebut(debut);
        location.setDateFin(fin);
        location.setMontantTotal(montant);
        location.setStatut(statut);

        return location;
    }
}
