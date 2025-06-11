document.addEventListener('DOMContentLoaded', function() {
    // Initialisation du dashboard
    initDashboard();

    // Gestion des événements
    setupEventListeners();
});

function initDashboard() {
    // Charger les données du dashboard
    loadDashboardData();

    // Mettre à jour l'heure de dernière mise à jour
    updateLastUpdateTime();

    // Charger les locations récentes
    loadRecentRentals();
}

function setupEventListeners() {
    // Bouton de déconnexion
    document.getElementById('logoutBtn').addEventListener('click', function() {
        if (confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    });

    // Barre de recherche globale
    document.getElementById('globalSearch').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        filterRecentRentals(searchTerm);
    });

    // Modal de retour de voiture
    document.getElementById('confirmReturnBtn').addEventListener('click', processCarReturn);

    // Fermeture des modales
    document.querySelectorAll('.close-modal').forEach(btn => {
        btn.addEventListener('click', function() {
            const modal = this.closest('.modal');
            closeModal(modal);
        });
    });

    // Fermer les modales en cliquant à l'extérieur
    window.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal')) {
            closeModal(e.target);
        }
    });
}

function loadDashboardData() {
    // Simulation de chargement de données - à remplacer par des appels AJAX réels
    setTimeout(() => {
        document.getElementById('availableCarsCount').textContent = '24';
        document.getElementById('rentedCarsCount').textContent = '18';
        document.getElementById('activeClientsCount').textContent = '156';
        document.getElementById('monthlyRevenue').textContent = '€12,450';
    }, 500);
}

function updateLastUpdateTime() {
    const now = new Date();
    const timeString = now.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
    document.getElementById('lastUpdateTime').textContent = timeString;
}

function loadRecentRentals() {
    // Simulation de données - à remplacer par un appel AJAX
    const rentals = [
        {
            id: 1,
            client: 'Martin Bernard',
            car: 'Peugeot 308 (AB-123-CD)',
            startDate:""}];
