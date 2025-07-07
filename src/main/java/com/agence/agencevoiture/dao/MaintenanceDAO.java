package com.agence.agencevoiture.dao;

import com.agence.agencevoiture.entity.Maintenance;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.List;

public class MaintenanceDAO {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("pu");

    public void creerMaintenance(Maintenance maintenance) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(maintenance);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void miseAJour(Maintenance maintenance) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(maintenance);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void update(Maintenance maintenance) {
        miseAJour(maintenance);
    }

    public void supprimerMaintenance(Maintenance maintenance) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            Maintenance toRemove = em.merge(maintenance);
            em.remove(toRemove);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Maintenance trouverParId(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Maintenance.class, id);
        } finally {
            em.close();
        }
    }

    public List<Maintenance> trouverToutes() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT m FROM Maintenance m", Maintenance.class).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Maintenance> trouverParVoiture(String immatriculation) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT m FROM Maintenance m WHERE m.voiture.immatriculation = :immatriculation", Maintenance.class)
                    .setParameter("immatriculation", immatriculation)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Maintenance> findMaintenancesEnCours() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery(
                            "SELECT m FROM Maintenance m WHERE m.voiture.enMaintenance = true", Maintenance.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
