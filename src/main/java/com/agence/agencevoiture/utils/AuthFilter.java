package com.agence.agencevoiture.utils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter({"/dashboardChef.jsp", "/dashboardManager.jsp"})
public class AuthFilter implements  Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        // Si pas connecté ou utilisateur absent de la session
        if (session == null || session.getAttribute("utilisateur") == null) {
            res.sendRedirect("Acceuil.jsp");
            return;
        }
        // Vérification du rôle pour chaque page
        String role = (String) session.getAttribute("role");
        String uri = req.getRequestURI();

        if (uri.contains("dashboardChef.jsp") && !"CHEF".equalsIgnoreCase(role)) {
            res.sendRedirect("Acceuil.jsp");
        } else if (uri.contains("dashboardManager.jsp") && !"GESTIONNAIRE".equalsIgnoreCase(role)) {
            res.sendRedirect("Acceuil.jsp");
        } else {
            chain.doFilter(request, response); // Laisser passer
        }
    }
}
