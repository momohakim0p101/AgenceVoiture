<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
<%@ page import="com.agence.agencevoiture.entity.*" %>

<%
    DecimalFormat df = new DecimalFormat("#,###");
    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
    Long totalVoitures = (Long) request.getAttribute("totalVoitures");
    totalVoitures = totalVoitures != null ? totalVoitures : 0L;
    List<Location> locationsEnCours = (List<Location>) request.getAttribute("locationsEnCours");
    List<Location> locationsHistoriques = (List<Location>) request.getAttribute("locationsHistoriques");
    List<Voiture> voituresDisponibles = (List<Voiture>) request.getAttribute("voituresDisponibles");
    BigDecimal revenuMois = (BigDecimal) request.getAttribute("revenuMois");
    revenuMois = revenuMois != null ? revenuMois : BigDecimal.ZERO;
    int nbVoituresDispo = voituresDisponibles != null ? voituresDisponibles.size() : 0;
    int nbVoituresLouees = locationsEnCours != null ? locationsEnCours.size() : 0;
%>

<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <title>Dashboard - AutoManager</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body class="bg-gray-100 min-h-screen flex">

<!-- Sidebar responsive -->
<div class="md:flex hidden flex-col w-64 bg-blue-600 text-white min-h-screen p-4" id="sidebar">
    <div class="flex items-center justify-between mb-6">
        <div class="flex items-center gap-2">
            <img src="https://cdn.brandfetch.io/idD08_sdcu/w/250/h/250/theme/dark/icon.png" alt="Logo" class="h-8" />
            <span class="font-bold text-xl">AutoManager</span>
        </div>
    </div>
    <nav class="flex flex-col gap-2 text-sm font-medium">
        <a href="${pageContext.request.contextPath}/DashboardManagerServlet" class="flex items-center gap-2 px-3 py-2 rounded hover:bg-blue-500">
            <i class="fas fa-tachometer-alt"></i> Tableau de bord
        </a>
        <a href="${pageContext.request.contextPath}/VoitureServlet" class="flex items-center gap-2 px-3 py-2 rounded hover:bg-blue-500">
            <i class="fas fa-car"></i> Gestion voitures
        </a>
        <a href="${pageContext.request.contextPath}/ClientServlet" class="flex items-center gap-2 px-3 py-2 rounded hover:bg-blue-500">
            <i class="fas fa-users"></i> Gestion clients
        </a>
        <a href="${pageContext.request.contextPath}/LocationServlet" class="flex items-center gap-2 px-3 py-2 rounded hover:bg-blue-500">
            <i class="fas fa-calendar-check"></i> Gestion locations
        </a>
        <a href="${pageContext.request.contextPath}/utilisateurs.jsp" class="flex items-center gap-2 px-3 py-2 rounded hover:bg-blue-500">
            <i class="fas fa-user-cog"></i> Utilisateurs
        </a>
    </nav>
    <form method="get" action="${pageContext.request.contextPath}/LogoutServlet" class="mt-auto">
        <button type="submit" class="w-full text-left flex items-center gap-2 px-3 py-2 hover:bg-red-600">
            <i class="fas fa-sign-out-alt"></i> Déconnexion
        </button>
    </form>
</div>

<!-- Content -->
<div class="flex-1 flex flex-col w-full">
    <!-- Topbar -->
    <header class="flex items-center justify-between bg-white shadow-md px-4 py-3 md:px-6 sticky top-0 z-10">
        <button class="md:hidden text-blue-600 text-2xl" onclick="document.getElementById('sidebarMobile').classList.toggle('hidden')">
            <i class="fas fa-bars"></i>
        </button>
        <div class="text-lg font-semibold">Tableau de bord</div>
        <div class="hidden md:flex items-center gap-4">
            <img src="https://randomuser.me/api/portraits/men/41.jpg" class="w-8 h-8 rounded-full" />
            <div class="text-sm text-gray-700">
                <div><%= utilisateur != null ? utilisateur.getNom() : "Utilisateur" %></div>
                <div class="text-xs text-gray-500"><%= utilisateur != null ? utilisateur.getRole() : "Rôle inconnu" %></div>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/LogoutServlet">
                <button title="Déconnexion" class="text-gray-600 hover:text-red-600">
                    <i class="fas fa-sign-out-alt"></i>
                </button>
            </form>
        </div>
    </header>

    <!-- Sidebar mobile -->
    <div id="sidebarMobile" class="md:hidden hidden bg-blue-600 text-white px-4 py-4">
        <nav class="flex flex-col gap-3">
            <a href="${pageContext.request.contextPath}/DashboardManagerServlet" class="hover:underline">Dashboard</a>
            <a href="${pageContext.request.contextPath}/VoitureServlet" class="hover:underline">Voitures</a>
            <a href="${pageContext.request.contextPath}/ClientServlet" class="hover:underline">Clients</a>
            <a href="${pageContext.request.contextPath}/LocationServlet" class="hover:underline">Locations</a>
            <a href="${pageContext.request.contextPath}/utilisateurs.jsp" class="hover:underline">Utilisateurs</a>
            <form method="get" action="${pageContext.request.contextPath}/LogoutServlet">
                <button class="hover:underline text-red-300">Déconnexion</button>
            </form>
        </nav>
    </div>

    <!-- Main content -->
    <main class="p-4 md:p-6 space-y-6">


        <!-- Cartes statistiques -->
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white shadow rounded-lg p-6 flex flex-col justify-between">
                <div class="flex justify-between items-center">
                    <p class="text-gray-500 font-semibold">Voitures Disponibles</p>
                    <div class="text-blue-600 text-4xl">
                        <i class="fas fa-car-side"></i>
                    </div>
                </div>
                <h2 class="text-3xl font-extrabold mt-3"><%= nbVoituresDispo %></h2>
                <p class="text-sm text-gray-500 mt-1">
                    <i class="fas fa-chart-line text-green-500 mr-1"></i>
                    <%= totalVoitures > 0 ? (nbVoituresDispo * 100 / totalVoitures) : 0 %>% du parc
                </p>
            </div>

            <div class="bg-white shadow rounded-lg p-6 flex flex-col justify-between">
                <div class="flex justify-between items-center">
                    <p class="text-gray-500 font-semibold">Voitures Louées</p>
                    <div class="text-red-600 text-4xl">
                        <i class="fas fa-car"></i>
                    </div>
                </div>
                <h2 class="text-3xl font-extrabold mt-3"><%= nbVoituresLouees %></h2>
                <p class="text-sm text-gray-500 mt-1">
                    <i class="fas fa-chart-line text-red-500 mr-1"></i>
                    <%= totalVoitures > 0 ? (nbVoituresLouees * 100 / totalVoitures) : 0 %>% du parc
                </p>
            </div>

            <div class="bg-white shadow rounded-lg p-6 flex flex-col justify-between">
                <div class="flex justify-between items-center">
                    <p class="text-gray-500 font-semibold">Clients Actifs</p>
                    <div class="text-green-600 text-4xl">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                <h2 class="text-3xl font-extrabold mt-3"><%= request.getAttribute("clientsActifs") != null ? request.getAttribute("clientsActifs") : 0 %></h2>
                <p class="text-sm text-gray-500 mt-1">
                    <i class="fas fa-arrow-up text-green-500 mr-1"></i>
                    <%= request.getAttribute("pourcentageClientsMois") != null ? request.getAttribute("pourcentageClientsMois") : 0 %>% ce mois
                </p>
            </div>

            <div class="bg-white shadow rounded-lg p-6 flex flex-col justify-between">
                <div class="flex justify-between items-center">
                    <p class="text-gray-500 font-semibold">Revenu du Mois</p>
                    <div class="text-yellow-500 text-4xl">
                        <i class="fas fa-euro-sign"></i>
                    </div>
                </div>
                <h2 class="text-3xl font-extrabold mt-3"><%= df.format(revenuMois) %> F CFA</h2>
                <p class="text-sm text-gray-500 mt-1">
                    <i class="fas fa-arrow-up text-yellow-500 mr-1"></i>
                    Ce mois
                </p>
            </div>
        </div>

        <!-- Section locations -->
        <div class="flex justify-between items-center mb-4">
            <h2 class="text-2xl font-bold text-gray-700">Locations en cours</h2>
            <button onclick="toggleHistorique()"
                    class="bg-blue-600 hover:bg-blue-700 transition text-white px-4 py-2 rounded shadow-sm select-none">
                Historique
            </button>
            <form action="NouvelleLocationServlet" method="get">
                <button
                        class="bg-blue-600 hover:bg-blue-700 transition text-white px-4 py-2 rounded shadow-sm select-none">
                    Nouvelle Location
                </button>
            </form>
        </div>

        <!-- Notification box -->
        <div id="notifBox" class="hidden bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-6 rounded shadow-sm select-none" role="alert" aria-live="assertive">
            <strong>Attention : </strong> Certaines locations ont dépassé leur date de fin. Veuillez les vérifier.
        </div>

        <!-- Table des locations en cours -->
        <div id="encoursTable" class="overflow-x-auto rounded shadow bg-white">
            <table class="min-w-full text-left border-collapse border border-gray-200">
                <thead class="bg-gray-100">
                <tr class="border-b border-gray-300">
                    <th class="px-4 py-3">Client</th>
                    <th class="px-4 py-3">Voiture</th>
                    <th class="px-4 py-3">Date début</th>
                    <th class="px-4 py-3">Date fin</th>
                    <th class="px-4 py-3">Montant</th>
                    <th class="px-4 py-3">Statut</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (locationsEnCours != null && !locationsEnCours.isEmpty()) {
                        for (Location l : locationsEnCours) {
                            if (l != null && l.getClient() != null && l.getVoiture() != null) {
                %>
                <tr data-fin="<%= l.getDateFin() %>" class="border-b border-gray-200 hover:bg-blue-50 transition">
                    <td class="px-4 py-2"><%= l.getClient().getNom() %></td>
                    <td class="px-4 py-2"><%= l.getVoiture().getMarque() %></td>
                    <td class="px-4 py-2"><%= l.getDateDebut() %></td>
                    <td class="px-4 py-2"><%= l.getDateFin() %></td>
                    <td class="px-4 py-2"><%= df.format(l.getMontantTotal()) %> F CFA</td>
                    <td class="px-4 py-2 font-semibold text-blue-600"><%= l.getStatut() %></td>
                </tr>
                <%
                        }
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="text-center p-4 text-gray-500">Aucune location en cours</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <!-- Table des locations historiques -->
        <div id="historiqueTable" class="hidden mt-8 overflow-x-auto rounded shadow bg-white">
            <h3 class="text-lg font-semibold mb-4 text-gray-700">Historique des locations</h3>
            <table class="min-w-full text-left border-collapse border border-gray-200">
                <thead class="bg-gray-100">
                <tr class="border-b border-gray-300">
                    <th class="px-4 py-3">Client</th>
                    <th class="px-4 py-3">Voiture</th>
                    <th class="px-4 py-3">Date début</th>
                    <th class="px-4 py-3">Date fin</th>
                    <th class="px-4 py-3">Montant</th>
                    <th class="px-4 py-3">Statut</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (locationsHistoriques != null && !locationsHistoriques.isEmpty()) {
                        for (Location l : locationsHistoriques) {
                            if (l != null && l.getClient() != null && l.getVoiture() != null) {
                %>
                <tr class="border-b border-gray-200 hover:bg-gray-50 transition">
                    <td class="px-4 py-2"><%= l.getClient().getNom() %></td>
                    <td class="px-4 py-2"><%= l.getVoiture().getMarque() %></td>
                    <td class="px-4 py-2"><%= l.getDateDebut() %></td>
                    <td class="px-4 py-2"><%= l.getDateFin() %></td>
                    <td class="px-4 py-2"><%= df.format(l.getMontantTotal()) %> F CFA</td>
                    <td class="px-4 py-2 font-semibold text-gray-600"><%= l.getStatut() %></td>
                </tr>
                <%
                        }
                    }
                } else {
                %>
                <tr>
                    <td colspan="6" class="text-center p-4 text-gray-500">Aucun historique disponible</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

    </main>
</div>

<script>
    // Toggle entre tables Locations en cours / Historique
    function toggleHistorique() {
        document.getElementById("historiqueTable").classList.toggle("hidden");
        document.getElementById("encoursTable").classList.toggle("hidden");
    }

    // Vérifier retards et afficher notification si nécessaire
    function verifierRetards() {
        const now = new Date();
        const rows = document.querySelectorAll('[data-fin]');
        let hasDelay = false;
        rows.forEach(row => {
            const dateFin = new Date(row.dataset.fin);
            if (dateFin < now) {
                row.classList.add("bg-red-100");
                hasDelay = true;
            }
        });
        if (hasDelay) {
            document.getElementById("notifBox").classList.remove("hidden");
        }
    }

    document.addEventListener("DOMContentLoaded", verifierRetards);
</script>
</body>
</html>
