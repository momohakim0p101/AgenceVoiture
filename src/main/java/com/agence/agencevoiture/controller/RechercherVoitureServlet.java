package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Voiture;
import com.agence.agencevoiture.service.VoitureService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/RechercherVoitureServlet")
public class RechercherVoitureServlet extends HttpServlet {

    private VoitureService voitureService;

    @Override
    public void init() {
        voitureService = new VoitureService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String marque = request.getParameter("marque");
        String categorie = request.getParameter("categorie");
        String carburant = request.getParameter("carburant");
        String kmMaxStr = request.getParameter("kmMax");
        String anneeStr = request.getParameter("annee");

        Double kmMax = (kmMaxStr != null && !kmMaxStr.isEmpty()) ? Double.parseDouble(kmMaxStr) : null;
        Integer annee = (anneeStr != null && !anneeStr.isEmpty()) ? Integer.parseInt(anneeStr) : null;

        List<Voiture> voituresFiltrees = voitureService.listerVoituresDisponibles().stream()
                .filter(v -> (marque == null || marque.isEmpty() || v.getMarque().equalsIgnoreCase(marque)))
                .filter(v -> (categorie == null || categorie.isEmpty() || v.getCategorie().equalsIgnoreCase(categorie)))
                .filter(v -> (carburant == null || carburant.isEmpty() || v.getTypeCarburant().equalsIgnoreCase(carburant)))
                .filter(v -> (kmMax == null || v.getKilometrage() <= kmMax))
                .filter(v -> (annee == null ||
                        (v.getDateMiseEnCirculation() != null &&
                                v.getDateMiseEnCirculation().toInstant().atZone(java.time.ZoneId.systemDefault()).getYear() >= annee)))
                .collect(Collectors.toList());

        // Renvoyer aussi les listes nécessaires aux select
        Set<String> marques = voitureService.listerVoituresDisponibles().stream()
                .map(Voiture::getMarque).collect(Collectors.toSet());
        Set<String> categories = voitureService.listerVoituresDisponibles().stream()
                .map(Voiture::getCategorie).collect(Collectors.toSet());
        Set<String> carburants = voitureService.listerVoituresDisponibles().stream()
                .map(Voiture::getTypeCarburant).collect(Collectors.toSet());

        request.setAttribute("voituresDisponibles", voituresFiltrees);
        request.setAttribute("marques", marques);
        request.setAttribute("categories", categories);
        request.setAttribute("carburants", carburants);

        request.getRequestDispatcher("location.jsp").forward(request, response);
    }
}
