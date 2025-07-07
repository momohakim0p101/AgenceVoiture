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
import java.util.concurrent.TimeUnit;

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
        List<Client> clients = clientService.rechercherTousLesClients();
        List<Voiture> voituresDisponibles = voitureService.listerVoituresDisponibles();

        request.setAttribute("clients", clients);
        request.setAttribute("voitures", voituresDisponibles);
        request.getRequestDispatcher("nouvelle_location.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cin = request.getParameter("cin");
        String immatriculation = request.getParameter("immatriculation");
        String dateDebutStr = request.getParameter("dateDebut");
        String dateFinStr = request.getParameter("dateFin");

        // Validation basique
        if (cin == null || cin.isEmpty() ||
                immatriculation == null || immatriculation.isEmpty() ||
                dateDebutStr == null || dateDebutStr.isEmpty() ||
                dateFinStr == null || dateFinStr.isEmpty()) {
            request.setAttribute("erreur", "Tous les champs sont requis.");
            doGet(request, response);
            return;
        }

        Client client = clientService.trouverParCin(cin);
        Voiture voiture = voitureService.trouverVoitureImm(immatriculation);

        if (client == null) {
            request.setAttribute("erreur", "Client introuvable.");
            doGet(request, response);
            return;
        }

        if (voiture == null) {
            request.setAttribute("erreur", "Voiture introuvable.");
            doGet(request, response);
            return;
        }

        if (!voiture.isDisponible()) {
            request.setAttribute("erreur", "Cette voiture n'est pas disponible.");
            doGet(request, response);
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dateDebut;
        Date dateFin;
        try {
            dateDebut = sdf.parse(dateDebutStr);
            dateFin = sdf.parse(dateFinStr);
        } catch (ParseException e) {
            request.setAttribute("erreur", "Format de date invalide. Utilisez AAAA-MM-JJ.");
            doGet(request, response);
            return;
        }

        if (!dateDebut.before(dateFin) && !dateDebut.equals(dateFin)) {
            request.setAttribute("erreur", "La date de début doit être antérieure ou égale à la date de fin.");
            doGet(request, response);
            return;
        }

        // Calcul des jours inclusifs (1 jour minimum)
        long diffMillis = dateFin.getTime() - dateDebut.getTime();
        long joursLocation = TimeUnit.DAYS.convert(diffMillis, TimeUnit.MILLISECONDS) + 1;

        double prixParJour = voiture.getPrixLocationJour();
        double montantTotal = joursLocation * prixParJour;

        try {
            // Utiliser la méthode reserverVoiture pour gérer la transaction et mise à jour
            Location location = locationService.reserverVoiture(client, voiture, dateDebut, dateFin, prixParJour);
            // Après enregistrement réussi
            request.getSession().setAttribute("successMessage", "La location a été enregistrée avec succès !");



            request.setAttribute("location", location);
            request.getRequestDispatcher("detail_location.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de la création de la location : " + e.getMessage());
            doGet(request, response);
        }
    }
}
