<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<aside class="sidebar-filters">
	<div class="filter-header"
		style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
		<h3
			style="font-size: 13px; font-weight: 700; color: var(--text-muted); margin: 0;">
			BUSCAR EVENTOS</h3>
		<button type="button" id="btn-clear-sidebar"
			style="background: none; border: none; color: var(--primary-accent); font-size: 13px; font-weight: 600; cursor: pointer; padding: 0;">
			Limpiar todo</button>
	</div>

	<form action="${pageContext.request.contextPath}/evento" method="GET" class="filter-form">
		<input type="hidden" name="action" value="search">

		<!-- Buscador general unificado -->
		<div class="filter-group" style="margin-bottom: 32px;">
			<div class="search-input">
				<span class="material-icons">search</span> <input type="text"
					name="query" placeholder="Buscar evento o artista..."
					style="background-color: var(--bg-card); border-radius: 12px; border: 1px solid var(--border-color); padding: 14px 12px 14px 40px;">
			</div>
		</div>

		<!-- RANGO DE FECHAS -->
		<div class="collapsible-group"
			style="border-bottom: 1px solid rgba(255, 255, 255, 0.08);">
			<button type="button" class="toggle-btn"
				style="width: 100%; display: flex; justify-content: space-between; align-items: center; background: none; border: none; padding: 16px 0; color: var(--text-main); font-size: 15px; font-weight: 600; cursor: pointer;">
				Fechas <span class="material-icons toggle-icon"
					style="color: var(--text-muted);">expand_more</span>
			</button>

			<div class="collapsible-content"
				style="display: none; padding-bottom: 16px; flex-direction: column; gap: 12px;">
				<div
					style="display: flex; gap: 12px; justify-content: space-between;">
					<!-- Fecha Desde -->
					<div style="flex: 1;">
						<label
							style="display: flex; align-items: center; gap: 6px; font-size: 12px; color: var(--text-muted); margin-bottom: 6px;">
							<span class="material-icons" style="font-size: 14px;">calendar_today</span>
							Desde
						</label> <input type="date" name="fechaDesde" id="fechaDesde"
							value="${param.fechaDesde}"
							style="width: 100%; background: var(--bg-card); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 6px; padding: 10px; color: var(--text-main); font-size: 13px; font-family: 'Inter', sans-serif;">
					</div>

					<!-- Fecha Hasta -->
					<div style="flex: 1;">
						<label
							style="display: flex; align-items: center; gap: 6px; font-size: 12px; color: var(--text-muted); margin-bottom: 6px;">
							<span class="material-icons" style="font-size: 14px;">calendar_today</span>
							Hasta
						</label> <input type="date" name="fechaHasta" id="fechaHasta"
							value="${param.fechaHasta}"
							style="width: 100%; background: var(--bg-card); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 6px; padding: 10px; color: var(--text-main); font-size: 13px; font-family: 'Inter', sans-serif;">
					</div>
				</div>
			</div>
		</div>

		<!-- GÉNERO MUSICAL -->
		<div class="filter-group collapsible-group"
			style="border-top: 1px solid var(--border-color); padding-top: 20px; margin-bottom: 20px;">
			<div class="filter-group-header toggle-btn"
				style="display: flex; justify-content: space-between; align-items: center; cursor: pointer; margin-bottom: 16px;">
				<label
					style="margin: 0; font-size: 14px; font-weight: 600; color: var(--text-main); text-transform: none; cursor: pointer;">Género
					Musical</label> <span class="material-icons toggle-icon"
					style="color: var(--text-muted); font-size: 20px;">expand_more</span>
			</div>
			<div class="checkbox-list collapsible-content" style="display: none">

				<!-- Iterar sobre el Map de Géneros -->
				<c:forEach var="entryGenero" items="${mapaGeneros}">

					<c:choose>
						<c:when test="${not empty entryGenero.value}">
							<!-- Padre: Tiene Subgéneros -->
							<div class="nested-group"
								style="display: flex; flex-direction: column; gap: 12px;">
								<label class="checkbox-item parent-item"> <!-- Clase parent-item añadida para JavaScript -->
									<input type="checkbox" class="parent-checkbox" name="genre"
									value="${entryGenero.key.id}">
									${entryGenero.key.nombre}
								</label>

								<!-- Hijas: Subgéneros -->
								<!-- Clase children-container añadida y oculto por defecto -->
								<div class="nested-children children-container"
									style="margin-left: 32px; display: none; flex-direction: column; gap: 12px;">
									<c:forEach var="subgenero" items="${entryGenero.value}">
										<label class="checkbox-item"> <input type="checkbox"
											class="child-checkbox" name="subgenre"
											value="${subgenero.id}"> ${subgenero.nombre}
										</label>
									</c:forEach>
								</div>
							</div>
						</c:when>

						<c:otherwise>
							<!-- Simple: Sin subgéneros -->
							<label class="checkbox-item"> <input type="checkbox"
								name="genre" value="${entryGenero.key.id}">
								${entryGenero.key.nombre}
							</label>
						</c:otherwise>
					</c:choose>

				</c:forEach>

			</div>
		</div>

		<!-- TIPO DE EVENTO -->
		<div class="filter-group collapsible-group"
			style="border-top: 1px solid var(--border-color); padding-top: 20px; margin-bottom: 20px;">
			<div class="filter-group-header toggle-btn"
				style="display: flex; justify-content: space-between; align-items: center; cursor: pointer; margin-bottom: 16px;">
				<label
					style="margin: 0; font-size: 14px; font-weight: 600; color: var(--text-main); text-transform: none; cursor: pointer;">Tipo
					de Evento</label> <span class="material-icons toggle-icon"
					style="color: var(--text-muted); font-size: 20px;">expand_more</span>
			</div>
			<div class="checkbox-list collapsible-content" style="display: none">

				<!-- Iterar sobre el Map de Tipos de Evento -->
				<c:forEach var="entryTipo" items="${mapaTipos}">
					<c:choose>
						<c:when test="${not empty entryTipo.value}">
							<!-- Padre: Tiene Subtipos (Ej: Club Night) -->
							<div class="nested-group"
								style="display: flex; flex-direction: column; gap: 12px;">
								<label class="checkbox-item parent-item"> <input
									type="checkbox" class="parent-checkbox" name="eventType"
									value="${entryTipo.key.id}"> ${entryTipo.key.nombre}
								</label>

								<!-- Hijas: Subtipos (Ocultos por defecto) -->
								<div class="nested-children children-container"
									style="margin-left: 32px; display: none; flex-direction: column; gap: 12px;">
									<c:forEach var="subtipo" items="${entryTipo.value}">
										<label class="checkbox-item"> <input type="checkbox"
											class="child-checkbox" name="sessionType"
											value="${subtipo.id}"> ${subtipo.nombre}
										</label>
									</c:forEach>
								</div>
							</div>
						</c:when>

						<c:otherwise>
							<!-- Simple: Sin subtipos -->
							<label class="checkbox-item"> <input type="checkbox"
								name="eventType" value="${entryTipo.key.id}">
								${entryTipo.key.nombre}
							</label>
						</c:otherwise>
					</c:choose>
				</c:forEach>

			</div>
		</div>

		<!-- UBICACIÓN -->
		<div class="filter-group collapsible-group"
			style="border-top: 1px solid var(--border-color); padding-top: 20px; margin-bottom: 20px;">
			<div class="filter-group-header toggle-btn"
				style="display: flex; justify-content: space-between; align-items: center; cursor: pointer; margin-bottom: 16px;">
				<label
					style="margin: 0; font-size: 14px; font-weight: 600; color: var(--text-main); text-transform: none; cursor: pointer;">Ubicación</label>
				<span class="material-icons toggle-icon"
					style="color: var(--text-muted); font-size: 20px;">expand_more</span>
			</div>
			<div class="checkbox-list collapsible-content" style="display: none">

				<!-- Nivel 1: Iterar sobre Países -->
				<c:forEach var="entryPais" items="${mapaUbicaciones}">
					<c:choose>
						<c:when test="${not empty entryPais.value}">
							<div class="nested-group"
								style="display: flex; flex-direction: column; gap: 12px;">
								<label class="checkbox-item parent-item"> <input
									type="checkbox" class="parent-checkbox" name="country"
									value="${entryPais.key.id}"> ${entryPais.key.nombre}
								</label>

								<!-- Nivel 2: Regiones (Ocultas por defecto) -->
								<div class="nested-children children-container"
									style="margin-left: 32px; display: none; flex-direction: column; gap: 12px;">
									<c:forEach var="entryRegion" items="${entryPais.value}">
										<c:choose>
											<c:when test="${not empty entryRegion.value}">
												<div class="nested-group"
													style="display: flex; flex-direction: column; gap: 12px;">
													<label class="checkbox-item parent-item"> <!-- Region tiene ambas clases: es hija de País, pero madre de Ciudad -->
														<input type="checkbox"
														class="parent-checkbox child-checkbox" name="region"
														value="${entryRegion.key.id}">
														${entryRegion.key.nombre}
													</label>

													<!-- Nivel 3: Ciudades (Ocultas por defecto) -->
													<div class="nested-children-2 children-container"
														style="margin-left: 32px; display: none; flex-direction: column; gap: 12px;">
														<c:forEach var="ciudad" items="${entryRegion.value}">
															<label class="checkbox-item"> <input
																type="checkbox" class="child-checkbox" name="city"
																value="${ciudad.id}"> ${ciudad.nombre}
															</label>
														</c:forEach>
													</div>
												</div>
											</c:when>

											<c:otherwise>
												<!-- Región sin ciudades -->
												<label class="checkbox-item"> <input type="checkbox"
													class="child-checkbox" name="region"
													value="${entryRegion.key.id}">
													${entryRegion.key.nombre}
												</label>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</div>
							</div>
						</c:when>

						<c:otherwise>
							<!-- País sin regiones -->
							<label class="checkbox-item"> <input type="checkbox"
								name="country" value="${entryPais.key.id}">
								${entryPais.key.nombre}
							</label>
						</c:otherwise>
					</c:choose>
				</c:forEach>

			</div>
		</div>

		<!-- PRECIO -->
		<div class="filter-group collapsible-group"
			style="border-top: 1px solid var(--border-color); padding-top: 20px; margin-bottom: 24px;">
			<div class="filter-group-header toggle-btn"
				style="display: flex; justify-content: space-between; align-items: center; cursor: pointer; margin-bottom: 20px;">
				<label
					style="margin: 0; font-size: 14px; font-weight: 600; color: var(--text-main); text-transform: none; cursor: pointer;">Precio</label>
				<span class="material-icons toggle-icon"
					style="color: var(--text-muted); font-size: 20px;">expand_more</span>
			</div>

			<div class="price-filter collapsible-content"
				style="display: none; flex-direction: column;">
				<div
					style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
					<span style="font-size: 13px; color: var(--text-muted);">Rango
						por entrada</span> <span id="price-range-label"
						style="font-size: 14px; font-weight: 700; color: var(--primary-accent);">
						<c:out
							value="${not empty param.precioDesde ? param.precioDesde : 0}" />
						€ - <c:choose>
							<c:when
								test="${empty param.precioHasta || param.precioHasta >= 200}">200+ €</c:when>
							<c:otherwise>
								<c:out value="${param.precioHasta}" /> €</c:otherwise>
						</c:choose>
					</span>
				</div>

				<!-- Slider con doble tirador -->
				<div class="range-slider-wrapper"
					style="position: relative; width: 100%; height: 24px; display: flex; align-items: center;">
					<!-- Pista base de fondo -->
					<div class="slider-track"
						style="position: absolute; width: 100%; height: 4px; background-color: var(--bg-card); border-radius: 2px;"></div>

					<!-- Barra activa (se llena dinámicamente con JS) -->
					<div id="slider-progress"
						style="position: absolute; height: 4px; background-color: var(--primary-accent); border-radius: 2px; left: 0%; right: 0%;"></div>

					<!-- Input Rango Mínimo -->
					<input type="range" id="precioDesde" name="precioDesde" min="0"
						max="200" step="5"
						value="${not empty param.precioDesde ? param.precioDesde : 0}"
						style="position: absolute; width: 100%; background: none; pointer-events: none; -webkit-appearance: none; appearance: none; z-index: 3;">

					<!-- Input Rango Máximo -->
					<input type="range" id="precioHasta" name="precioHasta" min="0"
						max="200" step="5"
						value="${not empty param.precioHasta ? param.precioHasta : 200}"
						style="position: absolute; width: 100%; background: none; pointer-events: none; -webkit-appearance: none; appearance: none; z-index: 4;">
				</div>
			</div>
		</div>
	</form>
</aside>