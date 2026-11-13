<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- Declaración de taglibs para JSTL -->
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Setlisto - Mi Perfil</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/mi-perfil-style.css">
<!-- Si usas Google Fonts (Inter) y Material Icons -->
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
</head>
<body class="perfil-body">

	<%@ include file="/public/cliente/cliente-header.jsp"%>

	<main class="perfil-container">

		<!-- Cabecera del Perfil -->
		<header class="perfil-header">
			<div class="perfil-header-izq">

				<!-- Intentamos cargar la imagen de perfil -->
				<div class="avatar-img-container" id="avatar-img-container">
					<!-- El evento onerror detecta el 404 del Servlet, oculta este div y muestra la inicial -->
					<img
						src="${pageContext.request.contextPath}/cliente?action=getimage"
						alt="Foto de perfil" class="avatar-imagen"
						onerror="document.getElementById('avatar-img-container').style.display='none'; document.getElementById('avatar-inicial-container').style.display='flex';">
					<span class="status-dot"></span>
				</div>

				<!-- Contenedor de la inicial (oculto por defecto, se revela si falla la imagen) -->
				<div class="avatar-grande" id="avatar-inicial-container"
					style="display: none;">
					<c:out
						value="${fn:toUpperCase(fn:substring(sessionScope.usuario.nombre, 0, 1))}" />
					<span class="status-dot"></span>
				</div>
				<div class="perfil-header-textos">
					<h1>Mi perfil</h1>
					<p>Gestiona tus datos y personaliza tu experiencia musical.</p>
				</div>
			</div>
			<div class="perfil-header-der">
				<span class="badge-asistente">Perfil de asistente</span>
			</div>
		</header>

		<!-- Sección: Datos Personales -->
		<section class="perfil-seccion">
			<div class="seccion-header">
				<span class="seccion-categoria">INFORMACIÓN PERSONAL</span>
				<h2>Datos personales</h2>
				<p>Estos datos se usarán para identificar tus reservas.</p>
			</div>

			<div class="formulario-grid">
				<div class="input-group">
					<label for="nombre">Nombre</label> <input type="text" id="nombre"
						value="<c:out value='${sessionScope.usuario.nombre}' />">
				</div>
				<div class="input-group">
					<label for="apellido">Primer Apellido</label> <input type="text"
						id="apellido"
						value="<c:out value='${sessionScope.usuario.apellido}' />">
				</div>
				<div class="input-group">
					<label for="telefono">Teléfono</label>
					<div class="input-telefono">
						<span class="prefijo">+34</span>
						<%-- Asumiendo que el campo teléfono exista en tu clase Cliente --%>
						<input type="tel" id="telefono"
							value="<c:out value='${sessionScope.usuario.telefono}' default='' />">
					</div>
				</div>
				<div class="input-group">
					<label for="fecha-nacimiento">Fecha de nacimiento</label>
					<div class="input-readonly-container">
						<%-- Formateo básico de fecha si es tipo Date --%>
						<input type="text" id="fecha-nacimiento"
							value="<c:out value='${sessionScope.usuario.fechaNacimiento}' />"
							readonly class="input-readonly"> <span
							class="material-icons icono-candado">lock</span>
					</div>
				</div>
			</div>
			<p class="nota-informativa">
				<span class="material-icons icon-info">info_outline</span> La fecha
				de nacimiento no se puede modificar por motivos de verificación de
				identidad.
			</p>
		</section>

		<!-- Sección: Acceso (Cuenta) -->
		<section class="perfil-seccion">
			<div class="seccion-header">
				<span class="seccion-categoria">ACCESO</span>
				<h2>Cuenta</h2>
				<p>Los cambios de acceso se confirman mediante un flujo seguro
					independiente.</p>
			</div>

			<div class="acceso-list">
				<div class="acceso-item">
					<div class="acceso-info">
						<label>Email</label>
						<div class="dato-protegido">
							<span><c:out value="${sessionScope.usuario.email}" /></span> <span
								class="material-icons icono-candado">lock</span>
						</div>
					</div>
					<button type="button" class="btn-secundario"
						onclick="openModal('modal-email')">Cambiar email</button>
				</div>

				<div class="acceso-item">
					<div class="acceso-info">
						<label>Contraseña</label>
						<div class="dato-protegido">
							<span>••••••••</span>
						</div>
					</div>
					<button type="button" class="btn-secundario"
						onclick="openModal('modal-password')">Actualizar
						contraseña</button>
				</div>
			</div>
		</section>

		<!-- Sección: Preferencias Musicales -->
		<section class="perfil-seccion">
			<div class="seccion-header">
				<span class="seccion-categoria">TU SONIDO</span>
				<h2>Preferencias musicales</h2>
				<p>Selecciona géneros y subgéneros para recibir recomendaciones
					más relevantes.</p>
			</div>

			<div class="tags-container">
				<span class="tag-musica">Techno <span
					class="material-icons icon-close">close</span></span> <span
					class="tag-musica">Rock <span
					class="material-icons icon-close">close</span></span> <span
					class="tag-musica">Corridos Tumbados <span
					class="material-icons icon-close">close</span></span>
			</div>

			<div class="buscador-generos">
				<span class="material-icons icon-search">search</span> <input
					type="text" placeholder="Busca y añade géneros o subgéneros..."
					autocomplete="off"> <span
					class="material-icons icon-expand">expand_more</span>
			</div>
		</section>

		<!-- Barra flotante de acciones -->
		<div class="acciones-flotantes">
			<span class="texto-cambios">Los cambios en los datos editables
				se aplicarán a tu cuenta.</span>
			<div class="botones-acciones">
				<button class="btn-secundario">Descartar</button>
				<button class="btn-primario">Guardar cambios</button>
			</div>
		</div>
	</main>
	<!-- Modal: Cambiar Email -->
	<div id="modal-email" class="modal-overlay" style="display: none;">
		<div class="modal-container">
			<form autocomplete="off" onsubmit="return false;">

				<!-- TRAMPA: Campo fantasma para absorber el autocompletado forzado de Chrome -->
				<input type="password" style="display: none;" tabindex="-1"
					autocomplete="current-password">

				<div class="modal-header">
					<div class="modal-title-group">
						<h3>Solicitar cambio de correo</h3>
						<p>
							Verifica tu identidad para cambiar
							<c:out value="${sessionScope.usuario.email}" />
						</p>
					</div>
					<span class="material-icons modal-close"
						onclick="closeModal('modal-email')">close</span>
				</div>

				<div class="modal-body">
					<div class="input-group">
						<label for="email-current-password">Contraseña actual</label>
						<!-- TRUCO: Nace en readonly, se libera al hacer clic. Usa new-password para no sugerir cuentas -->
						<input type="password" id="email-current-password"
							name="email_current_password" autocomplete="new-password"
							readonly onfocus="this.removeAttribute('readonly');"
							placeholder="••••••••">
					</div>

					<div class="info-box">Enviaremos las instrucciones y el
						enlace de confirmación al correo actual antes de realizar el
						cambio.</div>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn-secundario"
						onclick="closeModal('modal-email')">Cancelar</button>
					<button type="button" class="btn-modal-primary">Verificar
						y solicitar</button>
				</div>

			</form>
		</div>
	</div>

	<!-- Modal: Cambiar Contraseña -->
	<div id="modal-password" class="modal-overlay" style="display: none;">
		<div class="modal-container">
			<form autocomplete="off" onsubmit="return false;">

				<!-- TRAMPA: Campo fantasma para absorber el autocompletado forzado de Chrome -->
				<input type="password" style="display: none;" tabindex="-1"
					autocomplete="current-password">

				<div class="modal-header">
					<div class="modal-title-group">
						<h3>Cambiar contraseña</h3>
						<p>Elige una contraseña nueva y segura.</p>
					</div>
					<span class="material-icons modal-close"
						onclick="closeModal('modal-password')">close</span>
				</div>

				<div class="modal-body">
					<div class="input-group">
						<label for="pwd-current">Contraseña actual</label>
						<!-- TRUCO: Nace en readonly, se libera al hacer clic. -->
						<input type="password" id="pwd-current" name="current_password"
							autocomplete="new-password" readonly
							onfocus="this.removeAttribute('readonly');"
							placeholder="••••••••">
					</div>
					<div class="input-group">
						<label for="pwd-new">Nueva contraseña</label> <input
							type="password" id="pwd-new" name="new_password"
							autocomplete="new-password" placeholder="Mínimo 8 caracteres">
					</div>
					<div class="input-group">
						<label for="pwd-confirm">Confirmar nueva contraseña</label> <input
							type="password" id="pwd-confirm" name="confirm_new_password"
							autocomplete="new-password" placeholder="Repite la contraseña">
					</div>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn-secundario"
						onclick="closeModal('modal-password')">Cancelar</button>
					<button type="button" class="btn-modal-primary">Actualizar
						contraseña</button>
				</div>
			</form>
		</div>
	</div>
	<script
		src="${pageContext.request.contextPath}/assets/js/modal-perfil.js"
		defer></script>

</body>
</html>