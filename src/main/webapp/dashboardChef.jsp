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
    int clientsActifs = request.getAttribute("clientsActifs") != null ? (Integer) request.getAttribute("clientsActifs") : 0;
    int pourcentageClientsMois = request.getAttribute("pourcentageClientsMois") != null ? (Integer) request.getAttribute("pourcentageClientsMois") : 0;
    List<Object[]> voituresPopulaires = (List<Object[]>) request.getAttribute("voituresPopulaires");
    BigDecimal objectifMensuel = (BigDecimal) request.getAttribute("objectifMensuel");
    objectifMensuel = objectifMensuel != null ? objectifMensuel : BigDecimal.ZERO;
    BigDecimal evolutionRevenu = (BigDecimal) request.getAttribute("evolutionRevenu");
    evolutionRevenu = evolutionRevenu != null ? evolutionRevenu : BigDecimal.ZERO;
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Chef - AutoManager</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4F46E5;
            --secondary: #8B5CF6;
            --accent: #10B981;
            --light-bg: #F9FAFB;
            --card-bg: #FFFFFF;
            --text-dark: #1F2937;
            --text-light: #6B7280;
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: var(--text-dark);
        }

        .stat-card {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
        }

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .active-tab {
            border-bottom: 3px solid var(--primary);
            color: var(--primary);
            font-weight: 600;
        }

        .table-header {
            background-color: var(--primary);
            color: white;
        }

        .chart-container {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 24px;
        }

        .header-gradient {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .notification-dot {
            position: absolute;
            top: 0;
            right: 0;
            width: 10px;
            height: 10px;
            background-color: #EF4444;
            border-radius: 50%;
        }

        .progress-bar {
            height: 8px;
            border-radius: 4px;
            overflow: hidden;
            background-color: #E5E7EB;
        }

        .progress-fill {
            height: 100%;
        }

        .empty-state {
            text-align: center;
            padding: 20px;
            color: var(--text-light);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #D1D5DB;
        }
    </style>
</head>
<body class="bg-gray-50">
<div class="flex min-h-screen">
    <!-- Sidebar -->
    <aside class="w-64 bg-white p-6 shadow-lg flex flex-col">
        <div class="mb-10">
            <h1 class="text-2xl font-bold text-[var(--primary)] mb-2">Auto<span class="text-[var(--secondary)]">Manager</span></h1>
            <p class="text-sm text-[var(--text-light)]">Dashboard Chef</p>
        </div>

        <nav class="space-y-2 flex-1">
            <a href="#" class="flex items-center gap-3 px-4 py-3 rounded-xl bg-[#eef2ff] text-[var(--primary)] font-medium">
                <i class="fas fa-home"></i> Tableau de bord
            </a>
            <a href="#bilan" class="flex items-center gap-3 px-4 py-3 text-[var(--text-dark)] hover:bg-[#f3f4f6] rounded-xl">
                <i class="fas fa-chart-line"></i> Bilans financiers
            </a>
            <a href="#" class="flex items-center gap-3 px-4 py-3 text-[var(--text-dark)] hover:bg-[#f3f4f6] rounded-xl">
                <i class="fas fa-history"></i> Historique
            </a>
        </nav>

        <div class="mt-auto pt-6 border-t border-gray-200">
            <a href="#" class="flex items-center gap-3 px-4 py-3 text-[var(--text-dark)] hover:bg-[#f3f4f6] rounded-xl">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 p-8">
        <!-- Header -->
        <div class="header-gradient p-6 mb-8 rounded-2xl">
            <div class="flex justify-between items-center">
                <div>
                    <h1 class="text-2xl font-bold">Tableau de bord</h1>
                    <p class="opacity-90 mt-1">Bienvenue, Chef d'agence</p>
                </div>
                <div class="flex items-center gap-4">
                    <div class="relative">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-300"></i>
                        <input type="text" placeholder="Rechercher..." class="pl-10 pr-4 py-2 rounded-lg bg-white bg-opacity-20 placeholder-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-opacity-30 w-64">
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="relative">
                            <i class="fas fa-bell text-xl text-white"></i>
                            <span class="notification-dot"></span>
                        </div>
                        <div class="flex items-center gap-2">
                            <div class="w-10 h-10 rounded-full overflow-hidden border-2 border-white bg-gray-200 flex items-center justify-center">
                                <i class="fas fa-user text-gray-500"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="stat-card p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-[var(--text-light)] text-sm mb-1">Voitures disponibles</p>
                        <p class="text-2xl font-bold text-[var(--text-dark)]"><%= nbVoituresDispo %></p>
                    </div>
                    <div class="card-icon bg-blue-100 text-blue-600">
                        <i class="fas fa-car text-xl"></i>
                    </div>
                </div>
                <div class="mt-4 pt-3 border-t border-gray-100">
            <span class="text-sm text-[var(--text-light)] flex items-center">
                <i class="fas fa-chart-line text-green-500 mr-1"></i>
                <%= totalVoitures > 0 ? (nbVoituresDispo * 100 / totalVoitures) : 0 %>% du parc
            </span>
                </div>
            </div>

            <div class="stat-card p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-[var(--text-light)] text-sm mb-1">Voitures louées</p>
                        <p class="text-2xl font-bold text-[var(--text-dark)]"><%= nbVoituresLouees %></p>
                    </div>
                    <div class="card-icon bg-purple-100 text-purple-600">
                        <i class="fas fa-key text-xl"></i>
                    </div>
                </div>
                <div class="mt-4 pt-3 border-t border-gray-100">
            <span class="text-sm text-[var(--text-light)] flex items-center">
                <i class="fas fa-chart-line text-red-500 mr-1"></i>
                <%= totalVoitures > 0 ? (nbVoituresLouees * 100 / totalVoitures) : 0 %>% du parc
            </span>
                </div>
            </div>

            <div class="stat-card p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-[var(--text-light)] text-sm mb-1">Clients actifs</p>
                        <p class="text-2xl font-bold text-[var(--text-dark)]"><%= clientsActifs %></p>
                    </div>
                    <div class="card-icon bg-green-100 text-green-600">
                        <i class="fas fa-users text-xl"></i>
                    </div>
                </div>
                <div class="mt-4 pt-3 border-t border-gray-100">
            <span class="text-sm text-[var(--text-light)] flex items-center">
                <i class="fas fa-arrow-up text-green-500 mr-1"></i>
                <%= pourcentageClientsMois %>% ce mois
            </span>
                </div>
            </div>

            <div class="stat-card p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-[var(--text-light)] text-sm mb-1">Revenu du mois</p>
                        <p class="text-2xl font-bold text-[var(--text-dark)]"><%= df.format(revenuMois) %> F CFA</p>
                    </div>
                    <div class="card-icon bg-amber-100 text-amber-600">
                        <i class="fas fa-money-bill-wave text-xl"></i>
                    </div>
                </div>
                <div class="mt-4 pt-3 border-t border-gray-100">
            <span class="text-sm text-[var(--text-light)] flex items-center">
                <i class="fas fa-arrow-up text-yellow-500 mr-1"></i>
                Ce mois
            </span>
                </div>
            </div>
        </div>


        <!-- Main Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Section voitures populaires -->
            <div class="bg-white rounded-2xl shadow p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-xl font-bold text-[var(--text-dark)]">Voitures les plus louées</h2>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead>
                        <tr class="table-header">
                            <th class="text-left px-4 py-3 text-sm font-medium">Modèle</th>
                            <th class="text-left px-4 py-3 text-sm font-medium">Nombre de locations</th>
                            <th class="text-left px-4 py-3 text-sm font-medium">Taux</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (voituresPopulaires != null && !voituresPopulaires.isEmpty()) {
                            for (Object[] ligne : voituresPopulaires) {
                                Voiture v = (Voiture) ligne[0];
                                Long nbLoc = (Long) ligne[1];
                                double taux = ((double) nbLoc / totalVoitures) * 100;
                        %>
                        <tr>
                            <td class="px-4 py-2 text-sm"><%= v.getModele() %></td>
                            <td class="px-4 py-2 text-sm"><%= nbLoc %></td>
                            <td class="px-4 py-2 text-sm"><%= String.format("%.1f", taux) %>%</td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="3" class="empty-state">
                                <i class="fas fa-car text-gray-300 text-4xl"></i>
                                <p>Aucune donnée disponible</p>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Bilan financier -->
            <div class="bg-white rounded-2xl shadow p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-xl font-bold text-[var(--text-dark)]">Bilan financier</h2>
                    <div class="flex border-b" id="tabs-container">
                        <button id="tab-jour" onclick="afficherGraphique('jour')" class="px-3 py-1 text-sm focus:outline-none">
                            Jour
                        </button>
                        <button id="tab-semaine" onclick="afficherGraphique('semaine')" class="px-3 py-1 text-sm focus:outline-none">
                            Semaine
                        </button>
                        <button id="tab-mois" onclick="afficherGraphique('mois')" class="px-3 py-1 text-sm focus:outline-none active-tab">
                            Mois
                        </button>
                    </div>
                </div>

                <!-- Section graphique bilan financier -->
                <div class="chart-container" style="position: relative; height: 40vh; width: 100%">
                    <canvas id="bilanChart"></canvas>
                </div>
                <div class="mt-6 pt-4 border-t border-gray-100">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm text-[var(--text-light)]">Revenu total</p>
                            <p class="text-xl font-bold"><%= df.format(revenuMois) %> F CFA</p>
                        </div>
                        <div>
                            <p class="text-sm text-[var(--text-light)]">Évolution</p>
                            <p class="text-xl font-bold"><%= df.format(evolutionRevenu) %> F CFA</p>
                        </div>
                        <div>
                            <p class="text-sm text-[var(--text-light)]">Objectif</p>
                            <p class="text-xl font-bold"><%= df.format(objectifMensuel) %> F CFA</p>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Section résumé d'activité et objectifs -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-6">
            <div class="bg-white rounded-2xl shadow p-6 col-span-2">
                <h2 class="text-xl font-bold text-[var(--text-dark)] mb-4">Résumé d'activité</h2>
                <div class="empty-state">
                    <i class="fas fa-list-alt text-gray-300"></i>
                    <p><%= locationsHistoriques != null ? locationsHistoriques.size() : 0 %> location(s) passée(s)</p>
                </div>
            </div>
            <div class="bg-white rounded-2xl shadow p-6">
                <h2 class="text-xl font-bold text-[var(--text-dark)] mb-4">Objectifs du mois</h2>
                <div class="empty-state">
                    <i class="fas fa-bullseye text-gray-300"></i>
                    <p>Atteindre <%= df.format(objectifMensuel) %> F CFA ce mois</p>
                </div>
            </div>
        </div>

    </main>
</div>
<script>
    const labelsJour = ${joursLabelsJson};
    const dataJour = ${revenusJournaliersJson};
    const labelsSemaine = ${semainesLabelsJson};
    const dataSemaine = ${revenusHebdomadairesJson};
    const labelsMois = ${labelsJson};
    const dataMois = ${dataJson};

    function formatNumber(number) {
        return new Intl.NumberFormat('fr-FR').format(number);
    }

    let chart = null;

    function afficherGraphique(periode) {
        // Met à jour l'onglet actif
        document.querySelectorAll('#tabs-container button').forEach(btn => {
            btn.classList.remove('active-tab');
        });
        const tabButton = document.getElementById(`tab-${periode}`);
        if (tabButton) tabButton.classList.add('active-tab');

        // Récupère le canvas
        const canvas = document.getElementById('bilanChart');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');

        // Détruit l'ancien graphique s'il existe
        if (chart) chart.destroy();

        // Détermine les labels et les données selon la période
        let labels = [];
        let data = [];
        let labelGraphique = '';

        if (periode === 'jour') {
            labels = labelsJour;
            data = dataJour;
            labelGraphique = 'Revenus journaliers (F CFA)';
        } else if (periode === 'semaine') {
            labels = labelsSemaine;
            data = dataSemaine;
            labelGraphique = 'Revenus hebdomadaires (F CFA)';
        } else {
            labels = labelsMois;
            data = dataMois;
            labelGraphique = 'Revenus mensuels (F CFA)';
        }

        // Crée le graphique
        chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: labelGraphique,
                    data: data,
                    backgroundColor: 'rgba(79, 70, 229, 0.7)',
                    borderColor: '#4F46E5',
                    borderWidth: 1,
                    borderRadius: 6,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return formatNumber(context.raw) + ' F CFA';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return formatNumber(value);
                            }
                        },
                        grid: {
                            color: 'rgba(0, 0, 0, 0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }

    // Affiche le graphique mensuel au chargement de la page
    document.addEventListener('DOMContentLoaded', () => {
        afficherGraphique('mois');
    });
</script>

</body>
</html>
