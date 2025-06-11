<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Connexion Chef d'Agence</title>
  <link rel="stylesheet" href="./css/style-login.css">
</head>
<body>
<div class="login-container">
  <h2>Connexion Chef d'Agence</h2>
  <form action="LoginServlet" method="post">
    <input type="hidden" name="role" value="chef">
    <input type="text" name="identifiant" placeholder="Nom d'utilisateur" required>
    <input type="password" name="password" placeholder="Mot de passe" required>
    <button type="submit">Se connecter</button>
    <p class="info-message">${requestScope.error}</p>
  </form>
</div>
</body>
</html>
