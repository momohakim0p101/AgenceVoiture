package com.agence.agencevoiture.dao;


import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.utils.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import org.eclipse.persistence.jpa.JpaEntityManagerFactory;


import java.time.LocalDate;
import java.util.List;

import static org.eclipse.persistence.jpa.JpaHelper.getEntityManager;

public class LocationDAO {

    private static final JpaEntityManagerFactory emf = (JpaEntityManagerFactory) Persistence.createEntityManagerFactory("pu");

    private EntityManager getEntityManager() {
        return JPAUtil.getEntityManagerFactory().createEntityManager();
    }
    public void creerLocation(Location location){
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(location);
        em.getTransaction().commit();
        em.close();
    }

    public List<Location> findByStatut(Location.StatutLocation statut) {
        TypedQuery<Location> query = emf.createEntityManager().createQuery(
                "SELECT l FROM Location l WHERE l.statut = :statut", Location.class);
        query.setParameter("statut", statut);
        return query.getResultList();
    }

    public List<Location> findByStatuts(List<Location.StatutLocation> statuts) {
        TypedQuery<Location> query = emf.createEntityManager().createQuery(
                "SELECT l FROM Location l WHERE l.statut IN :statuts", Location.class);
        query.setParameter("statuts", statuts);
        return query.getResultList();
    }


    public Location trouverLocation(Long id_reservation){
        EntityManager em = emf.createEntityManager();
        Location location = em.find(Location.class, id_reservation);
        em.close();
        return location;
    }

    public void supprimerLocation(Location location){
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        location = em.merge(location);
        em.remove(location);
        em.getTransaction().commit();
        em.close();

    }

    public List<Location> trouverTous(){
        EntityManager em = emf.createEntityManager();
        List<Location> locations = em.createQuery("select r from Location r", Location.class).getResultList();
        em.close();
        return locations;}

    public void MiseAJour(Location location) {

     EntityManager em = emf.createEntityManager();
     em.getTransaction().begin();
     em.merge(location);
     em.getTransaction().commit();
     em.close();
    }

    public List<Location> rechercherParMarqueEtDate(String marque, LocalDate dateRecherche) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                            "SELECT l FROM Location l " +
                                    "WHERE (:marque IS NULL OR LOWER(l.voiture.marque) LIKE :marque) " +
                                    "AND (:dateRecherche IS NULL OR l.dateDebut = :dateRecherche OR l.dateFin = :dateRecherche)",
                            Location.class)
                    .setParameter("marque", marque != null ? "%" + marque.toLowerCase() + "%" : null)
                    .setParameter("dateRecherche", dateRecherche)
                    .getResultList();

        } finally {
            em.close();
        }
    }



}
