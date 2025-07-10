package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.service.LocationService;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.Locale;
import java.time.ZoneId;


@WebServlet("/RapportMensuelServlet")
public class RapportMensuelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=rapport_mensuel.pdf");

            OutputStream out = response.getOutputStream();
            Document document = new Document();
            PdfWriter.getInstance(document, out);

            document.open();

            // Logo
            String logoPath = getServletContext().getRealPath("/image/icon.png");
            Image logo = Image.getInstance(logoPath);
            logo.scaleAbsolute(50, 50);
            logo.setAlignment(Image.ALIGN_LEFT);
            document.add(logo);

            // Titre
            Font titreFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
            Paragraph titre = new Paragraph("Rapport Mensuel de l'État du Parc Automobile", titreFont);
            titre.setAlignment(Element.ALIGN_CENTER);
            titre.setSpacingBefore(10);
            titre.setSpacingAfter(20);
            document.add(titre);

            // Date du rapport
            LocalDate now = LocalDate.now();
            String mois = now.getMonth().getDisplayName(TextStyle.FULL, Locale.FRENCH);
            int annee = now.getYear();

            Font dateFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
            Paragraph date = new Paragraph("Période : " + mois + " " + annee, dateFont);
            date.setAlignment(Element.ALIGN_RIGHT);
            date.setSpacingAfter(10);
            document.add(date);

            // Texte introductif
            Font introFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
            Paragraph intro = new Paragraph(
                    "Ce rapport présente un aperçu de l’activité de location automobile pour le mois de " + mois + ". "
                            + "Il inclut les statistiques de performance financière, les données de location, ainsi que la disponibilité des véhicules.",
                    introFont);
            intro.setAlignment(Element.ALIGN_JUSTIFIED);
            intro.setSpacingAfter(20);
            document.add(intro);

            // Données depuis le service
            LocationService service = new LocationService();
            BigDecimal revenu = service.bilanFinancierMensuel(annee, now.getMonthValue());
            int clientsActifs = service.nombreClientsActifsDuMois(annee, now.getMonthValue());
            long totalClients = service.totalClients();
            long nbLocations = service.listerLocationsTerminees().stream()
                    .filter(l -> {
                        LocalDate dateFin = l.getDateFin().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                        return dateFin.getMonthValue() == now.getMonthValue() && dateFin.getYear() == now.getYear();
                    })
                    .count();
            long nbVoitures = service.compterVoitures();
            long nbDispo = service.voituresDisponibles().size();

            // Tableau
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10);

            addCell(table, "Indicateur", true);
            addCell(table, "Valeur", true);
            addCell(table, "Revenu généré", false);
            addCell(table, revenu + " F CFA", false);
            addCell(table, "Locations terminées", false);
            addCell(table, String.valueOf(nbLocations), false);
            addCell(table, "Clients actifs ce mois", false);
            addCell(table, String.valueOf(clientsActifs), false);
            addCell(table, "Clients total", false);
            addCell(table, String.valueOf(totalClients), false);
            addCell(table, "Voitures disponibles", false);
            addCell(table, nbDispo + " / " + nbVoitures, false);

            document.add(table);

            // Zone de signature
            Paragraph signature = new Paragraph("\n\nFait à Dakar, le " + now.getDayOfMonth() + " " + mois + " " + annee + ".\n\n"
                    + "Signature du gestionnaire :\n\n\n_____________________________", introFont);
            signature.setAlignment(Element.ALIGN_LEFT);
            signature.setSpacingBefore(40);
            document.add(signature);

            document.close();
            out.close();

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de la génération du rapport PDF", e);
        }
    }

    private void addCell(PdfPTable table, String content, boolean isHeader) {
        Font font = new Font(Font.FontFamily.HELVETICA, isHeader ? 12 : 11,
                isHeader ? Font.BOLD : Font.NORMAL);
        PdfPCell cell = new PdfPCell(new Phrase(content, font));
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(8);
        if (isHeader) {
            cell.setBackgroundColor(new BaseColor(240, 240, 240));
        }
        table.addCell(cell);
    }
}
