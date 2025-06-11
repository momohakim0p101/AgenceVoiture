package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.FactureDAO;
import com.agence.agencevoiture.entity.Facture;
import com.agence.agencevoiture.entity.Location;

import java.util.Date;
import java.util.List;

public class FactureService {
    private final FactureDAO factureDAO;

    public FactureService() {
        this.factureDAO = new FactureDAO();
    }

    public boolean genererFacture(Location location, String signatureClient, String signatureGestionnaire) {
        if (location == null || location.getIdReservation() == null) {
            return false;
        }

        Facture facture = new Facture();
        facture.setReservation(location);
        facture.setDateEmission(new Date());
        facture.setMontant(location.getMontantTotal());
        facture.setSignatureClient(signatureClient);
        facture.setSignatureGestionnaire(signatureGestionnaire);

        try {
            factureDAO.creerFacture(facture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Facture trouverFacture(Long id) {
        return factureDAO.trouverFacture(id);
    }

    public List<Facture> toutesLesFactures() {
        return factureDAO.trouverTous();
    }

    public boolean supprimerFacture(Long id) {
        Facture facture = factureDAO.trouverFacture(id);
        if (facture == null) return false;

        try {
            factureDAO.supprimerFacture(facture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean miseAJourFacture(Facture facture) {
        if (facture == null || facture.getIdFacture() == null) return false;

        try {
            factureDAO.miseAJour(facture);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
