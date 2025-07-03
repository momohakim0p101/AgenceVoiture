<%@ page import="com.agence.agencevoiture.entity.Client" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Gestion Clients - Agence AutoDrive</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
</head>
<body class="bg-slate-50 font-sans flex">

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


<!-- Contenu principal -->
<main class="flex-grow ml-64 p-6">

  <!-- Header -->
  <header class="flex justify-between items-center mb-6">
    <h1 class="text-3xl font-bold text-[#0c151d]">Gestion Clients</h1>
    <button id="btnAddClient" class="bg-[#e6edf4] text-[#0c151d] px-4 py-2 rounded-xl hover:bg-[#cddcea] transition">
      + Ajouter un client
    </button>
  </header>

  <!-- Recherche -->
  <section class="mb-6">
    <label class="block max-w-md">
      <div class="flex items-center bg-[#e6edf4] rounded-xl pl-3 py-2">
        <svg class="w-6 h-6 text-[#4574a1]" fill="currentColor" viewBox="0 0 24 24"><path d="M10 2a8 8 0 105.293 14.293l5.707 5.707 1.414-1.414-5.707-5.707A8 8 0 0010 2z"/></svg>
        <input type="search" id="searchInput" placeholder="Rechercher par ID ou nom"
               class="flex-grow bg-transparent px-3 outline-none text-[#0c151d]" />
      </div>
    </label>
  </section>

  <!-- Tableau Clients -->
  <section>
    <div class="overflow-x-auto rounded-xl border border-[#cddcea] bg-white">
      <table class="min-w-full table-auto text-left">
        <thead class="bg-slate-50">
        <tr>
          <th class="px-4 py-3 w-24 text-sm font-medium text-[#0c151d]">CIN</th>
          <th class="px-4 py-3 w-40 text-sm font-medium text-[#0c151d]">Prenom</th>
          <th class="px-4 py-3 w-40 text-sm font-medium text-[#0c151d]">Nom</th>
          <th class="px-4 py-3 w-24 text-sm font-medium text-[#0c151d]">Sexe</th>
          <th class="px-4 py-3 w-64 text-sm font-medium text-[#0c151d]">Adresse</th>
          <th class="px-4 py-3 w-64 text-sm font-medium text-[#0c151d]">Email</th>
          <th class="px-4 py-3 w-40 text-sm font-medium text-[#0c151d]">Telephone</th>
          <th class="px-4 py-3 w-36 text-sm font-medium text-[#4574a1]">Actions</th>
        </tr>
        </thead>
        <tbody id="clientsTableBody">
        <c:forEach var="client" items="${clients}">
          <tr class="border-t border-[#cddcea] hover:bg-[#f5f9ff]">
            <td class="px-4 py-3 text-[#4574a1] text-sm font-normal">${client.cin}</td>
            <td class="px-4 py-3 text-[#4574a1] text-sm font-normal">${client.prenom}</td>
            <td class="px-4 py-3 text-[#4574a1] text-sm font-normal">${client.nom}</td>
            <td class="px-4 py-3 text-[#4574a1] text-sm font-normal">
              <c:choose>
                <c:when test="${client.sexe == 'M'}">Homme</c:when>
                <c:when test="${client.sexe == 'F'}">Femme</c:when>
                <c:otherwise>Inconnu</c:otherwise>
              </c:choose>
            </td>
            <td class="px-4 py-3 text-[#4574a1] text-sm font-normal">${client.adresse}</td>
            <td class="px-4 py-3 text-[#4574a1] text-sm font-normal">${client.email}</td>
            <td class="px-4 py-3 text-[#4574a1] text-sm font-normal">${client.telephone}</td>
            <td class="px-4 py-3 text-[#4574a1] text-sm font-bold tracking-wider">
              <button
                      class="text-blue-600 hover:text-blue-800 btnEditClient"
                      data-cin="${client.cin}"
                      data-prenom="${client.prenom}"
                      data-nom="${client.nom}"
                      data-sexe="${client.sexe}"
                      data-adresse="${client.adresse}"
                      data-email="${client.email}"
                      data-telephone="${client.telephone}"
              >Modifier</button> |
              <button
                      class="text-red-600 hover:text-red-800 btnDeleteClient"
                      data-cin="${client.cin}"
                      data-prenom="${client.prenom}"
                      data-nom="${client.nom}"
              >Supprimer</button>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty clients}">
          <tr><td colspan="8" class="text-center py-4 text-gray-500">Aucun client trouvé.</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </section>

</main>

<!-- Modal Ajouter / Modifier Client -->
<div id="modalClient" class="fixed inset-0 bg-black bg-opacity-40 hidden items-center justify-center z-50">
  <div class="bg-white rounded-xl p-6 w-full max-w-md shadow-lg">
    <h2 id="modalClientTitle" class="text-xl font-semibold mb-4">Ajouter un client</h2>
    <form id="formClient" method="post" action="${pageContext.request.contextPath}/ClientServlet" class="space-y-4">
      <input type="hidden" name="action" id="formAction" value="save" />


      <div>
        <label for="clientCinInput" class="block text-sm font-medium text-gray-700">CIN</label>
        <input type="text" name="cin" id="clientCinInput"  required class="mt-1 block w-full rounded border border-gray-300 p-2" />
        <label for="clientPrenom" class="block text-sm font-medium text-gray-700">Prénom</label>
        <input type="text" id="clientPrenom" name="prenom" required class="mt-1 block w-full rounded border border-gray-300 p-2" />
      </div>
      <div>
        <label for="clientNom" class="block text-sm font-medium text-gray-700">Nom</label>
        <input type="text" id="clientNom" name="nom" required class="mt-1 block w-full rounded border border-gray-300 p-2" />
      </div>
      <div>
        <label for="clientSexe" class="block text-sm font-medium text-gray-700">Sexe</label>
        <select id="clientSexe" name="sexe" required class="mt-1 block w-full rounded border border-gray-300 p-2">
          <option value="">Sélectionner</option>
          <option value="M">Homme</option>
          <option value="F">Femme</option>
        </select>
      </div>
      <div>
        <label for="clientAdresse" class="block text-sm font-medium text-gray-700">Adresse</label>
        <input type="text" id="clientAdresse" name="adresse" class="mt-1 block w-full rounded border border-gray-300 p-2" />
      </div>
      <div>
        <label for="clientEmail" class="block text-sm font-medium text-gray-700">Email</label>
        <input type="email" id="clientEmail" name="email" required class="mt-1 block w-full rounded border border-gray-300 p-2" />
      </div>
      <div>
        <label for="clientTelephone" class="block text-sm font-medium text-gray-700">Téléphone</label>
        <input type="tel" id="clientTelephone" name="telephone" required class="mt-1 block w-full rounded border border-gray-300 p-2" />
      </div>

      <div class="flex justify-end gap-3 pt-4">
        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Enregistrer</button>
        <button type="button" id="btnCancelClient" class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400">Annuler</button>
      </div>
    </form>
  </div>
</div>

<!-- Modal Confirmation Suppression -->
<div id="modalDelete" class="fixed inset-0 bg-black bg-opacity-40 hidden items-center justify-center z-50">
  <div class="bg-white rounded-xl p-6 w-full max-w-sm shadow-lg">
    <h2 class="text-xl font-semibold mb-4">Confirmer la suppression</h2>
    <p id="deleteText" class="mb-6">Voulez-vous supprimer ce client ?</p>
    <form id="formDeleteClient" method="post" action="${pageContext.request.contextPath}/ClientServlet">
      <input type="hidden" name="action" value="delete" />
      <input type="hidden" name="cin" id="deleteClientId" />
      <div class="flex justify-end gap-3">
        <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">Supprimer</button>
        <button type="button" id="btnCancelDelete" class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400">Annuler</button>
      </div>
    </form>
  </div>
</div>

<script>
  // Ouverture modal Ajouter Client
  document.getElementById('btnAddClient').addEventListener('click', () => {
    document.getElementById('modalClientTitle').textContent = 'Ajouter un client';
    document.getElementById('formAction').value = 'save';
    document.getElementById('clientCinInput').value = '';
    document.getElementById('clientPrenom').value = '';
    document.getElementById('clientNom').value = '';
    document.getElementById('clientSexe').value = '';
    document.getElementById('clientAdresse').value = '';
    document.getElementById('clientEmail').value = '';
    document.getElementById('clientTelephone').value = '';
    document.getElementById('modalClient').classList.remove('hidden');
  });

  // Annuler modal Client
  document.getElementById('btnCancelClient').addEventListener('click', () => {
    document.getElementById('modalClient').classList.add('hidden');
  });

  // Modifier client
  document.querySelectorAll('.btnEditClient').forEach(btn => {
    btn.addEventListener('click', () => {
      document.getElementById('modalClientTitle').textContent = 'Modifier un client';
      document.getElementById('formAction').value = 'update';

      document.getElementById('clientCinInput').value = btn.dataset.cin;
      document.getElementById('clientPrenom').value = btn.dataset.prenom;
      document.getElementById('clientNom').value = btn.dataset.nom;
      document.getElementById('clientSexe').value = btn.dataset.sexe;
      document.getElementById('clientAdresse').value = btn.dataset.adresse;
      document.getElementById('clientEmail').value = btn.dataset.email;
      document.getElementById('clientTelephone').value = btn.dataset.telephone;

      document.getElementById('modalClient').classList.remove('hidden');
    });
  });

  // Ouvrir modal suppression
  document.querySelectorAll('.btnDeleteClient').forEach(btn => {
    btn.addEventListener('click', () => {
      const cin = btn.dataset.cin;
      const prenom = btn.dataset.prenom;
      const nom = btn.dataset.nom;

      document.getElementById('deleteText').textContent = `Voulez-vous supprimer le client ${prenom} ${nom} ?`;
      document.getElementById('deleteClientId').value = cin;
      document.getElementById('modalDelete').classList.remove('hidden');
    });
  });

  // Annuler modal suppression
  document.getElementById('btnCancelDelete').addEventListener('click', () => {
    document.getElementById('modalDelete').classList.add('hidden');
  });

  // Recherche simple (filtrage client dans le tableau côté front)
  document.getElementById('searchInput').addEventListener('input', e => {
    const filter = e.target.value.toLowerCase();
    const rows = document.querySelectorAll('#clientsTableBody tr');

    rows.forEach(row => {
      const id = row.cells[0].textContent.toLowerCase();
      const prenom = row.cells[1].textContent.toLowerCase();
      const nom = row.cells[2].textContent.toLowerCase();

      if (id.includes(filter) || prenom.includes(filter) || nom.includes(filter)) {
        row.style.display = '';
      } else {
        row.style.display = 'none';
      }
    });
  });
</script>

</body>
</html>
