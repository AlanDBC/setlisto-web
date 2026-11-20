package com.setlisto.web.controller;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.setlisto.criteria.EventoMusicalCriteria;
import com.setlisto.model.Ciudad;
import com.setlisto.model.ContentData;
import com.setlisto.model.ContentException;
import com.setlisto.model.ContentMetadata;
import com.setlisto.model.EventoMusicalDTO;
import com.setlisto.model.GeneroMusical;
import com.setlisto.model.Pais;
import com.setlisto.model.Region;
import com.setlisto.model.Results;
import com.setlisto.model.SubGeneroMusicalDTO;
import com.setlisto.model.SubTipoEventoDTO;
import com.setlisto.model.TipoEvento;
import com.setlisto.service.ContentService;
import com.setlisto.service.EventoMusicalService;
import com.setlisto.service.FiltroService;
import com.setlisto.service.ServiceException;
import com.setlisto.service.impl.ContentServiceImpl;
import com.setlisto.service.impl.EventoMusicalServiceImpl;
import com.setlisto.service.impl.FiltroServiceImpl;
import com.setlisto.web.utils.AppConstants.Actions;
import com.setlisto.web.utils.AppConstants.Routes;
import com.setlisto.web.utils.AppConstants.Views;
import com.setlisto.web.utils.ServletUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class HelloWorldServlet
 */
@WebServlet("/evento")
public class EventoMusicalServlet extends HttpServlet {

	private static final Logger logger = LogManager.getLogger(EventoMusicalServlet.class);

	private final EventoMusicalService eventoMusicalService;
	private final FiltroService filtroService;
	private final ContentService contentService;

	public EventoMusicalServlet() {
		eventoMusicalService = new EventoMusicalServiceImpl();
		filtroService = new FiltroServiceImpl();
		contentService = new ContentServiceImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action == null) {
			action = "";
		}

		switch (action.toLowerCase(Locale.ROOT)) {

		case Actions.SEARCH:
		    try {
		        // 1. Recuperar las jerarquías precargadas en memoria por AppStartupListener
		        @SuppressWarnings("unchecked")
		        Map<GeneroMusical, List<SubGeneroMusicalDTO>> mapaGeneros =
		                (Map<GeneroMusical, List<SubGeneroMusicalDTO>>) getServletContext().getAttribute("mapaGeneros");

		        @SuppressWarnings("unchecked")
		        Map<TipoEvento, List<SubTipoEventoDTO>> mapaTipos =
		                (Map<TipoEvento, List<SubTipoEventoDTO>>) getServletContext().getAttribute("mapaTipos");

		        @SuppressWarnings("unchecked")
		        Map<Pais, Map<Region, List<Ciudad>>> mapaUbicaciones =
		                (Map<Pais, Map<Region, List<Ciudad>>>) getServletContext().getAttribute("mapaUbicaciones");

		        // Fallback de seguridad: si el Listener no se ejecutó (ej. por configuración en web.xml), se cargan y cachean aquí
		        if (mapaGeneros == null || mapaTipos == null || mapaUbicaciones == null) {
		            logger.warn("Los mapas de filtros no estaban en ServletContext; cargando desde BD...");
		            mapaGeneros = filtroService.obtenerGenerosJerarquicos();
		            mapaTipos = filtroService.obtenerTiposEventoJerarquicos();
		            mapaUbicaciones = filtroService.obtenerUbicacionesJerarquicas();

		            getServletContext().setAttribute("mapaGeneros", mapaGeneros);
		            getServletContext().setAttribute("mapaTipos", mapaTipos);
		            getServletContext().setAttribute("mapaUbicaciones", mapaUbicaciones);
		        }

		        // 2. Pasar las estructuras al request para la vista JSP[cite: 2, 5]
		        request.setAttribute("mapaGeneros", mapaGeneros);
		        request.setAttribute("mapaTipos", mapaTipos);
		        request.setAttribute("mapaUbicaciones", mapaUbicaciones);

		        EventoMusicalCriteria criteria = new EventoMusicalCriteria();

				// Filtros de checkboxes (Padres e Hijos)
				ServletUtils.asignarIdsSeleccionados(request, "genre", criteria::setGenerosMusicalesIds);
				ServletUtils.asignarIdsSeleccionados(request, "subgenre", criteria::setSubGenerosMusicalesIds);
				ServletUtils.asignarIdsSeleccionados(request, "eventType", criteria::setTiposEventosIds);
				ServletUtils.asignarIdsSeleccionados(request, "sessionType", criteria::setSubTiposEventosIds);
				ServletUtils.asignarIdsSeleccionados(request, "country", criteria::setPaisesIds);
				ServletUtils.asignarIdsSeleccionados(request, "region", criteria::setRegionesIds);
				ServletUtils.asignarIdsSeleccionados(request, "city", criteria::setCiudadesIds);

				// Captura de filtro de Búsqueda General (nombre/artista)
				String query = request.getParameter("query");
				if (query != null && !query.isBlank()) {
					criteria.setNombre(query.trim());
				}

				// Captura de Precio Desde
				String precioDesdeStr = request.getParameter("precioDesde");
				if (precioDesdeStr != null && !precioDesdeStr.isBlank()) {
					try {
						criteria.setPrecioDesde(Integer.valueOf(precioDesdeStr));
					} catch (NumberFormatException e) {
						logger.warn("Formato inválido para precioDesde: {}", precioDesdeStr);
					}
				}

				// Captura de Precio Hasta
				String precioHastaStr = request.getParameter("precioHasta");
				if (precioHastaStr != null && !precioHastaStr.isBlank()) {
					try {
						Integer precioHasta = Integer.valueOf(precioHastaStr);

						if (precioHasta < 200) {
							criteria.setPrecioHasta(precioHasta);
						}
					} catch (NumberFormatException e) {
						logger.warn("Formato inválido para precioHasta: {}", precioHastaStr);
					}
				}

				// Captura de Fechas
				String fechaDesdeStr = request.getParameter("fechaDesde");
				String fechaHastaStr = request.getParameter("fechaHasta");

				if (fechaDesdeStr != null && !fechaDesdeStr.isBlank()) {
					try {
						LocalDate fechaDesde = LocalDate.parse(fechaDesdeStr);
						criteria.setFechaInicio(fechaDesde.atStartOfDay());
					} catch (DateTimeParseException e) {
						logger.warn("Formato inválido para fechaDesde: {}", fechaDesdeStr);
					}
				}

				if (fechaHastaStr != null && !fechaHastaStr.isBlank()) {
					try {
						LocalDate fechaHasta = LocalDate.parse(fechaHastaStr);
						criteria.setFechaFin(fechaHasta.atTime(23, 59, 59));
					} catch (DateTimeParseException e) {
						logger.warn("Formato inválido para fechaHasta: {}", fechaHastaStr);
					}
				}

				// 3. Ejecutar la búsqueda paginada mediante el servicio
				Results<EventoMusicalDTO> resultados = eventoMusicalService.findByCriteria(criteria, 1, 10);
				request.setAttribute("resultados", resultados);

				// 4. Redirigir a la vista
				request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);

			} catch (ServiceException e) {
				logger.error("Error al ejecutar la búsqueda de eventos", e);
				request.setAttribute("error", "No se pudieron obtener los eventos.");
				request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);
			}
			break;

		case Actions.DETAIL:
			String idParam = request.getParameter("id");
			if (idParam == null || idParam.isBlank()) {
				logger.warn("Petición de detalle sin parámetro id");
				response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);
				break;
			}
			try {
				Long eventoId = Long.valueOf(idParam.trim());
				EventoMusicalDTO evento = eventoMusicalService.findById(eventoId);
				if (evento == null) {
					logger.warn("No se encontró el evento con id {}", eventoId);
					response.sendError(HttpServletResponse.SC_NOT_FOUND);
					break;
				}
				request.setAttribute("evento", evento);
				request.getRequestDispatcher(Views.EVENTO_DETAIL).forward(request, response);
			} catch (NumberFormatException nfe) {
				logger.warn("ID de evento inválido en detalle: {}", idParam);
				response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);
			} catch (ServiceException se) {
				logger.error("Error de servicio al cargar detalle del evento {}: {}", idParam, se.getMessage(), se);
				request.setAttribute("error", "No se pudo cargar el detalle del evento.");
				request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);
			}
			break;

		case Actions.CREATE:
			response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED);
			break;

		case Actions.GET_SMALL_IMAGE:
			ContentMetadata cm = new ContentMetadata();
			cm.setEntityType("evento");
			cm.setEntityId(request.getParameter("id"));
			cm.setResourceId("small_image");
			cm.setFormat(".jpg");

			try {
				ContentData image = contentService.getContent(cm);
				response.setContentType("image/jpeg");
				response.getOutputStream().write(image.getRaw());
				response.getOutputStream().flush();
			} catch (ContentException ce) {
				// Al no existir en disco, se sirve la imagen estática por defecto desde webapp
				try (InputStream defaultImgStream = getServletContext()
						.getResourceAsStream("/assets/img/default-event.jpg")) {
					if (defaultImgStream != null) {
						response.setContentType("image/jpeg");
						defaultImgStream.transferTo(response.getOutputStream());
						response.getOutputStream().flush();
					} else {
						logger.warn("No se encontró la imagen por defecto en /assets/img/default-event.jpg");
						response.sendError(HttpServletResponse.SC_NOT_FOUND);
					}
				}
			}
			break;
		default:
			response.sendRedirect(request.getContextPath() + Routes.EVENTO + "?action=" + Actions.SEARCH);
			break;
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
