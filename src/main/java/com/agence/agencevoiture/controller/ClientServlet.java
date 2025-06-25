package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Utilisateur;
import com.agence.agencevoiture.service.ClientService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/ClientServlet")
public class ClientServlet extends HttpServlet {

    private ClientService clientService;
    private ObjectMapper objectMapper;

    @Override
    public void init() {
        clientService = new ClientService();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Utilisateur utilisateur = (Utilisateur) req.getSession().getAttribute("utilisateur");
        String action = req.getParameter("action");

        try {
            if (action == null || action.equals("view")) {
                // Afficher la liste complète des clients dans la JSP
                List<Client> clients = clientService.rechercherTousLesClients();
                req.setAttribute("clients", clients);
                req.getRequestDispatcher("/GestionClient.jsp").forward(req, resp);

            } else if ("find".equals(action)) {
                // Récupérer un client par CIN (pour AJAX)
                String cin = req.getParameter("cin");
                if (cin == null || cin.isEmpty()) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Paramètre 'cin' manquant");
                    return;
                }
                Client client = clientService.trouverParCin(cin);
                if (client != null) {
                    resp.setContentType("application/json;charset=UTF-8");
                    objectMapper.writeValue(resp.getWriter(), client);
                } else {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Client non trouvé");
                }

            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action inconnue : " + action);
            }

        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur serveur : " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Paramètre 'action' manquant");
            return;
        }

        String cin = req.getParameter("cin");
        String prenom = req.getParameter("prenom");
        String nom = req.getParameter("nom");
        String email = req.getParameter("email");
        String telephone = req.getParameter("telephone");
        String adresse = req.getParameter("adresse");
        String sexe = req.getParameter("sexe");

        if (cin == null || cin.isEmpty()) {
            req.setAttribute("erreur", "CIN obligatoire");
            req.getRequestDispatcher("/GestionClient.jsp").forward(req, resp);
            return;
        }

        Client client = new Client(cin, nom, prenom, email, telephone, adresse, sexe);
        boolean success = false;

        try {
            switch (action) {
                case "save":
                    success = clientService.ajouterClient(client);
                    break;
                case "update":
                    success = clientService.modifierClient(client);
                    break;
                case "delete":
                    success = clientService.supprimerClient(cin);
                    break;
                default:
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action inconnue : " + action);
                    return;
            }

            if (success) {
                resp.sendRedirect("ClientServlet?action=view");
            } else {
                req.setAttribute("erreur", "Échec de l'opération");
                req.getRequestDispatcher("/GestionClient.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace(); // ou logger.error(...)
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erreur serveur : " + e.getMessage());
        }
    }
}
