package com.agence.agencevoiture.test;

import com.agence.agencevoiture.dao.UtilisateurDAO;
import com.agence.agencevoiture.entity.Utilisateur;

public class TestInsertionUtilisateurs {
    public static void main(String[] args) {
        UtilisateurDAO dao = new UtilisateurDAO();

        Utilisateur papi = new Utilisateur();
        papi.setNom("Diop");
        papi.setPrenom("Papi");
        papi.setIdentifiant("Papi123@");
        papi.setEmail("papi@agence.com");
        papi.setMotDePasse("papi123"); // à hasher
        papi.setRole("gestionnaire");

        Utilisateur modou = new Utilisateur();
        modou.setNom("Fall");
        modou.setIdentifiant("modou123@");
        modou.setPrenom("Modou");
        modou.setEmail("modou@agence.com");
        modou.setMotDePasse("modou123");
        modou.setRole("chef");

        dao.creerUtilisateur(papi);
        dao.creerUtilisateur(modou);

        System.out.println("Utilisateurs ajoutés avec succès.");
    }
}
