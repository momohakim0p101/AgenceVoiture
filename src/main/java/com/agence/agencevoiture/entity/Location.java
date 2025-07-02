package com.agence.agencevoiture.entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "reservation")
public class Location {

    public enum StatutLocation {
        CONFIRMEE,
        TERMINEE,
        ANNULEE,
        EN_COURS,
        LOUE
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_reservation")
    private Long idReservation;

    // Correction ici : correspondance réelle avec la colonne "cin_client" dans la base
    @ManyToOne
    @JoinColumn(name = "cin_client", referencedColumnName = "cin", nullable = false)
    private Client client;

    // Adaptation selon ta base si tu as "immatriculation" comme clé de voiture
    @ManyToOne
    @JoinColumn(name = "immatriculation_voiture", referencedColumnName = "immatriculation", nullable = false)
    private Voiture voiture;

    @Temporal(TemporalType.DATE)
    @Column(name = "date_debut")
    private Date dateDebut;

    @Temporal(TemporalType.DATE)
    @Column(name = "date_fin")
    private Date dateFin;

    @Column(name = "montant_total")
    private double montantTotal;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut")
    private StatutLocation statut;

    @OneToOne(mappedBy = "location", cascade = CascadeType.ALL)
    private Facture facture;

    // Getters & Setters
    public Long getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(Long idReservation) {
        this.idReservation = idReservation;
    }

    public Client getClient() {
        return client;
    }

    public void setClient(Client client) {
        this.client = client;
    }

    public Voiture getVoiture() {
        return voiture;
    }

    public void setVoiture(Voiture voiture) {
        this.voiture = voiture;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public double getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(double montantTotal) {
        this.montantTotal = montantTotal;
    }

    public StatutLocation getStatut() {
        return statut;
    }

    public void setStatut(StatutLocation statut) {
        this.statut = statut;
    }

    public Facture getFacture() {
        return facture;
    }

    public void setFacture(Facture facture) {
        this.facture = facture;
    }
}
