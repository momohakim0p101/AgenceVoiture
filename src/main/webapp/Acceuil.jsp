<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Accueil - Agence AutoManager</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./css/StyleAcceuil.css">
</head>
<body>


<video autoplay muted loop class="background-video">
    <source src="./video/video.mp4" type="video/mp4">
</video>


<div class="overlay"></div>


<div class="container">
    <header class="header">
        <h1>Bienvenue à AutoManager</h1>
        <p>Optimisez la gestion de votre agence de location de voitures.</p>
        <div class="buttons">
            <a href="loginChef.jsp" class="btn btn-primary">Espace Chef d'Agence</a>
            <a href="loginManager.jsp" class="btn btn-secondary">Espace Gestionnaire</a>
        </div>
    </header>
</div>


<footer class="footer">
    <p>&copy; 2025 AutoManager. Tous droits réservés.</p>
</footer>

</body>
</html>
