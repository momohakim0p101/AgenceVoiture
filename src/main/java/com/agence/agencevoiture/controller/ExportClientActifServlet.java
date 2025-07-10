package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.service.LocationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ExportClientActifServlet", urlPatterns = "/ExportClientActifServlet")
public class ExportClientActifServlet extends HttpServlet {

    private LocationService locationService = new LocationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer tous les clients actifs
        List<Client> clientsActifs = locationService.rechercherClientsParNomOuPrenom(""); // méthode modifiée pour récupérer tous ?

        // Créer un classeur Excel
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Clients Actifs");

            // Style d'entête
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            // En-tête
            Row header = sheet.createRow(0);
            String[] colonnes = {"ID Client", "Nom", "Prénom", "Email", "Téléphone", "Adresse"};

            for (int i = 0; i < colonnes.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(colonnes[i]);
                cell.setCellStyle(headerStyle);
                sheet.autoSizeColumn(i);
            }

            // Remplir les données clients
            int rowNum = 1;
            for (Client client : clientsActifs) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(client.getCin());
                row.createCell(1).setCellValue(client.getNom());
                row.createCell(2).setCellValue(client.getPrenom());
                row.createCell(3).setCellValue(client.getEmail() != null ? client.getEmail() : "");
                row.createCell(4).setCellValue(client.getTelephone() != null ? client.getTelephone() : "");
                row.createCell(5).setCellValue(client.getAdresse() != null ? client.getAdresse() : "");
            }

            // Ajuster automatiquement la taille des colonnes
            for (int i = 0; i < colonnes.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Configurer la réponse HTTP
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=clients_actifs.xlsx");

            // Envoyer le fichier Excel dans la réponse
            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
        }
    }
}
