package com.setlisto.filter;

import java.io.IOException;

import com.setlisto.model.Cliente;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Filtro de autenticación para la parte privada
 */
public class AuthenticationFilter extends HttpFilter implements Filter {
       
    public AuthenticationFilter() {
        super();
    }	

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Usamos getSession(false) para evitar crear una sesión innecesaria si no existe
        Cliente cliente = null;
        if (httpRequest.getSession(false) != null) {
            cliente = (Cliente) httpRequest.getSession(false).getAttribute("usuario");
        }
        
        if (cliente != null) {
            // Usuario autenticado: continuar hacia el recurso solicitado
            chain.doFilter(request, response);
        } else {
            // Usuario no autenticado: redirigir al formulario de login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/html/public/login.html");
        }
    }

    @Override
    public void init(FilterConfig fConfig) throws ServletException {
    }
    
    @Override
    public void destroy() {
    }
}