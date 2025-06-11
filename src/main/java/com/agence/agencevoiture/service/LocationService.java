package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.LocationDAO;
import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;

import java.util.Date;
import java.util.List;

public class LocationService {
    private final LocationDAO locationDAO;

    public LocationService() {
        this.locationDAO = new LocationDAO();
    }

    public boolean reserverVoiture(Client client, Voiture voiture, Date dateDebut, Date dateFin, double prixJour) {
        if (client == null || voiture == null || dateDebut == null || dateFin == null || !dateFin.after(dateDebut)) {
            return false;
        }

        Location location = new Location();
        location.setClient(client);
        location.setVoiture(voiture);
        location.setDateDebut(dateDebut);
        location.setDateFin(dateFin);
        long diffJours = (dateFin.getTime() - dateDebut.getTime()) / (1000 * 60 * 60 * 24);
        location.setMontantTotal(diffJours * prixJour);
        location.setStatut("Confirmée");

        try {
            locationDAO.creerLocation(location);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean terminerLocation(Long idReservation) {
        Location location = locationDAO.trouverLocation(idReservation);
        if (location == null || !"Confirmée".equals(location.getStatut())) {
            return false;
        }

        location.setStatut("Terminée");

        try {
            locationDAO.MiseAJour(location);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean annulerLocation(Long idReservation) {
        Location location = locationDAO.trouverLocation(idReservation);
        if (location == null || !"Confirmée".equals(location.getStatut())) {
            return false;
        }

        location.setStatut("Annulée");

        try {
            locationDAO.MiseAJour(location);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Location> listerToutesLesLocations() {
        return locationDAO.trouverTous();
    }

    public Location chercherParId(Long id) {
        return locationDAO.trouverLocation(id);
    }

    public boolean supprimerLocation(Long id) {
        Location location = locationDAO.trouverLocation(id);
        if (location == null) return false;

        try {
            locationDAO.supprimerLocation(location);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean mettreAJourLocation(Location location) {
        if (location == null || location.getIdReservation() == null) {
            return false;
        }

        try {
            locationDAO.MiseAJour(location);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
