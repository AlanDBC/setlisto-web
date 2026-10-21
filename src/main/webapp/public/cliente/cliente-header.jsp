<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- Dagiti baro a Jakarta JSTL taglibs para iti Tomcat 10+ -->
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
		<a href="#" class="nav-item active">Explorar eventos</a> <a href="#"
			class="nav-item">Mis reservas</a>
	</nav>

	<div class="header-user-container">

		<c:choose>
			<c:when test="${not empty sessionScope.usuario}">

				<div class="header-user" id="userDropdownTrigger">
					<div class="user-avatar">
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
					<a href="${pageContext.request.contextPath}/cliente?action=logout"
						class="dropdown-item"> <span class="material-icons">logout</span>
						Cerrar sesión
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