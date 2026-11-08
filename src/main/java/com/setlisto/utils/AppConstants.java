package com.setlisto.utils;

public final class AppConstants {

	// Evitamos que se pueda instanciar
	private AppConstants() {}

	public static final class Views {	
		public static final String EVENTO_SEARCH = "/public/evento/evento-search-view.jsp";
		public static final String EVENTO_DETAIL = "/public/evento/evento-detail-view.html";

		public static final String USUARIO_LOGIN = "/public/auth/landing-login.jsp";
		public static final String USUARIO_REGISTER = "/public/auth/registro.jsp";
		
		public static final String CLIENTE_PROFILE = "/private/cliente/mi-perfil.jsp";
		
		
		public static final String ERROR_404 = "/public/error/error-404.html";	
	}

	public static final class Routes {
		public static final String EVENTO = "/evento";
		public static final String CLIENTE = "/cliente";
	}

	public static final class Actions {
		public static final String SEARCH = "search";
		public static final String DETAIL = "detail";
		public static final String LOGIN = "login";
		public static final String REGISTER = "register";
		public static final String GO_LOGIN = "gologin";
		public static final String GO_REGISTER = "goregister";
		public static final String LOGOUT = "logout";
		public static final String GET_PROFILE = "getprofile";
		public static final String GET_IMAGE = "getimage";
	}
	
	public static final class ParamNames {
		public static final String LOGGED = "usuario";
	}
}