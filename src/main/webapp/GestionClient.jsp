<%@ page import="com.agence.agencevoiture.entity.Utilisateur" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  Utilisateur utilisateur = (Utilisateur) request.getAttribute("utilisateur");
  if (utilisateur == null) {
    utilisateur = (Utilisateur) session.getAttribute("utilisateur");
  }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Gestion Clients - Agence de Location</title>

  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/GestionClient.css" />
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-header">
    <h3><i class="fas fa-car"></i> <span>Agence Location</span></h3>
  </div>
  <ul class="sidebar-menu">
    <li><a href="${pageContext.request.contextPath}/DashboardManagerServlet"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
    <li><a href="${pageContext.request.contextPath}/VoitureServlet" class="active"><i class="fas fa-car"></i> <span>Gestion Voitures</span></a></li>
    <li>
      <a href="${pageContext.request.contextPath}/ClientServlet">
        <i class="fas fa-users"></i> <span>Gestion Clients</span>
      </a>
    </li>
    <li><a href="${pageContext.request.contextPath}/LocationServlet?action.views"><i class="fas fa-file-contract"></i> <span>Locations</span></a></li>
  </ul>
</aside>

<main class="main-content">
  <div class="top-nav">
    <div class="search-bar">
      <i class="fas fa-search"></i>
      <input type="text" id="globalSearchInput" placeholder="Rechercher un client..." />
    </div>
    <div class="user-profile">
      <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Profile" />
      <div class="user-info">
        <% if (utilisateur != null) { %>
        <span class="user-name"><%= utilisateur.getNom() %></span>
        <span class="user-role"><%= utilisateur.getRole() %></span>
        <% } else { %>
        <span class="user-name">Utilisateur non connecté</span>
        <span class="user-role">Rôle inconnu</span>
        <% } %>
      </div>
      <form method="get" action="${pageContext.request.contextPath}/LogoutServlet" style="display:inline;">
        <button class="logout-btn" title="Déconnexion" type="submit">
          <i class="fas fa-sign-out-alt"></i>
        </button>
      </form>
    </div>
  </div>

  <div class="page-header">
    <h1 class="page-title"><i class="fas fa-users"></i> Gestion des Clients</h1>
    <button class="add-client-btn" id="addClientBtn">
      <i class="fas fa-plus"></i> Ajouter un Client
    </button>
  </div>

  <div class="clients-table-container">
    <div class="table-header">
      <h3>Liste des Clients</h3>
      <div class="table-actions">
        <button class="filter-btn" type="button">
          <i class="fas fa-filter"></i> Filtrer
        </button>
      </div>
    </div>

    <table id="clientsTable">
      <thead>
      <tr>
        <th>Client</th>
        <th>CIN</th>
        <th>Téléphone</th>
        <th>Email</th>
        <th>Sexe</th>
        <th>Adresse</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="client" items="${clients}">
        <tr>
          <td>
            <div class="client-name">
              <c:choose>
                <c:when test="${client.sexe == 'M'}">
                  <i class="fas fa-male client-avatar" style="font-size: 30px; color: steelblue; margin-right: 8px;"></i>
                </c:when>
                <c:when test="${client.sexe == 'F'}">
                  <i class="fas fa-female client-avatar" style="font-size: 30px; color: hotpink; margin-right: 8px;"></i>
                </c:when>
                <c:otherwise>
                  <i class="fas fa-user client-avatar" style="font-size: 30px; color: gray; margin-right: 8px;"></i>
                </c:otherwise>
              </c:choose>
              <span>${client.prenom} ${client.nom}</span>
            </div>
          </td>
          <td>${client.cin}</td>
          <td>${client.telephone}</td>
          <td>${client.email}</td>
          <td>
            <c:choose>
              <c:when test="${client.sexe == 'M'}">Masculin</c:when>
              <c:when test="${client.sexe == 'F'}">Féminin</c:when>
              <c:otherwise>Inconnu</c:otherwise>
            </c:choose>
          </td>
          <td>${client.adresse}</td>
          <td>
            <button class="action-btn edit-btn" data-client-id="${client.cin}" type="button">
              <i class="fas fa-edit"></i> Modifier
            </button>
            <button class="action-btn delete-btn" data-client-id="${client.cin}" type="button">
              <i class="fas fa-trash"></i> Supprimer
            </button>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty clients}">
        <tr><td colspan="7" style="text-align:center;">Aucun client trouvé.</td></tr>
      </c:if>
      </tbody>
    </table>
  </div>

  <!-- Modal Ajouter/Modifier Client -->
  <div class="modal" id="clientModal" aria-hidden="true" role="dialog" tabindex="-1">
    <div class="modal-content" role="document">
      <h3 id="modalTitle">Ajouter un Client</h3>
      <form id="clientForm" method="post"action="${pageContext.request.contextPath}/ClientServlet" novalidate>
        <input type="hidden" name="action" id="formAction" value="save" />

        CIN: <input type="text" id="clientCIN" name="cin" required /><br />
        Prénom: <input type="text" id="clientFirstName" name="prenom" required /><br />
        Nom: <input type="text" id="clientLastName" name="nom" required /><br />
        Sexe:
        <select id="clientGender" name="sexe" required>
          <option value="">Sélectionner</option>
          <option value="M">Masculin</option>
          <option value="F">Féminin</option>
        </select><br />
        Adresse: <input type="text" id="clientAddress" name="adresse" /><br />
        Email: <input type="email" id="clientEmail" name="email" required /><br />
        Téléphone: <input type="tel" id="clientPhone" name="telephone" required /><br />

        <button class="action-btn edit-btn" type="submit" id="saveClientBtn">Enregistrer</button>
        <button class="action-btn delete-btn" type="button" id="cancelBtn">Annuler</button>
      </form>
    </div>
  </div>
  <!-- Modal Confirmation Suppression -->
  <div class="modal" id="deleteModal" aria-hidden="true" role="dialog" tabindex="-1">
    <div class="modal-content" role="document">
      <h3>Confirmer la suppression</h3>
      <p>Voulez-vous vraiment supprimer ce client ?</p>

      <form method="post" action="${pageContext.request.contextPath}/ClientServlet">
        <input type="hidden" name="action" value="delete" />
        <input type="hidden" name="cin" id="deleteCin" />
        <button class="action-btn delete-btn" type="submit" id="submitDeleteBtn">Supprimer</button>
        <button class="action-btn edit-btn" type="button" id="cancelDeleteBtn">Annuler</button>
      </form>
    </div>
  </div>

</main>
<script>
  const clientModal = document.getElementById('clientModal');
  const deleteModal = document.getElementById('deleteModal');
  const modalTitle = document.getElementById('modalTitle');
  const clientForm = document.getElementById('clientForm');
  const formActionInput = document.getElementById('formAction');

  const clientCINInput = document.getElementById('clientCIN');
  const clientFirstNameInput = document.getElementById('clientFirstName');
  const clientLastNameInput = document.getElementById('clientLastName');
  const clientGenderInput = document.getElementById('clientGender');
  const clientAddressInput = document.getElementById('clientAddress');
  const clientEmailInput = document.getElementById('clientEmail');
  const clientPhoneInput = document.getElementById('clientPhone');

  const deleteCinInput = document.getElementById('deleteCin');

  let clientToDeleteCin = null;

  // Ouvrir un modal
  function openModal(modal) {
    modal.style.display = 'block';
    modal.setAttribute('aria-hidden', 'false');
  }

  // Fermer un modal
  function closeModal(modal) {
    modal.style.display = 'none';
    modal.setAttribute('aria-hidden', 'true');
  }

  // Bouton Ajouter Client : reset formulaire + ouvrir modal
  document.getElementById('addClientBtn').addEventListener('click', () => {
    modalTitle.textContent = 'Ajouter un Nouveau Client';
    clientForm.reset();
    formActionInput.value = 'save';
    clientCINInput.readOnly = false;
    openModal(clientModal);
  });

  // Gestion clics modifier / supprimer sur la table
  document.querySelector('#clientsTable tbody').addEventListener('click', e => {
    // Modifier
    if (e.target.closest('.edit-btn')) {
      const btn = e.target.closest('.edit-btn');
      const tr = btn.closest('tr');

      formActionInput.value = 'update';

      // Récupérer le texte complet prénom + nom
      const fullNameText = tr.querySelector('td:nth-child(1) span').textContent.trim();
      // Séparer prénom et nom (premier mot = prénom, reste = nom)
      const fullNameParts = fullNameText.split(' ');
      const prenom = fullNameParts.length > 0 ? fullNameParts[0] : '';
      const nom = fullNameParts.length > 1 ? fullNameParts.slice(1).join(' ') : '';

      const cin = tr.querySelector('td:nth-child(2)').textContent.trim();
      clientCINInput.value = cin;
      clientCINInput.readOnly = true;

      clientFirstNameInput.value = prenom;
      clientLastNameInput.value = nom;

      const sexeTexte = tr.querySelector('td:nth-child(5)').textContent.trim();
      clientGenderInput.value = (sexeTexte === 'Masculin') ? 'M' : (sexeTexte === 'Féminin' ? 'F' : '');

      clientAddressInput.value = tr.querySelector('td:nth-child(6)').textContent.trim();
      clientEmailInput.value = tr.querySelector('td:nth-child(4)').textContent.trim();
      clientPhoneInput.value = tr.querySelector('td:nth-child(3)').textContent.trim();

      modalTitle.textContent = 'Modifier le Client';
      openModal(clientModal);
    }
    // Supprimer
    else if (e.target.closest('.delete-btn')) {
      const btn = e.target.closest('.delete-btn');
      clientToDeleteCin = btn.getAttribute('data-client-id');
      deleteCinInput.value = clientToDeleteCin;
      openModal(deleteModal);
    }
  });

  // Annuler ajout/modif client
  document.getElementById('cancelBtn').addEventListener('click', () => {
    closeModal(clientModal);
  });

  // Annuler suppression client
  document.getElementById('cancelDeleteBtn').addEventListener('click', () => {
    closeModal(deleteModal);
  });

  // Fermer modals au clic en dehors
  window.addEventListener('click', e => {
    if (e.target.classList.contains('modal')) {
      closeModal(e.target);
    }
  });
</script>


</body>
</html>
