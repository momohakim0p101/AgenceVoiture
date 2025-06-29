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
    <style>
        /* Nouveaux styles pour les cartes de véhicules */
        .vehicle-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .vehicle-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            transition: transform 0.3s ease;
        }

        .vehicle-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .vehicle-card h3 {
            margin-top: 0;
            color: #2c3e50;
            font-size: 1.3rem;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .vehicle-card .immatriculation {
            font-weight: bold;
            color: #3498db;
            margin: 5px 0;
        }

        .vehicle-card .details {
            margin: 10px 0;
            color: #555;
        }

        .vehicle-card .details div {
            margin-bottom: 5px;
        }

        .vehicle-card .category {
            font-weight: bold;
            color: #e74c3c;
            margin: 10px 0;
        }

        .vehicle-card .price {
            font-size: 1.2rem;
            font-weight: bold;
            color: #27ae60;
            margin: 10px 0;
        }

        .vehicle-card .actions {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }

        .vehicle-card .actions button {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .vehicle-card .actions .edit-btn {
            background-color: #3498db;
            color: white;
        }

        .vehicle-card .actions .edit-btn:hover {
            background-color: #2980b9;
        }

        .vehicle-card .actions .delete-btn {
            background-color: #e74c3c;
            color: white;
        }

        .vehicle-card .actions .delete-btn:hover {
            background-color: #c0392b;
        }

        .search-container {
            padding: 20px;
            background: white;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .search-container input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }
    </style>
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
        <div class="table-actions">
            <div class="search-clients">
                <i class="fas fa-search"></i>
                <input type="text" id="tableSearchInput" placeholder="Rechercher..." />
            </div>
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

    <div class="search-container">
        <input type="text" id="vehicleSearchInput" placeholder="Rechercher par marque, modèle ou immatriculation..." />
    </div>

    <div class="vehicle-grid">
        <c:forEach var="voiture" items="${voitures}">
            <div class="vehicle-card">
                <h3>${voiture.marque} ${voiture.modele}</h3>
                <div class="immatriculation">${voiture.immatriculation}</div>
                <div class="details">
                    <div><i class="fas fa-users"></i> ${voiture.nombrePlaces} places</div>
                    <div><i class="fas fa-gas-pump"></i> ${voiture.typeCarburant}</div>
                    <div><i class="fas fa-calendar-alt"></i> ${voiture.dateMiseEnCirculation}</div>
                    <div><i class="fas fa-tachometer-alt"></i> ${voiture.kilometrage} km</div>
                </div>
                <div class="category">Catégorie: ${voiture.categorie}</div>
                <div class="price">${voiture.prixLocationJour} FCFA/jour</div>
                <div class="disponible">
                    <c:choose>
                        <c:when test="${voiture.disponible}">
                            <span style="color: green;"><i class="fas fa-check-circle"></i> Disponible</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: red;"><i class="fas fa-times-circle"></i> Indisponible</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="actions">
                    <button class="edit-btn" onclick="openEditModal('${voiture.immatriculation}')">
                        <i class="fas fa-edit"></i> Modifier
                    </button>
                    <button class="delete-btn" onclick="openDeleteModal('${voiture.immatriculation}')">
                        <i class="fas fa-trash"></i> Supprimer
                    </button>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty voitures}">
            <div style="grid-column: 1 / -1; text-align: center; padding: 20px;">
                Aucune voiture trouvée.
            </div>
        </c:if>
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

    <!-- Modal de modification -->
    <div class="modal" id="editVoitureModal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('editVoitureModal')">&times;</span>
            <h2>Modifier la Voiture</h2>
            <form method="post" action="${pageContext.request.contextPath}/VoitureServlet">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="immatriculation" id="edit-immatriculation" />

                <label>Immatriculation :</label>
                <input type="text" id="edit-immatriculation-display" readonly disabled />

                <label>Marque :</label>
                <select name="marque" id="edit-marque" required>
                    <option value="">-- Choisir une marque --</option>
                    <option value="Toyota">Toyota</option>
                    <option value="Renault">Renault</option>
                    <option value="Peugeot">Peugeot</option>
                    <option value="Ford">Ford</option>
                    <option value="BMW">BMW</option>
                </select>

                <label>Modèle :</label>
                <select name="modele" id="edit-modele" required>
                    <option value="">-- Choisir un modèle --</option>
                    <option value="Modèle A">Modèle A</option>
                    <option value="Modèle B">Modèle B</option>
                    <option value="Modèle C">Modèle C</option>
                    <option value="Modèle D">Modèle D</option>
                </select>

                <label>Places :</label>
                <select name="nombrePlaces" id="edit-nombrePlaces" required>
                    <option value="">-- Nombre de places --</option>
                    <option value="2">2</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="7">7</option>
                </select>

                <label>Type Carburant :</label>
                <select name="typeCarburant" id="edit-typeCarburant" required>
                    <option value="">-- Type de carburant --</option>
                    <option value="Essence">Essence</option>
                    <option value="Diesel">Diesel</option>
                    <option value="Électrique">Électrique</option>
                    <option value="Hybride">Hybride</option>
                </select>

                <label>Catégorie :</label>
                <select name="categorie" id="edit-categorie" required>
                    <option value="">-- Catégorie --</option>
                    <option value="Économique">Économique</option>
                    <option value="Berline">Berline</option>
                    <option value="SUV">SUV</option>
                    <option value="Luxe">Luxe</option>
                </select>

                <label>Prix / jour :</label>
                <input type="number" name="prixLocationJour" id="edit-prixLocationJour" required min="0" step="0.01" />

                <label>Disponible :</label>
                <select name="disponible" id="edit-disponible" required>
                    <option value="true">Disponible</option>
                    <option value="false">Indisponible</option>
                </select>

                <label>Date mise en circulation :</label>
                <input type="date" name="dateMiseEnCirculation" id="edit-dateMiseEnCirculation" />

                <label>Kilométrage :</label>
                <input type="number" name="kilometrage" id="edit-kilometrage" min="0" step="0.1" placeholder="Kilométrage" />

                <button type="submit">Modifier</button>
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

    // Nouvelle fonction de recherche pour les cartes
    document.getElementById("vehicleSearchInput").addEventListener("input", function() {
        const filter = this.value.toLowerCase();
        document.querySelectorAll(".vehicle-card").forEach(card => {
            const text = card.textContent.toLowerCase();
            card.style.display = text.includes(filter) ? "block" : "none";
        });
    });
</script>
</body>
</html>
