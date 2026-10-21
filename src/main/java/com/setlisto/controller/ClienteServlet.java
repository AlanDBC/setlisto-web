package com.setlisto.controller;

import java.io.IOException;
import java.sql.Date;

import com.setlisto.model.Cliente;
import com.setlisto.service.ClienteService;
import com.setlisto.service.ServiceException;
import com.setlisto.service.impl.ClienteServiceImpl;
import com.setlisto.utils.AppConstants.Actions;
import com.setlisto.utils.AppConstants.Routes;
import com.setlisto.utils.AppConstants.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UserServlet
 */
@WebServlet("/cliente")
public class ClienteServlet extends HttpServlet {


	private ClienteService clienteService = null;

	public ClienteServlet() {
		super();
		clienteService = new ClienteServiceImpl();
	}

	// senRedirect = request.getContextPath() + View...
	// forward = View...  Ya tiene el contexto del path
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			action = "";
		}
		switch (action.toLowerCase()) {

		case Actions.GO_LOGIN:
			response.sendRedirect(request.getContextPath());
			break;

		case "login":
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			try {
				Cliente cliente = clienteService.login(email, password);
				request.getSession().setAttribute("usuario", cliente);    
				response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);// Que pase por el controlador, para poblar datos de la sidebar 
			} catch (ServiceException se) {
				request.getRequestDispatcher(Views.USUARIO_LOGIN).forward(request, response);
			}
			break;

		case Actions.LOGOUT:
			request.getSession().removeAttribute("usuario");
			response.sendRedirect(request.getContextPath());
			break;

		case Actions.GO_REGISTER:
			response.sendRedirect(request.getContextPath() + Views.USUARIO_REGISTER);
			break;

		case Actions.REGISTER:
			String emailR = request.getParameter("email");
			String name = request.getParameter("name");
			String surname1 = request.getParameter("surname1");
			String birthDateStr = request.getParameter("birth_date");
			String passwordR = request.getParameter("password");
			String confirmPassword = request.getParameter("confirm_password");

			// 1. Validar que las contraseñas coincidan
			if (passwordR == null || !passwordR.equals(confirmPassword)) {
				request.setAttribute("error", "Las contraseñas no coinciden.");
				request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
				return;
			}
			// 2. Construir el objeto Cliente
			Cliente nuevoCliente = new Cliente();
			nuevoCliente.setEmail(emailR);
			nuevoCliente.setNombre(name);
			nuevoCliente.setApellido(surname1);
			nuevoCliente.setContrasena(passwordR);

			if (birthDateStr != null && !birthDateStr.isBlank()) {
				try {
					Date birthDate = Date.valueOf(birthDateStr);
					nuevoCliente.setFechaNacimiento(birthDate);
				} catch (IllegalArgumentException e) {
					request.setAttribute("error", "El formato de la fecha de nacimiento no es válido.");
					request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
					return;
				}
			} else {
				request.setAttribute("error", "La fecha de nacimiento es obligatoria.");
				request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
				return;
			}

			try {
				// 3. Registrar cliente en la capa Service/DAO
				clienteService.register(nuevoCliente); //

				// 4. Iniciar sesión automáticamente tras el registro o redirigir
				request.getSession().setAttribute("usuario", nuevoCliente);

				// Redirigimos al controlador de eventos para que procese la búsqueda y los filtros
				response.sendRedirect(request.getContextPath() + Routes.EVENTO+"?action="+Actions.SEARCH);

			} catch (ServiceException se) {
				// Si el correo ya existe o falla la base de datos
				request.setAttribute("error", se.getMessage());
				request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
			}

			break;

		case Actions.SEARCH:
			response.sendRedirect(request.getContextPath() + Routes.EVENTO+"?action="+Actions.SEARCH);
			break;

		default:
			response.sendRedirect(request.getContextPath() + "/");
			break;
		}
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
