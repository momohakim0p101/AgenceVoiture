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
                    "SELECT u FROM Utilisateur u WHERE LOWER(u.identifiant) = LOWER(:identifiant) AND u.motDePasse = :motDePasse AND LOWER(u.role) = LOWER(:role)",
                    Utilisateur.class
            );
            query.setParameter("identifiant", identifiant);
            query.setParameter("motDePasse", motDePasse);
            query.setParameter("role", role);

            return query.getSingleResult();
        } catch (NoResultException e){
            return null;
        } finally {
            em.close();
        }
    }
}
