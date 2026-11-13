<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<header class="top-header">
	<link rel="stylesheet"
		href="${pageContext.request.contextPath}/assets/css/cliente-header-styles.css">
	<!-- Importación del script del header -->
	<script
		src="${pageContext.request.contextPath}/assets/js/dropdown-usuario.js"
		defer></script>

	<div class="header-logo">
		<img
			src="${pageContext.request.contextPath}/assets/img/setlisto-logo-blanco.png"
			alt="Setlisto Logo">
	</div>

	<nav class="header-nav">
		<!-- Validamos si el parámetro action es 'search' para activar la pestaña 'Explorar eventos' -->
		<a href="${pageContext.request.contextPath}/evento?action=search" 
		   class="nav-item ${param.action == 'search' ? 'active' : ''}">Explorar eventos</a> 
		
		<!-- Validamos la acción de reservas (ajusta 'misreservas' al action real de tu servlet) -->
		<a href="#"
		   class="nav-item ${param.action == 'misreservas' ? 'active' : ''}">Mis reservas</a>
	</nav>

	<div class="header-user-container">

		<c:choose>
			<c:when test="${not empty sessionScope.usuario}">

				<div class="header-user" id="userDropdownTrigger">

					<!-- Contenedor con la imagen de perfil -->
					<div class="user-avatar" id="header-avatar-img"
						style="overflow: hidden; padding: 0; background: transparent;">
						<img
							src="${pageContext.request.contextPath}/cliente?action=getimage"
							alt="Avatar"
							style="width: 100%; height: 100%; object-fit: cover; border-radius: inherit;"
							onerror="document.getElementById('header-avatar-img').style.display='none'; document.getElementById('header-avatar-initial').style.display='flex';">
					</div>

					<!-- Contenedor con la inicial (oculto por defecto) -->
					<div class="user-avatar" id="header-avatar-initial"
						style="display: none;">
						<c:out
							value="${fn:toUpperCase(fn:substring(sessionScope.usuario.nombre, 0, 1))}" />
					</div>

					<div class="user-info">
						<span class="user-name"><c:out
								value="${sessionScope.usuario.nombre}" /></span> <span
							class="user-role">Cliente</span>
					</div>
					<span class="material-icons">expand_more</span>
				</div>

				<div class="dropdown-menu" id="userDropdown">
					<!-- Información del usuario en el dropdown -->
					<div class="dropdown-user-header">
						<span class="dropdown-user-name"><c:out
								value="${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}" /></span>
						<span class="dropdown-user-role">Rol Asignado: Cliente</span>
					</div>

					<hr class="dropdown-divider">

					<!-- Nuevo MenuItem: Mi perfil -->
					<a
						href="${pageContext.request.contextPath}/cliente?action=getprofile"
						class="dropdown-item"> <span class="material-icons">person</span>
						Mi perfil <span class="material-icons chevron-right">chevron_right</span>
					</a>

					<hr class="dropdown-divider">

					<!-- Opción de Cerrar sesión (ya sin el div extra que lo envolvía) -->
					<a href="${pageContext.request.contextPath}/cliente?action=logout"
						class="dropdown-item logout-item"> <span
						class="material-icons">logout</span> Cerrar sesión
					</a>
				</div>
			</c:when>
			<c:otherwise>

				<div class="header-user">
					<div class="user-avatar"
						style="background-color: #3a3a40; color: #fff;">?</div>
					<div class="user-info">
						<span class="user-name">Invitado</span> <a
							href="${pageContext.request.contextPath}/"
							style="color: var(--primary-accent); text-decoration: none; font-size: 12px; font-weight: 500;">Iniciar
							sesión</a>
					</div>
				</div>

			</c:otherwise>
		</c:choose>

	</div>
</header>