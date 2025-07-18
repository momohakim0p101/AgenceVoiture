<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Agence</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,line-clamp"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body class="bg-gray-100 font-sans leading-normal tracking-normal">
<div class="flex min-h-screen">
    <!-- Sidebar -->
    <div class="md:flex hidden flex-col w-64 bg-blue-600 text-white min-h-screen p-4" id="sidebar">
        <aside class="fixed top-0 left-0 h-screen w-64 bg-[#3b82f6] text-white flex flex-col">
            <div class="flex items-center justify-center gap-2 px-4 py-6 border-b border-white/10">
                <img src="https://cdn.brandfetch.io/idD08_sdcu/w/250/h/250/theme/dark/icon.png?c=1dxbfHSJFAPEGdCLU4o5B" alt="Logo AutoDrive" class="h-8" />
                <span class="font-bold text-xl">AutoManager</span>
            </div>
            <nav class="flex flex-col mt-4 px-2 space-y-1 text-sm font-medium">
                <a href="${pageContext.request.contextPath}/DashboardManagerServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
                    <!-- Icon Dashboard: graphique simple -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M11 17h2m-1-8v8m-6 4h14a2 2 0 002-2v-7a2 2 0 00-2-2H5a2 2 0 00-2 2v7a2 2 0 002 2z" />
                    </svg>
                    Tableau de bord
                </a>
                <a href="${pageContext.request.contextPath}/VoitureServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
                    <!-- Icon Voiture -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3 13l1.5-2h15l1.5 2M5 16h14v2a1 1 0 01-1 1h-12a1 1 0 01-1-1v-2z" />
                        <circle cx="7.5" cy="19.5" r="1.5" />
                        <circle cx="16.5" cy="19.5" r="1.5" />
                    </svg>
                    Gestion voitures
                </a>
                <a href="${pageContext.request.contextPath}/ClientServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
                    <!-- Icon Locations: clé -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 11c1.104 0 2-.896 2-2s-.896-2-2-2-2 .896-2 2 .896 2 2 2z" />
                        <path stroke-linecap="round" stroke-linejoin="round" d="M7 14l5 5m0 0l5-5m-5 5V9" />
                    </svg>
                    Gestion clients
                </a>
                <a href="${pageContext.request.contextPath}/LocationServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
                    <!-- Icon Locations: clé -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 11c1.104 0 2-.896 2-2s-.896-2-2-2-2 .896-2 2 .896 2 2 2z" />
                        <path stroke-linecap="round" stroke-linejoin="round" d="M7 14l5 5m0 0l5-5m-5 5V9" />
                    </svg>
                    Gestion locations
                </a>
                <a href="${pageContext.request.contextPath}/AgenceServlet" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
                    <!-- Icon Utilisateurs: groupe utilisateurs -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87M12 12a5 5 0 100-10 5 5 0 000 10z" />
                    </svg>
                    Gestion Agence
                </a>
            </nav>
            <div class="mt-auto">
                <!-- Bouton Déconnexion -->
                <a href="${pageContext.request.contextPath}/LogoutServlet"
                   class="flex items-center gap-2 px-3 py-2 mx-4 mb-2 rounded bg-red-500 hover:bg-red-600 text-white text-sm justify-center transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1" />
                    </svg>
                    Déconnexion
                </a>
                <!-- Copyright -->
                <div class="text-xs text-gray-300 text-center pb-4">© 2025 AutoManager</div>
            </div>

        </aside>
    </div>

    <!-- Main Content -->
    <div class="flex-1 p-8 space-y-12 bg-gray-50">
        <h1 class="text-3xl font-bold mb-8">Mon Agence</h1>

        <!-- Section Voitures en maintenance -->
        <section>
            <h2 class="text-2xl font-semibold mb-4">Voitures en maintenance</h2>
            <table class="min-w-full bg-white border border-gray-300 rounded shadow">
                <thead class="bg-gray-200 text-gray-700">
                <tr>
                    <th class="py-2 px-4 border">Marque</th>
                    <th class="py-2 px-4 border">Modèle</th>
                    <th class="py-2 px-4 border">Type Maintenance</th>
                    <th class="py-2 px-4 border">Prix</th>
                    <th class="py-2 px-4 border">Date</th>
                    <th class="py-2 px-4 border">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="m" items="${maintenancesEnCours}">
                    <tr class="text-sm">
                        <td class="py-2 px-4 border">${m.voiture.marque}</td>
                        <td class="py-2 px-4 border">${m.voiture.modele}</td>
                        <td class="py-2 px-4 border">${m.type}</td>
                        <td class="py-2 px-4 border"><fmt:formatNumber value="${m.prix}" type="currency" currencySymbol="FCFA" /></td>
                        <td class="py-2 px-4 border"><fmt:formatDate value="${m.dateMaintenance}" pattern="dd/MM/yyyy" /></td>
                        <td class="py-2 px-4 border text-center">
                            <form action="${pageContext.request.contextPath}/RetourMaintenanceServlet" method="post">
                                <input type="hidden" name="id" value="${m.id}" />
                                <button type="submit" class="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700">Terminer</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </section>

        <!-- Section Clients fidèles -->
        <section>
            <h2 class="text-2xl font-semibold mb-4">Clients les plus fidèles</h2>
            <div class="overflow-x-auto">
                <table class="min-w-full bg-white border border-gray-300 rounded shadow">
                    <thead class="bg-gray-200 text-gray-700">
                    <tr>
                        <th class="py-2 px-4 border">Nom</th>
                        <th class="py-2 px-4 border">Email</th>
                        <th class="py-2 px-4 border">Téléphone</th>
                        <th class="py-2 px-4 border">Nombre de locations</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="client" items="${clientsFideles}">
                        <tr>
                            <td class="py-2 px-4 border">${client.nom}</td>
                            <td class="py-2 px-4 border">${client.email}</td>
                            <td class="py-2 px-4 border">${client.telephone}</td>
                            <td class="py-2 px-4 border">${client.nombreLocations}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Section Actions Utilisateur & Rapport -->
        <section class="mt-12">
            <h2 class="text-2xl font-semibold mb-6">Actions de gestion</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

                <!-- Importer utilisateurs -->
                <div class="bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition">
                    <div class="flex items-center justify-between">
                        <div class="text-blue-600 text-4xl">
                            <i class="fas fa-file-import"></i>
                        </div>
                        <form action="${pageContext.request.contextPath}/ExporterVoitureActifServlet" method="post" enctype="multipart/form-data">
                            <label class="cursor-pointer inline-block bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded shadow">
                                <i class="fas fa-upload mr-2"></i>Exporter
                                <input type="file" name="file" class="hidden" onchange="this.form.submit()">
                            </label>
                        </form>
                    </div>
                    <p class="mt-4 text-gray-700 font-medium">Exporter tous les voitures en location vers un fichier CSV ou Excel.</p>
                </div>

                <!-- Exporter utilisateurs -->
                <div class="bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition">
                    <div class="flex items-center justify-between">
                        <div class="text-green-600 text-4xl">
                            <i class="fas fa-file-export"></i>
                        </div>
                        <form action="${pageContext.request.contextPath}/ExportClientActifServlet" method="get">
                            <button type="submit" class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded shadow">
                                <i class="fas fa-download mr-2"></i>Exporter
                            </button>
                        </form>
                    </div>
                    <p class="mt-4 text-gray-700 font-medium">Exporter tous les Clients actifs vers un fichier Excel ou PDF.</p>
                </div>

                <!-- Générer rapport -->
                <div class="bg-white rounded-lg shadow-md p-6 hover:shadow-xl transition">
                    <div class="flex items-center justify-between">
                        <div class="text-purple-600 text-4xl">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <form action="${pageContext.request.contextPath}/RapportMensuelServlet" method="get" target="_blank">
                            <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded shadow">
                                <i class="fas fa-file-alt mr-2"></i>Rapport
                            </button>
                        </form>
                    </div>
                    <p class="mt-4 text-gray-700 font-medium">Générer un rapport mensuel de l'état du parc automobile.</p>
                </div>

            </div>
        </section>


    </div>
    </div>
<!-- Font Awesome -->
</body>
</html>
