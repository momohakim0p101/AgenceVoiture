package com.agence.agencevoiture.entity;

import jakarta.persistence.*;

import java.util.List;

@Entity

@Table(name="clients")
public class Client {
    @Id
    @Column(name="cin", length=20)
    private String cin;

    @Column(name="prenom", nullable = false)
    private String prenom;

    @Column(name = "nom", nullable = false)
    private String nom;

    @Column(name = "sexe", length = 1)
    private String sexe;

    @Column(name = "adresse")
    private String adresse;

    @Column(name = "email", unique = true)
    private String email;

    @Column(name = "telephone", unique = true)
    private String telephone;
    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    private List<Location> location;

    @Transient
    public int getNombreLocations() {
        return location != null ? location.size() : 0;
    }



    public Client() {
        // constructeur vide nécessaire pour JPA
    }


    public Client(String cin, String nom, String prenom, String email, String telephone, String adresse, String sexe) {

        this.cin = cin;
        this.prenom = prenom;
        this.nom = nom;
        this.sexe = sexe;
        this.adresse = adresse;
        this.email = email;
        this.telephone = telephone;
        this.location = location;
    }

    public String getCin() {
        return cin;
    }

    public void setCin(String cin) {
        this.cin = cin;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public List<Location> getReservation() {
        return location;
    }

    public void setReservation(List<Location> location) {
        this.location = location;
    }




    @Override
    public String toString() {
        return "Client{" +
                "cin='" + cin + '\'' +
                ", prenom='" + prenom + '\'' +
                ", nom='" + nom + '\'' +
                ", sexe='" + sexe + '\'' +
                ", adresse='" + adresse + '\'' +
                ", email='" + email + '\'' +
                ", telephone='" + telephone + '\'' +
                ", reservation=" + location +
                '}';
    }
    public String toJson() {
        return String.format(
                "{\"cin\":\"%s\",\"prenom\":\"%s\",\"nom\":\"%s\",\"telephone\":\"%s\",\"email\":\"%s\",\"adresse\":\"%s\",\"sexe\":\"%s\"}",
                cin, prenom, nom, telephone, email, adresse, sexe
        );
    }

}
