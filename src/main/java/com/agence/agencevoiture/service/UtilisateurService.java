package com.agence.agencevoiture.service;

import com.agence.agencevoiture.entity.Utilisateur;
import jakarta.persistence.*;

public class UtilisateurService {

    private EntityManagerFactory emf;

    public UtilisateurService(){
        this.emf = Persistence.createEntityManagerFactory("pu");
    }

    public  Utilisateur authentifier(String identifiant, String motDePasse, String role){
        EntityManager em = emf.createEntityManager();

        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                    "SELECT u FROM Utilisateur u WHERE u.identifiant = :identifiant AND u.motDePasse = :motDePasse AND u.role = :role",
                    Utilisateur.class
            );            query.setParameter("identifiant", identifiant);
            query.setParameter("motDePasse", motDePasse);
            query.setParameter("role", role.toUpperCase());

            return query.getSingleResult();
        } catch (NoResultException e){
            return null;
        } finally {
            em.close();
        }
    }
}
