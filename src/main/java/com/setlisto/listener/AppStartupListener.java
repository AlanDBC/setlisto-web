package com.setlisto.listener;

import org.apache.logging.log4j.LogManager;

import com.setlisto.service.FiltroService;
import com.setlisto.service.impl.FiltroServiceImpl;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppStartupListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        FiltroService filtroService = new FiltroServiceImpl();
        ServletContext ctx = sce.getServletContext();
        try {
            ctx.setAttribute("mapaGeneros", filtroService.obtenerGenerosJerarquicos());
            ctx.setAttribute("mapaTipos", filtroService.obtenerTiposEventoJerarquicos());
            ctx.setAttribute("mapaUbicaciones", filtroService.obtenerUbicacionesJerarquicas());
        } catch (Exception e) {
            LogManager.getLogger(AppStartupListener.class).error("Error cargando caché de filtros", e);
        }
    }
}