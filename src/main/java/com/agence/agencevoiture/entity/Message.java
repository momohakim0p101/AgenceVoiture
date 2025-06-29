package com.agence.agencevoiture.entity;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "messages")
public class Message {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String expediteur; // "manager" ou "chef"
    private String destinataire;
    private String contenu;

    @Temporal(TemporalType.TIMESTAMP)
    private Date dateEnvoi;

    // Getters, Setters, Constructeurs

    public Message(Long id, String expediteur, String destinataire, String contenu, Date dateEnvoi) {
        this.id = id;
        this.expediteur = expediteur;
        this.destinataire = destinataire;
        this.contenu = contenu;
        this.dateEnvoi = dateEnvoi;
    }

    public Message() {

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getExpediteur() {
        return expediteur;
    }

    public void setExpediteur(String expediteur) {
        this.expediteur = expediteur;
    }

    public String getDestinataire() {
        return destinataire;
    }

    public void setDestinataire(String destinataire) {
        this.destinataire = destinataire;
    }

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public Date getDateEnvoi() {
        return dateEnvoi;
    }

    public void setDateEnvoi(Date dateEnvoi) {
        this.dateEnvoi = dateEnvoi;
    }

    @Override
    public String toString() {
        return "Message{" +
                "id=" + id +
                ", expediteur='" + expediteur + '\'' +
                ", destinataire='" + destinataire + '\'' +
                ", contenu='" + contenu + '\'' +
                ", dateEnvoi=" + dateEnvoi +
                '}';
    }
}
