// PARTE 1

object rolando {
	
var valorDeBaseParaHechiceria = 3 
	var valorDeBaseParaLucha = 1
	var hechizoPreferido = espectroMalefico
	var artefactos = [espadaDelDestino,collarDivino,mascaraOscura]
	
	
	
	method valorDeBaseParaHechiceria(unaCantidad){
		valorDeBaseParaHechiceria = unaCantidad
	}
	
	method valorDeBaseParaLucha(unaCantidad){
		valorDeBaseParaLucha = unaCantidad
		}
		
	method hechizoPreferido(unHechizo){
		hechizoPreferido = unHechizo
		
	}
	method nivelDeHechiceria(){
	return (valorDeBaseParaHechiceria * hechizoPreferido.poder() ) + fuerzaOscura.valor()	
	}
	
	method seCreePoderoso() {
		return hechizoPreferido.esPoderoso()
	}
	
method agregarArtefacto(unArtefacto){
	artefactos.add(unArtefacto)
}
method removerArtefacto(unArtefacto){
	artefactos.remove(unArtefacto)
}

method habilidadParaLaLucha(){
	
	 return valorDeBaseParaLucha + artefactos.sum{artefacto => artefacto.nivelDeLucha()}
	
}
method tieneMayorHabilidadDeLuchaQueNivelDeHechiceria(){
	return self.habilidadParaLaLucha() > self.nivelDeHechiceria()
}
	
					
}

object espectroMalefico {
	
var nombre = "espectro malefico"
	
	
 method nombre(unNombre){
 	nombre = unNombre
 }
 method poder() {
 	return self.cantidadDeLetras()
 }
 method cantidadDeLetras() {
 	return nombre.size()
 }
 
 method esPoderoso(){
 	return self.cantidadDeLetras() > 15 
 	
 }	
	
	
	
}

object hechizoBasico {
	var nombre = "hechizo basico"
	
	method poder() {
	return 10
	}
	method esPoderoso(){
		return false 
	}
	
}

object fuerzaOscura {
	var valor = 5
	
	method valor() {
		return valor
	}
	method valor(unValor) {
		valor = unValor
	
	method eclipse(){
		valor *= 2
	}
}

object espadaDelDestino {
	var nivelDeLucha = 3

	method nivelDeLucha(){
	return nivelDeLucha
	}
	
	}
	
	
	
object collarDivino {
	var cantidadDePerlas = 5
	var nivelDeLucha = 0

  method cantidadDePerlas(unaCantidad){
   cantidadDePerlas = unaCantidad
  }

method nivelDeLucha(){
return  (nivelDeLucha + cantidadDePerlas)
}

}
	
	
object mascaraOscura{
		
		
method nivelDeLucha(){
return 4.max(fuerzaOscura.valor()/2)
}
	}
	
