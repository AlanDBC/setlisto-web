<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Setlisto - Acceso</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/landing-style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <div class="main-wrapper">
        <div class="content-container">
            <!-- Columna Izquierda -->
            <div class="info-column">
                <div class="logo">
                    <img src="${pageContext.request.contextPath}/assets/img/setlisto-logo-blanco.png" alt="Setlisto Logo" class="logo-img">
                </div>
                
                <h1 class="main-title">Tu música. Tu público.<br>Todo conectado.</h1>
                <h2 class="sub-title">Eventos memorables,<br>gestión sin ruido.</h2>
                
                <p class="description">
                    Descubre experiencias en directo o dirige cada detalle de tus<br>
                    eventos desde una única plataforma.
                </p>
                
                <div class="stats-container">
                    <div class="stat-box">
                        <span class="stat-number">+240</span>
                        <span class="stat-text">eventos</span>
                    </div>
                    <div class="stat-box">
                        <span class="stat-number">18K</span>
                        <span class="stat-text">asistentes</span>
                    </div>
                    <div class="stat-box">
                        <span class="stat-number">4,8</span>
                        <span class="stat-text">valoración</span>
                    </div>
                </div>
            </div>

            <!-- Columna Derecha: Tarjeta de Acceso -->
            <div class="login-column">
                <div class="login-card">
                    <span class="welcome-text">BIENVENIDO DE NUEVO</span>
                    <h2 class="login-title">Accede a Setlisto</h2>
                    <p class="login-desc">Tu menú se configurará automáticamente según el rol de tu cuenta.</p>
                    
                    <c:if test="${not empty error}">
                        <div class="error-message" style="color: #ff5555; background: rgba(255,85,85,0.1); border: 1px solid #ff5555; padding: 10px; border-radius: 6px; font-size: 13px; margin-bottom: 20px; text-align: center;">
                            <c:out value="${error}" />
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/cliente" method="POST" class="login-form">
                        <input type="hidden" name="action" value="login">
                        
                        <div class="input-group">
                            <label for="email">USUARIO O CORREO</label>
                            <input type="email" id="email" name="email" placeholder="nombre@correo.com" value="<c:out value="${param.email}"/>" required>
                        </div>
                        
                        <div class="input-group">
                            <label for="password">CONTRASEÑA</label>
                            <input type="password" id="password" name="password" placeholder="••••••••" required>
                        </div>
                        
                        <div class="forgot-pwd">
                            <a href="#">¿Olvidaste tu contraseña?</a>
                        </div>
                        
                        <button type="submit" class="btn-primary">Acceder a mi cuenta</button>

                        <div class="guest-access">
                            <a href="${pageContext.request.contextPath}/evento?action=search" class="guest-link">Explorar catálogo como invitado &rarr;</a>
                        </div>
                    </form>

                    <div class="demo-section">
                        <span class="demo-title">Acceso rápido demo</span>
                        <div class="demo-buttons">
                            <button type="button" class="btn-secondary">Cliente</button>
                            <button type="button" class="btn-secondary">Organización</button>
                            <button type="button" class="btn-secondary">Administrador</button>
                        </div>
                    </div>

                    <div class="register-link">
                        ¿Aún no tienes cuenta? <a href="${pageContext.request.contextPath}/cliente?action=goregister">Crear cuenta</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Barra Inferior -->
    <div class="bottom-bar">
        <div class="bar-content">
            <div class="bar-left">
                <span class="badge">Setlisto Demo interactiva</span>
                <span class="bar-text">Selecciona una cuenta demo y pulsa "Acceder" Contraseña: demo123</span>
            </div>
            <div class="bar-right">
                <span class="feature-tag">Reservas seguras</span>
                <span class="feature-tag">Gestión en tiempo real</span>
            </div>
        </div>
    </div>
</body>
</html>