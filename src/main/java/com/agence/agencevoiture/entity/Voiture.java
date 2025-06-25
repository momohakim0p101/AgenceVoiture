package com.agence.agencevoiture.entity;

import jakarta.persistence.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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

    @OneToMany(mappedBy = "voiture")
    private List<Location> locations;


    public Voiture(){

    }


    // Constructeur avec conversion des String en types réels
    public Voiture(String immatriculation, String marque, String modele, String typeCarburant, String categorie,
                   String prixStr, String placesStr, String disponibleStr, String dateStr, String kilometrageStr) {
        this.immatriculation = immatriculation;
        this.marque = marque;
        this.modele = modele;
        this.typeCarburant = typeCarburant;
        this.categorie = categorie;

        try {
            this.prixLocationJour = Double.parseDouble(prixStr);
        } catch (NumberFormatException e) {
            this.prixLocationJour = 0.0;
        }

        try {
            this.nombrePlaces = Integer.parseInt(placesStr);
        } catch (NumberFormatException e) {
            this.nombrePlaces = 0;
        }

        // Conversion String -> boolean
        this.disponible = "true".equalsIgnoreCase(disponibleStr) || "on".equalsIgnoreCase(disponibleStr);

        SimpleDateFormat  sdf = new SimpleDateFormat("yyyy-MM-dd"); // adapter au format attendu
        try {
            this.dateMiseEnCirculation = sdf.parse(dateStr);
        } catch (ParseException e) {
            this.dateMiseEnCirculation = null;
        }

        try {
            this.kilometrage = Double.parseDouble(kilometrageStr);
        } catch (NumberFormatException e) {
            this.kilometrage = 0.0;
        }
    }




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

    public List<Location> getReservations() {
        return locations;
    }

    public void setReservations(List<Location> locations) {
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
                ", reservations=" + locations +

                '}';
    }
}
