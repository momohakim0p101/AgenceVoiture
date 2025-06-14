package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.LocationService;
import com.agence.agencevoiture.utils.JPAUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/RechercheServlet")
public class RechercheServlet extends HttpServlet {

    private LocationService locationService;

    @Override
    public void init() throws ServletException {
        locationService = new LocationService(); // instanciation manuelle
        locationService.setEntityManager(JPAUtil.getEntityManagerFactory().createEntityManager());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String query = request.getParameter("query");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (query == null || query.trim().isEmpty()) {
            response.getWriter().write("{\"voitures\":[], \"clients\":[]}");
            return;
        }

        try {
            List<Voiture> voitures = locationService.rechercherVoituresParMarqueOuModele(query);
            List<Client> clients = locationService.rechercherClientsParNomOuPrenom(query);

            StringBuilder json = new StringBuilder("{");

            json.append("\"voitures\":[");
            for (int i = 0; i < voitures.size(); i++) {
                Voiture v = voitures.get(i);
                json.append("{\"marque\":\"").append(escapeJson(v.getMarque())).append("\",");
                json.append("\"modele\":\"").append(escapeJson(v.getModele())).append("\"}");
                if (i < voitures.size() - 1) json.append(",");
            }
            json.append("],");

            json.append("\"clients\":[");
            for (int i = 0; i < clients.size(); i++) {
                Client c = clients.get(i);
                json.append("{\"prenom\":\"").append(escapeJson(c.getPrenom())).append("\",");
                json.append("\"nom\":\"").append(escapeJson(c.getNom())).append("\"}");
                if (i < clients.size() - 1) json.append(",");
            }
            json.append("]}");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Erreur lors de la recherche\"}");
        }
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\"", "\\\"").replace("\n", "").replace("\r", "");
    }
}
