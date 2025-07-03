package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Location;

import java.text.SimpleDateFormat;
import java.util.Date;

import jakarta.servlet.http.HttpServletRequest;

public class PDFGenerateurHelper {

    public static String buildLocationHTML(Location location, HttpServletRequest request) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        String logoURL = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() +
                request.getContextPath() + "/images/logo_automanager.png";

        return "<!DOCTYPE html>" +
                "<html lang='fr'>" +
                "<head>" +
                "  <meta charset='UTF-8' />" +
                "  <style>" +
                "    body { font-family: 'Arial', sans-serif; padding: 30px; color: #333; }" +
                "    h1 { color: #0078d4; font-size: 24px; border-bottom: 1px solid #0078d4; }" +
                "    table { width: 100%; border-collapse: collapse; margin-top: 20px; }" +
                "    th, td { padding: 8px 12px; border: 1px solid #ccc; text-align: left; }" +
                "    th { background: #f0f8ff; color: #005a9e; }" +
                "    .terms { margin-top: 40px; font-size: 0.9em; line-height: 1.5; }" +
                "    .footer { position: fixed; bottom: 30px; width: 100%; text-align: center; font-size: 0.8em; color: #666; }" +
                "    .logo { height: 60px; margin-bottom: 20px; }" +
                "  </style>" +
                "</head>" +
                "<body>" +
                "  <img src='" + logoURL + "' alt='Automanager' class='logo' />" +
                "  <h1>Contrat de location - Automanager</h1>" +
                "  <table>" +
                "    <tr><th>Client</th><td>" + location.getClient().getNom() + " " + location.getClient().getPrenom() + "</td></tr>" +
                "    <tr><th>CIN</th><td>" + location.getClient().getCin() + "</td></tr>" +
                "    <tr><th>Voiture</th><td>" + location.getVoiture().getMarque() + " " + location.getVoiture().getModele() + "</td></tr>" +
                "    <tr><th>Immatriculation</th><td>" + location.getVoiture().getImmatriculation() + "</td></tr>" +
                "    <tr><th>Date début</th><td>" + sdf.format(location.getDateDebut()) + "</td></tr>" +
                "    <tr><th>Date fin</th><td>" + sdf.format(location.getDateFin()) + "</td></tr>" +
                "    <tr><th>Statut</th><td>" + location.getStatut().toString() + "</td></tr>" +
                "  </table>" +
                "  <div class='terms'>" +
                "    <h2>Termes et conditions</h2>" +
                "    <ul>" +
                "      <li>Le conducteur doit avoir au moins 21 ans et un permis valide.</li>" +
                "      <li>Le véhicule doit être restitué avec le plein de carburant et en bon état.</li>" +
                "      <li>Les retards de restitution entraîneront des frais supplémentaires.</li>" +
                "      <li>En cas de dommage, le client est responsable des réparations.</li>" +
                "      <li>Automanager se réserve le droit de facturer les frais non couverts par l’assurance.</li>" +
                "    </ul>" +
                "  </div>" +
                "  <div class='footer'>" +
                "    Automanager © " + new SimpleDateFormat("yyyy").format(new Date()) + " - Dakar, Sénégal" +
                "  </div>" +
                "</body>" +
                "</html>";
    }
    }
