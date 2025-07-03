package com.agence.agencevoiture.controller;

import com.agence.agencevoiture.entity.Location;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/GenererPDFLocation")
public class GenererPDFLocationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Location location = (Location) request.getSession().getAttribute("location");
        if (location == null) {
            response.sendRedirect("NouvelleLocationServlet");
            return;
        }

        // Construction HTML via helper
        String html = PDFGenerateurHelper.buildLocationHTML(location, request);

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=location_automanager.pdf");

        try (OutputStream os = response.getOutputStream()) {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            builder.withHtmlContent(html, request.getRequestURL().toString());
            builder.toStream(os);
            builder.run();
        } catch (Exception e) {
            throw new ServletException("Erreur PDF", e);
        }
    }
}
