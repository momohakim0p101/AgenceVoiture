package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.ClientService;
import com.agence.agencevoiture.service.LocationService;
import com.agence.agencevoiture.service.VoitureService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/NouvelleLocationServlet")
public class NouvelleLocationServlet extends HttpServlet {

    private LocationService locationService;
    private ClientService clientService;
    private VoitureService voitureService;

    @Override
    public void init() throws ServletException {
        locationService = new LocationService();
        clientService = new ClientService();
        voitureService = new VoitureService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Charger clients et voitures pour affichage dans la JSP
        List<Client> clients = clientService.rechercherTousLesClients(); // méthode à créer si nécessaire
        List<Voiture> voitures = voitureService.listerToutesLesVoitures(); // méthode à créer si nécessaire

        request.setAttribute("clients", clients);
        request.setAttribute("voitures", voitures);
        request.getRequestDispatcher("nouvelle_location.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cin = request.getParameter("cin");
        String immatriculation = request.getParameter("immatriculation");
        String dateDebutStr = request.getParameter("dateDebut");
        String dateFinStr = request.getParameter("dateFin");

        if (cin == null || cin.isEmpty() ||
                immatriculation == null || immatriculation.isEmpty() ||
                dateDebutStr == null || dateDebutStr.isEmpty() ||
                dateFinStr == null || dateFinStr.isEmpty()) {

            request.setAttribute("erreur", "Tous les champs sont requis.");
            request.getRequestDispatcher("nouvelle_location.jsp").forward(request, response);
            return;
        }

        Client client = clientService.trouverParCin(cin);
        Voiture voiture = voitureService.trouverVoitureImm(immatriculation);

        if (client == null || voiture == null) {
            request.setAttribute("erreur", "Client ou voiture introuvable.");
            request.getRequestDispatcher("nouvelle_location.jsp").forward(request, response);
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dateDebut = null;
        Date dateFin = null;

        try {
            dateDebut = sdf.parse(dateDebutStr);
            dateFin = sdf.parse(dateFinStr);
        } catch (ParseException e) {
            request.setAttribute("erreur", "Format de date invalide.");
            request.getRequestDispatcher("nouvelle_location.jsp").forward(request, response);
            return;
        }

        if (dateDebut.after(dateFin)) {
            request.setAttribute("erreur", "La date de début doit être avant la date de fin.");
            request.getRequestDispatcher("nouvelle_location.jsp").forward(request, response);
            return;
        }

        Location location = new Location();
        location.setClient(client);
        location.setVoiture(voiture);
        location.setDateDebut(dateDebut);
        location.setDateFin(dateFin);
        location.setStatut(Location.StatutLocation.EN_COURS);

        try {
            locationService.ajouterLocation(location);
            // Après ajout réussi
            request.setAttribute("location", location);
            request.getRequestDispatcher("detail_location.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Une erreur est survenue lors de la création de la location.");
            request.getRequestDispatcher("nouvelle_location.jsp").forward(request, response);
        }
    }
}
