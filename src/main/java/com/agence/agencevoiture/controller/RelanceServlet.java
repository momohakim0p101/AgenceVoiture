package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.LocationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/RelanceServlet")
public class RelanceServlet extends HttpServlet {

    private final LocationService locationService = new LocationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String locIdParam = request.getParameter("locationId");
        HttpSession session = request.getSession();

        try {
            if (locIdParam == null || locIdParam.isEmpty()) {
                throw new IllegalArgumentException("ID de réservation manquant.");
            }
            long locId = Long.parseLong(locIdParam);

            Location loc = locationService.chercherParId(locId);
            if (loc == null) {
                throw new IllegalArgumentException("Réservation introuvable pour l’ID " + locId);
            }

            Client client = loc.getClient();
            Voiture voiture = loc.getVoiture();
            Date dateFin = loc.getDateFin();
            String dateFinStr = new SimpleDateFormat("dd/MM/yyyy").format(dateFin);

            String to = client.getEmail();
            String subject = "🚗 Rappel : retour de votre véhicule loué";
            String body = String.format(
                    "Bonjour %s %s,\n\n" +
                            "Nous vous rappelons que votre location du véhicule %s %s (immatriculation %s),\n" +
                            "prévue pour se terminer le %s, n’a pas encore été retournée.\n\n" +
                            "Merci de ramener le véhicule au plus vite. Tout retard entraîne des frais de 25 000 F CFA par jour.\n\n" +
                            "Cordialement,\nL’équipe AutoManager\n",
                    client.getPrenom(), client.getNom(),
                    voiture.getMarque(), voiture.getModele(), voiture.getImmatriculation(),
                    dateFinStr
            );

            sendEmail(to, subject, body);

            session.setAttribute("message", "E‑mail de relance envoyé à " + to);
        } catch (Exception e) {
            session.setAttribute("erreur", "Erreur lors de l'envoi : " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/DashboardManagerServlet");
    }

    /**
     * Envoie un e-mail via SMTP Gmail.
     */
    private void sendEmail(String to, String subject, String body) throws MessagingException, UnsupportedEncodingException {
        final String expediteur = "automanagersn221@gmail.com"; // ton Gmail
        final String motDePasseApp = "bcka lbne abca bloo"; // Mot de passe d’application généré dans Google

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(expediteur, motDePasseApp);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(expediteur, "AutoManager"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
        msg.setSubject(subject);
        msg.setSentDate(new Date());
        msg.setText(body);

        Transport.send(msg);
    }

}
