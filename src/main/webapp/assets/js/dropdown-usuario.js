document.addEventListener('DOMContentLoaded', function() {
    
    const trigger = document.getElementById('userDropdownTrigger');
    const dropdown = document.getElementById('userDropdown');

    // 1. Escuchar el clic en el botón del usuario (solo se activa si el usuario hizo login)
    if (trigger && dropdown) {
        trigger.addEventListener('click', function() {
            dropdown.classList.toggle('show');
        });
    }

    // 2. Escuchar clics en toda la ventana para cerrar el menú si se pincha fuera
    window.addEventListener('click', function(event) {
        // Verificamos si el clic ocurrió fuera del contenedor del header-user
        if (!event.target.closest('.header-user-container')) {
            const dropdowns = document.getElementsByClassName("dropdown-menu");
            for (let i = 0; i < dropdowns.length; i++) {
                const openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                }
            }
        }
    });
    
});