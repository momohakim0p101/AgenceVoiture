<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Location</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,line-clamp"></script>
</head>
<body class="bg-gray-100 font-sans leading-normal tracking-normal">
<div class="flex min-h-screen">
    <!-- Sidebar -->
    <div class="w-64 bg-white shadow-lg p-4">
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
                <a href="${pageContext.request.contextPath}/utilisateurs.jsp" class="flex items-center gap-3 px-3 py-2 rounded hover:bg-[#2563eb] transition">
                    <!-- Icon Utilisateurs: groupe utilisateurs -->
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87M12 12a5 5 0 100-10 5 5 0 000 10z" />
                    </svg>
                    Gestion utilisateurs
                </a>
            </nav>
            <div class="mt-auto text-xs text-gray-300 text-center pt-6">© 2025 AutoManager</div>
        </aside>
    </div>

    <!-- Main content -->
    <div class="flex-1 p-8 space-y-12 bg-gray-50">
        <section>
            <h2 class="text-2xl font-bold mb-4">Recherche de voitures (temps réel)</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <select id="filtreMarque" class="p-2 border rounded">
                    <option value="">-- Marque --</option>
                    <c:forEach var="marque" items="${marques}">
                        <option value="${marque}">${marque}</option>
                    </c:forEach>
                </select>
                <select id="filtreCategorie" class="p-2 border rounded">
                    <option value="">-- Catégorie --</option>
                    <c:forEach var="categorie" items="${categories}">
                        <option value="${categorie}">${categorie}</option>
                    </c:forEach>
                </select>
                <select id="filtreCarburant" class="p-2 border rounded">
                    <option value="">-- Carburant --</option>
                    <c:forEach var="carburant" items="${carburants}">
                        <option value="${carburant}">${carburant}</option>
                    </c:forEach>
                </select>
                <input type="number" id="filtreKm" placeholder="Kilométrage max" class="p-2 border rounded" />
                <input type="number" id="filtreAnnee" placeholder="Année min" class="p-2 border rounded" />
            </div>
        </section>

        <section>
            <h2 class="text-2xl font-bold mb-4">Voitures disponibles</h2>
            <div class="overflow-x-auto">
                <table class="min-w-full bg-white border border-gray-300 rounded shadow">
                    <thead class="bg-gray-200 text-gray-700">
                    <tr>
                        <th class="py-2 px-4 border">Marque</th>
                        <th class="py-2 px-4 border">Modèle</th>
                        <th class="py-2 px-4 border">Catégorie</th>
                        <th class="py-2 px-4 border">Carburant</th>
                        <th class="py-2 px-4 border">Km</th>
                        <th class="py-2 px-4 border">Année</th>
                        <th class="py-2 px-4 border">Action</th>
                    </tr>
                    </thead>
                    <tbody id="voitureTableBody">
                    <c:forEach var="voiture" items="${voituresDisponibles}">
                        <tr class="voitureRow"
                            data-marque="${voiture.marque}"
                            data-categorie="${voiture.categorie}"
                            data-carburant="${voiture.typeCarburant}"
                            data-km="${voiture.kilometrage}"
                            data-annee="${voiture.dateMiseEnCirculation.time}">
                            <td class="py-2 px-4 border">${voiture.marque}</td>
                            <td class="py-2 px-4 border">${voiture.modele}</td>
                            <td class="py-2 px-4 border">${voiture.categorie}</td>
                            <td class="py-2 px-4 border">${voiture.typeCarburant}</td>
                            <td class="py-2 px-4 border">${voiture.kilometrage}</td>
                            <td class="py-2 px-4 border"><fmt:formatDate value="${voiture.dateMiseEnCirculation}" pattern="yyyy" /></td>
                            <td class="py-2 px-4 border text-center">
                                <form action="LouerVoitureServlet" method="post">
                                    <input type="hidden" name="voitureId" value="${voiture.immatriculation}" />
                                    <button type="submit" class="text-blue-600 hover:underline">Louer</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

        <section>
            <h2 class="text-2xl font-bold mb-4">Louer une voiture</h2>
            <form action="LouerVoitureServlet" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <select name="voitureId" class="p-2 border rounded">
                    <option value="">-- Voiture --</option>
                    <c:forEach var="v" items="${voituresDisponibles}">
                        <option value="${v.immatriculation}">${v.marque} ${v.modele}</option>
                    </c:forEach>
                </select>
                <select name="clientId" class="p-2 border rounded">
                    <option value="">-- Client --</option>
                    <c:forEach var="c" items="${clients}">
                        <option value="${c.cin}">${c.nom} ${c.prenom}</option>
                    </c:forEach>
                </select>
                <input type="date" name="dateLocation" class="p-2 border rounded" />
                <input type="date" name="dateRetourPrevue" class="p-2 border rounded" />
                <div class="md:col-span-2">
                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Louer</button>
                </div>
            </form>
        </section>

        <section>
            <h2 class="text-2xl font-bold mb-4">Retourner une voiture</h2>
            <form action="RetournerVoitureServlet" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <select name="locationId" class="p-2 border rounded">
                    <option value="">-- Location --</option>
                    <c:forEach var="location" items="${locationsActives}">
                        <option value="${location.id}">
                                ${location.voiture.marque} ${location.voiture.modele} - ${location.client.nom}
                        </option>
                    </c:forEach>
                </select>
                <input type="date" name="dateRetourEffectif" class="p-2 border rounded" />
                <div class="md:col-span-2">
                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Retourner</button>
                </div>
            </form>
        </section>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const filtreMarque = document.getElementById("filtreMarque");
        const filtreCategorie = document.getElementById("filtreCategorie");
        const filtreCarburant = document.getElementById("filtreCarburant");
        const filtreKm = document.getElementById("filtreKm");
        const filtreAnnee = document.getElementById("filtreAnnee");
        const lignes = document.querySelectorAll(".voitureRow");

        function filtrer() {
            lignes.forEach(ligne => {
                const marque = ligne.dataset.marque.toLowerCase();
                const categorie = ligne.dataset.categorie.toLowerCase();
                const carburant = ligne.dataset.carburant.toLowerCase();
                const km = parseInt(ligne.dataset.km);
                const annee = new Date(parseInt(ligne.dataset.annee)).getFullYear();

                const matchMarque = !filtreMarque.value || marque === filtreMarque.value.toLowerCase();
                const matchCategorie = !filtreCategorie.value || categorie === filtreCategorie.value.toLowerCase();
                const matchCarburant = !filtreCarburant.value || carburant === filtreCarburant.value.toLowerCase();
                const matchKm = !filtreKm.value || km <= parseInt(filtreKm.value);
                const matchAnnee = !filtreAnnee.value || annee >= parseInt(filtreAnnee.value);

                ligne.style.display = (matchMarque && matchCategorie && matchCarburant && matchKm && matchAnnee)
                    ? ""
                    : "none";
            });
        }

        [filtreMarque, filtreCategorie, filtreCarburant, filtreKm, filtreAnnee].forEach(el => {
            el.addEventListener("input", filtrer);
            el.addEventListener("change", filtrer);
        });
    });
</script>

</body>
</html>
