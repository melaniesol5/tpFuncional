% pareja(Persona,OtraPersona)
pareja(marsellus,mia).
pareja(pumkin,honeyBunny).
pareja(bernardo,bianca).
pareja(bernardo,charo).

% trabajaPara(Empleador,Empleado)
trabajaPara(marsellus,vincent).
trabajaPara(marsellus,jules).
trabajaPara(marsellus,winston).
%NUEVOS TRABAJADORES
trabajaPara(Empleador,bernardo) :-
trabajaPara(marsellus,Empleador) ,
Empleador \= jules.
trabajaPara(Empleador,george) :-
saleCon(Empleador,bernardo).

% personaje(Nombre, Ocupacion)
personaje(pumkin,ladron([estacionesDeServicio, licorerias])).
personaje(honeyBunny,ladron([licorerias, estacionesDeServicio])).
personaje(vincent,mafioso(maton)).
personaje(jules,mafioso(maton)).
personaje(marsellus,mafioso(capo)).
personaje(winston,mafioso(resuelveProblemas)).
personaje(mia,actriz([foxForceFive])).
personaje(butch,boxeador).
personaje(bernardo,mafioso(cerebro)).
personaje(bianca,actriz([elPadrino1])).
personaje(elVendedor,vender([humo, iphone])).
personaje(jimmie,vender([auto])).

persona(Persona) :- personaje(Persona,_).

% encargo(Solicitante, Encargado, Tarea). 
% las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus,vincent,cuidar(mia)).
encargo(vincent,elVendedor,cuidar(mia)).
encargo(marsellus,winston,ayudar(jules)).
encargo(marsellus,winston,ayudar(vincent)).
encargo(marsellus,vincent,buscar(butch, losAngeles)).
encargo(bernardo,vincent,buscar(jules, fuerteApache)).
encargo(bernardo,winston,buscar(jules, sanMartin)).
encargo(bernardo,winston,buscar(jules, lugano)).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

% -----------------------------------------PRIMERA PARTE ---------------------------------------------------


%1- SALECON/2
saleCon(Persona,OtraPersona):-
sonPareja(Persona,OtraPersona),
Persona \= OtraPersona .

sonPareja(Persona,OtraPersona) :- 
pareja(Persona,OtraPersona).

sonPareja(Persona,OtraPersona) :-
pareja(OtraPersona,Persona).

% 2 - AGREGADO A LA BASE DE CONOCIMIENTO
% 3- AGREGADO A LA BASE DE CONOCIMIENTO 


%4 - FIDELIDAD
esFiel(Personaje):-
saleCon(Personaje, Alguien),
not((saleCon(Personaje,Alguien), saleCon(Personaje, AlguienMas), Alguien\=AlguienMas)).


%5- ACATA ORDEN

/*Caso Base */
acataOrden(Empleador,Empleado):-
  trabajaPara(Empleador,Empleado).
/* Caso Recursivo */
acataOrden(Empleador,Empleado2):-
  trabajaPara(Empleador,EmpleadoIntermedio),
  acataOrden(EmpleadoIntermedio,Empleado2).
  
/* La clausula es recursiva. El caso base aparece en primer lugar porque existe la situacion donde el empleado solo responde 
a un empleador (george acata ordenes solamente y directamente de bianca y charo) y luego el caso recursivo donde el empleado
responde a un empleador indirectamente por medio de otros empleados (marsellus posee empleados que a la vez son jefes de otros empleados)
*/


% ------------------------------------------------ SEGUNDA PARTE ------------------------------------------------

% 1- ES PELIGROSO

esPeligroso(Persona):-
	personaje(Persona,TipoDeOcupacion),
	realizaActividadPeligrosa(TipoDeOcupacion).
esPeligroso(Persona):-
	tieneJefePeligroso(Persona).

realizaActividadPeligrosa(mafioso(maton)).
realizaActividadPeligrosa(ladron(LugaresQueRoba)):-
	member(licorerias,LugaresQueRoba).

tieneJefePeligroso(Persona):-
	acataOrden(Jefe,Persona),
	esPeligroso(Jefe).

% 2- San Cayetano

sanCayetano(Personaje):-
	encargo(Personaje,_,_),
	forall(sonCercano(Personaje,Encargado),encargo(Personaje,Encargado,_)).

sonCercano(Personaje,Encargado):-
	sonAmigos(Personaje,Encargado).
sonCercano(Personaje,Encargado):-
	acataOrden(Personaje,Encargado).
	
sonAmigos(Persona,OtraPersona):-
	amigo(Persona,OtraPersona).
sonAmigos(Persona,OtraPersona):-
	amigo(OtraPersona,Persona).
	
% Si bien da que es bernardo, aparece 3 veces por lo que dijo la ultima vez el ayudante sobre todos los posibles valores que hagan verdadera la regla

% 3- NIVEL DE RESPETO

nivelDeRespeto(vincent,15).
nivelDeRespeto(Persona,NivelDeRespeto):-
	personaje(Persona,Tipo),
	tipoDeOcupacion(Tipo,NivelDeRespeto).

tipoDeOcupacion(actriz(ListaDePeliculas),NivelDeRespeto):-
	length(ListaDePeliculas,CantidadDePeliculas),
	NivelDeRespeto is CantidadDePeliculas / 10.
tipoDeOcupacion(mafioso(resuelveProblemas),10).
tipoDeOcupacion(mafioso(capo),20).

% 4 - RESPETABILIDAD
esRespetable(Personaje):-
nivelDeRespeto(Personaje,NivelDeRespeto),
NivelDeRespeto > 9.

respetabilidad(Respetables,NoRespetables):-
findall(Personaje,personaje(Personaje,_),ListaDePersonajes),
length(ListaDePersonajes,CantidadDePersonajes),
findall(Personaje,esRespetable(Personaje),ListaDeRespetables),
length(ListaDeRespetables,Respetables),
NoRespetables is (CantidadDePersonajes - Respetables).

% 5- MAS ATAREADO

masAtareado(Personaje):-
	personaje(Personaje,_),
	cantidadEncargos(Personaje,CantidadDeEncargos),
	forall(personaje(OtroPersonaje,_),tieneMasEncargos(OtroPersonaje,CantidadDeEncargos)).
	
cantidadEncargos(Personaje,CantidadDeEncargos):-
	findall(Personaje,encargo(_,Personaje,_),ListaDeEncargos),
	length(ListaDeEncargos,CantidadDeEncargos).
	
tieneMasEncargos(OtroPersonaje,CantidadDeEncargos):-
	cantidadEncargos(OtroPersonaje,OtraCantidadDeEncargos),
	CantidadDeEncargos >= OtraCantidadDeEncargos.








