<%--
  Created by IntelliJ IDEA.
  User: hakim01
  Date: 06/06/2025
  Time: 10:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Gestionnaire - Agence de Location</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="./css/dashboard.css">
    <link rel="stylesheet" href="./css/GestionClient.css">

</head>
<body>

<!-- Sidebar Navigation (identique au dashboard) -->
<aside class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fas fa-car"></i> <span>Agence Location</span></h3>
    </div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/dashboardManager.jsp">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/GestionVoiture.jsp">
                <i class="fas fa-car"></i>
                <span>Gestion Voitures</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/GestionClient.jsp" class="active">
                <i class="fas fa-users"></i>
                <span>Gestion Clients</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/GestionLocation.jsp">
                <i class="fas fa-file-contract"></i>
                <span>Locations</span>
            </a>
        </li>
    </ul>
</aside>

<!-- Main Content -->
<main class="main-content">
    <!-- Top Navigation (identique) -->
    <div class="top-nav">
        <div class="search-bar">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Rechercher un client...">
        </div>
        <div class="user-profile">
            <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Profile">
            <div class="user-info">
                <span class="user-name">Jean Dupont</span>
                <span class="user-role">Gestionnaire</span>
            </div>
            <button class="logout-btn" title="Déconnexion">
                <i class="fas fa-sign-out-alt"></i>
            </button>
        </div>
    </div>

    <!-- Clients Management Section -->
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
                    <input type="text" placeholder="Rechercher...">
                </div>
                <button class="filter-btn">
                    <i class="fas fa-filter"></i> Filtrer
                </button>
            </div>
        </div>

        <table>
            <thead>
            <tr>
                <th>Client</th>
                <th>CIN</th>
                <th>Téléphone</th>
                <th>Email</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>
                    <div class="client-name">
                        <img src="https://randomuser.me/api/portraits/men/32.jpg" class="client-avatar">
                        <span>Martin Bernard</span>
                    </div>
                </td>
                <td>AB123456</td>
                <td>06 12 34 56 78</td>
                <td>martin.bernard@example.com</td>
                <td><span class="client-status status-active">Actif</span></td>
                <td>
                    <button class="action-btn edit-btn" data-client-id="1">
                        <i class="fas fa-edit"></i> Modifier
                    </button>
                    <button class="action-btn delete-btn" data-client-id="1">
                        <i class="fas fa-trash"></i> Supprimer
                    </button>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="client-name">
                        <img src="https://randomuser.me/api/portraits/women/44.jpg" class="client-avatar">
                        <span>Sophie Lambert</span>
                    </div>
                </td>
                <td>CD789012</td>
                <td>06 98 76 54 32</td>
                <td>sophie.lambert@example.com</td>
                <td><span class="client-status status-active">Actif</span></td>
                <td>
                    <button class="action-btn edit-btn" data-client-id="2">
                        <i class="fas fa-edit"></i> Modifier
                    </button>
                    <button class="action-btn delete-btn" data-client-id="2">
                        <i class="fas fa-trash"></i> Supprimer
                    </button>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="client-name">
                        <img src="https://randomuser.me/api/portraits/men/67.jpg" class="client-avatar">
                        <span>Thomas Durand</span>
                    </div>
                </td>
                <td>EF345678</td>
                <td>07 12 34 56 78</td>
                <td>thomas.durand@example.com</td>
                <td><span class="client-status status-inactive">Inactif</span></td>
                <td>
                    <button class="action-btn edit-btn" data-client-id="3">
                        <i class="fas fa-edit"></i> Modifier
                    </button>
                    <button class="action-btn delete-btn" data-client-id="3">
                        <i class="fas fa-trash"></i> Supprimer
                    </button>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="client-name">
                        <img src="https://randomuser.me/api/portraits/women/28.jpg" class="client-avatar">
                        <span>Laura Petit</span>
                    </div>
                </td>
                <td>GH901234</td>
                <td>06 55 44 33 22</td>
                <td>laura.petit@example.com</td>
                <td><span class="client-status status-active">Actif</span></td>
                <td>
                    <button class="action-btn edit-btn" data-client-id="4">
                        <i class="fas fa-edit"></i> Modifier
                    </button>
                    <button class="action-btn delete-btn" data-client-id="4">
                        <i class="fas fa-trash"></i> Supprimer
                    </button>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- Add Client Modal -->
    <div class="modal" id="clientModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">Ajouter un Nouveau Client</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="clientForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="clientCIN">CIN*</label>
                            <input type="text" id="clientCIN" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="clientGender">Sexe*</label>
                            <select id="clientGender" class="form-select" required>
                                <option value="">Sélectionner</option>
                                <option value="M">Masculin</option>
                                <option value="F">Féminin</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="clientFirstName">Prénom*</label>
                            <input type="text" id="clientFirstName" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="clientLastName">Nom*</label>
                            <input type="text" id="clientLastName" class="form-control" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="clientAddress">Adresse</label>
                        <input type="text" id="clientAddress" class="form-control">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="clientEmail">Email*</label>
                            <input type="email" id="clientEmail" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="clientPhone">Téléphone*</label>
                            <input type="tel" id="clientPhone" class="form-control" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="clientStatus">Statut</label>
                        <select id="clientStatus" class="form-select">
                            <option value="active">Actif</option>
                            <option value="inactive">Inactif</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary close-modal">Annuler</button>
                <button class="btn btn-primary" id="saveClientBtn">Enregistrer</button>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
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
                <button class="btn btn-danger" id="confirmDeleteBtn">Supprimer</button>
            </div>
        </div>
    </div>
</main>
    <script>
        // DOM Elements
        const addClientBtn = document.getElementById('addClientBtn');
        const clientModal = document.getElementById('clientModal');
        const deleteModal = document.getElementById('deleteModal');
        const closeModalBtns = document.querySelectorAll('.close-modal');
        const saveClientBtn = document.getElementById('saveClientBtn');
        const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
        const modalTitle = document.getElementById('modalTitle');
        const clientForm = document.getElementById('clientForm');

        // Current client being edited/deleted
        let currentClientId = null;
        let isEditMode = false;

        // Event Listeners
        addClientBtn.addEventListener('click', openAddClientModal);
        saveClientBtn.addEventListener('click', saveClient);
        confirmDeleteBtn.addEventListener('click', deleteClient);

        // Edit/Delete buttons event delegation
        document.addEventListener('click', function(e) {
            // Edit button
            if (e.target.closest('.edit-btn')) {
                const btn = e.target.closest('.edit-btn');
                currentClientId = btn.dataset.clientId;
                isEditMode = true;
                openEditClientModal(currentClientId);
            }

            // Delete button
            if (e.target.closest('.delete-btn')) {
                const btn = e.target.closest('.delete-btn');
                currentClientId = btn.dataset.clientId;
                openDeleteModal();
            }
        });

        // Modal functions
        function openAddClientModal() {
            isEditMode = false;
            modalTitle.textContent = 'Ajouter un Nouveau Client';
            clientForm.reset();
            openModal(clientModal);
        }

        function openEditClientModal(clientId) {
            // In a real app, you would fetch client data from your backend
            // Here we simulate with dummy data
            const dummyData = {
                '1': {
                    cin: 'AB123456',
                    firstName: 'Martin',
                    lastName: 'Bernard',
                    gender: 'M',
                    address: '12 Rue de la Paix, Paris',
                    email: 'martin.bernard@example.com',
                    phone: '0612345678',
                    status: 'active'
                },
                '2': {
                    cin: 'CD789012',
                    firstName: 'Sophie',
                    lastName: 'Lambert',
                    gender: 'F',
                    address: '34 Avenue des Champs, Lyon',
                    email: 'sophie.lambert@example.com',
                    phone: '0698765432',
                    status: 'active'
                }
            };

            const clientData = dummyData[clientId] || dummyData['1'];

            // Fill the form
            document.getElementById('clientCIN').value = clientData.cin;
            document.getElementById('clientFirstName').value = clientData.firstName;
            document.getElementById('clientLastName').value = clientData.lastName;
            document.getElementById('clientGender').value = clientData.gender;
            document.getElementById('clientAddress').value = clientData.address;
            document.getElementById('clientEmail').value = clientData.email;
            document.getElementById('clientPhone').value = clientData.phone;
            document.getElementById('clientStatus').value = clientData.status;

            modalTitle.textContent = 'Modifier Client';
            openModal(clientModal);
        }

        function openDeleteModal() {
            openModal(deleteModal);
        }

        function openModal(modal) {
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }

        function closeModal(modal) {
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Close modals when clicking outside
        window.addEventListener('click', (e) => {
            if (e.target.classList.contains('modal')) {
                closeModal(e.target);
            }
        });

        // Close modals with close buttons
        closeModalBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const modal = btn.closest('.modal');
                closeModal(modal);
            });
        });

        // Form submission
        function saveClient() {
            // Validate form
            if (!clientForm.checkValidity()) {
                alert('Veuillez remplir tous les champs obligatoires');
                return;
            }

            // Get form data
            const clientData = {
                cin: document.getElementById('clientCIN').value,
                firstName: document.getElementById('clientFirstName').value,
                lastName: document.getElementById('clientLastName').value,
                gender: document.getElementById('clientGender').value,
                address: document.getElementById('clientAddress').value,
                email: document.getElementById('clientEmail').value,
                phone: document.getElementById('clientPhone').value,
                status: document.getElementById('clientStatus').value
            };

            // In a real app, you would send this to your backend
            console.log(isEditMode ? 'Updating client:' : 'Adding new client:', clientData);

            // Show success message
            alert(`Client ${isEditMode ? 'modifié' : 'ajouté'} avec succès!`);

            // Close modal and reset form
            closeModal(clientModal);
            clientForm.reset();

            // In a real app, you would refresh the client list
        }

        function deleteClient() {
            // In a real app, you would send a delete request to your backend
            console.log('Deleting client with ID:', currentClientId);

            // Show success message
            alert('Client supprimé avec succès!');

            // Close modal
            closeModal(deleteModal);

            // In a real app, you would remove the client from the table or refresh the list
        }

        // Search functionality
        document.querySelector('.search-bar input').addEventListener('input', (e) => {
            const searchTerm = e.target.value.toLowerCase();
            // Implement search logic here
            console.log('Searching clients for:', searchTerm);
        });

        document.querySelector('.search-clients input').addEventListener('input', (e) => {
            const searchTerm = e.target.value.toLowerCase();
            // Implement table search logic here
            console.log('Filtering table for:', searchTerm);
        });
    </script>
</body>
</html>
