object rolando {
	var nombreHechizoPreferido = espectroMalefico.nombre()
	var poderHechizoPreferido = espectroMalefico.poder()
	var esHechizoPoderoso = espectroMalefico.hechizoPoderoso()
	var nivelDeHechiceria
	var seCreePersonajePoderoso
	
	method nivelDeHechizo() {
		nivelDeHechiceria = (3 * poderHechizoPreferido) + fuerzaOscura.valorFuerzaOscura()
		return nivelDeHechiceria
	}
	
	method seCreePoderoso() {
		if(esHechizoPoderoso){
			seCreePersonajePoderoso = true
		}
		else { seCreePersonajePoderoso = false }
		return seCreePersonajePoderoso
	}
	
	method cambiarHechizoPreferido(hechizo) {
		nombreHechizoPreferido = hechizo.nombre()
		poderHechizoPreferido = hechizo.poder()
		esHechizoPoderoso = hechizo.hechizoPoderoso()
	}
}

object espectroMalefico {
	var nombreHechizo = "espectro malefico"
	var poder = nombreHechizo.size()
	var poderoso = true
	
	method nombre() {
		return nombreHechizo
	}
	
	method poder() {
		return poder
	}
	
	method hechizoPoderoso() {
		return poderoso
	}
	
	method cambiarNombre(nombre) {
		nombreHechizo = nombre
		poder = nombreHechizo.size()
		if(nombreHechizo.size() > 15){
			poderoso = true
		}
		else { poderoso = false }
	}
}

object hechizoBasico {
	var nombre = "hechizo basico"
	var poder = 10
	var poderoso = false
	
	method nombre() {
		return nombre
	}
	
	method poder() {
		return poder
	}
	
	method hechizoPoderoso() {
		return poderoso
	}
}

object fuerzaOscura {
	var valorFuerzaOscura = 5
	
	method valorFuerzaOscura() {
		return valorFuerzaOscura
	}
	
	method eclipse(){
		valorFuerzaOscura *= 2
	}
}