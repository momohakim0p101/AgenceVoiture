<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <title>Détails de la location - Automanager</title>
  <style>
    /* Reset simple */
    *, *::before, *::after {
      box-sizing: border-box;
    }

    body {
      font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #f5f7fa;
      color: #333;
      line-height: 1.6;
    }

    header {
      display: flex;
      align-items: center;
      gap: 15px;
      border-bottom: 2px solid #0078d4;
      padding-bottom: 10px;
      margin-bottom: 30px;
    }

    header img {
      height: 60px;
      width: auto;
    }

    header h1 {
      font-size: 1.8rem;
      color: #0078d4;
      margin: 0;
      font-weight: 700;
    }

    main {
      max-width: 800px;
      margin: 0 auto;
      background: #fff;
      padding: 30px 40px;
      border-radius: 8px;
      box-shadow: 0 8px 16px rgba(0,0,0,0.1);
    }

    h2 {
      margin-top: 0;
      color: #0078d4;
      border-bottom: 2px solid #0078d4;
      padding-bottom: 8px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 30px;
    }

    th, td {
      padding: 12px 15px;
      border: 1px solid #ddd;
      text-align: left;
    }

    th {
      background-color: #f0f8ff;
      font-weight: 600;
      color: #005a9e;
      width: 30%;
    }

    /* Termes et conditions */
    section.terms {
      background-color: #eef4fb;
      border-left: 5px solid #0078d4;
      padding: 20px 25px;
      border-radius: 4px;
      font-size: 0.95rem;
      color: #444;
      margin-bottom: 40px;
      max-height: 300px;
      overflow-y: auto;
    }

    /* Bouton impression */
    .btn-print {
      background-color: #0078d4;
      color: white;
      border: none;
      padding: 12px 25px;
      font-size: 1rem;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s ease;
      margin-bottom: 25px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }

    .btn-print:hover {
      background-color: #005a9e;
    }

    /* Icône imprimante simple avec SVG */
    .btn-print svg {
      width: 20px;
      height: 20px;
      fill: currentColor;
    }

    /* Responsive */
    @media (max-width: 600px) {
      main {
        padding: 20px;
      }

      th, td {
        padding: 10px 8px;
      }

      header h1 {
        font-size: 1.4rem;
      }
    }
    @media print {
      body {
        background: white;
        color: black;
      }

      .btn-print, header {
        display: none; /* Cacher le bouton et en-tête lors de l'impression */
      }

      section.terms {
        page-break-before: always;
      }

      table, section.terms {
        border: none;
      }
    }

  </style>
  <script>
    function imprimerPage() {
      window.print();
    }
  </script>
</head>
<body>

<header>
  <img src="https://cdn.brandfetch.io/idD08_sdcu/w/250/h/250/theme/dark/icon.png?c=1dxbfHSJFAPEGdCLU4o5B" alt="Logo Automanager" />
  <h1>Automanager - Détails de la location</h1>
</header>

<main>

  <a href="GenererPDFLocationServlet" style="text-decoration: none" class="btn-print" target="_blank">
    <svg>...</svg> Télécharger en PDF
  </a>
  <h2>Informations sur la location</h2>

  <table role="table" aria-label="Détails de la location">
    <tr>
      <th>Client</th>
      <td>${location.client.nom} ${location.client.prenom} (CIN : ${location.client.cin})</td>
    </tr>
    <tr>
      <th>Voiture</th>
      <td>${location.voiture.marque} ${location.voiture.modele} - Immatriculation : ${location.voiture.immatriculation}</td>
    </tr>
    <tr>
      <th>Date de début</th>
      <td><fmt:formatDate value="${location.dateDebut}" pattern="dd/MM/yyyy" /></td>
    </tr>
    <tr>
      <th>Date de fin</th>
      <td><fmt:formatDate value="${location.dateFin}" pattern="dd/MM/yyyy" /></td>
    </tr>
    <tr>
      <th>Statut</th>
      <td>${location.statut}</td>
    </tr>
    <tr>
      <th>Montant</th>
      <td><fmt:formatNumber value="${location.montantTotal}" pattern="#,##0.00 'FCFA'" /></td>
    </tr>
  </table>

  <section class="terms" aria-labelledby="termsTitle" tabindex="0">
    <h2 id="termsTitle">Termes et conditions de location</h2>
    <p>
      Bienvenue chez Automanager. En louant une voiture chez nous, vous acceptez les termes et conditions suivants :
    </p>
    <ul>
      <li>Le locataire doit être âgé d’au moins 21 ans et posséder un permis de conduire valide.</li>
      <li>Le carburant doit être restitué au même niveau qu’à la prise en charge.</li>
      <li>En cas d’accident ou de dommage, le locataire doit informer Automanager immédiatement.</li>
      <li>Le respect des horaires de prise en charge et de restitution est obligatoire.</li>
      <li>Les retards peuvent entraîner des frais supplémentaires.</li>
      <li>Automanager décline toute responsabilité en cas d’usage frauduleux ou illégal du véhicule.</li>
      <li>Le locataire s’engage à restituer le véhicule dans un état propre et sans dommages.</li>
    </ul>
    <p>
      Pour toute question, veuillez contacter notre service client au +221 33 000 00 00 ou par email à support@automanager.sn.
    </p>
  </section>

</main>

</body>
</html>
