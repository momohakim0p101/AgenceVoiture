package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Facture;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.service.FactureService;
import com.agence.agencevoiture.service.LocationService;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/FactureServlet")
public class FactureServlet extends HttpServlet {

    private final LocationService locationService = new LocationService();
    private final FactureService factureService = new FactureService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String idLocationParam = request.getParameter("id");
        if (idLocationParam == null || idLocationParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de location manquant");
            return;
        }

        Long idLocation = Long.parseLong(idLocationParam);
        Location location = locationService.chercherParId(idLocation);

        if (location == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Location introuvable");
            return;
        }

        // Génération de la facture
        Facture facture = new Facture();
        facture.setReservation(location);
        facture.setDateEmission(new Date());
        facture.setMontant(location.getMontantTotal());
        facture.setSignatureClient(location.getClient().getNom());
        facture.setSignatureGestionnaire("Gestionnaire");

        // Générer un fichier temporaire
        File pdfTemp = File.createTempFile("facture_" + idLocation + "_", ".pdf");

        try (FileOutputStream fos = new FileOutputStream(pdfTemp)) {
            generatePDF(facture, fos);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Erreur lors de la génération de la facture PDF");
            return;
        }

        // Configuration de la réponse HTTP pour téléchargement ou affichage
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=facture_" + idLocation + ".pdf");
        response.setContentLength((int) pdfTemp.length());

        try (FileInputStream fis = new FileInputStream(pdfTemp);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = fis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } finally {
            pdfTemp.delete(); // Nettoyage automatique du fichier temporaire
        }
    }

    private void generatePDF(Facture facture, OutputStream outputStream) throws Exception {
        Document document = new Document();
        PdfWriter.getInstance(document, outputStream);

        document.open();

        // Logo AutoManager
        String logoPath = getServletContext().getRealPath("./image/icon.png");
        Image logo = Image.getInstance(logoPath);
        logo.scaleAbsolute(60, 60);
        logo.setAlignment(Element.ALIGN_LEFT);
        document.add(logo);

        // Titre
        Paragraph title = new Paragraph("FACTURE DE LOCATION", new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD));
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // Infos location
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(15);

        table.addCell(getCell("Client :", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell(facture.getReservation().getClient().getNom(), PdfPCell.ALIGN_LEFT));
        table.addCell(getCell("Voiture :", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell(
                facture.getReservation().getVoiture().getMarque()
                        + " - " + facture.getReservation().getVoiture().getModele()
                        + " (" + facture.getReservation().getVoiture().getImmatriculation() + ")",
                PdfPCell.ALIGN_LEFT));
        table.addCell(getCell("Date de début :", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell(sdf.format(facture.getReservation().getDateDebut()), PdfPCell.ALIGN_LEFT));
        table.addCell(getCell("Date de fin :", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell(sdf.format(facture.getReservation().getDateFin()), PdfPCell.ALIGN_LEFT));
        table.addCell(getCell("Montant total :", PdfPCell.ALIGN_LEFT));
        table.addCell(getCell(facture.getMontant() + " F CFA", PdfPCell.ALIGN_LEFT));

        document.add(table);

        // Termes de location
        Paragraph termes = new Paragraph("Termes de la location :", new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD));
        termes.setSpacingAfter(10);
        document.add(termes);

        Paragraph body = new Paragraph(
                "- Le client s'engage à restituer le véhicule à la date prévue.\n" +
                        "- Tout dépassement entraînera des frais supplémentaires.\n" +
                        "- Le véhicule doit être rendu dans le même état qu'à la prise en charge.\n" +
                        "- La présente facture fait office de contrat de location.",
                new Font(Font.FontFamily.HELVETICA, 12));
        body.setSpacingAfter(20);
        document.add(body);

        // Signatures
        PdfPTable signatures = new PdfPTable(2);
        signatures.setWidthPercentage(100);
        signatures.setSpacingBefore(30);

        PdfPCell clientSig = getCell("Signature du client : " + facture.getSignatureClient(), PdfPCell.ALIGN_LEFT);
        PdfPCell gestionSig = getCell("Signature du gestionnaire : " + facture.getSignatureGestionnaire(), PdfPCell.ALIGN_RIGHT);

        clientSig.setBorder(Rectangle.NO_BORDER);
        gestionSig.setBorder(Rectangle.NO_BORDER);

        signatures.addCell(clientSig);
        signatures.addCell(gestionSig);

        document.add(signatures);

        // Date d'émission
        Paragraph date = new Paragraph("Date d’émission : " + sdf.format(facture.getDateEmission()), new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC));
        date.setSpacingBefore(30);
        document.add(date);

        document.close();
    }

    private PdfPCell getCell(String text, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(text));
        cell.setPadding(8);
        cell.setHorizontalAlignment(alignment);
        return cell;
    }
}
