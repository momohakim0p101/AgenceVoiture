package com.agence.agencevoiture.controller;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.LocationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "ExporterVoitureActifServlet", urlPatterns = "/ExporterVoitureActifServlet")
@MultipartConfig
public class ExporterVoitureActifServlet extends HttpServlet {

    private LocationService locationService = new LocationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer toutes les locations en cours (voitures louées)
        List<Location> locationsEnCours = locationService.getLocationsEnCours();

        // Préparer le nom et le format du fichier CSV
        String fileName = "voitures_en_location.csv";

        // Configurer la réponse HTTP pour le téléchargement
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setCharacterEncoding("UTF-8");

        // Format date lisible
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        try (PrintWriter writer = response.getWriter()) {
            // En-tête CSV
            writer.println("ID Location,Client,Voiture,Marque,Modèle,Date Début,Date Fin,Montant Total,F CFA,Statut");

            // Boucle sur toutes les locations actives
            for (Location loc : locationsEnCours) {
                Voiture v = loc.getVoiture();
                String ligne = String.format("%d,%s,%s,%s,%s,%s,%s,%.2f,%s",
                        loc.getIdReservation(),
                        loc.getClient().getNom().replaceAll(",", " "), // éviter les virgules dans CSV
                        v.getImmatriculation().replaceAll(",", " "),
                        v.getMarque().replaceAll(",", " "),
                        v.getModele().replaceAll(",", " "),
                        sdf.format(loc.getDateDebut()),
                        sdf.format(loc.getDateFin()),
                        loc.getMontantTotal(),
                        "F CFA",
                        loc.getStatut().name()
                );
                writer.println(ligne);
            }
            writer.flush();
        }
    }
}
