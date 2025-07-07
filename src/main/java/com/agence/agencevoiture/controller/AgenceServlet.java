package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Maintenance;
import com.agence.agencevoiture.service.ClientService;
import com.agence.agencevoiture.service.MaintenanceService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/AgenceServlet")
public class AgenceServlet extends HttpServlet {

    private final MaintenanceService maintenanceService = new MaintenanceService();
    private final ClientService clientService = new ClientService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Chargement des maintenances en cours
        List<Maintenance> maintenancesEnCours = maintenanceService.listerMaintenancesNonTerminees();
        request.setAttribute("maintenancesEnCours", maintenancesEnCours);

        // Chargement des clients les plus fidèles
        List<Client> clientsFideles = clientService.getClientsLesPlusFideles();
        request.setAttribute("clientsFideles", clientsFideles);

        // Redirection vers la JSP
        request.getRequestDispatcher("Agence.jsp").forward(request, response);
    }
}
