package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.LocationDAO;
import com.agence.agencevoiture.dao.VoitureDAO;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;

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






    public List<Voiture> rechercherVoituresDisponibles(String marque, String carburant, String categorie, Integer kmMax, Integer anneeMin) {
        return voitureDAO.trouverTous().stream()
                .filter(Voiture::isDisponible)
                .filter(v -> marque == null || marque.isEmpty() || v.getMarque().equalsIgnoreCase(marque))
                .filter(v -> carburant == null || carburant.isEmpty() || v.getTypeCarburant().equalsIgnoreCase(carburant))
                .filter(v -> categorie == null || categorie.isEmpty() || v.getCategorie().equalsIgnoreCase(categorie))
                .filter(v -> kmMax == null || v.getKilometrage() <= kmMax)
                .filter(v -> anneeMin == null ||
                        (v.getDateMiseEnCirculation() != null &&
                                v.getDateMiseEnCirculation().toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate().getYear() >= anneeMin))
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

    public Voiture trouverVoitureImm(String immatriculation){

        if(immatriculation == null || immatriculation.trim().isEmpty()){
            return null;
        }
        return voitureDAO.trouverVoiture(immatriculation);
    }

    public List<Voiture> listerVoituresDisponibles() {
        return voitureDAO.findVoituresDisponibles();
    }

    private final LocationDAO locationDAO = new LocationDAO();

    public boolean supprimerVoitureSiNonReserveeActive(String immatriculation) {
        Voiture voiture = voitureDAO.trouverVoiture(immatriculation);
        if (voiture == null) return false;

        // Vérifie s'il y a des réservations actives
        boolean hasActive = voiture.getLocations().stream()
                .anyMatch(r -> r.getStatut() == Location.StatutLocation.EN_COURS
                        || r.getStatut() == Location.StatutLocation.CONFIRMEE);

        if (hasActive) {
            return false;
        }

        try {
            // Déconnecte manuellement la relation voiture -> location
            for (Location loc : voiture.getLocations()) {
                loc.setVoiture(null); // IMPORTANT
                locationDAO.MiseAJour(loc); // Persist la modification
            }

            voitureDAO.supprimerVoiture(voiture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public Long totalVoitures() {
        return voitureDAO.compterVoitures();
    }

    public List<Object[]> voituresLesPlusLouees(int topN) {
        return voitureDAO.trouverVoituresTopLoueés(topN);
    }

}
