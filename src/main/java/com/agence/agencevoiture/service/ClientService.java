package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.ClientDAO;
import com.agence.agencevoiture.entity.Client;

import java.util.List;

public class ClientService {
    private ClientDAO clientDAO;

    public ClientService() {
        this.clientDAO = new ClientDAO();
    }

    public boolean ajouterClient(Client client) {
        if (client == null || client.getCin() == null || client.getCin().isEmpty()) {
            return false;
        }

        if (clientDAO.trouverClient(client.getCin()) != null) {
            // Client déjà existant
            return false;
        }

        try {
            clientDAO.creerClient(client);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Client rechercherParCin(String cin) {
        if (cin == null || cin.isEmpty()) {
            return null;
        }
        return clientDAO.trouverClient(cin);
    }

    public List<Client> rechercherTousLesClients() {
        return clientDAO.trouverTous();
    }

    public boolean supprimerClient(String cin) {
        Client client = clientDAO.trouverClient(cin);
        if (client == null) {
            return false;
        }
        try {
            clientDAO.supprimerClient(client);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean modifierClient(Client client) {
        if (client == null || client.getCin() == null) {
            return false;
        }

        try {
            clientDAO.miseAJour(client);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Client> rechercherParNom(String nom) {
        return clientDAO.rechercherParNom(nom);
    }
}
