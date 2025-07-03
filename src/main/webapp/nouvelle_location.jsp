<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.agence.agencevoiture.entity.Client" %>
<%@ page import="com.agence.agencevoiture.entity.Voiture" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8" />
    <title>Nouvelle location</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

<div class="bg-white rounded-xl shadow-lg w-full max-w-3xl p-6">
    <!-- Étapes Tabs -->
    <div class="mb-6 border-b pb-4">
        <h2 class="text-2xl font-semibold mb-2">Nouvelle location</h2>
        <div class="flex justify-between">
            <button class="step-tab text-blue-600 font-medium border-b-2 border-blue-600 px-3 pb-1" data-step="1">Client</button>
            <button class="step-tab text-gray-500 hover:text-blue-600 font-medium px-3 pb-1" data-step="2">Véhicule</button>
            <button class="step-tab text-gray-500 hover:text-blue-600 font-medium px-3 pb-1" data-step="3">Détails</button>
        </div>
    </div>

    <form method="post" action="NouvelleLocationServlet" class="space-y-6">
        <!-- Étape 1 : Client -->
        <div id="step1" class="step-section">
            <h3 class="text-md font-semibold mb-4">Sélectionner un client</h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <c:forEach var="client" items="${clients}">
                    <div class="border rounded-lg p-4 hover:border-blue-500 cursor-pointer flex gap-3 items-center select-client" data-cin="${client.cin}">
                        <div class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center font-bold text-blue-600">
                                ${client.prenom.substring(0,1)}${client.nom.substring(0,1)}
                        </div>
                        <div>
                            <div class="font-semibold">${client.prenom} ${client.nom}</div>
                            <div class="text-sm text-gray-500">${client.cin}</div>
                            <div class="text-sm text-gray-400">${client.email}</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <input type="hidden" name="cin" id="formCin">
            <div class="flex justify-end mt-6">
                <button type="button" class="btn-next bg-blue-600 text-white px-4 py-2 rounded" data-next="2">Suivant</button>
            </div>
        </div>

        <!-- Étape 2 : Véhicule -->
        <div id="step2" class="step-section hidden">
            <h3 class="text-md font-semibold mb-4">Sélectionner un véhicule</h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <c:forEach var="voiture" items="${voitures}">
                    <div class="border rounded-lg p-4 hover:border-blue-500 cursor-pointer flex flex-col select-voiture" data-immat="${voiture.immatriculation}">
                        <div class="font-semibold text-blue-700">${voiture.marque} ${voiture.modele}</div>
                        <div class="text-sm text-gray-500">${voiture.immatriculation}</div>
                        <div class="text-sm text-gray-400">Carburant : ${voiture.typeCarburant}</div>
                    </div>
                </c:forEach>
            </div>
            <input type="hidden" name="immatriculation" id="formImmat">
            <div class="flex justify-between mt-6">
                <button type="button" class="btn-prev px-4 py-2 bg-gray-300 rounded" data-prev="1">Précédent</button>
                <button type="button" class="btn-next bg-blue-600 text-white px-4 py-2 rounded" data-next="3">Suivant</button>
            </div>
        </div>

        <!-- Étape 3 : Détails -->
        <div id="step3" class="step-section hidden">
            <h3 class="text-md font-semibold mb-4">Détails de la location</h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="dateDebut" class="block text-sm font-medium text-gray-700">Date début</label>
                    <input type="date" id="dateDebut" name="dateDebut" required class="mt-1 block w-full rounded border border-gray-300 p-2" />
                </div>
                <div>
                    <label for="dateFin" class="block text-sm font-medium text-gray-700">Date fin</label>
                    <input type="date" id="dateFin" name="dateFin" required class="mt-1 block w-full rounded border border-gray-300 p-2" />
                </div>
            </div>
            <div class="flex justify-between mt-6">
                <button type="button" class="btn-prev px-4 py-2 bg-gray-300 rounded" data-prev="2">Précédent</button>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Valider</button>
            </div>
        </div>
    </form>
</div>

<!-- FontAwesome -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

<!-- JS navigation étapes + sélection -->
<script>
    const tabs = document.querySelectorAll('.step-tab');
    const sections = document.querySelectorAll('.step-section');

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const step = tab.dataset.step;
            switchStep(step);
        });
    });

    document.querySelectorAll('.btn-next').forEach(btn => {
        btn.addEventListener('click', () => switchStep(btn.dataset.next));
    });

    document.querySelectorAll('.btn-prev').forEach(btn => {
        btn.addEventListener('click', () => switchStep(btn.dataset.prev));
    });

    function switchStep(step) {
        sections.forEach((section, idx) => {
            section.classList.toggle('hidden', idx !== step - 1);
        });
        tabs.forEach(tab => {
            tab.classList.remove('border-b-2', 'border-blue-600', 'text-blue-600');
            if (tab.dataset.step == step) {
                tab.classList.add('border-b-2', 'border-blue-600', 'text-blue-600');
            }
        });
    }

    // Sélection client
    const clients = document.querySelectorAll('.select-client');
    const formCin = document.getElementById('formCin');
    clients.forEach(client => {
        client.addEventListener('click', () => {
            clients.forEach(c => c.classList.remove('border-blue-500', 'bg-blue-50'));
            client.classList.add('border-blue-500', 'bg-blue-50');
            formCin.value = client.dataset.cin;
        });
    });

    // Sélection voiture
    const voitures = document.querySelectorAll('.select-voiture');
    const formImmat = document.getElementById('formImmat');
    voitures.forEach(v => {
        v.addEventListener('click', () => {
            voitures.forEach(c => c.classList.remove('border-blue-500', 'bg-blue-50'));
            v.classList.add('border-blue-500', 'bg-blue-50');
            formImmat.value = v.dataset.immat;
        });
    });
</script>

</body>
</html>
