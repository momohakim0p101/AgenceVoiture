package com.agence.agencevoiture.dao;

import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.eclipse.persistence.jpa.JpaEntityManagerFactory;


import java.util.List;



public class VoitureDAO {

        private static final JpaEntityManagerFactory emf = (JpaEntityManagerFactory) Persistence.createEntityManagerFactory("pu");

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
        String jpql = "SELECT v FROM Voiture v " +
                "WHERE v NOT IN (" +
                "  SELECT l.voiture FROM Location l WHERE l.statut = :enCours OR l.statut = :confirmee" +
                ") AND v.enMaintenance = false";

        EntityManager em = emf.createEntityManager();
        TypedQuery<Voiture> query = em.createQuery(jpql, Voiture.class);
        query.setParameter("enCours", Location.StatutLocation.EN_COURS);
        query.setParameter("confirmee", Location.StatutLocation.CONFIRMEE);
        List<Voiture> result = query.getResultList();
        em.close();
        return result;
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

    public long compterVoitures() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT COUNT(v) FROM Voiture v", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

}
