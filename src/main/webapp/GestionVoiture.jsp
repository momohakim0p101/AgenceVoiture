<%@ page import="com.agence.agencevoiture.entity.Utilisateur" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Utilisateur utilisateur = (Utilisateur) request.getAttribute("utilisateur");
    if (utilisateur == null) {
        utilisateur = (Utilisateur) session.getAttribute("utilisateur");
    }
    // CSRF token example (if CSRF protection is added)
    String csrfToken = (String) session.getAttribute("csrfToken");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Gestion Voitures - Agence de Location</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/GestionClient.css">
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-car"></i> <span>Agence Location</span></h3>
    </div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/DashboardManagerServlet"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/VoitureServlet?action=view" class="active"><i class="fas fa-car"></i> Gestion Voitures</a></li>
        <li><a href="${pageContext.request.contextPath}/ClientServlet"><i class="fas fa-users"></i> Gestion Clients</a></li>
        <li><a href="${pageContext.request.contextPath}/GestionLocation.jsp"><i class="fas fa-file-contract"></i> Locations</a></li>
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
                <span class="user-name"><%= utilisateur != null ? utilisateur.getNom() : "Utilisateur non connecté" %></span>
                <span class="user-role"><%= utilisateur != null ? utilisateur.getRole() : "Rôle inconnu" %></span>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/LogoutServlet" style="display:inline;">
                <button class="logout-btn" title="Déconnexion" type="submit">
                    <i class="fas fa-sign-out-alt"></i>
                </button>
            </form>
        </div>
    </div>

    <c:if test="${not empty param.error}">
        <div class="alert-error">
            <p>Erreur : ${param.error}</p>
        </div>
    </c:if>

    <div class="page-header">
        <h1 class="page-title"><i class="fas fa-car"></i> Gestion des Voitures</h1>
        <button class="add-client-btn" onclick="openModal('addVoitureModal')">
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
            </div>
        </div>

        <table id="voituresTable">
            <thead>
            <tr>
                <th>Immatriculation</th><th>Marque</th><th>Modèle</th><th>Places</th><th>Carburant</th>
                <th>Catégorie</th><th>Prix/Jour</th><th>Disponible</th><th>Date Mise en Circulation</th><th>Kilométrage</th><th>Actions</th>
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
                    <td><c:choose><c:when test="${voiture.disponible}">Oui</c:when><c:otherwise>Non</c:otherwise></c:choose></td>
                    <td>${voiture.dateMiseEnCirculation}</td>
                    <td>${voiture.kilometrage} km</td>
                    <td>
                        <button class="action-btn edit-btn" onclick="openEditModal('${voiture.immatriculation}')">
                            <i class="fas fa-edit"></i> Modifier
                        </button>
                        <button class="action-btn delete-btn" onclick="openDeleteModal('${voiture.immatriculation}')">
                            <i class="fas fa-trash"></i> Supprimer
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty voitures}">
                <tr><td colspan="11" style="text-align:center;">Aucune voiture trouvée.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Modales d'ajout, modification, suppression incluses ici (même structure, mais formulaire avec champ caché CSRF si activé) -->

    <!-- Ajout -->
    <div class="modal" id="addVoitureModal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('addVoitureModal')">&times;</span>
            <h2>Ajouter une Voiture</h2>
            <form method="post" action="${pageContext.request.contextPath}/VoitureServlet">
                <input type="hidden" name="action" value="save" />

                <input type="text" name="immatriculation" placeholder="Immatriculation" required />

                <select name="marque" required>
                    <option value="">-- Choisir une marque --</option>
                    <option value="Toyota">Toyota</option>
                    <option value="Renault">Renault</option>
                    <option value="Peugeot">Peugeot</option>
                    <option value="Ford">Ford</option>
                    <option value="BMW">BMW</option>
                </select>

                <select name="modele" required>
                    <option value="">-- Choisir un modèle --</option>
                    <option value="Modèle A">Modèle A</option>
                    <option value="Modèle B">Modèle B</option>
                    <option value="Modèle C">Modèle C</option>
                    <option value="Modèle D">Modèle D</option>
                </select>

                <select name="nombrePlaces" required>
                    <option value="">-- Nombre de places --</option>
                    <option value="2">2</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="7">7</option>
                </select>

                <select name="typeCarburant" required>
                    <option value="">-- Type de carburant --</option>
                    <option value="Essence">Essence</option>
                    <option value="Diesel">Diesel</option>
                    <option value="Électrique">Électrique</option>
                    <option value="Hybride">Hybride</option>
                </select>

                <select name="categorie" required>
                    <option value="">-- Catégorie --</option>
                    <option value="Économique">Économique</option>
                    <option value="Berline">Berline</option>
                    <option value="SUV">SUV</option>
                    <option value="Luxe">Luxe</option>
                </select>

                <input type="number" name="prixLocationJour" placeholder="Prix / jour" required min="0" step="0.01" />

                <select name="disponible" required>
                    <option value="true">Disponible</option>
                    <option value="false">Indisponible</option>
                </select>

                <label>Date mise en circulation :</label>
                <input type="date" name="dateMiseEnCirculation" />

                <label>Kilométrage :</label>
                <input type="number" name="kilometrage" min="0" step="0.1" placeholder="Kilométrage" />

                <button type="submit">Ajouter</button>
            </form>
        </div>
    </div>

    <div class="modal" id="addVoitureModal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('addVoitureModal')">&times;</span>
            <h2>Ajouter une Voiture</h2>
            <form method="post" action="${pageContext.request.contextPath}/VoitureServlet">
                <input type="hidden" name="action" value="save" />

                <input type="text" name="immatriculation" placeholder="Immatriculation" required />

                <select name="marque" required>
                    <option value="">-- Choisir une marque --</option>
                    <option value="Toyota">Toyota</option>
                    <option value="Renault">Renault</option>
                    <option value="Peugeot">Peugeot</option>
                    <option value="Ford">Ford</option>
                    <option value="BMW">BMW</option>
                </select>

                <select name="modele" required>
                    <option value="">-- Choisir un modèle --</option>
                    <option value="Modèle A">Modèle A</option>
                    <option value="Modèle B">Modèle B</option>
                    <option value="Modèle C">Modèle C</option>
                    <option value="Modèle D">Modèle D</option>
                </select>

                <select name="nombrePlaces" required>
                    <option value="">-- Nombre de places --</option>
                    <option value="2">2</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="7">7</option>
                </select>

                <select name="typeCarburant" required>
                    <option value="">-- Type de carburant --</option>
                    <option value="Essence">Essence</option>
                    <option value="Diesel">Diesel</option>
                    <option value="Électrique">Électrique</option>
                    <option value="Hybride">Hybride</option>
                </select>

                <select name="categorie" required>
                    <option value="">-- Catégorie --</option>
                    <option value="Économique">Économique</option>
                    <option value="Berline">Berline</option>
                    <option value="SUV">SUV</option>
                    <option value="Luxe">Luxe</option>
                </select>

                <input type="number" name="prixLocationJour" placeholder="Prix / jour" required min="0" step="0.01" />

                <select name="disponible" required>
                    <option value="true">Disponible</option>
                    <option value="false">Indisponible</option>
                </select>

                <label>Date mise en circulation :</label>
                <input type="date" name="dateMiseEnCirculation" />

                <label>Kilométrage :</label>
                <input type="number" name="kilometrage" min="0" step="0.1" placeholder="Kilométrage" />

                <button type="submit">Ajouter</button>
            </form>
        </div>
    </div>

    <div class="modal" id="deleteVoitureModal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('deleteVoitureModal')">&times;</span>
            <h2>Supprimer la voiture ?</h2>
            <p>Voulez-vous vraiment supprimer cette voiture ?</p>
            <form method="post" action="${pageContext.request.contextPath}/VoitureServlet">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="immatriculation" id="delete-immatriculation" />
                <button type="submit" class="delete-confirm-btn">Oui, supprimer</button>
                <button type="button" onclick="closeModal('deleteVoitureModal')">Annuler</button>
            </form>
        </div>
    </div>


</main>

<script>
    function openModal(id) {
        document.getElementById(id).style.display = "block";
    }
    function closeModal(id) {
        document.getElementById(id).style.display = "none";
    }
    function openEditModal(immatriculation) {
        document.getElementById("edit-immatriculation").value = immatriculation;
        document.getElementById("edit-immatriculation-display").value = immatriculation;
        openModal("editVoitureModal");
    }
    function openDeleteModal(immatriculation) {
        document.getElementById("delete-immatriculation").value = immatriculation;
        openModal("deleteVoitureModal");
    }
    document.getElementById("tableSearchInput").addEventListener("input", function() {
        const filter = this.value.toLowerCase();
        document.querySelectorAll("#voituresTable tbody tr").forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(filter) ? "" : "none";
        });
    });
</script>
</body>
</html>
