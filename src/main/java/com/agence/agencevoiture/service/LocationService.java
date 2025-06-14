package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.LocationDAO;
import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Voiture;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

public class LocationService {

    @PersistenceContext
    private EntityManager em;

    // 1. Situation du parking

    /**
     * Nombre total de voitures dans l’agence
     */
    public long compterVoitures() {
        return em.createQuery("SELECT COUNT(v) FROM Voiture v", Long.class).getSingleResult();
    }

    /**
     * Liste des voitures actuellement en location avec infos locataires
     */
    public List<Location> voituresEnLocation() {
        return em.createQuery(
                        "SELECT l FROM Location l WHERE l.statut = :statut", Location.class)
                .setParameter("statut", "Confirmée")
                .getResultList();
    }

    /**
     * Liste des voitures disponibles
     */
    public List<Voiture> voituresDisponibles() {
        return em.createQuery(
                        "SELECT v FROM Voiture v WHERE v.disponible = true", Voiture.class)
                .getResultList();
    }

    // 2. Voitures les plus recherchées (les plus louées)

    /**
     * Top N voitures les plus louées
     */
    public List<Object[]> voituresLesPlusLoueés(int topN) {
        return em.createQuery(
                        "SELECT l.voiture, COUNT(l) as nb " +
                                "FROM Location l " +
                                "GROUP BY l.voiture " +
                                "ORDER BY nb DESC", Object[].class)
                .setMaxResults(topN)
                .getResultList();
    }

    // 3. Bilan financier mensuel

    /**
     * Chiffre d’affaires (total des locations terminées) pour un mois donné
     */
    public BigDecimal bilanFinancierMensuel(int annee, int mois) {
        TypedQuery<Double> query = em.createQuery(
                "SELECT COALESCE(SUM(l.montantTotal), 0) FROM Location l " +
                        "WHERE l.statut = :statut " +
                        "AND FUNCTION('YEAR', l.dateFin) = :annee " +
                        "AND FUNCTION('MONTH', l.dateFin) = :mois", Double.class);
        query.setParameter("statut", "Terminée");
        query.setParameter("annee", annee);
        query.setParameter("mois", mois);
        Double result = query.getSingleResult();
        return BigDecimal.valueOf(result != null ? result : 0.0);
    }


    public Location reserverVoiture(Client client, Voiture voiture, Date dateDebut, Date dateFin, double prixJour) {
        if (client == null || voiture == null || !voiture.isDisponible() || dateDebut == null || dateFin == null || !dateFin.after(dateDebut)) {
            throw new IllegalArgumentException("Paramètres invalides ou voiture non disponible");
        }
        Location location = new Location();
        location.setClient(client);
        location.setVoiture(voiture);
        location.setDateDebut(dateDebut);
        location.setDateFin(dateFin);
        long diffJours = (dateFin.getTime() - dateDebut.getTime()) / (1000 * 60 * 60 * 24);
        location.setMontantTotal(diffJours * prixJour);
        location.setStatut("Confirmée");

        em.persist(location);
        voiture.setDisponible(false);
        em.merge(voiture);

        return location;
    }

    public Location terminerLocation(Long idReservation) {
        Location location = em.find(Location.class, idReservation);
        if (location == null || !"Confirmée".equals(location.getStatut())) {
            throw new IllegalStateException("Location non trouvée ou déjà terminée");
        }
        location.setStatut("Terminée");
        location.getVoiture().setDisponible(true);
        em.merge(location.getVoiture());
        return em.merge(location);
    }

    public Location annulerLocation(Long idReservation) {
        Location location = em.find(Location.class, idReservation);
        if (location == null || !"Confirmée".equals(location.getStatut())) {
            throw new IllegalStateException("Location non trouvée ou déjà terminée");
        }
        location.setStatut("Annulée");
        location.getVoiture().setDisponible(true);
        em.merge(location.getVoiture());
        return em.merge(location);
    }


    public Location chercherParId(Long id) {
        return em.find(Location.class, id);
    }

    public boolean ajouterLocation(Location location) {
        try {
            locationDAO.creerLocation(location);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Location> listerToutesLesLocations() {
        return locationDAO.trouverTous();
    }

    private final LocationDAO locationDAO = new LocationDAO();

    public boolean supprimerLocation(Long id) {
        try {
            Location location = locationDAO.trouverLocation(id);
            if (location != null) {
                locationDAO.supprimerLocation(location);
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void mettreAJourLocation(Location location) {
        locationDAO.MiseAJour(location);
    }

    public long compterClientsAyantLoué() {
        String jpql = "SELECT COUNT(DISTINCT l.client) FROM Location l WHERE l.statut IN (:statuts)";
        return em.createQuery(jpql, Long.class)
                .setParameter("statuts", Arrays.asList("Confirmée", "Terminée"))
                .getSingleResult();
    }

    public long compterTotalClients() {
        return em.createQuery("SELECT COUNT(c) FROM Client c", Long.class)
                .getSingleResult();
    }

    public long compterClientsActifsMois(int annee, int mois) {
        String jpql = "SELECT COUNT(DISTINCT l.client) FROM Location l " +
                "WHERE l.statut IN (:statuts) " +
                "AND FUNCTION('YEAR', l.dateDebut) = :annee " +
                "AND FUNCTION('MONTH', l.dateDebut) = :mois";

        return em.createQuery(jpql, Long.class)
                .setParameter("statuts", Arrays.asList("Confirmée", "Terminée"))
                .setParameter("annee", annee)
                .setParameter("mois", mois)
                .getSingleResult();
    }

    public List<Voiture> rechercherVoituresParMarqueOuModele(String motCle) {
        String jpql = "SELECT v FROM Voiture v WHERE LOWER(v.marque) LIKE :motCle OR LOWER(v.modele) LIKE :motCle";
        return em.createQuery(jpql, Voiture.class)
                .setParameter("motCle", "%" + motCle.toLowerCase() + "%")
                .getResultList();
    }

    public List<Client> rechercherClientsParNomOuPrenom(String motCle) {
        String jpql = "SELECT c FROM Client c WHERE LOWER(c.nom) LIKE :motCle OR LOWER(c.prenom) LIKE :motCle";
        return em.createQuery(jpql, Client.class)
                .setParameter("motCle", "%" + motCle.toLowerCase() + "%")
                .getResultList();
    }



    public void setEntityManager(EntityManager em) {
        this.em = em;

    }
}
