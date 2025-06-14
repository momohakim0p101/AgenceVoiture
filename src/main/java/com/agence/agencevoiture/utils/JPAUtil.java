package com.agence.agencevoiture.utils;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtil {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("locationPU");

    public static EntityManagerFactory getEntityManagerFactory() {
        return emf;
    }
}
