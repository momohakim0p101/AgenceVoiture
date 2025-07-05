package com.agence.agencevoiture.dao;

import com.agence.agencevoiture.entity.Maintenance;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;

import java.util.List;

/**
 * DAO pour la gestion des opérations CRUD sur les maintenances.
 */
public class MaintenanceDAO {

    private final EntityManager em;

    public MaintenanceDAO() {
        this.em = Persistence
                .createEntityManagerFactory("pu")
                .createEntityManager();
    }

    /**
     * Crée une nouvelle maintenance.
     */
    public void creerMaintenance(Maintenance maintenance) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(maintenance);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        }
    }

    /**
     * Met à jour une maintenance existante.
     */
    public void miseAJour(Maintenance maintenance) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(maintenance);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        }
    }

    /**
     * Supprime une maintenance.
     */
    public void supprimerMaintenance(Maintenance maintenance) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Maintenance m = em.find(Maintenance.class, maintenance.getId());
            if (m != null) {
                em.remove(m);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        }
    }

    /**
     * Trouve une maintenance par son ID.
     */
    public Maintenance trouverParId(Long id) {
        return em.find(Maintenance.class, id);
    }

    /**
     * Récupère toutes les maintenances.
     */
    public List<Maintenance> trouverToutes() {
        TypedQuery<Maintenance> query = em.createQuery("SELECT m FROM Maintenance m", Maintenance.class);
        return query.getResultList();
    }

    /**
     * Récupère les maintenances associées à une voiture.
     */
    public List<Maintenance> trouverParVoiture(String immatriculation) {
        TypedQuery<Maintenance> query = em.createQuery(
                "SELECT m FROM Maintenance m WHERE m.voiture.immatriculation = :immatriculation",
                Maintenance.class
        );
        query.setParameter("immatriculation", immatriculation);
        return query.getResultList();
    }
}
