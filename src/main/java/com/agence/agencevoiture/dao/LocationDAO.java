package com.agence.agencevoiture.dao;


import com.agence.agencevoiture.entity.Location;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Persistence;
import org.eclipse.persistence.jpa.JpaEntityManagerFactory;


import java.util.List;

public class LocationDAO {

    private static final JpaEntityManagerFactory emf = (JpaEntityManagerFactory) Persistence.createEntityManagerFactory("pu");

    public void creerLocation(Location location){
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(location);
        em.getTransaction().commit();
        em.close();
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
}
