<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
<%@ page import="com.agence.agencevoiture.entity.*" %>

<%
    DecimalFormat df = new DecimalFormat("#,###");

    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");

    Long totalVoitures = (Long) request.getAttribute("totalVoitures");
    List<Voiture> voituresDisponibles = (List<Voiture>) request.getAttribute("voituresDisponibles");
    List<Location> locationsEnCours = (List<Location>) request.getAttribute("locationsEnCours");
    Object revenuMoisObj = request.getAttribute("revenuMois");
    BigDecimal revenuMois = revenuMoisObj instanceof BigDecimal ? (BigDecimal) revenuMoisObj : BigDecimal.ZERO;
    Long clientsActifs = (Long) request.getAttribute("clientsActifs");
    Long pourcentageClientsMois = (Long) request.getAttribute("pourcentageClientsMois");
    List<Object[]> voituresPopulaires = (List<Object[]>) request.getAttribute("voituresPopulaires");

    String moisLabelsJson = (String) request.getAttribute("labelsJson");
    String revenusMensuelsJson = (String) request.getAttribute("dataJson");

    int nbVoituresDispo = voituresDisponibles != null ? voituresDisponibles.size() : 0;
    int nbVoituresLouees = locationsEnCours != null ? locationsEnCours.size() : 0;
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Chef - AutoManager</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-50 font-sans">
<div class="flex min-h-screen">
    <aside class="w-80 bg-gray-50 p-4 flex flex-col justify-between">
        <div>
            <h1 class="text-base font-medium text-[#101518] mb-6">Auto Manager</h1>
            <nav class="flex flex-col gap-2">
                <a href="#" class="flex items-center gap-3 px-3 py-2 rounded-xl bg-[#eaedf1] text-[#101518] font-medium text-sm">
                    <i class="fas fa-home"></i> Situation du parking
                </a>
                <a href="#" class="flex items-center gap-3 px-3 py-2 text-[#101518] text-sm">
                    <i class="fas fa-star"></i> Voitures les plus recherchées
                </a>
                <a href="#bilan" class="flex items-center gap-3 px-3 py-2 text-[#101518] text-sm">
                    <i class="fas fa-chart-line"></i> Bilan mensuel
                </a>
            </nav>
        </div>
        <div>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="flex items-center gap-3 px-3 py-2 text-[#101518] text-sm">
                <i class="fas fa-sign-out-alt"></i> Retour au site
            </a>
        </div>
    </aside>
    <main class="flex-1 p-6">
        <header class="flex justify-between items-center mb-6">
            <h2 class="text-3xl font-bold text-[#101518]">Tableau de bord</h2>
            <div class="flex items-center gap-3">
                <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Profil" class="w-10 h-10 rounded-full">
                <div>
                    <p class="text-sm font-medium text-[#101518]"><%= utilisateur != null ? utilisateur.getPrenom() + " " + utilisateur.getNom() : "Utilisateur" %></p>
                    <p class="text-xs text-gray-500">Chef</p>
                </div>
            </div>
        </header>

        <section class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-10">
            <div class="border rounded-xl p-6 bg-white">
                <p class="text-sm font-medium text-[#101518]">Voitures disponibles</p>
                <p class="text-2xl font-bold text-[#101518] mt-2"><%= nbVoituresDispo %></p>
            </div>
            <div class="border rounded-xl p-6 bg-white">
                <p class="text-sm font-medium text-[#101518]">Voitures louées</p>
                <p class="text-2xl font-bold text-[#101518] mt-2"><%= nbVoituresLouees %></p>
            </div>
            <div class="border rounded-xl p-6 bg-white">
                <p class="text-sm font-medium text-[#101518]">Clients actifs</p>
                <p class="text-2xl font-bold text-[#101518] mt-2"><%= clientsActifs %></p>
            </div>
            <div class="border rounded-xl p-6 bg-white">
                <p class="text-sm font-medium text-[#101518]">Revenu du mois</p>
                <p class="text-2xl font-bold text-[#101518] mt-2"><%= df.format(revenuMois) %> F CFA</p>
            </div>
        </section>

        <section class="mb-10">
            <h3 class="text-xl font-bold text-[#101518] mb-4">Voitures les plus louées</h3>
            <div class="overflow-x-auto">
                <table class="min-w-full border bg-white">
                    <thead>
                    <tr class="bg-gray-100">
                        <th class="text-left px-4 py-2 text-sm font-medium text-[#101518]">Modèle</th>
                        <th class="text-left px-4 py-2 text-sm font-medium text-[#101518]">Nombre de locations</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (voituresPopulaires != null && !voituresPopulaires.isEmpty()) {
                        for (Object[] obj : voituresPopulaires) {
                            Voiture v = (Voiture) obj[0];
                            Long nb = (Long) obj[1]; %>
                    <tr class="border-t">
                        <td class="px-4 py-2 text-sm text-[#101518]"><%= v.getMarque() + " " + v.getModele() %></td>
                        <td class="px-4 py-2 text-sm text-[#101518]"><%= nb %></td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="2" class="px-4 py-2 text-center text-sm text-gray-500">Aucune donnée disponible</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <section id="bilan" class="mt-10">
            <h3 class="text-xl font-bold text-[#101518] mb-4">Bilan Financier Mensuel</h3>
            <div class="bg-white rounded-xl p-6">
                <canvas id="bilanChart" height="100"></canvas>
            </div>
            <script>
                const ctx = document.getElementById('bilanChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: <%= moisLabelsJson %>,
                        datasets: [{
                            label: 'Revenus mensuels (F CFA)',
                            data: <%= revenusMensuelsJson %>,
                            backgroundColor: '#4F46E5',
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            </script>
        </section>

    </main>
</div>
</body>
</html>
