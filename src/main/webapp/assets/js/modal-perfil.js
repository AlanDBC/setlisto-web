/**
 * Abre el modal especificado por su ID.
 * @param {string} modalId - El ID del elemento modal a mostrar.
 */
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'flex';
    }
}

/**
 * Cierra el modal especificado por su ID.
 * @param {string} modalId - El ID del elemento modal a ocultar.
 */
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.style.display = 'none';
    }
}

/**
 * Event listener para cerrar cualquier modal abierto si el usuario hace clic fuera de la caja contenedora.
 */
window.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal-overlay')) {
        event.target.style.display = 'none';
    }
});