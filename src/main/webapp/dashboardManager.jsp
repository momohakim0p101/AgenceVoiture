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
<%
    String message = (String) session.getAttribute("message");
    String erreur = (String) session.getAttribute("erreur");
    if (message != null) session.removeAttribute("message");
    if (erreur != null) session.removeAttribute("erreur");
%>

<div id="flashMessage" class="fixed top-5 right-5 max-w-sm w-full z-50
    <%= (message != null || erreur != null) ? "opacity-100" : "opacity-0 pointer-events-none" %>
    transition-opacity duration-700 ease-in-out">
    <% if (message != null) { %>
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded shadow flex items-center gap-3">
        <svg class="w-6 h-6 text-green-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
        </svg>
        <span><%= message %></span>
    </div>
    <% } else if (erreur != null) { %>
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded shadow flex items-center gap-3">
        <svg class="w-6 h-6 text-red-500" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
        </svg>
        <span><%= erreur %></span>
    </div>
    <% } %>
</div>


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
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-6 gap-4">
            <div class="flex items-center gap-2">
                <form action="NouvelleLocationServlet" method="get">
                    <button type="submit"
                            class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white font-medium px-4 py-2 rounded-md shadow transition">
                        <i class="fas fa-plus-circle"></i>
                        Nouvelle Location
                    </button>
                </form>

                <button onclick="toggleHistorique()"
                        class="inline-flex items-center gap-2 bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium px-4 py-2 rounded-md shadow transition">
                    <i class="fas fa-history"></i>
                    Historique
                </button>
            </div>
        </div>


        <!-- Notification box -->
        <div id="notifBox" class="hidden bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-6 rounded shadow-sm select-none" role="alert" aria-live="assertive">
            <strong>Attention : </strong> Certaines locations ont dépassé leur date de fin. Veuillez les vérifier.
        </div>

        <!-- Table des locations en cours -->
        <h2 class="text-xl md:text-2xl font-semibold text-gray-700 mb-4 flex items-center gap-2">
            <i class="fas fa-calendar-check text-blue-600 text-xl"></i>
            Locations en cours
        </h2>
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
                    <th class="px-4 py-3 text-center">Actions</th>
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
                    <td class="px-4 py-2 text-center">
                        <form action="RetournerVoitureServlet" method="post" onsubmit="return confirm('Confirmer le retour de cette voiture ?');">
                            <input type="hidden" name="locationId" value="<%= l.getIdReservation() %>">
                            <input type="hidden" name="dateRetourEffectif" value=" <%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(l.getDateFin()) %>
%>">
                            <button type="submit"
                                    class="inline-flex items-center gap-1 bg-green-600 hover:bg-green-700 text-white px-3 py-1 rounded text-sm shadow transition">
                                <i class="fas fa-undo"></i> Retourner
                            </button>
                        </form>


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
