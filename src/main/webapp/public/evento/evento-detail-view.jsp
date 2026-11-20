<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<%-- Separamos fecha y hora desde fechaInicioFormateada ("d MMM yyyy - HH:mm") --%>
<c:set var="fechaHoraRaw" value="${evento.fechaInicioFormateada}" />
<c:choose>
	<c:when test="${fn:contains(fechaHoraRaw, ' - ')}">
		<c:set var="fechaEvento"
			value="${fn:substringBefore(fechaHoraRaw, ' - ')}" />
		<c:set var="horaEvento"
			value="${fn:substringAfter(fechaHoraRaw, ' - ')}" />
	</c:when>
	<c:otherwise>
		<c:set var="fechaEvento"
			value="${not empty fechaHoraRaw ? fechaHoraRaw : 'Por confirmar'}" />
		<c:set var="horaEvento" value="Por confirmar" />
	</c:otherwise>
</c:choose>

<%-- Calculamos el precio mínimo si el evento tiene zonas cargadas --%>
<c:set var="precioMinimo" value="" />
<c:if test="${not empty evento.zonas}">
	<c:forEach var="z" items="${evento.zonas}">
		<c:if
			test="${not empty z.precioBase and (empty precioMinimo or z.precioBase < precioMinimo)}">
			<c:set var="precioMinimo" value="${z.precioBase}" />
		</c:if>
	</c:forEach>
</c:if>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out
		value="${not empty evento.nombre ? evento.nombre : 'Detalle de Evento'}" />
	- Setlisto</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/evento-detail-style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

	<%@ include file="/public/cliente/cliente-header.jsp"%>

	<!-- HERO SECTION (Imagen dinámica del evento con fallback al fondo por defecto) -->
	<header class="hero-section"
		style="background-image: linear-gradient(to top, var(--bg-main) 0%, rgba(15, 15, 17, 0.4) 100%), url('${pageContext.request.contextPath}/evento?action=getsmallimage&id=${evento.id}'), url('https://images.unsplash.com/photo-1540039155732-d674d6e300ce?q=80&w=2000&auto=format&fit=crop');">

		<!-- Botón volver -->
		<a href="${pageContext.request.contextPath}/evento?action=search"
			class="btn-back"> <i class="fa-solid fa-arrow-left"></i> Volver a
			eventos
		</a>

		<!-- Cabecera Hero -->
		<div class="hero-content">
			<c:if test="${not empty evento.tipoNombre}">
				<span class="badge"><c:out value="${evento.tipoNombre}" /></span>
			</c:if>
			<h1 class="hero-title">
				<c:out value="${evento.nombre}" />
			</h1>
			<h2 class="hero-subtitle">
				<c:out
					value="${not empty evento.nombresArtistas ? evento.nombresArtistas : 'Artista por confirmar'}" />
			</h2>
		</div>

	</header>

	<!-- MAIN CONTENT -->
	<main class="main-container">

		<!-- COLUMNA IZQUIERDA: DETALLES -->
		<div class="event-details">

			<!-- Grid de 4 tarjetas de información rápida -->
			<div class="quick-info-grid">
				<div class="info-card">
					<i class="fa-solid fa-map-pin" style="color: #ff5599;"></i> <span
						class="info-card-label">Lugar</span> <span class="info-card-value">
						<c:out
							value="${not empty evento.ciudadNombre ? evento.ciudadNombre : 'Por confirmar'}" />
					</span>
				</div>
				<div class="info-card">
					<i class="fa-regular fa-calendar" style="color: #55aaff;"></i> <span
						class="info-card-label">Fecha</span> <span class="info-card-value">
						<c:out value="${fechaEvento}" />
					</span>
				</div>
				<div class="info-card">
					<i class="fa-regular fa-clock" style="color: #aaaaaa;"></i> <span
						class="info-card-label">Horario</span> <span
						class="info-card-value"> <c:out value="${horaEvento}" />
					</span>
				</div>
				<div class="info-card">
					<i class="fa-solid fa-music" style="color: #9955ff;"></i> <span
						class="info-card-label">Género</span> <span
						class="info-card-value"> <c:out
							value="${not empty evento.nombresGeneros ? evento.nombresGeneros : 'Varios'}" />
						<c:if test="${not empty evento.nombresSubgeneros}">
							(<c:out value="${evento.nombresSubgeneros}" />)
						</c:if>
					</span>
				</div>
			</div>

			<!-- Sobre el evento -->
			<section class="about-section">
				<h3 class="section-title">Sobre el evento</h3>
				<p class="about-text">
					<c:choose>
						<c:when test="${not empty evento.descripcion}">
							<c:out value="${evento.descripcion}" />
						</c:when>
						<c:otherwise>
							Disfruta en directo de <c:out value="${evento.nombre}" />
							<c:if test="${not empty evento.nombresArtistas}">
								con <c:out value="${evento.nombresArtistas}" />
							</c:if>
							en <c:out
								value="${not empty evento.lugarNombre ? evento.lugarNombre : 'un recinto exclusivo'}" />.
						</c:otherwise>
					</c:choose>
				</p>
			</section>

			<!-- Recinto -->
			<section class="venue-section">
				<div class="venue-card">
					<img
						src="${pageContext.request.contextPath}/assets/img/recinto.png"
						alt="Recinto" class="venue-img">
					<div class="venue-details">
						<span class="info-card-label">Recinto</span>
						<h4>
							<c:out
								value="${not empty evento.lugarNombre ? evento.lugarNombre : 'Recinto por confirmar'}" />
						</h4>
						<p>
							<c:out value="${evento.lugarDireccion}" />
							<c:if
								test="${not empty evento.lugarDireccion and not empty evento.ciudadNombre}"> · </c:if>
							<c:out value="${evento.ciudadNombre}" />
						</p>
					</div>
				</div>
			</section>

			<!-- Reseñas (Maquetación del prototipo hasta conectar ResenaService en el DTO) -->
			<section class="reviews-section">
				<div class="reviews-header">
					<h3 class="section-title" style="margin: 0;">Reseñas</h3>
					<div class="overall-rating">
						<div class="stars-gold">
							<i class="fa-solid fa-star"></i> <i class="fa-solid fa-star"></i>
							<i class="fa-solid fa-star"></i> <i class="fa-solid fa-star"></i>
							<i class="fa-solid fa-star-half-stroke"></i>
						</div>
						<span class="rating-number">4.5</span> <span class="rating-count">(2
							reseñas)</span>
					</div>
				</div>

				<!-- Barras de progreso de reseñas -->
				<div class="rating-bars">
					<div class="rating-bar-row">
						<span>5 <i class="fa-solid fa-star"
							style="color: var(--accent-gold); font-size: 10px;"></i></span>
						<div class="bar-bg">
							<div class="bar-fill" style="width: 50%;"></div>
						</div>
						<span>1</span>
					</div>
					<div class="rating-bar-row">
						<span>4 <i class="fa-solid fa-star"
							style="color: var(--accent-gold); font-size: 10px;"></i></span>
						<div class="bar-bg">
							<div class="bar-fill" style="width: 50%;"></div>
						</div>
						<span>1</span>
					</div>
					<div class="rating-bar-row">
						<span>3 <i class="fa-solid fa-star"
							style="color: var(--accent-gold); font-size: 10px;"></i></span>
						<div class="bar-bg">
							<div class="bar-fill" style="width: 0%;"></div>
						</div>
						<span>0</span>
					</div>
					<div class="rating-bar-row">
						<span>2 <i class="fa-solid fa-star"
							style="color: var(--accent-gold); font-size: 10px;"></i></span>
						<div class="bar-bg">
							<div class="bar-fill" style="width: 0%;"></div>
						</div>
						<span>0</span>
					</div>
					<div class="rating-bar-row">
						<span>1 <i class="fa-solid fa-star"
							style="color: var(--accent-gold); font-size: 10px;"></i></span>
						<div class="bar-bg">
							<div class="bar-fill" style="width: 0%;"></div>
						</div>
						<span>0</span>
					</div>
				</div>

				<article class="review-card">
					<div class="review-header">
						<div class="review-avatar">M</div>
						<div class="review-meta">
							<h5>Marta G.</h5>
							<span>
								<div class="stars-gold" style="font-size: 10px;">
									<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i
										class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i
										class="fa-solid fa-star"></i>
								</div> Reciente
							</span>
						</div>
					</div>
					<p class="review-text">El sonido en el recinto fue espectacular
						y la organización impecable. Sin duda repetiría.</p>
					<div class="review-actions">
						<span>¿Útil?</span>
						<button type="button" class="btn-helpful">
							<i class="fa-solid fa-thumbs-up"></i> 31
						</button>
					</div>
				</article>
			</section>
		</div>

		<!-- COLUMNA DERECHA: TARJETA DE RESERVA (STICKY) -->
		<aside class="sidebar">
			<div class="booking-card">

				<div class="price-section">
					<div class="price-label">Precio desde</div>
					<div class="price-amount">
						<c:choose>
							<c:when test="${not empty precioMinimo}">
								<fmt:formatNumber value="${precioMinimo}" maxFractionDigits="0" />€
							</c:when>
							<c:otherwise>
								<span
									style="font-size: 20px; color: var(--accent-gold); font-weight: 700;">Ver
									zonas</span>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<ul class="event-summary-list">
					<li><i class="fa-solid fa-microphone"></i> Artista: <c:out
							value="${not empty evento.nombresArtistas ? evento.nombresArtistas : 'Por confirmar'}" />
					</li>
					<li><i class="fa-solid fa-map-pin"></i> <c:out
							value="${not empty evento.lugarNombre ? evento.lugarNombre : evento.ciudadNombre}" />
					</li>
					<li><i class="fa-regular fa-calendar"></i> <c:out
							value="${fechaEvento}" /></li>
					<li><i class="fa-regular fa-clock"></i> <c:out
							value="${horaEvento}" /></li>
				</ul>

				<div class="zones-section">
					<div class="zones-title">
						<i class="fa-solid fa-ticket"></i> Zonas disponibles
					</div>

					<c:choose>
						<c:when test="${not empty evento.zonas}">
							<c:forEach var="zona" items="${evento.zonas}" varStatus="st">
								<c:set var="dotClass"
									value="${st.index % 3 == 0 ? 'vip' : (st.index % 3 == 1 ? 'pista' : 'general')}" />
								<div class="zone-item">
									<span class="zone-name"> <span class="dot ${dotClass}"></span>
										<c:out value="${zona.nombreSeccion}" />
									</span> <span class="zone-price"> <fmt:formatNumber
											value="${zona.precioBase}" maxFractionDigits="0" />€
									</span>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="zone-item">
								<span class="zone-name" style="color: var(--text-secondary);">Zonas
									disponibles próximamente</span>
							</div>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- Formulario listo para conectar con ReservaServlet -->
				<%-- <form action="${pageContext.request.contextPath}/reserva" method="GET"> --%>
				<form action="#" method="GET">
					<input type="hidden" name="action" value="select"> <input
						type="hidden" name="eventoId" value="${evento.id}">
					<button type="button" class="btn-primary">
						<i class="fa-solid fa-ticket-simple"></i> Reservar asiento
					</button>
				</form>
				<p class="cancel-policy">Cancelación gratuita hasta 48h antes</p>

			</div>
		</aside>

	</main>
</body>
</html>