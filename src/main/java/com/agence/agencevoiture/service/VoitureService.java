package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.VoitureDAO;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.entity.Location;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.time.ZoneId;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class VoitureService {
    private final VoitureDAO voitureDAO;
    private final EntityManager em;

    public VoitureService() {
        this.voitureDAO = new VoitureDAO();
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("pu");
        this.em = emf.createEntityManager();
    }

    public boolean ajouterVoiture(Voiture voiture) {
        if (voiture == null || voiture.getImmatriculation() == null) {
            return false;
        }

        if (voitureDAO.trouverVoiture(voiture.getImmatriculation()) != null) {
            return false;
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

    public List<Voiture> rechercherVoituresDisponibles(String marque, String carburant, String categorie, Integer kmMax, Integer anneeMin) {
        return voitureDAO.trouverTous().stream()
                .filter(Voiture::isDisponible)
                .filter(v -> marque == null || marque.isEmpty() || v.getMarque().equalsIgnoreCase(marque))
                .filter(v -> carburant == null || carburant.isEmpty() || v.getTypeCarburant().equalsIgnoreCase(carburant))
                .filter(v -> categorie == null || categorie.isEmpty() || v.getCategorie().equalsIgnoreCase(categorie))
                .filter(v -> kmMax == null || v.getKilometrage() <= kmMax)
                .filter(v -> anneeMin == null ||
                        (v.getDateMiseEnCirculation() != null &&
                                v.getDateMiseEnCirculation().toInstant().atZone(ZoneId.systemDefault()).toLocalDate().getYear() >= anneeMin))
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

    public Voiture trouverVoitureImm(String immatriculation) {
        if (immatriculation == null || immatriculation.trim().isEmpty()) {
            return null;
        }
        return voitureDAO.trouverVoiture(immatriculation);
    }

    public List<Voiture> listerVoituresDisponibles() {
        return voitureDAO.findVoituresDisponibles();
    }

    public long totalVoitures() {
        return voitureDAO.trouverTous().size();
    }

    // Correction ici : plus static, et utilise l'EntityManager local
    public List<Object[]> voituresLesPlusLouees(int limite) {
        return em.createQuery(
                        "SELECT l.voiture, COUNT(l) as nb " +
                                "FROM Location l GROUP BY l.voiture ORDER BY nb DESC", Object[].class)
                .setMaxResults(limite)
                .getResultList();
    }

    public List<Voiture> rechercherVoitures(String query) {
        if (query == null || query.trim().isEmpty()) {
            return listerToutesLesVoitures();
        }
        query = query.toLowerCase();
        String finalQuery = query;
        return voitureDAO.trouverTous().stream()
                .filter(v -> v.getMarque().toLowerCase().contains(finalQuery)
                        || v.getModele().toLowerCase().contains(finalQuery))
                .collect(Collectors.toList());
    }
}
