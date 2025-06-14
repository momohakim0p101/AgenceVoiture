package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.service.ClientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/ClientServlet")
public class ClientServlet extends HttpServlet {

    private ClientService clientService = new ClientService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Client> clients = clientService.rechercherTousLesClients();
        request.setAttribute("clients", clients);
        request.getRequestDispatcher("/GestionClient.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cin = request.getParameter("cin");
        String prenom = request.getParameter("prenom");
        String nom = request.getParameter("nom");
        String telephone = request.getParameter("telephone");
        String adresse = request.getParameter("adresse");
        String sexe = request.getParameter("sexe");
        String email = request.getParameter("email");

        Client client = new Client();
        client.setCin(cin);
        client.setPrenom(prenom);
        client.setNom(nom);
        client.setEmail(email);
        client.setAdresse(adresse);
        client.setTelephone(telephone);
        client.setSexe(sexe);

        clientService.ajouterClient(client);

        response.sendRedirect(request.getContextPath() + "/GestionClient.jsp");
    }
}
