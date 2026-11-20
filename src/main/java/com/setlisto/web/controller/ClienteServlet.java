package com.setlisto.web.controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;
import java.util.Locale;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.setlisto.model.Cliente;
import com.setlisto.model.ContentData;
import com.setlisto.model.ContentException;
import com.setlisto.model.ContentMetadata;
import com.setlisto.service.ClienteService;
import com.setlisto.service.ContentService;
import com.setlisto.service.ServiceException;
import com.setlisto.service.impl.ClienteServiceImpl;
import com.setlisto.service.impl.ContentServiceImpl;
import com.setlisto.web.utils.AppConstants.Actions;
import com.setlisto.web.utils.AppConstants.ParamNames;
import com.setlisto.web.utils.AppConstants.Routes;
import com.setlisto.web.utils.AppConstants.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Servlet implementation class UserServlet
 */
@WebServlet("/cliente")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ClienteServlet extends HttpServlet {

	private static final Logger logger = LogManager.getLogger(ClienteServlet.class);

	private final ClienteService clienteService;
	private final ContentService contentService;

	public ClienteServlet() {
		super();
		clienteService = new ClienteServiceImpl();
		contentService = new ContentServiceImpl();
	}

	// senRedirect = request.getContextPath() + View...
	// forward = View... Ya tiene el contexto del path
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action == null) {
			action = "";
		}
		switch (action.toLowerCase(Locale.ROOT)) {

		case Actions.GO_LOGIN:
			response.sendRedirect(request.getContextPath());
			break;

		case Actions.LOGIN:
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			try {
				Cliente cliente = clienteService.login(email, password);
				HttpSession previousSession = request.getSession(false);
				if (previousSession != null) {
					previousSession.invalidate();
				}
				request.getSession().setAttribute(ParamNames.LOGGED, cliente);
				// Que pase por el controlador para poblar datos de la sidebar
				response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);
			} catch (ServiceException se) {
			    logger.warn("Intento de inicio de sesión fallido.");
			    request.setAttribute("error", "Correo o contraseña incorrectos.");
			    request.getRequestDispatcher(Views.USUARIO_LOGIN).forward(request, response);
			}
			break;

		case Actions.LOGOUT:
			HttpSession session = request.getSession(false);
			if (session != null) {
			    logger.info("Cerrando sesión de cliente.");
			    session.invalidate();
			}
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
				Cliente registrado = clienteService.register(nuevoCliente); //

				// La foto es opcional: si falla su almacenamiento, el alta sigue siendo válida.
				try {
					saveProfileImage(request.getPart("imagen_perfil"), registrado);
				} catch (Exception e) {
					logger.warn("No se pudo guardar la imagen de perfil del cliente {}", registrado.getId(), e);
				}

				// 5. Iniciar sesión automáticamente tras el registro o redirigir
				request.getSession().setAttribute(ParamNames.LOGGED, registrado);

				response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);
			} catch (ServiceException se) {
				if (se.getCause() == null) {
					request.setAttribute("error", se.getMessage());
				} else {
					logger.error("No se pudo completar el registro del cliente.", se);
					request.setAttribute("error", "No se pudo completar el registro. Inténtalo de nuevo.");
				}
				request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
			}
			break;

		case Actions.SEARCH:
			response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);
			break;

		case Actions.GET_PROFILE:
			request.getRequestDispatcher(Views.CLIENTE_PROFILE).forward(request, response);
			break;

		// por ahora traera y mostrara la imagen de perfil
		case Actions.GET_IMAGE:
			HttpSession currentSession = request.getSession(false);
			Object usuario = currentSession == null ? null : currentSession.getAttribute(ParamNames.LOGGED);

			if (!(usuario instanceof Cliente logueado)) {
				response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
				break;
			}

			ContentMetadata cm = new ContentMetadata();
			cm.setEntityType("cliente");
			cm.setEntityId(logueado.getId().toString());
			cm.setResourceId("avatar");
			cm.setResourceName("perfil");
			cm.setFormat(".jpg");

			try {
				ContentData image = contentService.getContent(cm);

				response.setContentType("image/jpeg");

				response.getOutputStream().write(image.getRaw());
				response.getOutputStream().flush();
			} catch (ContentException ce) {
				// Enviar error 404 si el cliente no tiene foto subida, en vez de romper la
				// página
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
			}
			break;

		case Actions.UPDATE:
			// traer todos los datos de la vista
			// validar que no esten vacios los que antes tenian datos
			response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED);
			break;

		default:
			response.sendRedirect(request.getContextPath());
			break;
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

	private void saveProfileImage(Part filePart, Cliente cliente) throws IOException, ContentException {
		if (filePart == null || filePart.getSize() == 0) {
			return;
		}

		String submittedFileName = filePart.getSubmittedFileName();
		String extension = submittedFileName != null && submittedFileName.contains(".")
				? submittedFileName.substring(submittedFileName.lastIndexOf('.'))
				: "";

		ContentMetadata metadata = new ContentMetadata();
		metadata.setEntityType("cliente");
		metadata.setEntityId(String.valueOf(cliente.getId()));
		metadata.setResourceId("avatar");
		metadata.setResourceName("perfil");
		metadata.setFormat(extension);

		ContentData contentData = new ContentData();
		contentData.setMetadata(metadata);
		try (InputStream input = filePart.getInputStream()) {
			contentData.setRaw(input.readAllBytes());
		}
		contentService.save(contentData);
	}

}
