package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Location.StatutLocation;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.LocationService;
import com.agence.agencevoiture.service.VoitureService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/RetournerVoitureServlet")
public class RetournerVoitureServlet extends HttpServlet {

    private LocationService locationService;
    private VoitureService voitureService;

    @Override
    public void init() throws ServletException {
        locationService = new LocationService();
        voitureService = new VoitureService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String locationIdStr = request.getParameter("locationId");
        String dateRetourStr = request.getParameter("dateRetourEffectif");

        // Validation des paramètres
        if (locationIdStr == null || locationIdStr.isEmpty() || dateRetourStr == null || dateRetourStr.isEmpty()) {
            session.setAttribute("erreur", "Tous les champs sont obligatoires.");
            response.sendRedirect(request.getContextPath() + "/DashboardManagerServlet");
            return;
        }

        Long locationId;
        try {
            locationId = Long.parseLong(locationIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("erreur", "ID de location invalide.");
            response.sendRedirect(request.getContextPath() + "/DashboardManagerServlet");
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dateRetourEffectif;
        try {
            dateRetourEffectif = sdf.parse(dateRetourStr);
        } catch (ParseException e) {
            session.setAttribute("erreur", "Format de date de retour invalide.");
            response.sendRedirect(request.getContextPath() + "/DashboardManagerServlet");
            return;
        }

        Location location = locationService.chercherParId(locationId);
        if (location == null) {
            session.setAttribute("erreur", "Location introuvable.");
            response.sendRedirect(request.getContextPath() + "/DashboardManagerServlet");
            return;
        }

        // Validation : date de retour >= date de début
        if (dateRetourEffectif.before(location.getDateDebut())) {
            session.setAttribute("erreur", "La date de retour ne peut pas être antérieure à la date de début.");
            response.sendRedirect(request.getContextPath() + "/DashboardManagerServlet");
            return;
        }

        try {
            // Mise à jour de la location : date de fin et statut TERMINEE
            location.setDateFin(dateRetourEffectif);
            location.setStatut(StatutLocation.TERMINEE);

            // Rendre la voiture disponible
            Voiture voiture = location.getVoiture();
            voiture.setDisponible(true);

            // Mettre à jour la location et la voiture en base
            locationService.mettreAJourLocation(location);
            voitureService.mettreAJourVoiture(voiture);

            session.setAttribute("message", "Voiture retournée avec succès.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("erreur", "Erreur lors de la mise à jour du retour.");
        }

        // Rediriger vers LocationServlet pour recharger les données et afficher message
        response.sendRedirect(request.getContextPath() + "/DashboardManagerServlet");
    }
}
