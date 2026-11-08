package com.setlisto.test;

import java.io.File;

public class FileTest {

	public FileTest() {
	}

	public static void main(String[] args) {
		File c = new File("c:/");

		File[] arrayFiles = c.listFiles();

		int ficheros = 0;
		int directorios = 0;
		Long totalBytes = 0l;

		if (arrayFiles != null) {

		    for (File f : arrayFiles) {
		        
		        if (f.isDirectory()) {
		            directorios += 1; 
		        } else if (f.isFile()) { 
		            ficheros += 1;
		        }
		        
		        totalBytes += f.length();
		        
		        System.out.println(f.getName());
		    }
		}

		System.out.println("Son ficheros: " + ficheros);
		System.out.println("Son directorios: " + directorios);
		System.out.println("Total de bytes: " + totalBytes);
	}
}
