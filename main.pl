%paradigmaDocsRegister(Sn1, Fecha, Username, Password, Sn2).
% Funcion Register:
% Predicado
% paradigmaDocsRegister(Sn1, Fecha, Username, Password, Sn2):-
%   registradoAntes?(Username,Password),
%   fechaValida(Fecha),
%   registrar(Username,Password,Fecha)
% date(Day,Month,Year,[Day,Month,Year]):-
%
% TDA DATE
% Constructor
date(Day, Month, Year, Date):-
  isDate(Day,Month,Year),
  Date = [Day, Month, Year].

% De Pertenencia
isDay(Day):-
	(Day > 0),(Day < 32).

isMonth(Month):-
	(Month > 0),(Month < 13).

isYear(Year):-
  (Year > 1921).

isDate(Day, Month, Year):-
  integer(Day),
  integer(Month),
  integer(Year),
	isDay(Day), isMonth(Month), isYear(Year).

% Selectores
getDay([D,_,_],D).
getMonth([_,M,_],M).
getYear([_,_,Y],Y).

% TDA ParadigmaDocs
% Constructor Paradigmadocs

paradigmaDocs(Name,Date,SOut):-
  string(Name),
  SOut = [Name,Date,[],[],[]].
  
% Predicado usado para construir la version anterior (Sn1) de paradigmadocs
constPdocs(Name,Date,Registrados,Logeados,Documentos,[Name,Date,Registrados,Logeados,Documentos]).

% Getters ParadigmaDocs
getNombrePdocs([Nombre,_,_,_,_],Nombre).
getFechaCreacionPdocs([_,Fecha,_,_,_],Fecha).
getRegistrados([_,_,ListaReg,_,_],ListaReg).
getLogeados([_,_,_,ListaLog,_],ListaLog).
getDocumentos([_,_,_,_,ListaDocs],ListaDocs).

% TDA USUARIO

% Getters Usuario
getUser([User,_,_],User).
getPass([_,Pass,_],Pass).
getFechaCreacionUser([_,_,DateC],DateC). % GetDateCreation

% Obtiene una lista con todos los usernames de los usuarios registrados
getUserNames([],[]).
getUserNames([H|T],[H1|T1]):-
  getUser(H,H1),
  getUserNames(T,T1).

% Obtiene una lista con todas las contraseñas de los usuarios registrados
getPasswords([],[]).
getPasswords([H|T],[H1|T1]):-
  getPass(H,H1),
  getPasswords(T,T1).

% getLogeado: Predicado que extrae al usuario con sesión activa en paradigmadocs
getLogeado(Sn1,Logeado):-
  getLogeados(Sn1,Logeados),
  \+vacia(Logeados,[]),
  head(Logeados,Logeado).

getRegisterUsers(Sn1,Users):-
  getRegistrados(Sn1,Registrados),
  getUserNames(Registrados,Users).

% Registrado Antes: Predicado que determina si un usuario se ha registrado antes
registradoAntes(ParadigmaDocs,User):-
  string(User),
  getRegistrados(ParadigmaDocs,ListaRegistrados),
  getUserNames(ListaRegistrados,Usernames),
  member(User,Usernames).

% SesionActiva: Predicado que verifica cuando un usuario tiene sesion activa en paradigmaDocs 
sesionActiva(Sn1):-       
  getLogeados(Sn1,Logeados),
  \+vacia(Logeados,[]).

% TDA DOCUMENTO

% Constructor de Documento
constDocumento(Fecha, Nombre, Contenido, Id, Autor, [Id ,0 ,Autor ,Fecha ,Nombre ,Contenido ,[]]).
% Getters Documento:
getIdDoc([Id,_,_,_,_,_,_],Id).        % Id Documento
getIdvDoc([_,Idv,_,_,_,_,_],Idv).     % Id version
getAutorDoc([_,_,Autor,_,_,_,_],Autor).
getFechaCreacionDoc([_,_,_,Fecha,_,_,_],Fecha).
getNombreDoc([_,_,_,_,Nombre,_,_],Nombre).
getContenidoDoc([_,_,_,_,_,Contenido,_],Contenido).
getContenidoDoc([_,_,_,_,_,_,Compartidos],Compartidos).

% SetId: Genera Id
setId(Sn1,Id):-
  getDocumentos(Sn1,Docs),
  length(Docs,Idd),
  Id is Idd + 1.

%  -------------------------------------------MAIN---------------------------------------------------
% Otros Predicados
indexOf([Element|_], Element, 0). % We found the element
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1), % Check in the tail of the list
  Index is Index1+1.  % and increment the resulting index
% Otros Hechos
equal(X,X).
head([H|_],H).
vacia([],[]).

% Predicados Principales:

paradigmaDocsRegister(Sn1,Fecha,Username,Password,Sn2):-
  string(Username),
  string(Password),
  \+registradoAntes(Sn1,Username),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getLogeados(Sn1,Logeados),
  getDocumentos(Sn1,Docs),
  getRegistrados(Sn1,Registrados),
  append(Registrados,[[Username,Password,Fecha]],UpdateRegistrados), 
  Sn2 = [Nombre,FechaCreacion,UpdateRegistrados,Logeados,Docs].      % Retorna paradigmaDocs con la lista de registrados actualizada

paradigmaDocsLogin(Sn1,Username,Password,Sn2):-
  string(Username),
  string(Password),
  getNombrePdocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getLogeados(Sn1,Logeados),
  
  vacia(Logeados,[]),     % Si la lista de logeados esta vacía se permite que un usuario inicie sesión
  getUserNames(Registrados,Usernames),
  getPasswords(Registrados,Passwords),

  indexOf(Usernames,Username,Index),
  nth0(Index,Passwords,Pass),
  equal(Pass,Password),

  getDocumentos(Sn1,Docs),
  append(Logeados,[Username],UpdateLogeados),
  Sn2 = [Nombre,FechaCreacion,Registrados,UpdateLogeados,Docs]. % Retorna paradigmaDocs con la lista de logeados actualizada

paradigmaDocsCreate(Sn1, Fecha, Nombre, Contenido, Sn2):-
  string(Nombre),
  string(Contenido),
  sesionActiva(Sn1),    % Si existe sesion activa se saca al usuario
  getNombrePdocs(Sn1,NombrePdocs),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getRegistrados(Sn1,Registrados),
  getDocumentos(Sn1,Docs),
  getLogeado(Sn1,Autor),
  setId(Sn1,Id),
  constDocumento(Fecha, Nombre, Contenido, Id, Autor,Doc),
  append(Docs,[[Doc]],UpdateDocs),
  Sn2 = [NombrePdocs,FechaCreacion,Registrados,[],UpdateDocs].  % Retorna paradigmaDocs sin el usuario logeado
% ["R","W","C"]
% ["nico","robert"]
% ["nico","R"]  
% paradigmaDocsShare(Sn1, DocumentId, ListaPermisos, ListaUsernamesPermitidos, Sn2):-
%   getRegistrados(Sn1,Registrados),
%   getUserNames()


% EJEMPLOS:
% Register:
% 1. Se logea un usuario comun, no existe un username igual:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2).
% 2. Se intenta logear un usuario con el mismo "username", el predicado retorna false:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"nico","1234",PD3).
% 3. Se intenta logear un usuario con un "username" distinto, se permite el registro:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3).

% Login
% 1. Se logea un usuario existente con credenciales correctas:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsLogin(PD3,"nico","qwerty",PD4).
% 2. El usuario "robert" se intenta logear con contraseña incorrecta, el predicado, retorna false:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsLogin(PD3,"robert","qwerty",PD4).
% 3. El usuario "nico" ya se encuentra logeado, ahora el usuario "robert" desea logearse, pero no esta permitido, retorna false:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsLogin(PD3,"nico","qwerty",PD4),paradigmaDocsLogin(PD4, "robert","1234",PD5).
% 4. Se intenta logear un usuario, no registrado en paradigmaDocs, retorna false:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsLogin(PD3,"juanJose","1234",PD4).

% Create
% 1. El usuario "nico" autenticado, crea un documento en paradigmaDocs id1:
% date(20, 12, 2015, D1), date(21, 12, 2018, D2), paradigmaDocs("Google docs", D1, PD1), paradigmaDocsRegister(PD1, D2, "nico", "qwerty", PD2), paradigmaDocsRegister(PD2,D2,"robert","1234",PD3), paradigmaDocsLogin(PD3,"nico","qwerty",PD4),paradigmaDocsCreate(PD4,D2,"mi CV","lorem ipsum",PD5).
% 2. 