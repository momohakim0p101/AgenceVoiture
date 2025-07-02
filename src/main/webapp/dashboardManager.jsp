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
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

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
</head>
<body class="flex bg-gray-100 min-h-screen font-sans">

<!-- Sidebar menu inchangé -->
<aside class="w-64 bg-blue-600 text-white min-h-screen p-4 flex flex-col">
    <div class="flex items-center justify-center gap-2 px-4 py-6 border-b border-white/10">
        <img src="https://cdn.brandfetch.io/idD08_sdcu/w/250/h/250/theme/dark/icon.png?c=1dxbfHSJFAPEGdCLU4o5B" alt="Logo AutoDrive" class="h-8" />
        <span class="font-bold text-xl select-none">AutoManager</span>
    </div>
    <nav class="flex flex-col mt-4 px-2 space-y-1 text-sm font-medium flex-grow">
        <a href="${pageContext.request.contextPath}/DashboardManagerServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M11 17h2m-1-8v8m-6 4h14a2 2 0 002-2v-7a2 2 0 00-2-2H5a2 2 0 00-2 2v7a2 2 0 002 2z" />
            </svg>
            Tableau de bord
        </a>
        <a href="${pageContext.request.contextPath}/VoitureServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M3 13l1.5-2h15l1.5 2M5 16h14v2a1 1 0 01-1 1h-12a1 1 0 01-1-1v-2z" />
                <circle cx="7.5" cy="19.5" r="1.5" />
                <circle cx="16.5" cy="19.5" r="1.5" />
            </svg>
            Gestion voitures
        </a>
        <a href="${pageContext.request.contextPath}/ClientServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 11c1.104 0 2-.896 2-2s-.896-2-2-2-2 .896-2 2 .896 2 2 2z" />
                <path stroke-linecap="round" stroke-linejoin="round" d="M7 14l5 5m0 0l5-5m-5 5V9" />
            </svg>
            Gestion clients
        </a>
        <a href="${pageContext.request.contextPath}/LocationServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 11c1.104 0 2-.896 2-2s-.896-2-2-2-2 .896-2 2 .896 2 2 2z" />
                <path stroke-linecap="round" stroke-linejoin="round" d="M7 14l5 5m0 0l5-5m-5 5V9" />
            </svg>
            Gestion locations
        </a>
        <a href="${pageContext.request.contextPath}/utilisateurs.jsp" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87M12 12a5 5 0 100-10 5 5 0 000 10z" />
            </svg>
            Gestion utilisateurs
        </a>
    </nav>
    <div class="mt-auto text-xs text-gray-300 text-center pt-6">© 2025 AutoManager</div>
</aside>

<main class="flex-1 p-6">

    <!-- Header avec recherche et profil utilisateur -->
    <header class="flex justify-between items-center bg-white px-6 py-4 shadow-sm border-b border-gray-200 rounded-md mb-6">
        <div class="relative max-w-md w-full">
            <input id="searchInput" type="text" placeholder="Rechercher par marque, modèle ou immatriculation..."
                   class="pl-10 pr-4 py-2 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 w-full" />
            <i class="fas fa-search absolute left-3 top-2.5 text-gray-400"></i>
        </div>

        <div class="flex items-center gap-4">
            <div class="flex items-center gap-3">
                <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Profil" class="w-10 h-10 rounded-full object-cover shadow-sm" />
                <div class="flex flex-col text-gray-700">
                    <span class="font-semibold text-sm"><%= utilisateur != null ? utilisateur.getNom() : "Utilisateur" %></span>
                    <span class="text-xs text-gray-500"><%= utilisateur != null ? utilisateur.getRole() : "Rôle inconnu" %></span>
                </div>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/LogoutServlet" class="inline">
                <button type="submit" title="Déconnexion"
                        class="text-gray-600 hover:text-red-600 transition text-lg">
                    <i class="fas fa-sign-out-alt"></i>
                </button>
            </form>
        </div>
    </header>

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

</body>
</html>
