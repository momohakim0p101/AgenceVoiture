<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.agence.agencevoiture.entity.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <title>Dashboard Chef d'Agence</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <style>
        /* Ajoute ici ton CSS personnalisé */
        body { font-family: 'Roboto', sans-serif; margin:0; background:#f5f5f5; }
        .sidebar { width: 220px; background:#222; height: 100vh; position: fixed; color: white; }
        .sidebar-header { padding: 20px; font-size: 1.5em; text-align:center; background:#111; }
        .sidebar-menu { list-style:none; padding:0; margin:0; }
        .sidebar-menu li a { color:#bbb; display:flex; align-items:center; padding:15px 20px; text-decoration:none; }
        .sidebar-menu li a.active, .sidebar-menu li a:hover { background:#444; color:#fff; }
        .sidebar-menu i { margin-right:10px; }
        .main-content { margin-left: 220px; padding: 20px; }
        .top-nav { background:#fff; padding: 10px 20px; display:flex; justify-content:flex-end; align-items:center; box-shadow: 0 1px 5px rgba(0,0,0,0.1); }
        .top-nav .user-profile { display:flex; align-items:center; gap:10px; }
        .top-nav img { border-radius:50%; width:35px; height:35px; }
        .dashboard-cards { display:flex; gap:20px; margin:20px 0; flex-wrap: wrap; }
        .card { background:#fff; flex: 1 1 200px; padding:20px; border-radius:8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); position: relative; }
        .card .card-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; }
        .card .card-title { font-weight: 500; font-size: 1.1em; }
        .card .card-icon { font-size: 1.5em; padding: 8px; border-radius: 50%; color:#fff; }
        .card-icon.info { background:#17a2b8; }
        .card-icon.success { background:#28a745; }
        .card-icon.warning { background:#ffc107; color:#212529; }
        .card-icon.danger { background:#dc3545; }
        .card .card-value { font-size: 2.2em; font-weight: 700; }
        .section-title { font-size: 1.3em; margin: 30px 0 10px; color: #333; }
        table { width: 100%; border-collapse: collapse; background:#fff; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        th, td { padding: 12px 15px; border-bottom: 1px solid #ddd; text-align: left; }
        th { background: #f8f9fa; }
    </style>
</head>
<body>

<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-header"><i class="fas fa-car"></i> Chef d'Agence</div>
    <ul class="sidebar-menu">
        <li><a href="#" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
        <li><a href="#"><i class="fas fa-car"></i> Gestion Voitures</a></li>
        <li><a href="#"><i class="fas fa-users"></i> Gestion Clients</a></li>
        <li><a href="#"><i class="fas fa-file-contract"></i> Locations</a></li>
        <li><a href="#"><i class="fas fa-chart-line"></i> Statistiques</a></li>
    </ul>
</aside>

<!-- Main Content -->
<main class="main-content">
    <div class="top-nav">
        <div class="user-profile">
            <img src="https://randomuser.me/api/portraits/men/45.jpg" alt="Profile" />
            <div>
                <div><strong>Chef d'Agence</strong></div>
                <div>Jean Dupont</div>
            </div>
        </div>
    </div>

    <div class="dashboard-cards">
        <div class="card">
            <div class="card-header">
                <span class="card-title">Total Voitures</span>
                <div class="card-icon info"><i class="fas fa-car"></i></div>
            </div>
            <div class="card-value"><%= request.getAttribute("totalVoitures") %></div>
        </div>
        <div class="card">
            <div class="card-header">
                <span class="card-title">Voitures Disponibles</span>
                <div class="card-icon success"><i class="fas fa-check-circle"></i></div>
            </div>
            <div class="card-value"><%= request.getAttribute("voituresDispo") %></div>
        </div>
        <div class="card">
            <div class="card-header">
                <span class="card-title">Voitures en Location</span>
                <div class="card-icon warning"><i class="fas fa-car-side"></i></div>
            </div>
            <div class="card-value"><%= request.getAttribute("voituresEnLocation") %></div>
        </div>
        <div class="card">
            <div class="card-header">
                <span class="card-title">Bilan (FCFA)</span>
                <div class="card-icon danger"><i class="fas fa-money-bill-wave"></i></div>
            </div>
            <div class="card-value"><%= request.getAttribute("bilan") %></div>
        </div>
    </div>

    <h3 class="section-title"><i class="fas fa-clock"></i> Locations en cours</h3>
    <table>
        <thead>
        <tr>
            <th>Client</th>
            <th>Voiture</th>
            <th>Montant (FCFA)</th>
            <th>Jours</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Location> locations = (List<Location>) request.getAttribute("locations");
            if (locations != null && !locations.isEmpty()) {
                for (Location l : locations) {
        %>
        <tr>
            <td><%= l.getClient().getNom() %></td>
            <td><%= l.getVoiture().getImmatriculation() %></td>
            <td><%= l.getMontantTotal() %></td>
            <td><%= l.getJours() %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="4" style="text-align:center;">Aucune location en cours</td></tr>
        <%
            }
        %>
        </tbody>
    </table>
</main>

</body>
</html>
