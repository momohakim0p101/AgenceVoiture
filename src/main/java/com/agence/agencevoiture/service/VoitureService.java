package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.VoitureDAO;
import com.agence.agencevoiture.entity.Voiture;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.stream.Collectors;

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

    public List<Voiture> rechercherParCriteres(String marque, String carburant, String categorie) {
        return voitureDAO.trouverTous().stream()
                .filter(v -> (marque == null || v.getMarque().equalsIgnoreCase(marque)))
                .filter(v -> (carburant == null || v.getTypeCarburant().equalsIgnoreCase(carburant)))
                .filter(v -> (categorie == null || v.getCategorie().equalsIgnoreCase(categorie)))
                .collect(Collectors.toList());

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
                .collect(Collectors.toList());
    }
    public boolean changerDisponibilite(String immat, boolean disponible) {
        Voiture voiture = voitureDAO.trouverVoiture(immat);
        if (voiture == null) return false;
        voiture.setDisponible(disponible);
        try {
            voitureDAO.miseAJour(voiture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


}
