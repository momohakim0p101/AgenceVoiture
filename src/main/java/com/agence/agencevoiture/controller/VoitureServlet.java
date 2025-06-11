package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.VoitureService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/voiture")
public class VoitureServlet extends HttpServlet {

    private final VoitureService voitureService = new VoitureService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Voiture> voitures = voitureService.listerToutesLesVoitures();
        request.setAttribute("voitures", voitures);
        request.getRequestDispatcher("voiture.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "ajouter":
                ajouterVoiture(request, response);
                break;
            case "supprimer":
                supprimerVoiture(request, response);
                break;
            case "modifier":
                modifierVoiture(request, response);
                break;
            default:
                request.setAttribute("erreur", "Action non reconnue.");
                doGet(request, response);
        }
    }

    private void ajouterVoiture(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Voiture voiture = extractVoitureFromRequest(request);
            boolean success = voitureService.ajouterVoiture(voiture);

            request.setAttribute(success ? "message" : "erreur",
                    success ? "Voiture ajoutée avec succès." : "Échec de l'ajout (doublon ?)");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de l'ajout.");
        }

        doGet(request, response);
    }

    private void supprimerVoiture(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String immat = request.getParameter("immatriculation");

        boolean success = voitureService.supprimerVoiture(immat);
        request.setAttribute(success ? "message" : "erreur",
                success ? "Voiture supprimée." : "Voiture introuvable.");
        doGet(request, response);
    }

    private void modifierVoiture(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Voiture voiture = extractVoitureFromRequest(request);
            boolean success = voitureService.mettreAJourVoiture(voiture);

            request.setAttribute(success ? "message" : "erreur",
                    success ? "Voiture mise à jour avec succès." : "Échec de la mise à jour.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de la mise à jour.");
        }

        doGet(request, response);
    }

    private Voiture extractVoitureFromRequest(HttpServletRequest request) throws Exception {
        String immatriculation = request.getParameter("immatriculation");
        int places = Integer.parseInt(request.getParameter("nombrePlaces"));
        String marque = request.getParameter("marque");
        String modele = request.getParameter("modele");
        Date miseEnCirc = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("dateMiseEnCirculation"));
        double km = Double.parseDouble(request.getParameter("kilometrage"));
        String carburant = request.getParameter("typeCarburant");
        String categorie = request.getParameter("categorie");
        double prix = Double.parseDouble(request.getParameter("prixLocationJour"));
        boolean dispo = "on".equals(request.getParameter("disponible"));

        Voiture voiture = new Voiture();
        voiture.setImmatriculation(immatriculation);
        voiture.setNombrePlaces(places);
        voiture.setMarque(marque);
        voiture.setModele(modele);
        voiture.setDateMiseEnCirculation(miseEnCirc);
        voiture.setKilometrage(km);
        voiture.setTypeCarburant(carburant);
        voiture.setCategorie(categorie);
        voiture.setPrixLocationJour(prix);
        voiture.setDisponible(dispo);

        return voiture;
    }
}
