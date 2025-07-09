package com.agence.agencevoiture.dao;

import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.eclipse.persistence.jpa.JpaEntityManagerFactory;


import java.util.List;

import static org.eclipse.persistence.jpa.JpaHelper.getEntityManager;


public class VoitureDAO {

        private static final JpaEntityManagerFactory emf = (JpaEntityManagerFactory) Persistence.createEntityManagerFactory("pu");

    private EntityManager getEntityManager() {
        return jakarta.persistence.Persistence
                .createEntityManagerFactory("Gestion_agence_voiture")
                .createEntityManager();
    }

    public void creerVoiture(Voiture voiture){
            EntityManager em = emf.createEntityManager();
            em.getTransaction().begin();
            em.persist(voiture);
            em.getTransaction().commit();
            em.close();
        }

        public  Voiture trouverVoiture(String immatriculation){
            EntityManager em = emf.createEntityManager();
            Voiture voiture = em.find(Voiture.class, immatriculation);
            em.close();
            return voiture;
        }


    public List<Voiture> findVoituresDisponibles() {
        String jpql = "SELECT v FROM Voiture v WHERE v NOT IN (" +
                "SELECT l.voiture FROM Location l WHERE l.statut = :enCours OR l.statut = :Confirmee" +
                ")";
        TypedQuery<Voiture> query = emf.createEntityManager().createQuery(jpql, Voiture.class);
        query.setParameter("enCours", Location.StatutLocation.EN_COURS);
        query.setParameter("Confirmee", Location.StatutLocation.CONFIRMEE);
        return query.getResultList();
    }

    public List<Voiture> trouverTous(){
        EntityManager em = emf.createEntityManager();
        List<Voiture> voitures = em.createQuery("select v from Voiture v", Voiture.class).getResultList();
        em.close();
        return voitures;
    }


    public void supprimerVoiture(Voiture voiture){
            EntityManager em = emf.createEntityManager();
            em.getTransaction().begin();
            voiture = em.merge(voiture);
            em.remove(voiture);
            em.getTransaction().commit();
            em.close();
        }

        public void miseAJour(Voiture voiture){
            EntityManager em = emf.createEntityManager();
            em.getTransaction().begin();
            em.merge(voiture);
            em.getTransaction().commit();
            em.close();
        }

    public List<Object[]> trouverVoituresTopLoueés(int topN) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v, COUNT(l) AS nbLocations " +
                    "FROM Voiture v JOIN v.locations l " +
                    "GROUP BY v " +
                    "ORDER BY nbLocations DESC";
            TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
            query.setMaxResults(topN);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Voiture> rechercherParMarqueEtModele(String marque, String modele) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                            "SELECT v FROM Voiture v WHERE " +
                                    "(:marque IS NULL OR LOWER(v.marque) LIKE LOWER(CONCAT('%', :marque, '%'))) AND " +
                                    "(:modele IS NULL OR LOWER(v.modele) LIKE LOWER(CONCAT('%', :modele, '%')))",
                            Voiture.class)
                    .setParameter("marque", marque != null && !marque.trim().isEmpty() ? marque : null)
                    .setParameter("modele", modele != null && !modele.trim().isEmpty() ? modele : null)
                    .getResultList();
        } finally {
            em.close();
        }
    }



}
