package com.agence.agencevoiture.entity;

import jakarta.persistence.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "voiture")
public class Voiture {

    @Id
    @Column(name = "immatriculation", length = 20)
    private String immatriculation;

    @Column(name = "nombre_places")
    private int nombrePlaces;

    @Column(name = "marque", nullable = false)
    private String marque;

    @Column(name = "modele", nullable = false)
    private String modele;

    @Column(name = "date_mise_en_circulation")
    @Temporal(TemporalType.DATE)
    private Date dateMiseEnCirculation;

    @Column(name = "kilometrage")
    private double kilometrage;

    @Column(name = "type_carburant")
    private String typeCarburant; // Essence, Diesel, Électrique...

    @Column(name = "categorie")
    private String categorie; // SUV, Berline, etc.

    @Column(name = "prix_location_jour")
    private double prixLocationJour;

    @Column(name = "disponible")
    private boolean disponible = true;

    @Column(name = "image_path")
    private String imagePath;  // Chemin ou nom du fichier image

    @OneToMany(mappedBy = "voiture")
    private List<Location> locations;
    @OneToMany(mappedBy = "voiture", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Maintenance> maintenances = new ArrayList<>();

    @Column(name = "en_maintenance")
    private boolean enMaintenance = false;

    public boolean isEnMaintenance() {
        return enMaintenance;
    }

    public void setEnMaintenance(boolean enMaintenance) {
        this.enMaintenance = enMaintenance;
    }


    public List<Maintenance> getMaintenances() {
        return maintenances;
    }

    public void setMaintenances(List<Maintenance> maintenances) {
        this.maintenances = maintenances;
    }

    public void ajouterMaintenance(Maintenance m) {
        maintenances.add(m);
        m.setVoiture(this);
    }

    public void retirerMaintenance(Maintenance m) {
        maintenances.remove(m);
        m.setVoiture(null);
    }


    // Constructeur vide obligatoire pour JPA
    public Voiture() {
    }

    /**
     * Constructeur avec conversion depuis des chaînes de caractères.
     * Utile pour créer une instance à partir d'une requête HTTP.
     */
    public Voiture(String immatriculation, String marque, String modele, String typeCarburant, String categorie,
                   String prixStr, String placesStr, String disponibleStr, String dateStr, String kilometrageStr,
                   String imagePath) {
        this.immatriculation = immatriculation;
        this.marque = marque;
        this.modele = modele;
        this.typeCarburant = typeCarburant;
        this.categorie = categorie;
        this.imagePath = imagePath;

        // Parsing prixLocationJour
        try {
            this.prixLocationJour = Double.parseDouble(prixStr);
        } catch (NumberFormatException e) {
            this.prixLocationJour = 0.0;
        }

        // Parsing nombrePlaces
        try {
            this.nombrePlaces = Integer.parseInt(placesStr);
        } catch (NumberFormatException e) {
            this.nombrePlaces = 0;
        }

        // Parsing boolean disponible
        this.disponible = "true".equalsIgnoreCase(disponibleStr) || "on".equalsIgnoreCase(disponibleStr);

        // Parsing date (format yyyy-MM-dd attendu)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            this.dateMiseEnCirculation = sdf.parse(dateStr);
        } catch (ParseException e) {
            this.dateMiseEnCirculation = null;
        }

        // Parsing kilometrage
        try {
            this.kilometrage = Double.parseDouble(kilometrageStr);
        } catch (NumberFormatException e) {
            this.kilometrage = 0.0;
        }
    }

    // Getters & setters

    public String getImmatriculation() {
        return immatriculation;
    }

    public void setImmatriculation(String immatriculation) {
        this.immatriculation = immatriculation;
    }

    public int getNombrePlaces() {
        return nombrePlaces;
    }

    public void setNombrePlaces(int nombrePlaces) {
        this.nombrePlaces = nombrePlaces;
    }

    public String getMarque() {
        return marque;
    }

    public void setMarque(String marque) {
        this.marque = marque;
    }

    public String getModele() {
        return modele;
    }

    public void setModele(String modele) {
        this.modele = modele;
    }

    public Date getDateMiseEnCirculation() {
        return dateMiseEnCirculation;
    }

    public void setDateMiseEnCirculation(Date dateMiseEnCirculation) {
        this.dateMiseEnCirculation = dateMiseEnCirculation;
    }

    public double getKilometrage() {
        return kilometrage;
    }

    public void setKilometrage(double kilometrage) {
        this.kilometrage = kilometrage;
    }

    public String getTypeCarburant() {
        return typeCarburant;
    }

    public void setTypeCarburant(String typeCarburant) {
        this.typeCarburant = typeCarburant;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public double getPrixLocationJour() {
        return prixLocationJour;
    }

    public void setPrixLocationJour(double prixLocationJour) {
        this.prixLocationJour = prixLocationJour;
    }

    public boolean isDisponible() {
        return disponible;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public List<Location> getLocations() {
        return locations;
    }

    public void setLocations(List<Location> locations) {
        this.locations = locations;
    }

    @Override
    public String toString() {
        return "Voiture{" +
                "immatriculation='" + immatriculation + '\'' +
                ", nombrePlaces=" + nombrePlaces +
                ", marque='" + marque + '\'' +
                ", modele='" + modele + '\'' +
                ", dateMiseEnCirculation=" + dateMiseEnCirculation +
                ", kilometrage=" + kilometrage +
                ", typeCarburant='" + typeCarburant + '\'' +
                ", categorie='" + categorie + '\'' +
                ", prixLocationJour=" + prixLocationJour +
                ", disponible=" + disponible +
                ", imagePath='" + imagePath + '\'' +
                ", locations=" + locations +
                '}';
    }
}
