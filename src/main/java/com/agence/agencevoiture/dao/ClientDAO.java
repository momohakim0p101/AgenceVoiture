package com.agence.agencevoiture.dao;


import com.agence.agencevoiture.entity.Client;
import jakarta.persistence.Persistence;
import jakarta.persistence.EntityManager;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.eclipse.persistence.jpa.JpaEntityManagerFactory;

import java.util.List;

import static org.eclipse.persistence.jpa.JpaHelper.getEntityManager;


public class ClientDAO {

    private final EntityManager entityManager;
    //on a ajoueter ça pour la recherche
    public ClientDAO() {
        this.entityManager = Persistence
                .createEntityManagerFactory("Gestion_agence_voiture")
                .createEntityManager();
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    private static  final JpaEntityManagerFactory emf = (JpaEntityManagerFactory) Persistence.createEntityManagerFactory("pu");


    public void creerClient(Client client) {
          EntityManager em = emf.createEntityManager();
          em.getTransaction().begin();
          em.persist(client);
          em.getTransaction().commit();
          em.close();
      }

    public Client trouverClient(String cin){
          EntityManager em = emf.createEntityManager();
          Client client = em.find(Client.class, cin);
          em.close();
          return client;
    }

    public List<Client> trouverTous(){
          EntityManager em = emf.createEntityManager();
          List<Client> clients = em.createQuery("select c from Client c",Client.class).getResultList();
          em.close();
          return clients;
    }

    public void supprimerClient(Client client){
          EntityManager em = emf.createEntityManager();
          em.getTransaction().begin();
          client = em.merge(client);
          em.remove(client);
          em.getTransaction().commit();
          em.close();
    }

    public void miseAJour(Client client){
          EntityManager em = emf.createEntityManager();
          em.getTransaction().begin();
          em.merge(client);
          em.getTransaction().commit();
          em.close();
    }
    public List<Client> rechercherParNom(String nom) {
        EntityManager em = emf.createEntityManager();
        List<Client> clients = em.createQuery("SELECT c FROM Client c WHERE LOWER(c.nom) LIKE LOWER(:nom)", Client.class)
                .setParameter("nom", "%" + nom + "%")
                .getResultList();
        em.close();
        return clients;
    }

    public List<Client> findAll() {
        return entityManager
                .createQuery("SELECT c FROM Client c", Client.class)
                .getResultList();
    }

    public List<Client> rechercherParNomPrenomOuCin(String motCle) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                            "SELECT c FROM Client c WHERE " +
                                    "LOWER(c.nom) LIKE :mc OR " +
                                    "LOWER(c.prenom) LIKE :mc OR " +
                                    "LOWER(c.cin) LIKE :mc", Client.class)
                    .setParameter("mc", "%" + motCle + "%")
                    .getResultList();
        } finally {
            em.close();
        }
    }



}




