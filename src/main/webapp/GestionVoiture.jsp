<%@ page import="com.agence.agencevoiture.entity.Utilisateur" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Locale" %>






<%
    SimpleDateFormat sdfPro = new SimpleDateFormat("EEEE dd MMMM yyyy", new Locale("fr", "FR"));
    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
%>
<!DOCTYPE html>
<html lang="fr" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Gestion Voitures - Agence de Location</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .vehicle-card[data-enmaintenance="true"] {
            opacity: 0.6;
            cursor: not-allowed;
        }
    </style>
</head>
<body class="bg-gray-100 flex min-h-screen font-sans">

<!-- Sidebar -->
<!-- Menu Latéral -->
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

<!-- Main Content -->
<main class="flex-1 flex flex-col ml-64">
    <!-- Top nav -->
    <header class="flex justify-between items-center bg-white px-6 py-4 shadow-sm border-b border-gray-200">
        <div class="flex items-center gap-4">
            <div class="relative">
                <input id="searchInput" type="text" placeholder="Rechercher par marque, modele ou immatriculation..."
                       class="pl-10 pr-4 py-2 rounded border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 w-72" />
                <i class="fas fa-search absolute left-3 top-2.5 text-gray-400"></i>
            </div>
        </div>

        <div class="flex items-center gap-4">
            <div class="flex items-center gap-3">
                <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Profil" class="w-10 h-10 rounded-full object-cover" />
                <div class="flex flex-col text-gray-700">
                    <span class="font-semibold text-sm"><%= utilisateur != null ? utilisateur.getNom() : "Utilisateur" %></span>
                    <span class="text-xs text-gray-500"><%= utilisateur != null ? utilisateur.getRole() : "Rôle inconnu" %></span>
                </div>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/LogoutServlet">
                <button type="submit" title="Deconnexion"
                        class="text-gray-600 hover:text-red-600 transition">
                    <i class="fas fa-sign-out-alt fa-lg"></i>
                </button>
            </form>
        </div>
    </header>

    <!-- Page Header -->
    <section class="flex justify-between items-center bg-white p-6 border-b border-gray-200">
        <h2 class="text-2xl font-semibold text-gray-700 flex items-center gap-2">
            <i class="fas fa-car-side text-blue-600"></i> Gestion des Voitures
        </h2>
        <button
                onclick="openModal('addCarModal')"
                class="bg-blue-600 hover:bg-blue-700 text-white px-5 py-2 rounded flex items-center gap-2 transition"
        >
            <i class="fas fa-plus"></i> Ajouter une voiture
        </button>
    </section>

    <!-- Cars Grid -->
    <section id="carsGrid" class="p-6 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 overflow-auto">
        <c:forEach var="voiture" items="${voitures}"><article
                class="vehicle-card relative bg-white rounded-lg shadow-md overflow-hidden flex flex-col"
                data-marque="${voiture.marque.toLowerCase()}"
                data-modele="${voiture.modele.toLowerCase()}"
                data-immatriculation="${voiture.immatriculation.toLowerCase()}"
                data-enmaintenance="${voiture.enMaintenance}"
                data-nombreplaces="${voiture.nombrePlaces}"
                data-typecarburant="${voiture.typeCarburant.toLowerCase()}"
                data-categorie="${voiture.categorie.toLowerCase()}"
                data-prixlocationjour="${voiture.prixLocationJour}"
                data-disponible="${voiture.disponible}"
                data-datemiseencirculation="${sdfPro.format(voiture.dateMiseEnCirculation)}"
                data-kilometrage="${voiture.kilometrage}"
        >
            <!-- Image -->
            <!-- Image -->
            <img src="${voiture.imagePath}" alt="${voiture.marque} ${voiture.modele}" class="h-40 w-full object-cover rounded-t-lg" />

            <!-- Badge de statut -->
            <div class="p-2 text-sm">
                <c:choose>
                    <c:when test="${voiture.enMaintenance}">
            <span class="text-yellow-600 font-semibold flex items-center gap-1">
                <i class="fas fa-wrench"></i> En maintenance
            </span>
                    </c:when>
                    <c:when test="${voiture.disponible}">
            <span class="text-green-600 font-semibold flex items-center gap-1">
                <i class="fas fa-check-circle"></i> Disponible
            </span>
                    </c:when>
                    <c:otherwise>
            <span class="text-red-600 font-semibold flex items-center gap-1">
                <i class="fas fa-times-circle"></i> Loué
            </span>
                    </c:otherwise>
                </c:choose>
            </div>



            <!-- Infos -->
            <div class="p-4 flex-1 flex flex-col justify-between">
                <header>
                    <h3 class="text-lg font-semibold text-gray-800">${voiture.marque} ${voiture.modele}</h3>
                    <p class="text-sm text-blue-600 font-semibold">${voiture.immatriculation}</p>
                </header>

                <ul class="mt-3 text-gray-600 text-sm space-y-1">
                    <li><i class="fas fa-users mr-1 text-gray-400"></i> ${voiture.nombrePlaces} places</li>
                    <li><i class="fas fa-gas-pump mr-1 text-gray-400"></i> ${voiture.typeCarburant}</li>
                    <li><i class="fas fa-calendar-alt mr-1 text-gray-400"></i> ${voiture.dateMiseEnCirculation}</li>
                    <li><i class="fas fa-tachometer-alt mr-1 text-gray-400"></i> ${voiture.kilometrage} km</li>
                </ul>

                <div class="mt-3">
                    <p class="text-sm text-gray-500">Catégorie:</p>
                    <p class="font-semibold text-gray-700">${voiture.categorie}</p>
                </div>

                <div class="mt-2">
                    <p class="text-sm text-gray-500">Prix/jour:</p>
                    <p class="font-bold text-blue-600">${voiture.prixLocationJour} FCFA</p>
                </div>

                <!-- Actions -->
                <div class="mt-4 flex gap-2">
                    <button onclick="openEditModal('${voiture.immatriculation}')" class="flex-1 bg-gray-100 hover:bg-blue-100 text-blue-600 border border-blue-600 py-2 rounded flex items-center justify-center gap-2 text-sm">
                        <i class="fas fa-edit"></i> Modifier
                    </button>
                    <button onclick="openDeleteModal('${voiture.immatriculation}')" class="flex-1 bg-red-600 hover:bg-red-700 text-white py-2 rounded flex items-center justify-center gap-2 text-sm">
                        <i class="fas fa-trash"></i> Supprimer
                    </button>
                </div>
            </div>
        </article>

        </c:forEach>

        <c:if test="${empty voitures}">
            <p class="col-span-full text-center text-gray-500 mt-10">Aucune voiture trouve.</p>
        </c:if>
    </section>

    <!-- Modals -->

    <!-- Modal Ajout -->
    <div id="addCarModal" class="fixed inset-0 bg-black bg-opacity-50 hidden justify-center items-center z-50">
        <div class="bg-white rounded-lg shadow-lg w-11/12 max-w-lg p-6 relative">
            <button
                    class="absolute top-3 right-3 text-gray-500 hover:text-gray-700"
                    onclick="closeModal('addCarModal')"
                    aria-label="Fermer"
            >
                <i class="fas fa-times fa-lg"></i>
            </button>
            <h3 class="text-xl font-semibold mb-4">Ajouter une voiture</h3>
            <form method="post" action="${pageContext.request.contextPath}/VoitureServlet" class="space-y-4">
                <input type="hidden" name="action" value="save" />

                <input
                        type="text" name="immatriculation" placeholder="Immatriculation"
                        required
                        class="w-full border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />

                <select name="marque" required class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="" disabled selected>-- Choisir une marque --</option>
                    <option>Toyota</option>
                    <option>Ranger Rover</option>
                    <option>Chevrolet</option>
                    <option>Mercedes</option>
                    <option>Renault</option>
                    <option>Peugeot</option>
                    <option>Ford</option>
                    <option>BMW</option>
                </select>

                <select name="modele" required class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="" disabled selected>-- Choisir un modele --</option>
                    <option>Modele A</option>
                    <option>Modele B</option>
                    <option>Modele C</option>
                    <option>Modele D</option>
                </select>

                <select name="nombrePlaces" required class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="" disabled selected>-- Nombre de places --</option>
                    <option>2</option>
                    <option>4</option>
                    <option>5</option>
                    <option>7</option>
                </select>

                <select name="typeCarburant" required class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="" disabled selected>-- Type de carburant --</option>
                    <option>Essence</option>
                    <option>Diesel</option>
                    <option>Electrique</option>
                    <option>Hybride</option>
                </select>

                <select name="categorie" required class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="" disabled selected>-- Categorie --</option>
                    <option>Economique</option>
                    <option>Berline</option>
                    <option>SUV</option>
                    <option>Luxe</option>
                </select>

                <input
                        type="number" name="prixLocationJour" placeholder="Prix / jour (FCFA)"
                        min="0" step="0.01" required
                        class="w-full border border-gray-300 rounded px-3 py-2"
                />

                <select name="disponible" required class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="true" selected>Disponible</option>
                    <option value="false">Indisponible</option>
                </select>

                <label class="block font-semibold">Date mise en circulation :</label>
                <input type="date" name="dateMiseEnCirculation" class="w-full border border-gray-300 rounded px-3 py-2" />

                <label class="block font-semibold">Kilometrage :</label>
                <input
                        type="number" name="kilometrage" min="0" step="0.1" placeholder="Kilométrage"
                        class="w-full border border-gray-300 rounded px-3 py-2"
                />
                <input
                        type="text"
                        name="imageUrl"
                        placeholder="URL de l'image"
                        class="w-full border border-gray-300 rounded px-3 py-2"
                />

                <button
                        type="submit"
                        class="bg-blue-600 hover:bg-blue-700 text-white w-full py-2 rounded font-semibold transition"
                >
                    Ajouter
                </button>
            </form>
        </div>
    </div>

    <!-- Modal Modification -->
    <div id="editCarModal" class="fixed inset-0 bg-black bg-opacity-50 hidden justify-center items-center z-50">
        <div class="bg-white rounded-lg shadow-lg w-11/12 max-w-lg p-6 relative overflow-auto max-h-[90vh]">
            <button
                    class="absolute top-3 right-3 text-gray-500 hover:text-gray-700"
                    onclick="closeModal('editCarModal')"
                    aria-label="Fermer"
            >
                <i class="fas fa-times fa-lg"></i>
            </button>
            <h3 class="text-xl font-semibold mb-4">Modifier la voiture</h3>
            <form method="post" action="${pageContext.request.contextPath}/VoitureServlet" class="space-y-4">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="immatriculation" id="edit-immatriculation" />

                <label class="block font-semibold">Immatriculation :</label>
                <input
                        type="text"
                        id="edit-immatriculation-display"
                        disabled
                        class="w-full border border-gray-300 rounded px-3 py-2 bg-gray-100"
                />

                <label class="block font-semibold">Marque :</label>
                <select
                        name="marque"
                        id="edit-marque"
                        required
                        class="w-full border border-gray-300 rounded px-3 py-2"
                >
                    <option value="" disabled>-- Choisir une marque --</option>
                    <option>Toyota</option>
                    <option>Renault</option>
                    <option>Peugeot</option>
                    <option>Ford</option>
                    <option>BMW</option>
                </select>

                <label class="block font-semibold">Modele :</label>
                <select
                        name="modele"
                        id="edit-modele"
                        required
                        class="w-full border border-gray-300 rounded px-3 py-2"
                >
                    <option value="" disabled>-- Choisir un modele --</option>
                    <option>Modèle A</option>
                    <option>Modèle B</option>
                    <option>Modèle C</option>
                    <option>Modèle D</option>
                </select>

                <label class="block font-semibold">Nombre de places :</label>
                <select
                        name="nombrePlaces"
                        id="edit-nombrePlaces"
                        required
                        class="w-full border border-gray-300 rounded px-3 py-2"
                >
                    <option value="" disabled>-- Nombre de places --</option>
                    <option>2</option>
                    <option>4</option>
                    <option>5</option>
                    <option>7</option>
                </select>

                <label class="block font-semibold">Type de carburant :</label>
                <select
                        name="typeCarburant"
                        id="edit-typeCarburant"
                        required
                        class="w-full border border-gray-300 rounded px-3 py-2"
                >
                    <option value="" disabled>-- Type de carburant --</option>
                    <option>Essence</option>
                    <option>Diesel</option>
                    <option>Electrique</option>
                    <option>Hybride</option>
                </select>

                <label class="block font-semibold">Categorie :</label>
                <select
                        name="categorie"
                        id="edit-categorie"
                        required
                        class="w-full border border-gray-300 rounded px-3 py-2"
                >
                    <option value="" disabled>-- Categorie --</option>
                    <option>Economique</option>
                    <option>Berline</option>
                    <option>SUV</option>
                    <option>Luxe</option>
                </select>

                <label class="block font-semibold">Prix / jour (FCFA) :</label>
                <input
                        type="number"
                        name="prixLocationJour"
                        id="edit-prixLocationJour"
                        min="0"
                        step="0.01"
                        required
                        class="w-full border border-gray-300 rounded px-3 py-2"
                />

                <label class="block font-semibold">Disponible :</label>
                <select
                        name="disponible"
                        id="edit-disponible"
                        required
                        class="w-full border border-gray-300 rounded px-3 py-2"
                >
                    <option value="true">Disponible</option>
                    <option value="false">Indisponible</option>
                </select>

                <label class="block font-semibold">Date mise en circulation :</label>
                <input
                        type="date"
                        name="dateMiseEnCirculation"
                        id="edit-dateMiseEnCirculation"
                        class="w-full border border-gray-300 rounded px-3 py-2"
                />

                <label class="block font-semibold">Kilometrage :</label>
                <input
                        type="number"
                        name="kilometrage"
                        id="edit-kilometrage"
                        min="0"
                        step="0.1"
                        placeholder="Kilométrage"
                        class="w-full border border-gray-300 rounded px-3 py-2"
                />

                <button
                        type="submit"
                        class="bg-blue-600 hover:bg-blue-700 text-white w-full py-2 rounded font-semibold transition"
                >
                    Modifier
                </button>
            </form>
        </div>
    </div>

    <!-- Modal Suppression -->
    <div id="deleteCarModal" class="fixed inset-0 bg-black bg-opacity-50 hidden justify-center items-center z-50">
        <div class="bg-white rounded-lg shadow-lg w-96 p-6 relative">
            <button
                    class="absolute top-3 right-3 text-gray-500 hover:text-gray-700"
                    onclick="closeModal('deleteCarModal')"
                    aria-label="Fermer"
            >
                <i class="fas fa-times fa-lg"></i>
            </button>
            <h3 class="text-xl font-semibold mb-4">Supprimer la voiture</h3>
            <p>Voulez-vous vraiment supprimer cette voiture ?</p>
            <form method="post" action="${pageContext.request.contextPath}/VoitureServlet" class="mt-4 flex justify-end gap-4">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="immatriculation" id="delete-immatriculation" />
                <button type="submit" class="bg-red-600 hover:bg-red-700 text-white px-5 py-2 rounded font-semibold transition">
                    Oui, supprimer
                </button>
                <button
                        type="button"
                        onclick="closeModal('deleteCarModal')"
                        class="bg-gray-300 hover:bg-gray-400 px-5 py-2 rounded transition"
                >
                    Annuler
                </button>
            </form>
        </div>
    </div>
</main>

<script>
    // Modal open/close helpers
    function openModal(id) {
        document.getElementById(id).classList.remove('hidden');
    }
    function closeModal(id) {
        document.getElementById(id).classList.add('hidden');
    }

    function openEditModal(immatriculation) {
        const card = [...document.querySelectorAll('.vehicle-card')].find(
            c => c.dataset.immatriculation === immatriculation.toLowerCase()
        );
        if (!card) return;

        document.getElementById('edit-immatriculation').value = immatriculation;
        document.getElementById('edit-immatriculation-display').value = immatriculation;
        document.getElementById('edit-marque').value = card.dataset.marque || '';
        document.getElementById('edit-modele').value = card.dataset.modele || '';
        document.getElementById('edit-nombrePlaces').value = card.dataset.nombreplaces || '';
        document.getElementById('edit-typeCarburant').value = card.dataset.typecarburant || '';
        document.getElementById('edit-categorie').value = card.dataset.categorie || '';
        document.getElementById('edit-prixLocationJour').value = card.dataset.prixlocationjour || '';
        document.getElementById('edit-disponible').value = card.dataset.disponible || 'true';
        // Pour la date, formate en yyyy-MM-dd si besoin
        if (card.dataset.datemiseencirculation) {
            // Assure-toi que la date est au bon format, sinon adapte ici
            document.getElementById('edit-dateMiseEnCirculation').value = card.dataset.datemiseencirculation.split(' ')[0]; // enlever heure si existe
        } else {
            document.getElementById('edit-dateMiseEnCirculation').value = '';
        }
        document.getElementById('edit-kilometrage').value = card.dataset.kilometrage || '';

        openModal('editCarModal');
    }


    function openDeleteModal(immatriculation) {
        document.getElementById('delete-immatriculation').value = immatriculation;
        openModal('deleteCarModal');
    }

    // Recherche filtre simple sur les cartes
    document.getElementById('searchInput').addEventListener('input', function () {
        const filter = this.value.toLowerCase();
        document.querySelectorAll('.vehicle-card').forEach(card => {
            const text = (
                card.dataset.marque + ' ' +
                card.dataset.modele + ' ' +
                card.dataset.immatriculation
            ).toLowerCase();
            card.style.display = text.includes(filter) ? 'flex' : 'none';
        });
    });
</script>
</body>
</html>
