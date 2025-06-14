<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
<%@ page import="com.agence.agencevoiture.entity.*" %>

<%
    DecimalFormat df = new DecimalFormat("#,###");

    Utilisateur utilisateur = (Utilisateur) request.getAttribute("utilisateur");
    if (utilisateur == null) {
        utilisateur = (Utilisateur) session.getAttribute("utilisateur");
    }

    Long totalVoituresAttr = (Long) request.getAttribute("totalVoitures");
    long totalVoitures = totalVoituresAttr != null ? totalVoituresAttr : 0L;

    List<Location> locationsEnCours = (List<Location>) request.getAttribute("locationsEnCours");
    if (locationsEnCours == null) {
        locationsEnCours = new ArrayList<>();
    }

    List<Voiture> voituresDisponibles = (List<Voiture>) request.getAttribute("voituresDisponibles");
    if (voituresDisponibles == null) {
        voituresDisponibles = new ArrayList<>();
    }

    BigDecimal revenuMois = (BigDecimal) request.getAttribute("revenuMois");
    if (revenuMois == null) {
        revenuMois = BigDecimal.ZERO;
    }

    int nbVoituresDispo = voituresDisponibles.size();
    int nbVoituresLouees = locationsEnCours.size();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Gestionnaire - Agence de Location</title>
    <link rel="stylesheet" href="./css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>

<body>

<aside class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-car"></i> <span>Agence Location</span></h3>
    </div>
    <ul class="sidebar-menu">
        <li><a href="${pageContext.request.contextPath}/DashboardManager.jsp" class="active"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
        <li><a href="${pageContext.request.contextPath}/GestionVoiture.jsp"><i class="fas fa-car"></i> <span>Gestion Voitures</span></a></li>
        <li><a href="${pageContext.request.contextPath}/GestionClient.jsp"><i class="fas fa-users"></i> <span>Gestion Clients</span></a></li>
        <li><a href="${pageContext.request.contextPath}/GestionLocation.jsp"><i class="fas fa-file-contract"></i> <span>Locations</span></a></li>
        <li><a href="#"><i class="fas fa-search"></i> <span>Recherche Avancée</span></a></li>
        <li><a href="#"><i class="fas fa-chart-line"></i> <span>Statistiques</span></a></li>
    </ul>
</aside>

<main class="main-content">
    <div class="top-nav">
        <div class="search-bar">
            <i class="fas fa-search"></i>
            <input type="text" id="searchInput" placeholder="Rechercher voiture, client...">
        </div>

        <div class="user-profile">
            <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Profile">
            <div class="user-info">
                <% if (utilisateur != null) { %>
                <span class="user-name"><%= utilisateur.getNom() %></span>
                <span class="user-role"><%= utilisateur.getRole() %></span>
                <% } else { %>
                <span class="user-name">Utilisateur non connecté</span>
                <span class="user-role">Rôle inconnu</span>
                <% } %>
            </div>
            <button class="logout-btn" title="Déconnexion">
                <a href="<%= request.getContextPath() %>/LogoutServlet"><i class="fas fa-sign-out-alt"></i></a>
            </button>
        </div>
    </div>

    <div class="dashboard-cards">
        <div class="card">
            <div class="card-header">
                <span class="card-title">Voitures Disponibles</span>
                <div class="card-icon blue"><i class="fas fa-car"></i></div>
            </div>
            <div class="card-value"><%= nbVoituresDispo %></div>
            <div class="card-footer">
                <i class="fas fa-arrow-up"></i>
                <%= totalVoitures > 0 ? (nbVoituresDispo * 100 / totalVoitures) : 0 %>% du parc
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <span class="card-title">Voitures Louées</span>
                <div class="card-icon red"><i class="fas fa-car-side"></i></div>
            </div>
            <div class="card-value"><%= nbVoituresLouees %></div>
            <div class="card-footer">
                <i class="fas fa-arrow-down"></i>
                <%= totalVoitures > 0 ? (nbVoituresLouees * 100 / totalVoitures) : 0 %>% du parc
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <span class="card-title">Clients Actifs</span>
                <div class="card-icon green"><i class="fas fa-users"></i></div>
            </div>
            <div class="card-value"><%= request.getAttribute("clientsActifs") != null ? request.getAttribute("clientsActifs") : 0 %></div>
            <div class="card-footer">
                <i class="fas fa-arrow-up"></i>
                <%= request.getAttribute("pourcentageClientsMois") != null ? request.getAttribute("pourcentageClientsMois") : 0 %>% ce mois
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <span class="card-title">Revenu du Mois</span>
                <div class="card-icon yellow"><i class="fas fa-euro-sign"></i></div>
            </div>
            <div class="card-value"><%= df.format(revenuMois) %> F CFA</div>
            <div class="card-footer">
                <i class="fas fa-arrow-up"></i> Ce mois
            </div>
        </div>
    </div>

    <h2 class="section-title"><i class="fas fa-file-contract"></i> Locations en cours</h2>

    <!-- Champ recherche local au tableau -->
    <div style="margin-bottom: 10px;">
        <input type="text" id="searchInputTable" placeholder="Filtrer le tableau des locations...">
    </div>

    <table class="activity-table">
        <thead>
        <tr>
            <th>Client</th>
            <th>Voiture</th>
            <th>Date début</th>
            <th>Date fin</th>
            <th>Montant</th>
            <th>Statut</th>
        </tr>
        </thead>
        <tbody>
        <% if (!locationsEnCours.isEmpty()) {
            for(Location l : locationsEnCours) { %>
        <tr>
            <td><%= l.getClient().getPrenom() + " " + l.getClient().getNom() %></td>
            <td><%= l.getVoiture().getMarque() + " " + l.getVoiture().getModele() %></td>
            <td><%= l.getDateDebut() %></td>
            <td><%= l.getDateFin() %></td>
            <td><%= df.format(l.getMontantTotal()) %> F CFA</td>
            <td>
                <button class="action-btn edit-btn"><%= l.getStatut() %></button>
                <button class="action-btn delete-btn"><i class="fas fa-trash"></i></button>
            </td>
        </tr>
        <%  }
        } else { %>
        <tr><td colspan="6" style="text-align:center;">Aucune location en cours</td></tr>
        <% } %>
        </tbody>
    </table>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const input = document.getElementById("searchInputTable");
        const rows = document.querySelectorAll(".activity-table tbody tr");

        input.addEventListener("input", function () {
            const filter = input.value.toLowerCase();

            rows.forEach(row => {
                const client = row.cells[0]?.textContent.toLowerCase() || "";
                const voiture = row.cells[1]?.textContent.toLowerCase() || "";

                if (client.includes(filter) || voiture.includes(filter)) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        });
    });
</script>

</body>
</html>
