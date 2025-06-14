<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Gestion Clients - Agence de Location</title>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
  <link rel="stylesheet"  href="./css/dashboard.css">
  <link rel="stylesheet" href="./css/GestionClient.css">
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-header">
    <h3><i class="fas fa-car"></i> <span>Agence Location</span></h3>
  </div>
  <ul class="sidebar-menu">
    <li><a href="a href="${pageContext.request.contextPath}/DashboardManagerServlet"><i class="fas fa-tachometer-alt"></i> <span>Dashboard</span></a></li>
    <li><a href="GestionVoiture.jsp"><i class="fas fa-car"></i> <span>Gestion Voitures</span></a></li>
    <li><a href="GestionClient.jsp" class="active"><i class="fas fa-users"></i> <span>Gestion Clients</span></a></li>
    <li><a href="GestionLocation.jsp"><i class="fas fa-file-contract"></i> <span>Locations</span></a></li>
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
        <span class="user-name">Jean Dupont</span>
        <span class="user-role">Gestionnaire</span>
      </div>
      <button class="logout-btn" title="Déconnexion">
        <i class="fas fa-sign-out-alt"></i>
      </button>
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
        <div class="search-clients">
          <i class="fas fa-search"></i>
          <input type="text" id="tableSearchInput" placeholder="Rechercher..." />
        </div>
        <button class="filter-btn">
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
              <img src="${client.avatarUrl != null ? client.avatarUrl : 'https://randomuser.me/api/portraits/lego/1.jpg'}" class="client-avatar" />
              <span>${client.prenom} ${client.nom}</span>
            </div>
          </td>
          <td>${client.cin}</td>
          <td>${client.telephone}</td>
          <td>${client.email}</td>
          <td>${client.sexe == 'M' ? 'Masculin' : 'Féminin'}</td>
          <td>${client.adresse}</td>
          <td>
            <button class="action-btn edit-btn" data-client-id="${client.id}">
              <i class="fas fa-edit"></i> Modifier
            </button>
            <button class="action-btn delete-btn" data-client-id="${client.id}">
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
  <div class="modal" id="clientModal">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="modalTitle">Ajouter un Nouveau Client</h3>
        <button class="close-modal">&times;</button>
      </div>
      <div class="modal-body">
        <form id="clientForm" method="post" action="ClientServlet">
          <input type="hidden" id="clientId" name="id" />
          <div class="form-row">
            <div class="form-group">
              <label for="clientCIN">CIN*</label>
              <input type="text" id="clientCIN" name="cin" class="form-control" required />
            </div>
            <div class="form-group">
              <label for="clientGender">Sexe*</label>
              <select id="clientGender" name="sexe" class="form-select" required>
                <option value="">Sélectionner</option>
                <option value="M">Masculin</option>
                <option value="F">Féminin</option>
              </select>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="clientFirstName">Prénom*</label>
              <input type="text" id="clientFirstName" name="prenom" class="form-control" required />
            </div>
            <div class="form-group">
              <label for="clientLastName">Nom*</label>
              <input type="text" id="clientLastName" name="nom" class="form-control" required />
            </div>
          </div>

          <div class="form-group">
            <label for="clientAddress">Adresse</label>
            <input type="text" id="clientAddress" name="adresse" class="form-control" />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="clientEmail">Email*</label>
              <input type="email" id="clientEmail" name="email" class="form-control" required />
            </div>
            <div class="form-group">
              <label for="clientPhone">Téléphone*</label>
              <input type="tel" id="clientPhone" name="telephone" class="form-control" required />
            </div>
          </div>

          <div class="form-group">
            <label for="clientStatus">Statut</label>
            <select id="clientStatus" name="statut" class="form-select">
              <option value="active">Actif</option>
              <option value="inactive">Inactif</option>
            </select>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary close-modal">Annuler</button>
        <button type="submit" form="clientForm" class="btn btn-primary" id="saveClientBtn">Enregistrer</button>
      </div>
    </div>
  </div>

  <!-- Modal Confirmation Suppression -->
  <div class="modal" id="deleteModal">
    <div class="modal-content" style="max-width: 500px;">
      <div class="modal-header">
        <h3 class="modal-title">Confirmer la suppression</h3>
        <button class="close-modal">&times;</button>
      </div>
      <div class="modal-body">
        <p>Êtes-vous sûr de vouloir supprimer ce client? Cette action est irréversible.</p>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary close-modal">Annuler</button>
        <form method="post" action="ClientServlet" style="display:inline;">
          <input type="hidden" id="deleteClientId" name="id" />
          <input type="hidden" name="action" value="delete" />
          <button type="submit" class="btn btn-danger" id="confirmDeleteBtn">Supprimer</button>
        </form>
      </div>
    </div>
  </div>
</main>

<script>
  const addClientBtn = document.getElementById('addClientBtn');
  const clientModal = document.getElementById('clientModal');
  const deleteModal = document.getElementById('deleteModal');
  const closeModalBtns = document.querySelectorAll('.close-modal');
  const modalTitle = document.getElementById('modalTitle');
  const clientForm = document.getElementById('clientForm');
  const clientIdInput = document.getElementById('clientId');
  const deleteClientIdInput = document.getElementById('deleteClientId');
  const saveClientBtn = document.getElementById('saveClientBtn');

  let isEditMode = false;

  // Ouvrir le modal d'ajout
  addClientBtn.addEventListener('click', () => {
    isEditMode = false;
    modalTitle.textContent = 'Ajouter un Nouveau Client';
    clientForm.reset();
    clientIdInput.value = '';
    clientForm.action = 'ClientServlet?action=save';
    openModal(clientModal);
  });

  // Gérer les clics sur les boutons Modifier et Supprimer
  document.addEventListener('click', (e) => {
    const editBtn = e.target.closest('.edit-btn');
    const deleteBtn = e.target.closest('.delete-btn');

    // Modifier
    if (editBtn) {
      const clientId = editBtn.getAttribute('data-client-id');
      fetch(`ClientServlet?action=find&id=${clientId}`)
              .then(response => response.json())
              .then(client => {
                isEditMode = true;
                modalTitle.textContent = 'Modifier le Client';
                clientForm.action = 'ClientServlet?action=update';
                clientIdInput.value = client.id;
                document.getElementById('clientCIN').value = client.cin;
                document.getElementById('clientFirstName').value = client.prenom;
                document.getElementById('clientLastName').value = client.nom;
                document.getElementById('clientEmail').value = client.email;
                document.getElementById('clientPhone').value = client.telephone;
                document.getElementById('clientAddress').value = client.adresse;
                document.getElementById('clientGender').value = client.sexe;
                document.getElementById('clientStatus').value = client.statut;
                openModal(clientModal);
              })
              .catch(error => {
                console.error('Erreur lors de la récupération du client :', error);
                alert("Une erreur s'est produite lors du chargement du client.");
              });
    }

    // Supprimer
    if (deleteBtn) {
      const clientId = deleteBtn.getAttribute('data-client-id');
      deleteClientIdInput.value = clientId;
      openModal(deleteModal);
    }
  });

  // Fermer toutes les modales
  closeModalBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      closeModal(btn.closest('.modal'));
    });
  });

  function openModal(modal) {
    modal.classList.add('show');
    modal.style.display = 'block';
  }

  function closeModal(modal) {
    modal.classList.remove('show');
    modal.style.display = 'none';
  }
</script>

</body>
</html>
