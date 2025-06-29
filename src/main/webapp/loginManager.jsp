<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Connexion Gestionnaire - Auto-Manager</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-blue-100 to-white flex items-center justify-center min-h-screen">

<div class="bg-white rounded-xl shadow-2xl p-8 w-full max-w-sm">
  <!-- Logo -->
  <div class="flex flex-col items-center mb-6">
    <div class="bg-blue-600 rounded-xl p-3">
      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M4 13V6a1 1 0 011-1h3v2H6v6h12V7h-2V5h3a1 1 0 011 1v7m-4 4H8a2 2 0 00-2 2v1h12v-1a2 2 0 00-2-2z"/>
      </svg>
    </div>
    <h1 class="text-xl font-semibold text-gray-800 mt-3">Auto-Manager</h1>
    <p class="text-sm text-gray-500">Connectez-vous à votre compte</p>
  </div>

  <!-- Formulaire -->
  <form action="LoginServlet" method="post" class="space-y-4">
    <input type="hidden" name="role" value="gestionnaire" />

    <div>
      <label for="identifiant" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
      <input type="email" id="identifiant" name="identifiant"
             class="w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-2 focus:ring-blue-500 focus:outline-none"
             placeholder="votre@email.com" required />
    </div>

    <div>
      <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Mot de passe</label>
      <input type="password" id="password" name="password"
             class="w-full px-4 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-2 focus:ring-blue-500 focus:outline-none"
             placeholder="********" required />
    </div>

    <button type="submit"
            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 rounded-md transition duration-150">
      Se connecter
    </button>
  </form>

  <!-- Message d'erreur -->
  <%
    String error = (String) request.getAttribute("error");
    if (error != null) {
  %>
  <div class="mt-4 bg-red-100 text-red-700 text-sm rounded-md px-4 py-2">
    <%= error %>
  </div>
  <% } %>

  <!-- Comptes de démo -->
  <div class="mt-6 border-t pt-4 text-sm text-gray-600">
    <p class="font-medium">Comptes de démonstration :</p>
    <ul class="mt-1 ml-4 list-disc space-y-1">
      <li><strong>Gestionnaire :</strong> gestionnaire@agence.ma</li>
      <li><strong>Mot de passe :</strong> <code>password</code></li>
    </ul>
  </div>
</div>

</body>
</html>
