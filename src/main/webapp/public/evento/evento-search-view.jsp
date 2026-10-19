<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Setlisto - Explorar Eventos</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/evento-search-view-style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<!-- Iconos de Material Design -->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
</head>
<body>

	<!-- Header Compartido (cliente-header.jsp) -->
	<%@ include file="/public/cliente/cliente-header.jsp"%>

	<div class="main-container">

		<!-- Panel de Filtros Lateral Desacoplado -->
		<%@ include file="/public/evento/evento-search-sidebar.jsp"%>

		<main class="content-area">
			<div class="content-header">
				<div>
					<h1 class="page-title">Eventos musicales</h1>
					<!-- Mostrar el número total de resultados real -->
					<span class="results-count">${resultados.total} resultados</span>
				</div>

				<div class="sort-dropdown">
					<span>Fecha: próximos</span> <span class="material-icons">expand_more</span>
				</div>
			</div>

			<div class="events-grid">
				<c:choose>
					<c:when test="${not empty resultados.page}">
						<c:forEach var="evento" items="${resultados.page}">
							<article class="event-card">
								<c:set var="bgImage"
									value="${not empty evento.rutaImagenPlano ? pageContext.request.contextPath.concat('/img/').concat(evento.rutaImagenPlano) : pageContext.request.contextPath.concat('/img/placeholder-event.jpg')}" />

								<div class="card-image"
									style="background-image: url('${bgImage}');">
									<span class="event-badge">${evento.tipoNombre}</span>
								</div>

								<div class="card-body">
									<h3 class="event-title">${evento.nombre}</h3>

									<div class="event-details">
										<div class="detail-row">
											<span class="material-icons">place</span>
											${evento.ciudadNombre}, ${evento.lugarNombre}
										</div>

										<div class="detail-row">
											<span class="material-icons">music_note</span>
											${evento.nombresGeneros}
											<c:if test="${not empty evento.nombresSubgeneros}">
                        (${evento.nombresSubgeneros})
                    </c:if>
										</div>

										<!-- Fecha formateada directamente desde el DTO -->
										<div class="detail-row">
											<span class="material-icons">schedule</span>
											${evento.fechaInicioFormateada}
										</div>

										<div class="detail-row">
											<span class="material-icons">mic</span>
											${evento.nombresArtistas}
										</div>
									</div>

									<div class="rating">
										<span class="stars">★★★★<span class="star-empty">★</span></span>
										<span class="rating-text">4.4 (5)</span>
									</div>

									<div class="card-footer">
										<span class="price">Ver disponibilidad</span> <a
											href="${pageContext.request.contextPath}/evento?action=detail&id=${evento.id}"
											class="btn-primary-small"> Ver más <span
											class="material-icons">arrow_forward</span>
										</a>
									</div>
								</div>
							</article>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<!-- Mensaje cuando no hay resultados para los filtros -->
						<div class="no-results"
							style="grid-column: 1/-1; text-align: center; padding: 40px;">
							<span class="material-icons"
								style="font-size: 48px; color: var(--text-muted);">search_off</span>
							<h3 style="margin-top: 16px; color: var(--text-main);">No
								encontramos eventos</h3>
							<p style="color: var(--text-muted); margin-top: 8px;">Intenta
								ajustar tus filtros de búsqueda, probar otros géneros o ampliar
								el rango de precio.</p>

							<!-- Botón de acción para vaciar filtros -->
							<button type="button" id="btn-reset-filters"
								class="btn-primary-small"
								style="margin-top: 20px; cursor: pointer; display: inline-flex; align-items: center; gap: 6px;">
								<span class="material-icons" style="font-size: 18px;">restart_alt</span>
								Limpiar filtros
							</button>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</main>
	</div>
	<script src="${pageContext.request.contextPath}/assets/js/filtros-sidebar.js"></script>
</body>
</html>