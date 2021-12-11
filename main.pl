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
% date: Funcion que comprueba que una fecha es correcta
% Dominio: Lista [Day, Month, Year]
% Recorrido: Lista

% De Pertenencia

isDay(Day):-
	(Day > 0),(Day < 32).
isMonth(Month):-
	(Month > 0),(Month < 13).
isYear(Year):-
  (Year > 0).
isDate(Date):-
		getDay(Date,D),
		getMonth(Date,M),
    getYear(Date,Y),
		isDay(D), isMonth(M), isYear(Y).

% Selectores
getDay([D,_,_],D).
getMonth([_,M,_],M).
getYear([_,_,Y],Y).

% TDA ParadigmaDocs
% Constructor Paradigmadocs
% Representacion: NombrePlataforma X Fecha X ListaRegistrados X ListaLogeados X ListaDocumentos[Lista Historial]


constPdocs(Name,Date,Registrados,Logeados,Documentos,[Name,Date,Registrados,Logeados,Documentos]):-
  isDate(Date).

paradigmaDocs(Name,Date,SOut):-
  isDate(Date),
  constPdocs(Name,Date,[],[],[[]],SOut).
	

% Lista de Registrados
% getRegistrados: Funcion que obtiene la lista de registrados de paradigmadocs
getNombrePDocs([Nombre,_,_,_,_],Nombre).
getFechaCreacionPdocs([_,Fecha,_,_,_],Fecha).
getRegistrados([_,_,ListaReg,_,_],ListaReg).
getLogeados([_,_,_,ListaLog,_],ListaLog).
getDocumentos([_,_,_,_,ListaDocs],ListaDocs).
% TDA USUARIO
% Getters and Setters user

getUser([User,_,_],User).
getPass([_,Pass,_],Pass).
getFechaCreacionUser([_,_,DateC],DateC). % GetDateCreation

getUserNames([],[]).

getUserNames([H|T],[H1|T1]):-
  getUser(H,H1),
  getUserNames(T,T1).

% Registrado Antes

registradoAntes(ParadigmaDocs,User):-
  getRegistrados(ParadigmaDocs,ListaRegistrados),
  getUserNames(ListaRegistrados,Usernames),
  member(User,Usernames).
% [User,Pass,Fecha]

aniadirUsuario(Sn1,ListaUsuario,Sn2):-
  getNombrePDocs(Sn1,Nombre),
  getFechaCreacionPdocs(Sn1,FechaCreacion),
  getLogeados(Sn1,Logeados),
  getDocumentos(Sn1,Docs),
  getRegistrados(Sn1,Registrados),
  append(Registrados,[ListaUsuario],ListaActualizada),
  constPdocs(Nombre,FechaCreacion,ListaActualizada,Logeados,Docs,Sn2).

constUsuario(Username,Password,Date,[Username,Password,Date]).

paradigmaDocsRegister(Sn1,Fecha,Username,Password,Sn2):-
  \+registradoAntes(Sn1,Username),
  isDate(Fecha),
  constUsuario(Username,Password,Fecha,ListaUsuario),
  aniadirUsuario(Sn1,ListaUsuario,Sn2).

% paradigmaDocsLogin(Sn1,Username,Password,Sn2):-
  
