package com.agence.agencevoiture.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "maintenance")
public class Maintenance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "type_maintenance", nullable = false)
    private String type;

    @Temporal(TemporalType.DATE)
    @Column(name = "date_maintenance", nullable = false)
    private Date dateMaintenance;

    @Column(name = "prix_maintenance")
    private double prix;


    @Column(name = "description", length = 500)
    private String description;

    @ManyToOne
    @JoinColumn(name = "voiture_immatriculation", nullable = false)
    private Voiture voiture;

    // Constructeur vide obligatoire pour JPA
    public Maintenance() {
    }

    public Maintenance(String type, Date dateMaintenance, String description, Voiture voiture) {
        this.type = type;
        this.dateMaintenance = dateMaintenance;
        this.description = description;
        this.voiture = voiture;
    }

    // Getters et setters
    public double getPrix() {
        return prix;
    }

    public void setPrix(double prix) {
        this.prix = prix;
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getDateMaintenance() {
        return dateMaintenance;
    }

    public void setDateMaintenance(Date dateMaintenance) {
        this.dateMaintenance = dateMaintenance;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Voiture getVoiture() {
        return voiture;
    }

    public void setVoiture(Voiture voiture) {
        this.voiture = voiture;
    }

    @Override
    public String toString() {
        return "Maintenance{" +
                "id=" + id +
                ", type='" + type + '\'' +
                ", dateMaintenance=" + dateMaintenance +
                ", description='" + description + '\'' +
                ", voiture=" + (voiture != null ? voiture.getImmatriculation() : "null") +
                '}';
    }
}
