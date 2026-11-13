package com.setlisto.controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;

import com.setlisto.model.Cliente;
import com.setlisto.model.ContentData;
import com.setlisto.model.ContentException;
import com.setlisto.model.ContentMetadata;
import com.setlisto.service.ClienteService;
import com.setlisto.service.ContentService;
import com.setlisto.service.ServiceException;
import com.setlisto.service.impl.ClienteServiceImpl;
import com.setlisto.service.impl.ContentServiceImpl;
import com.setlisto.utils.AppConstants.Actions;
import com.setlisto.utils.AppConstants.ParamNames;
import com.setlisto.utils.AppConstants.Routes;
import com.setlisto.utils.AppConstants.Views;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

	private ClienteService clienteService = null;
	private ContentService contentService = null;

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
		switch (action.toLowerCase()) {

		case Actions.GO_LOGIN:
			response.sendRedirect(request.getContextPath());
			break;

		case Actions.LOGIN:
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			try {
				Cliente cliente = clienteService.login(email, password);
				request.getSession().setAttribute(ParamNames.LOGGED, cliente);
				response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);// Que
																												// pase
																												// por
																												// el
																												// controlador
																												// para
																												// poblar
																												// datos
																												// de la
																												// sidebar
			} catch (ServiceException se) {
				request.getRequestDispatcher(Views.USUARIO_LOGIN).forward(request, response);
			}
			break;

		case Actions.LOGOUT:
			request.getSession().removeAttribute(ParamNames.LOGGED);
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

				// 4. Procesar la imagen adjunta AHORA que el cliente ya existe y tiene un ID
				Part filePart = request.getPart("imagen_perfil");

				if (filePart != null && filePart.getSize() > 0) {
					String submittedFileName = filePart.getSubmittedFileName();
					String extension = submittedFileName.contains(".")
							? submittedFileName.substring(submittedFileName.lastIndexOf("."))
							: "";

					// Preparar metadatos
					ContentMetadata metadata = new ContentMetadata();
					metadata.setEntityType("cliente");
					metadata.setEntityId(String.valueOf(registrado.getId())); // Obtienes el ID recién creado
					metadata.setResourceId("avatar");
					metadata.setFormat(extension); // ej: ".jpg"

					// Extraer los bytes de la imagen
					byte[] rawBytes;
					try (InputStream is = filePart.getInputStream()) {
						rawBytes = is.readAllBytes();
					}

					// Empaquetar y enviar al servicio de contenido
					ContentData contentData = new ContentData();
					contentData.setMetadata(metadata);
					contentData.setRaw(rawBytes);

					// Guarda la imagen en la estructura
					// CMS_BASE_FOLDER/cliente/{id}/avatar/perfil.jpg
					contentService.save(contentData);
				}

				// 5. Iniciar sesión automáticamente tras el registro o redirigir
				request.getSession().setAttribute(ParamNames.LOGGED, registrado);

				response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);
			} catch (ServiceException se) {
				request.setAttribute("error", se.getMessage());
				request.getRequestDispatcher(Views.USUARIO_REGISTER).forward(request, response);
			} catch (Throwable e) {
				// Capturar errores del guardado de contenido
				request.setAttribute("error", "Error guardando la imagen: " + e.getMessage());
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
			// 1. Obtener de la sesión y validar que no sea null
			Cliente logueado = (Cliente) request.getSession().getAttribute(ParamNames.LOGGED);

			if (logueado == null) {
				response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
				break;
			}

			ContentMetadata cm = new ContentMetadata();
			cm.setEntityType("cliente");
			cm.setEntityId(logueado.getId().toString());
			cm.setResourceId("avatar");
			cm.setResourceName("perfil"); // 2. Asignar el nombre que definiste en el registro

			// 3. Nota: Para que sea 100% dinámico, deberías guardar la extensión en la base
			// de datos de tu Cliente.
			// Por ahora, asegúrate de pedir el formato con punto si así lo guardaste:
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
			
			

			break;
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
