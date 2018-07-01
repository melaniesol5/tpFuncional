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

esPeligroso(Persona) :-
personaje(Persona,TipoDeOcupacion),
realizaActividadPeligrosa(TipoDeOcupacion).

esPeligroso(Persona) :-
tieneJefePeligroso(Persona).

realizaActividadPeligrosa(mafioso(maton)).
realizaActividadPeligrosa(ladron(Actividades)) :-
member(licorerias,Actividades).

tieneJefePeligroso(Persona) :-
trabajaPara(Jefe,Persona),
personaje(Jefe,Ocupacion),
realizaActividadPeligrosa(Ocupacion).

% 2- San Cayetano

sonAmigos(Persona,OtraPersona):-
	amigo(Persona,OtraPersona).
sonAmigos(Persona,OtraPersona):-
	amigo(OtraPersona,Persona).

sanCayetano(Personaje):-
	personaje(Personaje,_),
	encargo(Personaje,Encargado,_),
	sonAmigos(Personaje,Encargado).
sanCayetano(Personaje):-
	personaje(Personaje,_),
	encargo(Personaje,Encargado,_),
	acataOrden(Encargado,Personaje).

% 3- NIVEL DE RESPETO

nivelDeRespeto(vincent,15).
nivelDeRespeto(Persona,NivelDeRespeto) :-
personaje(Persona,Tipo),
findall(CantidadDeRespeto,tipoDeOcupacion(Tipo,CantidadDeRespeto),CantidadDeRespetoTotal),
sumlist(CantidadDeRespetoTotal,NivelDeRespeto).


tipoDeOcupacion(actriz(ListaDePeliculas),CantidadDeRespeto) :-
length(ListaDePeliculas,CantidadDePeliculas),
CantidadDeRespeto is CantidadDePeliculas * (10 / 100).

tipoDeOcupacion(mafioso(resuelveProblemas),10).
tipoDeOcupacion(mafioso(capo),20).

% 5- Mas Atareado

masAtareado(Personaje):-
	personaje(Personaje,_),
	cantidadEncargos(Personaje,CantidadDeEncargos),
	forall(personaje(OtroPersonaje,_),(cantidadEncargos(OtroPersonaje,OtraCantidadDeEncargos),CantidadDeEncargos >= OtraCantidadDeEncargos)).
	
cantidadEncargos(Personaje,CantidadDeEncargos):-
	findall(Personaje,encargo(_,Personaje,_),ListaDeEncargos),
	length(ListaDeEncargos,CantidadDeEncargos).







