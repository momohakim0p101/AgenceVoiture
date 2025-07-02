package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Utilisateur;
import com.agence.agencevoiture.service.UtilisateurService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {


    private UtilisateurService utilisateurService;

    public void init(){
        utilisateurService = new UtilisateurService();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String identifiant = request.getParameter("identifiant");
        String motDePasse = request.getParameter("password");
        String role = request.getParameter("role");

        Utilisateur utilisateur = utilisateurService.authentifier(identifiant, motDePasse, role);

        if(utilisateur != null){
            HttpSession session = request.getSession();
            session.setAttribute("utilisateur", utilisateur);
            session.setAttribute("role", utilisateur.getRole());

            if("Chef".equalsIgnoreCase(utilisateur.getRole())){
                response.sendRedirect("DashboardChefServlet");
            } else if ("gestionnaire".equalsIgnoreCase(utilisateur.getRole())){
                    response.sendRedirect("DashboardManagerServlet");
            }
            else {
                response.sendRedirect("Acceuil.jsp");
            }

        }
        else {
            request.setAttribute("error","Identifiant ou mot de passe incorrect");
            String page = "chef".equalsIgnoreCase(role) ? "loginChef.jsp" : "loginManager.jsp";
            request.getRequestDispatcher(page).forward(request, response);
        }




    }
}
