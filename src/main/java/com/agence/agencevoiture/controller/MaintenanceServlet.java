package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Maintenance;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.MaintenanceService;
import com.agence.agencevoiture.service.VoitureService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/MaintenanceServlet")
public class MaintenanceServlet extends HttpServlet {

    private final MaintenanceService maintenanceService = new MaintenanceService();
    private final VoitureService voitureService = new VoitureService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupère le paramètre qui correspond à l'immatriculation (ou change ici en "voitureId" si tu envoies l'ID)
        String immatriculation = request.getParameter("immatriculation");
        String type = request.getParameter("type");
        String description = request.getParameter("description");
        String dateStr = request.getParameter("date");
        String prixStr = request.getParameter("prix");
        double prix = Double.parseDouble(prixStr);


        try {
            // Validation rapide
            if (immatriculation == null || type == null || dateStr == null ||
                    immatriculation.isEmpty() || type.isEmpty() || dateStr.isEmpty()) {
                throw new IllegalArgumentException("Tous les champs sont requis.");
            }

            // Recherche de la voiture
            Voiture voiture = voitureService.trouverVoitureImm(immatriculation);
            if (voiture == null) {
                throw new IllegalArgumentException("Voiture non trouvée : " + immatriculation);
            }

            // Conversion de la date
            Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);

            // Création et enregistrement de la maintenance
            Maintenance maintenance = new Maintenance();
            maintenance.setVoiture(voiture);
            maintenance.setType(type);
            maintenance.setDescription(description);
            maintenance.setDateMaintenance(date);
            maintenance.setPrix(prix);


            boolean success = maintenanceService.ajouterMaintenance(maintenance);

            // Mets la voiture en maintenance et enregistre ce changement
            if (success) {
                voiture.setEnMaintenance(true);
                voitureService.mettreAJourVoiture(voiture);

                request.getSession().setAttribute("message", "Maintenance planifiée avec succès.");
            } else {
                request.getSession().setAttribute("erreur", "Échec de la planification de la maintenance.");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("erreur", "Erreur : " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/LocationServlet");
    }
}
