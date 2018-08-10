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
acataOrden(Empleador,Empleado):-
  trabajaPara(Empleador,EmpleadoIntermedio),
  acataOrden(EmpleadoIntermedio,Empleado).
  
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
esPeligroso(Jefe).

% 2-SAN CAYETANO
sanCayetano(Persona):-
   encargo(Persona,_,_),
   forall(tieneCerca(Persona,OtraPersona), encargo(Persona,OtraPersona,_)).

tieneCerca(Persona,OtraPersona):-
   amigo(Persona,OtraPersona).
tieneCerca(Persona,OtraPersona):-
   amigo(OtraPersona,Persona).
tieneCerca(Persona,OtraPersona):-
   trabajaPara(OtraPersona,Persona).
tieneCerca(Persona,OtraPersona):-
   trabajaPara(Persona,OtraPersona).
   
% 3- NIVEL DE RESPETO

nivelRespeto(vincent,15).
nivelRespeto(Personaje,Nivel) :-
personaje(Personaje,Ocupacion),
   ocupacion(Ocupacion, Nivel).
   

ocupacion(mafioso(resuelveProblemas),10).
ocupacion(mafioso(capo),20).
ocupacion(actriz(Peliculas),Nivel):-
length(Peliculas,Cantidad),
Nivel is Cantidad/10.

esRespetable(Personaje):-
nivelRespeto(Personaje,Nivel),
Nivel > 9.

noEsRespetable(Personaje):-
personaje(Personaje,_),
not((esRespetable(Personaje))).

respetabilidad(CantidadRespetables,CantidadNoRespetables):-
findall(Personaje, esRespetable(Personaje), PersonajesRespetables),
length(PersonajesRespetables,CantidadRespetables),
findall(Personaje, noEsRespetable(Personaje), PersonajesNoRespetables),
length(PersonajesNoRespetables,CantidadNoRespetables).




% 5- Mas Atareado

masAtareado(Personaje):-
	personaje(Personaje,_),
	cantidadEncargos(Personaje,CantidadDeEncargos),
	forall(personaje(OtroPersonaje,_),(cantidadEncargos(OtroPersonaje,OtraCantidadDeEncargos),CantidadDeEncargos >= OtraCantidadDeEncargos)).
	
cantidadEncargos(Personaje,CantidadDeEncargos):-
	findall(Personaje,encargo(_,Personaje,_),ListaDeEncargos),
	length(ListaDeEncargos,CantidadDeEncargos).







