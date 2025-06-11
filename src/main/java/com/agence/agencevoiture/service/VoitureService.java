package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.VoitureDAO;
import com.agence.agencevoiture.entity.Voiture;

import java.util.List;

public class VoitureService {
    private final VoitureDAO voitureDAO;

    public VoitureService() {
        this.voitureDAO = new VoitureDAO();
    }

    public boolean ajouterVoiture(Voiture voiture) {
        if (voiture == null || voiture.getImmatriculation() == null) {
            return false;
        }

        if (voitureDAO.trouverVoiture(voiture.getImmatriculation()) != null) {
            return false; // Voiture déjà existante
        }

        try {
            voitureDAO.creerVoiture(voiture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Voiture rechercherParImmatriculation(String immat) {
        if (immat == null || immat.isEmpty()) return null;
        return voitureDAO.trouverVoiture(immat);
    }

    public boolean supprimerVoiture(String immat) {
        Voiture voiture = voitureDAO.trouverVoiture(immat);
        if (voiture == null) return false;

        try {
            voitureDAO.supprimerVoiture(voiture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean mettreAJourVoiture(Voiture voiture) {
        if (voiture == null || voiture.getImmatriculation() == null) {
            return false;
        }

        try {
            voitureDAO.miseAJour(voiture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Voiture> listerToutesLesVoitures() {
        return voitureDAO.trouverTous();
    }

    public List<Voiture> listerVoituresDisponibles() {
        return voitureDAO.trouverTous().stream()
                .filter(Voiture::isDisponible)
                .toList();
    }
}
