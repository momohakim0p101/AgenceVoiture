package com.agence.agencevoiture.service;

import com.agence.agencevoiture.dao.LocationDAO;
import com.agence.agencevoiture.entity.Client;
import com.agence.agencevoiture.entity.Location;
import com.agence.agencevoiture.entity.Location.StatutLocation;
import com.agence.agencevoiture.entity.Voiture;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class LocationService {

    @PersistenceContext
    private EntityManager em;

    private final LocationDAO locationDAO = new LocationDAO();

    public LocationService() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("pu");
        this.em = emf.createEntityManager();
    }

    // 1. Situation du parking

    public long compterVoitures() {
        return em.createQuery("SELECT COUNT(v) FROM Voiture v", Long.class)
                .getSingleResult();
    }

    public List<Location> getLocationsEnCours() {
        return locationDAO.findByStatut(StatutLocation.CONFIRMEE);
    }

    public List<Location> getLocationsHistoriques() {
        return locationDAO.findByStatuts(List.of(
                Location.StatutLocation.TERMINEE,
                Location.StatutLocation.ANNULEE
        ));
    }


    public List<Voiture> voituresDisponibles() {
        return em.createQuery(
                        "SELECT v FROM Voiture v WHERE v.disponible = true", Voiture.class)
                .getResultList();
    }

    // 2. Voitures les plus louées

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

    public BigDecimal bilanFinancierMensuel(int annee, int mois) {
        TypedQuery<Double> query = em.createQuery(
                "SELECT COALESCE(SUM(l.montantTotal), 0) FROM Location l " +
                        "WHERE l.statut = :statut " +
                        "AND FUNCTION('YEAR', l.dateFin) = :annee " +
                        "AND FUNCTION('MONTH', l.dateFin) = :mois", Double.class);
        query.setParameter("statut", StatutLocation.TERMINEE);
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
        location.setStatut(StatutLocation.CONFIRMEE);

        em.getTransaction().begin();
        em.persist(location);
        voiture.setDisponible(false);
        em.merge(voiture);
        em.getTransaction().commit();

        return location;
    }

    public Location terminerLocation(Long idReservation) {
        em.getTransaction().begin();
        Location location = em.find(Location.class, idReservation);
        if (location == null || location.getStatut() != StatutLocation.CONFIRMEE) {
            em.getTransaction().rollback();
            throw new IllegalStateException("Location non trouvée ou déjà terminée");
        }
        location.setStatut(StatutLocation.TERMINEE);
        location.getVoiture().setDisponible(true);
        em.merge(location.getVoiture());
        em.merge(location);
        em.getTransaction().commit();
        return location;
    }

    public Location annulerLocation(Long idReservation) {
        em.getTransaction().begin();
        Location location = em.find(Location.class, idReservation);
        if (location == null || location.getStatut() != StatutLocation.CONFIRMEE) {
            em.getTransaction().rollback();
            throw new IllegalStateException("Location non trouvée ou déjà terminée");
        }
        location.setStatut(StatutLocation.ANNULEE);
        location.getVoiture().setDisponible(true);
        em.merge(location.getVoiture());
        em.merge(location);
        em.getTransaction().commit();
        return location;
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
        List<StatutLocation> statuts = Arrays.asList(StatutLocation.LOUE, StatutLocation.EN_COURS);
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(DISTINCT l.client) FROM Location l WHERE l.statut IN :statuts", Long.class);
        query.setParameter("statuts", statuts);
        Long result = query.getSingleResult();
        return result != null ? result : 0L;
    }



    public long compterTotalClients() {
        return em.createQuery("SELECT COUNT(c) FROM Client c", Long.class)
                .getSingleResult();
    }

    public long compterClientsActifsMois(int annee, int mois) {
        List<StatutLocation> statuts = Arrays.asList(StatutLocation.CONFIRMEE, StatutLocation.TERMINEE);
        String jpql = "SELECT COUNT(DISTINCT l.client) FROM Location l " +
                "WHERE l.statut IN :statuts " +
                "AND FUNCTION('YEAR', l.dateDebut) = :annee " +
                "AND FUNCTION('MONTH', l.dateDebut) = :mois";

        return em.createQuery(jpql, Long.class)
                .setParameter("statuts", statuts)
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

    public List<Location> listerLocationsHistoriques() {
        List<Location> toutesLocations = locationDAO.trouverTous();
        return toutesLocations.stream()
                .filter(loc -> loc.getStatut() != null && loc.getStatut() != StatutLocation.CONFIRMEE)
                .collect(Collectors.toList());
    }

    public BigDecimal bilanFinancierHebdomadaire(LocalDate debut, LocalDate fin) {
        TypedQuery<Double> query = em.createQuery(
                "SELECT COALESCE(SUM(l.montantTotal), 0) FROM Location l " +
                        "WHERE l.statut = :statut " +
                        "AND l.dateFin BETWEEN :debut AND :fin", Double.class);
        query.setParameter("statut", StatutLocation.TERMINEE);
        query.setParameter("debut", java.sql.Date.valueOf(debut));
        query.setParameter("fin", java.sql.Date.valueOf(fin));
        Double result = query.getSingleResult();
        return BigDecimal.valueOf(result != null ? result : 0.0);
    }

    public BigDecimal bilanFinancierJournalier(LocalDate date) {
        TypedQuery<Double> query = em.createQuery(
                "SELECT COALESCE(SUM(l.montantTotal), 0) FROM Location l " +
                        "WHERE l.statut = :statut " +
                        "AND FUNCTION('YEAR', l.dateFin) = :annee " +
                        "AND FUNCTION('MONTH', l.dateFin) = :mois " +
                        "AND FUNCTION('DAY', l.dateFin) = :jour", Double.class);
        query.setParameter("statut", StatutLocation.TERMINEE);
        query.setParameter("annee", date.getYear());
        query.setParameter("mois", date.getMonthValue());
        query.setParameter("jour", date.getDayOfMonth());
        Double result = query.getSingleResult();
        return BigDecimal.valueOf(result != null ? result : 0.0);
    }

    public BigDecimal objectifDuMois() {
        // À améliorer plus tard via paramètre dynamique ou en BDD
        return BigDecimal.valueOf(1_000_000); // Ex: 1 million F CFA
    }
    // Lister les locations encore actives
    public List<Location> listerLocationsEnCours() {
        return em.createQuery("SELECT l FROM Location l WHERE l.statut = :statut", Location.class)
                .setParameter("statut", StatutLocation.EN_COURS)
                .getResultList();
    }

    // Lister les locations terminées
    public List<Location> listerLocationsTerminees() {
        return em.createQuery("SELECT l FROM Location l WHERE l.statut = :statut", Location.class)
                .setParameter("statut", StatutLocation.TERMINEE)
                .getResultList();
    }

    // Nombre de clients actifs ce mois
    public int nombreClientsActifsDuMois(int annee, int mois) {
        Long count = em.createQuery(
                        "SELECT COUNT(DISTINCT l.client.id) FROM Location l " +
                                "WHERE FUNCTION('YEAR', l.dateDebut) = :annee AND FUNCTION('MONTH', l.dateDebut) = :mois", Long.class)
                .setParameter("annee", annee)
                .setParameter("mois", mois)
                .getSingleResult();
        return count != null ? count.intValue() : 0;
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
