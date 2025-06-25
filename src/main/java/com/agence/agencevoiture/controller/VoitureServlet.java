package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.VoitureService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/VoitureServlet")
public class VoitureServlet extends HttpServlet {

    private VoitureService voitureService;
    private static final Logger logger = Logger.getLogger(VoitureServlet.class.getName());

    @Override
    public void init() {
        voitureService = new VoitureService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "save" -> ajouterVoiture(req, resp);
                case "update" -> modifierVoiture(req, resp);
                case "delete" -> supprimerVoiture(req, resp);
                default -> redirigerAvecErreur(resp, "action_inconnue");
            }
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Erreur de format numérique", e);
            redirigerAvecErreur(resp, "format_invalide");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Erreur dans doPost", e);
            redirigerAvecErreur(resp, "exception");
        }
    }

    // ----- Méthodes privées -----

    private void afficherListeVoitures(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Voiture> voitures = voitureService.listerToutesLesVoitures();
        req.setAttribute("voitures", voitures);
        req.getRequestDispatcher("/GestionVoiture.jsp").forward(req, resp);
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

    private Voiture construireVoitureDepuisRequete(HttpServletRequest req) throws NumberFormatException {
        String immatriculation = req.getParameter("immatriculation");
        String marque = req.getParameter("marque");
        String modele = req.getParameter("modele");
        String typeCarburant = req.getParameter("typeCarburant");
        String categorie = req.getParameter("categorie");
        String prixStr = req.getParameter("prixLocationJour");
        String placesStr = req.getParameter("nombrePlaces");
        String disponibleStr = req.getParameter("disponible");
        String dateStr = req.getParameter("dateMiseEnCirculation");
        String kilometrageStr = req.getParameter("kilometrage");

        // Validation simple : null ou vide
        if (immatriculation == null || marque == null || modele == null ||
                immatriculation.isEmpty() || marque.isEmpty() || modele.isEmpty()) {
            throw new IllegalArgumentException("Champs obligatoires manquants");
        }

        return new Voiture(
                immatriculation, marque, modele,
                typeCarburant, categorie,
                prixStr, placesStr,
                disponibleStr, dateStr, kilometrageStr
        );
    }

    private void redirigerAvecErreur(HttpServletResponse resp, String codeErreur) throws IOException {
        resp.sendRedirect("VoitureServlet?action=view&error=" + codeErreur);
    }

    private void redirigerSansErreur(HttpServletResponse resp) throws IOException {
        resp.sendRedirect("VoitureServlet?action=view");
    }
}
