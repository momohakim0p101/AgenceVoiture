<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Agence</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,line-clamp"></script>
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
            <div class="mt-auto text-xs text-gray-300 text-center pt-6">© 2025 AutoManager</div>
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

        <!-- Section Réseaux sociaux -->
        <section>
            <h2 class="text-2xl font-semibold mb-4">Suivez-nous</h2>
            <div class="flex space-x-4">
                <a href="#" class="text-blue-600 text-2xl hover:text-blue-800">
                    <i class="fab fa-facebook"></i>
                </a>
                <a href="#" class="text-pink-500 text-2xl hover:text-pink-700">
                    <i class="fab fa-instagram"></i>
                </a>
                <a href="#" class="text-blue-400 text-2xl hover:text-blue-600">
                    <i class="fab fa-twitter"></i>
                </a>
                <a href="#" class="text-red-600 text-2xl hover:text-red-800">
                    <i class="fab fa-youtube"></i>
                </a>
            </div>
        </section>
    </div>
</div>
<!-- Font Awesome -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>
