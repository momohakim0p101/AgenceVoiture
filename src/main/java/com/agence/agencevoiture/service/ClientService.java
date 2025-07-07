package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.ClientDAO;
import com.agence.agencevoiture.entity.Client;
import jakarta.persistence.EntityManager;

import java.util.List;

/**
 * Service métier pour la gestion des clients.
 */
public class ClientService {

    private final ClientDAO clientDAO;

    public ClientService() {
        this.clientDAO = new ClientDAO();
    }

    /**
     * Ajoute un nouveau client si son CIN est unique.
     *
     * @param client Le client à ajouter.
     * @return true si l'ajout est réussi, false sinon.
     */
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
            System.err.println("Erreur lors de l'ajout du client : " + e.getMessage());
            return false;
        }
    }

    /**
     * Recherche un client par son CIN.
     *
     * @param cin CIN du client.
     * @return Le client trouvé, ou null.
     */
    public Client trouverParCin(String cin) {
        if (cin == null || cin.trim().isEmpty()) {
            return null;
        }
        return clientDAO.trouverClient(cin.trim());
    }



    /**
     * Récupère tous les clients enregistrés.
     *
     * @return Liste de tous les clients.
     */
    public List<Client> rechercherTousLesClients() {
        return clientDAO.trouverTous();
    }

    /**
     * Supprime un client selon son CIN.
     *
     * @param cin Le CIN du client à supprimer.
     * @return true si la suppression est réussie, false sinon.
     */
    public boolean supprimerClient(String cin) {
        if (cin == null || cin.trim().isEmpty()) {
            return false;
        }

        Client client = clientDAO.trouverClient(cin.trim());
        if (client == null) {
            return false;
        }

        try {
            clientDAO.supprimerClient(client);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la suppression du client : " + e.getMessage());
            return false;
        }
    }

    /**
     * Met à jour les informations d'un client existant.
     *
     * @param client Le client avec les nouvelles données.
     * @return true si la mise à jour est réussie, false sinon.
     */
    public boolean modifierClient(Client client) {
        if (client == null || client.getCin() == null || client.getCin().trim().isEmpty()) {
            return false;
        }

        try {
            clientDAO.miseAJour(client);
            return true;
        } catch (Exception e) {
            System.err.println("Erreur lors de la modification du client : " + e.getMessage());
            return false;
        }
    }

    /**
     * Recherche les clients dont le nom contient le mot-clé donné.
     *
     * @param nom Le nom à rechercher.
     * @return Liste des clients correspondants.
     */
    public List<Client> rechercherParNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            return List.of();
        }
        return clientDAO.rechercherParNom(nom.trim());
    }
    // Total de clients ayant déjà loué
    public int totalClients() {
        EntityManager em = null;
        Long count = em.createQuery(
                        "SELECT COUNT(DISTINCT l.client.id) FROM Location l", Long.class)
                .getSingleResult();
        return count != null ? count.intValue() : 0;
    }
}
