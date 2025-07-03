package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.VoitureService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@WebServlet("/VoitureServlet")
public class VoitureServlet extends HttpServlet {

    private VoitureService voitureService;
    private static final Logger logger = Logger.getLogger(VoitureServlet.class.getName());

    @Override
    public void init() {
        voitureService = new VoitureService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");

        try {
            if (action == null || action.equals("view")) {
                afficherListeVoitures(req, resp);
            } else if ("delete".equals(action)) {
                supprimerVoiture(req, resp);
            } else {
                redirigerAvecErreur(resp, "action_inconnue");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Erreur dans doGet", e);
            redirigerAvecErreur(resp, "exception");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "save" -> ajouterVoiture(req, resp);
                case "update" -> modifierVoiture(req, resp);
                case "delete" -> supprimerVoiture(req, resp);
                default -> redirigerAvecErreur(resp, "action_inconnue");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Erreur dans doPost", e);
            redirigerAvecErreur(resp, "exception");
        }
    }

    private void afficherListeVoitures(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<Voiture> voitures = voitureService.listerVoituresDisponibles();

        String query = req.getParameter("query");
        String carburant = req.getParameter("carburant");
        String categorie = req.getParameter("categorie");
        String prixMaxStr = req.getParameter("prixMax");
        String kmMaxStr = req.getParameter("kmMax");
        String sort = req.getParameter("sort");

        // Filtrage
        if (query != null && !query.trim().isEmpty()) {
            voitures = voitures.stream()
                    .filter(v -> v.getMarque().toLowerCase().contains(query.toLowerCase()) ||
                            v.getModele().toLowerCase().contains(query.toLowerCase()) ||
                            v.getImmatriculation().toLowerCase().contains(query.toLowerCase()))
                    .collect(Collectors.toList());
        }

        if (carburant != null && !carburant.isEmpty()) {
            voitures = voitures.stream()
                    .filter(v -> carburant.equalsIgnoreCase(v.getTypeCarburant()))
                    .collect(Collectors.toList());
        }

        if (categorie != null && !categorie.isEmpty()) {
            voitures = voitures.stream()
                    .filter(v -> categorie.equalsIgnoreCase(v.getCategorie()))
                    .collect(Collectors.toList());
        }

        if (prixMaxStr != null && !prixMaxStr.isEmpty()) {
            try {
                double prixMax = Double.parseDouble(prixMaxStr);
                voitures = voitures.stream()
                        .filter(v -> v.getPrixLocationJour() <= prixMax)
                        .collect(Collectors.toList());
            } catch (NumberFormatException ignored) {}
        }

        if (kmMaxStr != null && !kmMaxStr.isEmpty()) {
            try {
                int kmMax = Integer.parseInt(kmMaxStr);
                voitures = voitures.stream()
                        .filter(v -> v.getKilometrage() <= kmMax)
                        .collect(Collectors.toList());
            } catch (NumberFormatException ignored) {}
        }

        // Tri
        if ("prix_asc".equals(sort)) {
            voitures.sort(Comparator.comparingDouble(Voiture::getPrixLocationJour));
        } else if ("prix_desc".equals(sort)) {
            voitures.sort(Comparator.comparingDouble(Voiture::getPrixLocationJour).reversed());
        }

        try {
            req.setAttribute("voitures", voitures);
            req.getRequestDispatcher("/GestionVoiture.jsp").forward(req, resp);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Erreur dans afficherListeVoitures", e);
            redirigerAvecErreur(resp, "affichage");
        }
    }

    private void ajouterVoiture(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Voiture voiture = construireVoitureDepuisRequete(req);
        boolean success = voitureService.ajouterVoiture(voiture);
        if (success) {
            redirigerSansErreur(resp);
        } else {
            redirigerAvecErreur(resp, "ajout");
        }
    }

    private void modifierVoiture(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Voiture voiture = construireVoitureDepuisRequete(req);
        boolean success = voitureService.mettreAJourVoiture(voiture);
        if (success) {
            redirigerSansErreur(resp);
        } else {
            redirigerAvecErreur(resp, "modification");
        }
    }

    private void supprimerVoiture(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String immatriculation = req.getParameter("immatriculation");
        if (immatriculation == null || immatriculation.isEmpty()) {
            redirigerAvecErreur(resp, "champs_obligatoires");
            return;
        }

        boolean success = voitureService.supprimerVoiture(immatriculation);
        if (success) {
            redirigerSansErreur(resp);
        } else {
            redirigerAvecErreur(resp, "suppression");
        }
    }

    private Voiture construireVoitureDepuisRequete(HttpServletRequest req) {
        return new Voiture(
                req.getParameter("immatriculation"),
                req.getParameter("marque"),
                req.getParameter("modele"),
                req.getParameter("typeCarburant"),
                req.getParameter("categorie"),
                req.getParameter("prixLocationJour"),
                req.getParameter("nombrePlaces"),
                req.getParameter("disponible"),
                req.getParameter("dateMiseEnCirculation"),
                req.getParameter("kilometrage"),
                req.getParameter("imageUrl")
        );
    }

    private void redirigerAvecErreur(HttpServletResponse resp, String codeErreur) throws IOException {
        resp.sendRedirect("VoitureServlet?action=view&error=" + codeErreur);
    }

    private void redirigerSansErreur(HttpServletResponse resp) throws IOException {
        resp.sendRedirect("VoitureServlet?action=view");
    }
}
