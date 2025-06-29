package com.agence.agencevoiture.test;

import com.agence.agencevoiture.dao.UtilisateurDAO;
import com.agence.agencevoiture.entity.Utilisateur;

public class TestInsertionUtilisateurs {
    public static void main(String[] args) {
        UtilisateurDAO dao = new UtilisateurDAO();

        Utilisateur papi = new Utilisateur();
        papi.setNom("DIOP");
        papi.setPrenom("Papa Bothie");
        papi.setIdentifiant("gestionnaire@agence.ma");
        papi.setEmail("papi@agence.com");
        papi.setMotDePasse("password"); // à hasher
        papi.setRole("gestionnaire");

        Utilisateur modou = new Utilisateur();
        modou.setNom("POUYE");
        modou.setIdentifiant("chef@agence.ma");
        modou.setPrenom("Modou");
        modou.setEmail("modou@agence.com");
        modou.setMotDePasse("password");
        modou.setRole("chef");

        dao.creerUtilisateur(papi);
        dao.creerUtilisateur(modou);

        System.out.println("Utilisateurs ajoutés avec succès.");
    }
}
