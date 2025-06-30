package com.agence.agencevoiture.utils;

import org.apache.logging.log4j.*;
public class MainApp {

    private static final Logger logger = LogManager.getLogger(MainApp.class);

            public static void main(String[] args){
                logger.info("Démarrage de l'apllication");
                logger.warn("Ceci est un avertissement");
                logger.error("Une erreur c'est produite");
            }
}
