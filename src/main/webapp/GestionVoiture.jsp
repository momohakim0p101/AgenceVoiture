<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Gestion Voitures - Agence de Location</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <link rel="stylesheet"  href="./css/dashboard.css">
    <link rel="stylesheet" href="./css/GestionClient.css">
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-car"></i> <span>Agence Location</span></h3>
    </div>
    <ul class="sidebar-menu">
        <li><a href="DashboardManager.jsp"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
        <li><a href="GestionVoiture.jsp" class="active"><i class="fas fa-car"></i> <span>Gestion Voitures</span></a></li>
        <li><a href="GestionClient.jsp"><i class="fas fa-users"></i> <span>Gestion Clients</span></a></li>
        <li><a href="GestionLocation.jsp"><i class="fas fa-file-contract"></i> <span>Locations</span></a></li>
    </ul>
</aside>

<main class="main-content">
    <div class="top-nav">
        <div class="search-bar">
            <i class="fas fa-search"></i>
            <input type="text" id="globalSearchInput" placeholder="Rechercher une voiture..." />
        </div>
        <div class="user-profile">
            <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Profile" />
            <div class="user-info">
                <span class="user-name">Jean Dupont</span>
                <span class="user-role">Gestionnaire</span>
            </div>
            <button class="logout-btn" title="Déconnexion">
                <i class="fas fa-sign-out-alt"></i>
            </button>
        </div>
    </div>

    <div class="page-header">
        <h1 class="page-title"><i class="fas fa-car"></i> Gestion des Voitures</h1>
        <button class="add-client-btn" id="addVoitureBtn">
            <i class="fas fa-plus"></i> Ajouter une Voiture
        </button>
    </div>

    <div class="clients-table-container">
        <div class="table-header">
            <h3>Liste des Voitures</h3>
            <div class="table-actions">
                <div class="search-clients">
                    <i class="fas fa-search"></i>
                    <input type="text" id="tableSearchInput" placeholder="Rechercher..." />
                </div>
                <button class="filter-btn">
                    <i class="fas fa-filter"></i> Filtrer
                </button>
            </div>
        </div>

        <table id="voituresTable">
            <thead>
            <tr>
                <th>Immatriculation</th>
                <th>Marque</th>
                <th>Modèle</th>
                <th>Places</th>
                <th>Carburant</th>
                <th>Catégorie</th>
                <th>Prix/Jour</th>
                <th>Disponible</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="voiture" items="${voitures}">
                <tr>
                    <td>${voiture.immatriculation}</td>
                    <td>${voiture.marque}</td>
                    <td>${voiture.modele}</td>
                    <td>${voiture.nombrePlaces}</td>
                    <td>${voiture.typeCarburant}</td>
                    <td>${voiture.categorie}</td>
                    <td>${voiture.prixLocationJour} FCFA</td>
                    <td>${voiture.disponible ? 'Oui' : 'Non'}</td>
                    <td>
                        <button class="action-btn edit-btn" data-voiture-id="${voiture.id}">
                            <i class="fas fa-edit"></i> Modifier
                        </button>
                        <button class="action-btn delete-btn" data-voiture-id="${voiture.id}">
                            <i class="fas fa-trash"></i> Supprimer
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty voitures}">
                <tr><td colspan="9" style="text-align:center;">Aucune voiture trouvée.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Modals similaires pour Ajouter/Modifier et Supprimer voiture seront ici -->
    <!-- Modal d'ajout -->
    <div class="modal" id="addVoitureModal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('addVoitureModal')">&times;</span>
            <h2>Ajouter une Voiture</h2>
            <form id="addVoitureForm">
                <input type="text" name="immatriculation" placeholder="Immatriculation" required />
                <input type="text" name="marque" placeholder="Marque" required />
                <input type="text" name="modele" placeholder="Modèle" required />
                <input type="number" name="nombrePlaces" placeholder="Nombre de places" required />
                <input type="text" name="typeCarburant" placeholder="Type de carburant" required />
                <input type="text" name="categorie" placeholder="Catégorie" required />
                <input type="number" name="prixLocationJour" placeholder="Prix / jour" required />
                <select name="disponible">
                    <option value="true">Disponible</option>
                    <option value="false">Indisponible</option>
                </select>
                <button type="submit">Ajouter</button>
            </form>
        </div>
    </div>

    <!-- Modal de modification -->
    <div class="modal" id="editVoitureModal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('editVoitureModal')">&times;</span>
            <h2>Modifier Voiture</h2>
            <form id="editVoitureForm">
                <input type="hidden" name="id" id="edit-id" />
                <input type="text" name="immatriculation" id="edit-immatriculation" required />
                <input type="text" name="marque" id="edit-marque" required />
                <input type="text" name="modele" id="edit-modele" required />
                <input type="number" name="nombrePlaces" id="edit-nombrePlaces" required />
                <input type="text" name="typeCarburant" id="edit-typeCarburant" required />
                <input type="text" name="categorie" id="edit-categorie" required />
                <input type="number" name="prixLocationJour" id="edit-prixLocationJour" required />
                <select name="disponible" id="edit-disponible">
                    <option value="true">Disponible</option>
                    <option value="false">Indisponible</option>
                </select>
                <button type="submit">Modifier</button>
            </form>
        </div>
    </div>

    <!-- Modal de suppression -->
    <div class="modal" id="deleteVoitureModal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('deleteVoitureModal')">&times;</span>
            <h2>Supprimer la voiture ?</h2>
            <p>Voulez-vous vraiment supprimer cette voiture ?</p>
            <form id="deleteVoitureForm">
                <input type="hidden" name="id" id="delete-id" />
                <button type="submit" class="delete-confirm-btn">Oui, supprimer</button>
                <button type="button" onclick="closeModal('deleteVoitureModal')">Annuler</button>
            </form>
        </div>
    </div>

</main>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        // Ouvrir modal ajout
        document.getElementById("addVoitureBtn").addEventListener("click", () => {
            openModal("addVoitureModal");
        });

        // Soumission formulaire d'ajout
        document.getElementById("addVoitureForm").addEventListener("submit", (e) => {
            e.preventDefault();
            const formData = new FormData(e.target);
            fetch("VoitureServlet", {
                method: "POST",
                body: formData,
            })
                .then(() => location.reload());
        });

        // Préremplir et ouvrir modal de modification
        document.querySelectorAll(".edit-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                const id = btn.dataset.voitureId;
                fetch(`VoitureServlet?action=get&id=${id}`)
                    .then(res => res.json())
                    .then(data => {
                        document.getElementById("edit-id").value = data.id;
                        document.getElementById("edit-immatriculation").value = data.immatriculation;
                        document.getElementById("edit-marque").value = data.marque;
                        document.getElementById("edit-modele").value = data.modele;
                        document.getElementById("edit-nombrePlaces").value = data.nombrePlaces;
                        document.getElementById("edit-typeCarburant").value = data.typeCarburant;
                        document.getElementById("edit-categorie").value = data.categorie;
                        document.getElementById("edit-prixLocationJour").value = data.prixLocationJour;
                        document.getElementById("edit-disponible").value = data.disponible;
                        openModal("editVoitureModal");
                    });
            });
        });

        // Soumission formulaire de modification
        document.getElementById("editVoitureForm").addEventListener("submit", (e) => {
            e.preventDefault();
            const formData = new FormData(e.target);
            formData.append("action", "update");
            fetch("VoitureServlet", {
                method: "POST",
                body: formData,
            })
                .then(() => location.reload());
        });

        // Ouvrir modal de suppression
        document.querySelectorAll(".delete-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                const id = btn.dataset.voitureId;
                document.getElementById("delete-id").value = id;
                openModal("deleteVoitureModal");
            });
        });

        // Soumission formulaire suppression
        document.getElementById("deleteVoitureForm").addEventListener("submit", (e) => {
            e.preventDefault();
            const id = document.getElementById("delete-id").value;
            fetch(`VoitureServlet?action=delete&id=${id}`, {
                method: "GET"
            })
                .then(() => location.reload());
        });
    });

    // Fonctions utilitaires
    function openModal(id) {
        document.getElementById(id).style.display = "block";
    }
    function closeModal(id) {
        document.getElementById(id).style.display = "none";
    }
</script>

</body>
</html>
