package com.setlisto.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.setlisto.criteria.EventoMusicalCriteria;
import com.setlisto.model.Ciudad;
import com.setlisto.model.EventoMusicalDTO;
import com.setlisto.model.GeneroMusical;
import com.setlisto.model.Pais;
import com.setlisto.model.Region;
import com.setlisto.model.Results;
import com.setlisto.model.SubGeneroMusicalDTO;
import com.setlisto.model.SubTipoEventoDTO;
import com.setlisto.model.TipoEvento;
import com.setlisto.service.EventoMusicalService;
import com.setlisto.service.FiltroService;
import com.setlisto.service.ServiceException;
import com.setlisto.service.impl.EventoMusicalServiceImpl;
import com.setlisto.service.impl.FiltroServiceImpl;
import com.setlisto.utils.AppConstants.Actions;
import com.setlisto.utils.AppConstants.Views;

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

	private static final Logger logger = LogManager.getLogger(EventoMusicalServlet.class.getName());

	private EventoMusicalService eventoMusicalService = null;
	private FiltroService filtroService = null;

	public EventoMusicalServlet() {
		eventoMusicalService = new EventoMusicalServiceImpl();
		filtroService = new FiltroServiceImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action == null) {
			action = "";
		}

		switch (action.toLowerCase()) {

		case Actions.SEARCH:
			try {
				// 1. Cargar las jerarquías desde la base de datos
				Map<GeneroMusical, List<SubGeneroMusicalDTO>> mapaGeneros = filtroService.obtenerGenerosJerarquicos();
				Map<TipoEvento, List<SubTipoEventoDTO>> mapaTipos = filtroService.obtenerTiposEventoJerarquicos();
				Map<Pais, Map<Region, List<Ciudad>>> mapaUbicaciones = filtroService.obtenerUbicacionesJerarquicas();

				// 2. Pasar las estructuras al request para la vista JSP
				request.setAttribute("mapaGeneros", mapaGeneros);
				request.setAttribute("mapaTipos", mapaTipos);
				request.setAttribute("mapaUbicaciones", mapaUbicaciones);

				EventoMusicalCriteria criteria = new EventoMusicalCriteria();

				// Géneros Musicales (Padre)
				String[] generosSeleccionados = request.getParameterValues("genre");
				if (generosSeleccionados != null && generosSeleccionados.length > 0) {
					List<Long> generoIds = Arrays.stream(generosSeleccionados)
							.map(Long::valueOf)
							.collect(Collectors.toList());
					criteria.setGenerosMusicalesIds(generoIds); // Asume que creaste este método en el Criteria
				}

				// Tipos de Evento (Padre)
				String[] tiposSeleccionados = request.getParameterValues("eventType");
				if (tiposSeleccionados != null && tiposSeleccionados.length > 0) {
					List<Long> tipoIds = Arrays.stream(tiposSeleccionados)
							.map(Long::valueOf)
							.collect(Collectors.toList());
					criteria.setTiposEventosIds(tipoIds); // Asume que creaste este método en el Criteria
				}

				// Países
				String[] paisesSeleccionados = request.getParameterValues("country");
				if (paisesSeleccionados != null && paisesSeleccionados.length > 0) {
					List<Long> paisIds = Arrays.stream(paisesSeleccionados)
							.map(Long::valueOf)
							.collect(Collectors.toList());
					criteria.setPaisesIds(paisIds); // Asume que creaste este método en el Criteria
				}

				// Regiones
				String[] regionesSeleccionadas = request.getParameterValues("region");
				if (regionesSeleccionadas != null && regionesSeleccionadas.length > 0) {
					List<Long> regionIds = Arrays.stream(regionesSeleccionadas)
							.map(Long::valueOf)
							.collect(Collectors.toList());
					criteria.setRegionesIds(regionIds); // Asume que creaste este método en el Criteria
				}

				// Ciudades
				String[] ciudadesSeleccionadas = request.getParameterValues("city");
				if (ciudadesSeleccionadas != null && ciudadesSeleccionadas.length > 0) {
					List<Long> ciudadIds = Arrays.stream(ciudadesSeleccionadas)
							.map(Long::valueOf)
							.collect(Collectors.toList());
					criteria.setCiudadesIds(ciudadIds); // Asume que creaste este método en el Criteria
				}

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

				// Captura de Listas de Checkboxes (Subgéneros, Subtipos, Ciudades)
				String[] subgenerosSeleccionados = request.getParameterValues("subgenre");
				if (subgenerosSeleccionados != null && subgenerosSeleccionados.length > 0) {
					List<Long> subgeneroIds = Arrays.stream(subgenerosSeleccionados)
							.map(Long::valueOf)
							.collect(Collectors.toList());
					criteria.setSubGenerosMusicalesIds(subgeneroIds);
				}

				String[] subtiposSeleccionados = request.getParameterValues("sessionType");
				if (subtiposSeleccionados != null && subtiposSeleccionados.length > 0) {
					List<Long> subtipoIds = Arrays.stream(subtiposSeleccionados)
							.map(Long::valueOf)
							.collect(Collectors.toList());
					criteria.setSubTiposEventosIds(subtipoIds);
				}

				// 3. Ejecutar la búsqueda paginada mediante el servicio
				Results<EventoMusicalDTO> resultados = eventoMusicalService.findByCriteria(criteria, 1, 10);
				request.setAttribute("resultados", resultados);

				// 4. Redirigir a la vista
				request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);

			} catch (ServiceException e) {
				logger.error("Error al ejecutar la búsqueda de eventos: {}", e.getMessage());
				request.setAttribute("error", "No se pudieron obtener los eventos.");
				request.getRequestDispatcher(Views.EVENTO_SEARCH).forward(request, response);
			}
			break;

		case Actions.DETAIL:
			break;
			
		case Actions.REGISTER:
				
			break;

		default:
			response.sendRedirect(request.getContextPath() + Views.EVENTO_SEARCH);
			break;

		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
