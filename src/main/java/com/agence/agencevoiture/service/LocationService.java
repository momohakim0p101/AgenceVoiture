package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.LocationDAO;
import com.agence.agencevoiture.dao.VoitureDAO;
import com.agence.agencevoiture.entity.Voiture;

public class LocationService {

    private static VoitureDAO voitureDAO;
    private static LocationDAO locationDAO;

    public void enrigistrerRetour(String immatriculation, double nouveaukilometrage){
        Voiture voiture = voitureDAO.trouverVoiture(immatriculation);


    }
}
