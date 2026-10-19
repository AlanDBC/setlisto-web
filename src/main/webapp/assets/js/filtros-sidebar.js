document.addEventListener('DOMContentLoaded', () => {

    const filterForm = document.querySelector('.filter-form');
    const allCheckboxes = document.querySelectorAll('.filter-form input[type="checkbox"]');
    const parentCheckboxes = document.querySelectorAll('.parent-checkbox');
    const toggleButtons = document.querySelectorAll('.toggle-btn');
    
    const minInput = document.getElementById('precioDesde');
    const maxInput = document.getElementById('precioHasta');
    const priceLabel = document.getElementById('price-range-label');
    const progress = document.getElementById('slider-progress');


    // =====================================================================
    // 1. INICIALIZACIÓN (LEER URL Y DESPLEGAR MENÚS)
    // =====================================================================
    const urlParams = new URLSearchParams(window.location.search);
    const checkboxNames = ['genre', 'subgenre', 'eventType', 'sessionType', 'country', 'region', 'city','fechaDesde','fechaHasta'];

    checkboxNames.forEach(paramName => {
        const selectedValues = urlParams.getAll(paramName);
        selectedValues.forEach(value => {
            const checkbox = document.querySelector(`input[name="${paramName}"][value="${value}"]`);
            if (checkbox) {
                checkbox.checked = true;

                const nestedGroup = checkbox.closest('.nested-group');
                if (nestedGroup) {
                    const directChildren = nestedGroup.querySelector(':scope > .children-container');
                    if (directChildren) directChildren.style.display = 'flex';
                }

                let currentElement = checkbox;
                while (currentElement) {
                    const hiddenContainer = currentElement.closest('.children-container, .collapsible-content');
                    if (hiddenContainer) {
                        hiddenContainer.style.display = 'flex';
                        if (hiddenContainer.classList.contains('collapsible-content')) {
                            const toggleBtn = hiddenContainer.parentElement.querySelector('.toggle-btn .toggle-icon');
                            if (toggleBtn) toggleBtn.textContent = 'expand_less';
                        }
                        currentElement = hiddenContainer.parentElement;
                    } else {
                        break;
                    }
                }
            }
        });
    });


    // =====================================================================
    // 2. LA MAGIA: FETCH API (Cero recargas, cero parpadeos)
    // =====================================================================
    function fetchFilteredResults() {
        const grid = document.querySelector('.events-grid');
        
        // 1. Efecto visual suave mientras carga (opcional pero profesional)
        if(grid) grid.style.opacity = '0.4';

        // 2. Construir la URL con todos los filtros marcados
        const formData = new FormData(filterForm);
        const params = new URLSearchParams(formData);
        
        // Asumiendo que tu Servlet responde en la misma ruta actual
        const url = window.location.pathname + '?' + params.toString();

        // 3. Actualizar la URL del navegador sin recargar (para que el botón de retroceso funcione)
        window.history.replaceState({}, '', url);

        // 4. Petición en segundo plano al Servlet Java
        fetch(url)
            .then(response => response.text()) // El Servlet nos devuelve el JSP completo como texto
            .then(html => {
                // 5. Convertimos el texto en un documento HTML virtual
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');

                // 6. Extraemos SOLO lo que nos interesa (las tarjetas y el contador)
                const newGrid = doc.querySelector('.events-grid');
                const newCount = doc.querySelector('.results-count');

                // 7. Reemplazamos en nuestra página actual
                if (newGrid && grid) {
                    grid.innerHTML = newGrid.innerHTML;
                    grid.style.opacity = '1'; // Restaurar visión completa
                }
                if (newCount) {
                    document.querySelector('.results-count').innerHTML = newCount.innerHTML;
                }
            })
            .catch(error => {
                console.error('Error al filtrar eventos:', error);
                if(grid) grid.style.opacity = '1';
            });
    }

    // Prevenir el submit tradicional (por ejemplo, si el usuario da "Enter" en la barra de búsqueda)
    filterForm.addEventListener('submit', (e) => {
        e.preventDefault();
        fetchFilteredResults();
    });


    // =====================================================================
    // 3. LÓGICA DE INTERFAZ (UI - Click en desplegables y slider)
    // =====================================================================
    toggleButtons.forEach(button => {
        button.addEventListener('click', () => {
            const group = button.closest('.collapsible-group');
            const content = group.querySelector('.collapsible-content');
            const icon = button.querySelector('.toggle-icon');

            if (content.style.display === 'none') {
                content.style.display = 'flex';
                icon.textContent = 'expand_less';
            } else {
                content.style.display = 'none';
                icon.textContent = 'expand_more';
            }
        });
    });

    parentCheckboxes.forEach(parentCheckbox => {
        parentCheckbox.addEventListener('change', function() {
            const nestedGroup = this.closest('.nested-group');
            if (!nestedGroup) return;

            const directChildrenContainer = nestedGroup.querySelector(':scope > .children-container');

            if (this.checked) {
                if (directChildrenContainer) directChildrenContainer.style.display = 'flex';
            } else {
                if (directChildrenContainer) {
                    directChildrenContainer.style.display = 'none';
                    const allDescendantCheckboxes = directChildrenContainer.querySelectorAll('.child-checkbox');
                    const allDescendantContainers = directChildrenContainer.querySelectorAll('.children-container');
                    
                    allDescendantCheckboxes.forEach(childCb => childCb.checked = false);
                    allDescendantContainers.forEach(container => container.style.display = 'none');
                }
            }
        });
    });
	
    if (minInput && maxInput && priceLabel && progress) {
        const minGap = 5; 

        function updatePriceSlider(e) {
            let minVal = parseInt(minInput.value);
            let maxVal = parseInt(maxInput.value);

            if (maxVal - minVal < minGap) {
                if (e && e.target === minInput) {
                    minInput.value = maxVal - minGap;
                    minVal = parseInt(minInput.value);
                } else if (e && e.target === maxInput) {
                    maxInput.value = minVal + minGap;
                    maxVal = parseInt(maxInput.value);
                }
            }

            const minPercent = (minVal / minInput.max) * 100;
            const maxPercent = 100 - ((maxVal / maxInput.max) * 100);

            progress.style.left = minPercent + '%';
            progress.style.right = maxPercent + '%';

            const maxText = maxVal >= 200 ? '200+ €' : `${maxVal} €`;
            priceLabel.textContent = `${minVal} € - ${maxText}`;
        }

        minInput.addEventListener('input', updatePriceSlider);
        maxInput.addEventListener('input', updatePriceSlider);
        updatePriceSlider();
    }


    // =====================================================================
    // 4. AUTO-SUBMIT SILENCIOSO EN INTERACCIONES
    // =====================================================================
    allCheckboxes.forEach(cb => {
        cb.addEventListener('change', fetchFilteredResults);
    });

    if (minInput && maxInput) {
        minInput.addEventListener('change', fetchFilteredResults);
        maxInput.addEventListener('change', fetchFilteredResults);
    }
	const fechaDesdeInput = document.getElementById('fechaDesde');
	const fechaHastaInput = document.getElementById('fechaHasta');

	if (fechaDesdeInput) fechaDesdeInput.addEventListener('change', fetchFilteredResults);
	if (fechaHastaInput) fechaHastaInput.addEventListener('change', fetchFilteredResults);
	
	// =====================================================================
	// 5. LÓGICA DE RESETEO DE FILTROS
	// =====================================================================
	function resetAllFilters() {
	    // 1. Desmarcar todos los checkboxes
	    allCheckboxes.forEach(cb => cb.checked = false);

	    // 2. Ocultar todos los contenedores de subgéneros/ciudades
	    document.querySelectorAll('.children-container').forEach(container => {
	        container.style.display = 'none';
	    });

	    // 3. Resetear el slider de precio a sus valores iniciales
	    if (minInput && maxInput) {
	        minInput.value = minInput.min || 0;
	        maxInput.value = maxInput.max || 200;
	        if (typeof updatePriceSlider === 'function') {
	            updatePriceSlider();
	        }
	    }

	    // 4. Limpiar input de texto de búsqueda si existiera
	    const searchInput = document.querySelector('input[name="query"]');
	    if (searchInput) searchInput.value = '';
		
		if (fechaDesdeInput) fechaDesdeInput.value = '';
		if (fechaHastaInput) fechaHastaInput.value = '';

	    // 5. Disparar el fetch para traer todos los eventos de nuevo
	    fetchFilteredResults();
	}

	// Usamos delegación de eventos para capturar el clic en el botón de la vista o en la sidebar
	document.addEventListener('click', (e) => {
	    const resetBtn = e.target.closest('#btn-reset-filters, #btn-clear-sidebar');
	    if (resetBtn) {
	        e.preventDefault();
	        resetAllFilters();
	    }
	});
});