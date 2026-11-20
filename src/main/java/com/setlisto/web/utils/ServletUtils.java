package com.setlisto.web.utils;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.function.Consumer;
import java.util.stream.Collectors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import jakarta.servlet.http.HttpServletRequest;

public class ServletUtils {
	
	private static final Logger logger = LogManager.getLogger(ServletUtils.class);

	private ServletUtils() {
	}
	
	/**
	 * Extrae los valores de un grupo de checkboxes del request, los convierte a Long
	 * y los asigna al criteria mediante el setter proporcionado.
	 *
	 * @param request   La petición HTTP con los parámetros.
	 * @param paramName El atributo 'name' de los checkboxes en el JSP (ej. "genre").
	 * @param setter    Referencia al método setter del Criteria (ej. criteria::setGenerosMusicalesIds).
	 */
	public static void asignarIdsSeleccionados(HttpServletRequest request, String paramName, Consumer<List<Long>> setter) {
	    String[] seleccionados = request.getParameterValues(paramName);
	    
	    if (seleccionados != null && seleccionados.length > 0) {
	        List<Long> ids = Arrays.stream(seleccionados)
	                .filter(val -> val != null && !val.isBlank())
	                .map(val -> {
	                    try {
	                        return Long.valueOf(val.trim());
	                    } catch (NumberFormatException e) {
	                        logger.warn("ID inválido '{}' recibido para el filtro '{}'", val, paramName);
	                        return null;
	                    }
	                })
	                .filter(Objects::nonNull)
	                .collect(Collectors.toList());

	        if (!ids.isEmpty()) {
	            setter.accept(ids);
	        }
	}
	}
}
