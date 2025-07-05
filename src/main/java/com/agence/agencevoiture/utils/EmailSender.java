package com.agence.agencevoiture.utils;

import com.sendgrid.*;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.*;

import java.io.IOException;

public class EmailSender {

    private static final String API_KEY = System.getenv("SENDGRID_API_KEY");
    private static final SendGrid sg = new SendGrid(API_KEY);

    /**
     * Envoie un e‑mail simple via SendGrid.
     *
     * @param fromEmail adresse expéditeur (ex. "noreply@agencelocation.com")
     * @param fromName  nom expéditeur ("AutoManager")
     * @param toEmail   destinataire
     * @param subject   objet du mail
     * @param body      contenu texte
     */
    public static void send(String fromEmail, String fromName,
                            String toEmail, String subject,
                            String body) throws IOException {

        Email from    = new Email(fromEmail, fromName);
        Email to      = new Email(toEmail);
        Content content = new Content("text/plain", body);
        Mail mail       = new Mail(from, subject, to, content);

        Request request = new Request();
        request.setMethod(Method.POST);
        request.setEndpoint("mail/send");
        request.setBody(mail.build());

        Response response = sg.api(request);
        int code = response.getStatusCode();
        if (code >= 400) {
            throw new IOException("SendGrid error " + code + ": " + response.getBody());
        }
    }
}
