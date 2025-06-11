<%--
  Created by IntelliJ IDEA.
  User: hakim01
  Date: 06/06/2025
  Time: 10:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Gestionnaire - Agence de Location</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="./css/dashboard.css">
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-car"></i> <span>Agence Location</span></h3>
    </div>
    <ul class="sidebar-menu">
        <li>
            <a href="#" class="active">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/manager/voitures">
                <i class="fas fa-car"></i>
                <span>Gestion Voitures</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/manager/clients">
                <i class="fas fa-users"></i>
                <span>Gestion Clients</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/manager/locations">
                <i class="fas fa-file-contract"></i>
                <span>Locations</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/manager/recherche">
                <i class="fas fa-search"></i>
                <span>Recherche Avancée</span>
            </a>
        </li>
    </ul>
</aside>

<!-- Main Content -->
<main class="main-content">
    <!-- Top Navigation -->
    <div class="top-nav">
        <div class="search-bar">
            <i class="fas fa-search"></i>
            <input type="text" id="globalSearch" placeholder="Rechercher voiture, client...">
        </div>
        <div class="user-profile">
            <img src="${pageContext.request.contextPath}/images/profile.jpg" alt="Profile">
            <div class="user-info">
                <span class="user-name">${sessionScope.manager.prenom} ${sessionScope.manager.nom}</span>
                <span class="user-role">Gestionnaire</span>
            </div>
            <button class="logout-btn" title="Déconnexion" id="logoutBtn">
                <i class="fas fa-sign-out-alt"></i>
            </button>
        </div>
    </div>

    <!-- Dashboard Cards -->
    <div class="dashboard-cards">
        <div class="card">
            <div class="card-header">
                <span class="card-title">Voitures Disponibles</span>
                <div class="card-icon blue">
                    <i class="fas fa-car"></i>
                </div>
            </div>
            <div class="card-value" id="availableCarsCount">0</div>
            <div class="card-footer">
                <i class="fas fa-info-circle"></i> Dernière mise à jour: <span id="lastUpdateTime"></span>
            </div>
        </div>
        <div class="card">
            <div class="card-header">
                <span class="card-title">Voitures Louées</span>
                <div class="card-icon red">
                    <i class="fas fa-car-side"></i>
                </div>
            </div>
            <div class="card-value" id="rentedCarsCount">0</div>
            <div class="card-footer">
                <i class="fas fa-info-circle"></i> En cours cette semaine
            </div>
        </div>
        <div class="card">
            <div class="card-header">
                <span class="card-title">Clients Actifs</span>
                <div class="card-icon green">
                    <i class="fas fa-users"></i>
                </div>
            </div>
            <div class="card-value" id="activeClientsCount">0</div>
            <div class="card-footer">
                <i class="fas fa-info-circle"></i> Total clients
            </div>
        </div>
        <div class="card">
            <div class="card-header">
                <span class="card-title">Revenu du Mois</span>
                <div class="card-icon yellow">
                    <i class="fas fa-euro-sign"></i>
                </div>
            </div>
            <div class="card-value" id="monthlyRevenue">€0</div>
            <div class="card-footer">
                <i class="fas fa-info-circle"></i> Objectif: €15,000
            </div>
        </div>
    </div>

    <!-- Recent Activity Section -->
    <h3 class="section-title"><i class="fas fa-clock"></i> Locations Récentes</h3>
    <div class="activity-table">
        <table id="recentRentalsTable">
            <thead>
            <tr>
                <th>Client</th>
                <th>Voiture</th>
                <th>Date Début</th>
                <th>Date Fin</th>
                <th>Montant</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <!-- Les données seront chargées via JavaScript -->
            </tbody>
        </table>
    </div>

    <!-- Return Car Modal -->
    <div class="modal" id="returnCarModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Enregistrer le retour</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="returnCarForm">
                    <div class="form-group">
                        <label for="returnKilometers">Nouveau kilométrage</label>
                        <input type="number" id="returnKilometers" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="returnNotes">Notes (dommages, etc.)</label>
                        <textarea id="returnNotes" class="form-control" rows="3"></textarea>
                    </div>
                    <input type="hidden" id="rentalId">
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary close-modal">Annuler</button>
                <button class="btn btn-primary" id="confirmReturnBtn">Enregistrer</button>
            </div>
        </div>
    </div>
</main>

<script src="./js/dashboard.js"></script>
</body>
</html>
