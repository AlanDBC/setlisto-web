package com.setlisto.web.filter;

import java.io.IOException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.setlisto.model.Cliente;
import com.setlisto.web.utils.AppConstants.ParamNames;
import com.setlisto.web.utils.AppConstants.Views;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Filtro de autenticación para la parte privada
 */
public class AuthenticationFilter extends HttpFilter {

    private static final Logger logger = LogManager.getLogger(AuthenticationFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Usamos getSession(false) para evitar crear una sesión innecesaria si no existe
        Object usuario = null;
        if (httpRequest.getSession(false) != null) {
            usuario = httpRequest.getSession(false).getAttribute(ParamNames.LOGGED);
        }

        if (usuario instanceof Cliente) {
            // Usuario autenticado: continuar hacia el recurso solicitado
            chain.doFilter(request, response);
        } else {
            // Usuario no autenticado: redirigir al formulario de login
            if (usuario != null) {
                logger.warn("La sesión contiene un usuario con un tipo inesperado: {}", usuario.getClass().getName());
            }
            httpResponse.sendRedirect(httpRequest.getContextPath() + Views.USUARIO_LOGIN);
        }
    }
}
