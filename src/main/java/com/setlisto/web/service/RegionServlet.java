package com.setlisto.web.service;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import com.setlisto.model.Region;
import com.setlisto.service.RegionService;
import com.setlisto.service.ServiceException;
import com.setlisto.service.impl.RegionServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegionServlet extends HttpServlet {

	private RegionService regionService = null;
	
	public RegionServlet() {
		regionService = new RegionServiceImpl();
		
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String idPaisStr = request.getParameter("id-pais");
		Long idPais = Long.valueOf(idPaisStr);
		
		try {
			
			List<Region> regiones = regionService.findByPaisId(idPais);
			
			response.setContentType("application/json");
			OutputStream os = response.getOutputStream();
//			os.write(json.getBytes);
			
			
		} catch (ServiceException se) {
			
		}
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
