package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.ClientService;
import com.agence.agencevoiture.service.LocationService;
import com.agence.agencevoiture.service.VoitureService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/LocationServlet")
public class LocationServlet extends HttpServlet {

    private VoitureService voitureService;
    private ClientService clientService;
    private LocationService locationService;

    @Override
    public void init() {
        voitureService = new VoitureService();
        clientService = new ClientService();
        locationService = new LocationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Voiture> voituresDisponibles = voitureService.listerVoituresDisponibles();
        List<Location> locationsActives = locationService.getLocationsEnCours()
                .stream()
                .filter(loc -> loc.getStatut() == Location.StatutLocation.CONFIRMEE)
                .collect(Collectors.toList());


        Set<String> marques = voituresDisponibles.stream()
                .map(Voiture::getMarque)
                .filter(Objects::nonNull)
                .collect(Collectors.toCollection(TreeSet::new));

        Set<String> categories = voituresDisponibles.stream()
                .map(Voiture::getCategorie)
                .filter(Objects::nonNull)
                .collect(Collectors.toCollection(TreeSet::new));

        Set<String> carburants = voituresDisponibles.stream()
                .map(Voiture::getTypeCarburant)
                .filter(Objects::nonNull)
                .collect(Collectors.toCollection(TreeSet::new));

        request.setAttribute("voituresDisponibles", voituresDisponibles);
        request.setAttribute("locationsActives", locationsActives);
        request.setAttribute("marques", marques);
        request.setAttribute("categories", categories);
        request.setAttribute("carburants", carburants);


        request.getRequestDispatcher("Location.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Rediriger simplement vers doGet (aucune logique côté POST nécessaire)
        doGet(request, response);
    }
}
