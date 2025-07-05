package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.MaintenanceDAO;
import com.agence.agencevoiture.entity.Maintenance;

import java.util.List;

/**
 * Service métier pour la gestion des maintenances des voitures.
 */
public class MaintenanceService {

    private final MaintenanceDAO maintenanceDAO;

    public MaintenanceService() {
        this.maintenanceDAO = new MaintenanceDAO();
    }

    /**
     * Ajoute une nouvelle maintenance.
     *
     * @param maintenance La maintenance à ajouter.
     * @return true si l'ajout est réussi, false sinon.
     */
    public boolean ajouterMaintenance(Maintenance maintenance) {
        if (maintenance == null || maintenance.getVoiture() == null) {
            return false;
        }

        try {
            maintenanceDAO.creerMaintenance(maintenance);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de l'ajout de la maintenance : " + e.getMessage());
            return false;
        }
    }

    /**
     * Met à jour une maintenance existante.
     *
     * @param maintenance La maintenance mise à jour.
     * @return true si la mise à jour est réussie, false sinon.
     */
    public boolean modifierMaintenance(Maintenance maintenance) {
        if (maintenance == null || maintenance.getId() == null) {
            return false;
        }

        try {
            maintenanceDAO.miseAJour(maintenance);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la modification de la maintenance : " + e.getMessage());
            return false;
        }
    }

    /**
     * Supprime une maintenance selon son ID.
     *
     * @param id ID de la maintenance à supprimer.
     * @return true si la suppression est réussie, false sinon.
     */
    public boolean supprimerMaintenance(Long id) {
        if (id == null) {
            return false;
        }

        Maintenance m = maintenanceDAO.trouverParId(id);
        if (m == null) return false;

        try {
            maintenanceDAO.supprimerMaintenance(m);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la suppression de la maintenance : " + e.getMessage());
            return false;
        }
    }

    /**
     * Recherche une maintenance par son ID.
     *
     * @param id L'identifiant de la maintenance.
     * @return La maintenance trouvée, ou null.
     */
    public Maintenance trouverParId(Long id) {
        if (id == null) return null;
        return maintenanceDAO.trouverParId(id);
    }

    /**
     * Récupère toutes les maintenances enregistrées.
     *
     * @return Liste des maintenances.
     */
    public List<Maintenance> listerToutes() {
        return maintenanceDAO.trouverToutes();
    }

    /**
     * Récupère les maintenances d’une voiture spécifique.
     *
     * @param immatriculation L’immatriculation de la voiture.
     * @return Liste des maintenances associées.
     */
    public List<Maintenance> listerParVoiture(String immatriculation) {
        if (immatriculation == null || immatriculation.trim().isEmpty()) {
            return List.of();
        }
        return maintenanceDAO.trouverParVoiture(immatriculation.trim());
    }
}
