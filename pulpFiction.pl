%pareja(Persona, Persona)
pareja(marsellus, mia).
pareja(pumkin, honeyBunny).
pareja(bernardo, bianca).
pareja(bernardo, charo).
 
%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).
trabajaPara(vincent, bernardo).
trabajaPara(winston, bernardo).
trabajaPara(bianca, george).
trabajaPara(charo, george).

%Información base
%personaje(Nombre, Ocupacion)
personaje(pumkin,     ladron([estacionesDeServicio, licorerias])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).
personaje(bernardo,   mafioso(cerebro)).
personaje(bianca,     actriz([elPadrino1])).
personaje(elVendedor, vender([humo, iphone])).
personaje(jimmie,     vender([auto])).

%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(bernardo, vincent, buscar(jules, fuerteApache)).
encargo(bernardo, winston, buscar(jules, sanMartin)).
encargo(bernardo, winston, buscar(jules, lugano)).
%************************************************************
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).
%*************************************************************

saleCon(Persona,OtraPersona):- pareja(Persona, OtraPersona).
saleCon(OtraPersona, Persona):- pareja(Persona, OtraPersona).

esFiel(Personaje):-
	saleCon(Personaje, Pareja),
	not(saleConOtra(Personaje,Pareja)).	
saleConOtra(Persona, OtraPersona):-
	saleCon(Persona, Alguien),
	OtraPersona \= Alguien.

acataOrden(Empleador, Empleado):-
	trabajaPara(Empleador, Empleado).
acataOrden(Empleador, Empleado):-
	trabajaPara(OtroEmpleador, Empleado),
	acataOrden(Empleador, OtroEmpleador).
	
%**************************************************************
esPeligroso(Personaje):- realizaActividadPeligrosa(Personaje).
esPeligroso(Personaje):- 
	trabajaPara(Jefe,Personaje),
	esPeligroso(Jefe).

realizaActividadPeligrosa(Personaje):-
	personaje(Personaje,Ocupacion),
	ocupacionPeligrosa(Ocupacion).
	
ocupacionPeligrosa(mafioso(maton)).
ocupacionPeligrosa(ladron(Lista)):- member(licorerias,Lista).

%***************************************************************
sanCayetano(Personaje):-
	tieneCercaA(PersonajeCerca, Personaje),
	forall(tieneCercaA(PersonajeCerca, Personaje), encargo(Personaje,PersonajeCerca,_)).
	
tieneCercaA(PersonajeCerca, Personaje):- amigo(PersonajeCerca, Personaje).
tieneCercaA(PersonajeCerca, Personaje):- trabajaPara(PersonajeCerca, Personaje).

%*******************************************************************
nivelRespeto(Personaje, Nivel):-
	personaje(Personaje, Ocupacion),
	nivelRespetoCopado(Personaje,Ocupacion,Nivel).

nivelRespetoCopado(_,actriz(ListaPeliculas),Nivel):- 
	length(ListaPeliculas, Tamanio),
	Nivel is Tamanio/10.
nivelRespetoCopado(_,mafioso(resuelveProblemas),Nivel):- Nivel is 10.
nivelRespetoCopado(_,mafioso(capo),Nivel):- Nivel is 20.
nivelRespetoCopado(vincent,_,Nivel):- Nivel is 15.

%*********************************************************************
respetabilidad(Respetables, NoRespetables):-
	cantidadDeRespetables(Respetables),
	cantidadDeNoRespetables(NoRespetables).

cantidadDeRespetables(Respetables):-
	findall(Personaje,esRespetable(Personaje),PersonajesRespetables),
	length(PersonajesRespetables,Respetables).

esRespetable(Personaje):-
	nivelRespeto(Personaje,Nivel),
	Nivel > 9.

cantidadDeNoRespetables(NoRespetables):-
	findall(Personaje,noRespetable(Personaje), PersonajesNoRespetables),
	length(PersonajesNoRespetables, NoRespetables).
	
noRespetable(Personaje):- 
	personaje(Personaje,_),
	not(esRespetable(Personaje)).

%***********************************************************************
masAtareado(Personaje):-
	personaje(Personaje,_),
	forall(personaje(OtroPersonaje,_),tieneMasEncargoQue(OtroPersonaje,Personaje)).
	
cantidadEncargos(Personaje, Cantidad):-
	personaje(Personaje,_),
	findall(Personaje,encargo(_,Personaje,_),Encargos),
	length(Encargos,Cantidad).
	
tieneMasEncargoQue(OtroPersonaje, Personaje):-
	cantidadEncargos(Personaje,CantidadEncargo),
	cantidadEncargos(OtroPersonaje,CantidadEncargosOtro),
	CantidadEncargo >= CantidadEncargosOtro.

	