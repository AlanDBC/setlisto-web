<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Setlisto - Crear Cuenta</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/registro-style.css">
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
	rel="stylesheet">
</head>
<body>
	<div class="register-wrapper">
		<div class="register-card">
			<!-- Enlace para regresar al Login -->
			<a href="${pageContext.request.contextPath}/cliente?action=gologin"
				class="back-link">&larr; Volver</a>

			<div class="logo-container">
				<img
					src="${pageContext.request.contextPath}/assets/img/setlisto-logo-blanco.png"
					alt="Setlisto Logo" class="logo-img">
			</div>

			<!-- Mensaje de error dinámico con JSTL -->
			<c:if test="${not empty error}">
				<div class="error-message"
					style="color: #ff5555; background: rgba(255, 85, 85, 0.1); border: 1px solid #ff5555; padding: 10px; border-radius: 6px; font-size: 13px; margin-bottom: 20px; text-align: center;">
					<c:out value="${error}" />
				</div>
			</c:if>

			<form action="${pageContext.request.contextPath}/cliente"
				method="POST" class="register-form" autocomplete="off">
				<input type="hidden" name="action" value="register">

				<div class="input-group">
					<label for="email">CORREO ELECTRÓNICO</label> <input type="email"
						id="email" name="email" autocomplete="email"
						placeholder="correo@ejemplo.com"
						value="<c:out value="${param.email}"/>" required>
				</div>

				<div class="input-group">
					<label for="name">NOMBRE</label> <input type="text" id="name"
						name="name" autocomplete="given-name" placeholder="Joaquín"
						value="<c:out value="${param.name}"/>" required>
				</div>

				<div class="input-group">
					<label for="surname1">PRIMER APELLIDO</label> <input type="text"
						id="surname1" name="surname1" autocomplete="family-name"
						placeholder="Pérez" value="<c:out value="${param.surname1}"/>"
						required>
				</div>

				<div class="input-group">
					<label for="birth_date">FECHA DE NACIMIENTO</label> <input
						type="date" id="birth_date" name="birth_date"
						value="<c:out value="${param.birth_date}"/>" required>
				</div>

				<div class="input-group">
					<label for="password">CONTRASEÑA</label> <input type="password"
						id="password" name="password" autocomplete="new-password"
						placeholder="••••••••" required>
				</div>

				<div class="input-group">
					<label for="confirm_password">REPETIR CONTRASEÑA</label> <input
						type="password" id="confirm_password" name="confirm_password"
						autocomplete="new-password" placeholder="••••••••" required>
				</div>

				<button type="submit" class="btn-primary">Crear cuenta</button>
			</form>
		</div>
	</div>
</body>
</html>