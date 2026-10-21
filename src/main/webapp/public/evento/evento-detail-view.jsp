<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Detalle de Evento - Setlisto</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/evento-detail-style.css">
<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
<!-- FontAwesome para iconos -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

	<!-- NAVBAR (Se puede abstraer a un include en el JSP) -->
	<%@ include file="/public/cliente/cliente-header.jsp"%>

	<!-- HERO SECTION -->
	<header class="hero-section">
		<!-- Reemplazar href con AppConstants.Routes.EVENTO + "?action=" + AppConstants.Actions.SEARCH -->
		<a href="#" class="btn-back"><i class="fa-solid fa-arrow-left"></i>
			Volver a eventos</a>

		<div class="hero-content">
			<!-- Datos dinámicos: ${evento.tipoEvento.nombre}, ${evento.nombre}, ${evento.artista.nombre} -->
			<span class="badge">Concierto</span>
			<h1 class="hero-title">Megadeth World Tour</h1>
			<h2 class="hero-subtitle">Megadeth</h2>
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
						class="info-card-label">Lugar</span> <span class="info-card-value">Medellín,
						Colombia</span>
					<!-- ${evento.ciudad.nombre}, ${evento.ciudad.pais.nombre} -->
				</div>
				<div class="info-card">
					<i class="fa-regular fa-calendar" style="color: #55aaff;"></i> <span
						class="info-card-label">Fecha</span> <span class="info-card-value">5
						Feb 2025</span>
					<!-- fmt:formatDate -->
				</div>
				<div class="info-card">
					<i class="fa-regular fa-clock" style="color: #aaaaaa;"></i> <span
						class="info-card-label">Horario</span> <span
						class="info-card-value">16:30 – 22:00</span>
				</div>
				<div class="info-card">
					<i class="fa-solid fa-music" style="color: #9955ff;"></i> <span
						class="info-card-label">Género</span> <span
						class="info-card-value">Rock (Heavy Metal)</span>
					<!-- ${evento.genero.nombre} -->
				</div>
			</div>

			<!-- Sobre el evento -->
			<section class="about-section">
				<h3 class="section-title">Sobre el evento</h3>
				<p class="about-text">La legendaria banda de thrash metal
					regresa a Colombia con su espectacular World Tour. Más de dos horas
					de metal puro con Dave Mustaine al frente, repasando sus grandes
					éxitos y material de su último álbum. Un show de producción
					monumental con pirotecnia, luces y el sonido que hizo historia.</p>
			</section>

			<!-- Recinto -->
			<section class="venue-section">
				<div class="venue-card">
					<img
						src="https://images.unsplash.com/photo-1574623452334-1e0ac2b5c7ad?q=80&w=200&auto=format&fit=crop"
						alt="Estadio" class="venue-img">
					<div class="venue-details">
						<span class="info-card-label">Recinto</span>
						<h4>Estadio Atanasio Girardot</h4>
						<p>Antioquia, Colombia</p>
					</div>
				</div>
			</section>

			<!-- Reseñas -->
			<section class="reviews-section">
				<div class="reviews-header">
					<h3 class="section-title" style="margin: 0;">Reseñas</h3>
					<div class="overall-rating">
						<div class="stars-gold">
							<i class="fa-solid fa-star"></i> <i class="fa-solid fa-star"></i>
							<i class="fa-solid fa-star"></i> <i class="fa-solid fa-star"></i>
							<i class="fa-solid fa-star-half-stroke"></i>
						</div>
						<span class="rating-number">4.4</span> <span class="rating-count">(5
							reseñas)</span>
					</div>
				</div>

				<!-- Barras de progreso de reseñas -->
				<div class="rating-bars">
					<div class="rating-bar-row">
						<span>5 <i class="fa-solid fa-star"
							style="color: var(--accent-gold); font-size: 10px;"></i></span>
						<div class="bar-bg">
							<div class="bar-fill" style="width: 60%;"></div>
						</div>
						<span>3</span>
					</div>
					<div class="rating-bar-row">
						<span>4 <i class="fa-solid fa-star"
							style="color: var(--accent-gold); font-size: 10px;"></i></span>
						<div class="bar-bg">
							<div class="bar-fill" style="width: 20%;"></div>
						</div>
						<span>1</span>
					</div>
					<div class="rating-bar-row">
						<span>3 <i class="fa-solid fa-star"
							style="color: var(--accent-gold); font-size: 10px;"></i></span>
						<div class="bar-bg">
							<div class="bar-fill" style="width: 20%;"></div>
						</div>
						<span>1</span>
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

				<%-- Lista de reseñas (Futuro <c:forEach items="${evento.resenas}" var="resena">) --%>
				<article class="review-card">
					<div class="review-header">
						<div class="review-avatar">C</div>
						<div class="review-meta">
							<h5>Carlos M.</h5>
							<span>
								<div class="stars-gold" style="font-size: 10px;">
									<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i
										class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i
										class="fa-solid fa-star"></i>
								</div> 8 Feb 2025
							</span>
						</div>
					</div>
					<p class="review-text">Absolutamente épico. Megadeth superó
						todas mis expectativas. El sonido en el estadio fue perfecto y el
						setlist incluyó todos los clásicos. Sin duda el mejor concierto al
						que he asistido.</p>
					<div class="review-actions">
						<span>¿Útil?</span>
						<button class="btn-helpful">
							<i class="fa-solid fa-thumbs-up"></i> 42
						</button>
					</div>
				</article>

				<article class="review-card">
					<div class="review-header">
						<div class="review-avatar">L</div>
						<div class="review-meta">
							<h5>Laura P.</h5>
							<span>
								<div class="stars-gold" style="font-size: 10px;">
									<i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i
										class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i
										class="fa-solid fa-star-half-stroke"></i>
								</div> 7 Feb 2025
							</span>
						</div>
					</div>
					<p class="review-text">Dave Mustaine en su mejor momento. La
						producción del espectáculo fue impresionante, con pantallas
						gigantes y pirotecnia espectacular. ¡Volveré sin dudarlo!</p>
					<div class="review-actions">
						<span>¿Útil?</span>
						<button class="btn-helpful">
							<i class="fa-solid fa-thumbs-up"></i> 28
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
						43€ <span>200.000 COP</span>
						<!-- ${evento.precioDesde} -->
					</div>
				</div>

				<ul class="event-summary-list">
					<li><i class="fa-solid fa-microphone"></i> Artista: Megadeth</li>
					<li><i class="fa-solid fa-map-pin"></i> Estadio Atanasio
						Girardot</li>
					<li><i class="fa-regular fa-calendar"></i> 5 Feb 2025</li>
					<li><i class="fa-regular fa-clock"></i> 16:30 – 22:00</li>
				</ul>

				<div class="zones-section">
					<div class="zones-title">
						<i class="fa-solid fa-ticket"></i> Zonas disponibles
					</div>

					<%-- Futuro <c:forEach items="${evento.zonas}" var="zona"> --%> >
					<div class="zone-item">
						<span class="zone-name"><span class="dot vip"></span> VIP</span> <span
							class="zone-price">90€</span>
					</div>
					<div class="zone-item">
						<span class="zone-name"><span class="dot pista"></span>
							Pista</span> <span class="zone-price">55€</span>
					</div>
					<div class="zone-item">
						<span class="zone-name"><span class="dot general"></span>
							General</span> <span class="zone-price">30€</span>
					</div>
				</div>

				<!-- Formulario futuro para enviar a ReservaServlet -->
				<button class="btn-primary">
					<i class="fa-solid fa-ticket-simple"></i> Reservar asiento
				</button>
				<p class="cancel-policy">Cancelación gratuita hasta 48h antes</p>

			</div>
		</aside>

	</main>
</body>
</html>