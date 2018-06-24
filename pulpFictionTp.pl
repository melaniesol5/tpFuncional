% persona(Persona)
persona(marsellus).
persona(mia).
persona(pumkin).
persona(honeyBunny).
persona(bernardo).
persona(bianca).
persona(charo).
persona(vincent).
persona(jules).
persona(winston).

% pareja(Persona,OtraPersona)
pareja(marsellus,mia).
pareja(pumkin,honeyBunny).
pareja(bernardo,bianca).
pareja(bernardo,charo).

% trabajaPara(Empleador,Empleado)
trabajaPara(marsellus,vincent).
trabajaPara(marsellus,jules).
trabajaPara(marsellus,winston).

%1- SALECON/2
saleCon(Persona,OtraPersona):-
sonPareja(Persona,OtraPersona),
Persona \= OtraPersona .

sonPareja(Persona,OtraPersona) :- 
pareja(Persona,OtraPersona).

sonPareja(Persona,OtraPersona) :-
pareja(OtraPersona,Persona).


%4 - FIDELIDAD
esFiel(Persona) :-
persona(Persona),
persona(OtraPersona),
persona(TerceraPersona),
saleCon(Persona,OtraPersona),
not(saleCon(Persona,TerceraPersona)).

% Me tira multiples respuestas 
