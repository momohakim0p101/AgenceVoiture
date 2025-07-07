package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Maintenance;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.MaintenanceService;
import com.agence.agencevoiture.service.VoitureService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/RetourMaintenanceServlet")
public class RetourMaintenanceServlet extends HttpServlet {

    private final MaintenanceService maintenanceService = new MaintenanceService();
    private final VoitureService voitureService = new VoitureService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String maintenanceIdStr = request.getParameter("id");

        try {
            if (maintenanceIdStr == null || maintenanceIdStr.isEmpty()) {
                throw new IllegalArgumentException("Identifiant de maintenance manquant.");
            }

            Long maintenanceId = Long.parseLong(maintenanceIdStr);

            // Récupérer la maintenance
            Maintenance maintenance = maintenanceService.trouverParId(maintenanceId);
            if (maintenance == null) {
                throw new IllegalArgumentException("Maintenance non trouvée.");
            }

            // Marquer comme terminée
            maintenance.setTerminee(true);
            maintenanceService.mettreAJourMaintenance(maintenance);

            // Remettre la voiture disponible (hors maintenance)
            Voiture voiture = maintenance.getVoiture();
            voiture.setEnMaintenance(false);
            voitureService.mettreAJourVoiture(voiture);

            request.getSession().setAttribute("message", "Maintenance terminée et voiture remise en service.");

        } catch (Exception e) {
            request.getSession().setAttribute("erreur", "Erreur lors du retour de maintenance : " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/AgenceServlet");

    }
}
