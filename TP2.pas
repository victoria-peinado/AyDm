program ordenarCadena(input,output);
uses crt;
Const
{CLAVES}
clave_em='hola123';
clave_cli='soy cliente';

{MAXIMOS ARRAYS}
max_ciu=5;
max_e=4;
max_p=4;{minimo 1 por empresa}
max_cli=3;
TYPE
empr=array[1..max_e,1..6]of string[20];
ciu=array[1..max_ciu,1..2] of string[20];
cli=array[1..max_cli,1..2]of string[20];
proy=array[1..max_p,1..5]of string[10];
proy_cant=array[1..max_p]of integer; {este tipo es para guardar la cantidad de productos de los proyectos}
ciu_cont=array[1..max_ciu]of integer;{este tipo es para guardar la cantidad de empresas que hay en cada ciudad}
VAR
{CREACION ARRAYS}
empresas:empr;
ciudades:ciu;
clientes:cli;
proyectos:proy;
pcant:proy_cant; {array con la cant de productos por proyecto}
cont_ciu:ciu_cont;{array con la cantidad empresas por ciudad}

{CONTADORES para saber donde esta el ultimmo elemento de cada array}
c_empresas,c_ciudades,c_proyectos,c_clientes:integer;
opcion:char;
Procedure Inicializar; {inicializa los contadores y el array cont_ciu en 0}
Var i:integer;
BEGIN
     c_empresas:=0;
     c_ciudades:=0;
     c_proyectos:=0;
     c_clientes:=0;
     FOR i:= 1 to max_ciu DO cont_ciu[i]:=0;

END;
Function ingreso_clave(clave:string):boolean; {dado un strin que es la clave correcta te devuelve true si se ngresa correctamente, se tienen 3 intentos}
Var c:char;
    intento_clave:string;
    cont:integer;
BEGIN
     cont:=0;{contador de inteentos}
     REPEAT
           ClrScr;
           intento_clave:=''; {inicializamos la clave como un string vacio}
           Write('Ingrese la clave: ');
           c:= readkey;
           While c<>#13 do {mienentras que el caracter ingressado no sea enter}
           BEGIN
                intento_clave:=intento_clave+c;{le agregamos a intento el caracter ingresado}
                Write('*');
                c:=readkey
           END;
           Writeln;
           cont:=cont+1
     UNTIL(clave=intento_clave)OR (cont>=3);
     ingreso_clave:=(clave=intento_clave); {se asingna True si clave=intento_clave, o False en caso contrario}
END;
{PARTE CIUDADES}
Procedure ordenar_ciudades;{ordena ciudades de menor a mayor y deja los vacios al final}
Var aux:string[20];
    i,j,h,aux2:integer;
BEGIN
     FOR i:= 1 to (c_ciudades-1) do
         FOR j:=i+1 to c_ciudades do
             IF ciudades[i,1]>ciudades[j,1] THEN
             BEGIN
                  aux2:= cont_ciu[i];  {ordeno tambien los contadores de las ciudades}
                  cont_ciu[i]:= cont_ciu[j];
                  cont_ciu[j]:=aux2;
                  FOR h:=1 to 2 do
                      BEGIN
                           aux:=ciudades[i,h];
                           ciudades[i,h]:=ciudades[j,h];
                           ciudades[j,h]:=aux
                      END
             END
END;
Procedure Mostrar_ciudades;{funcion axiliar para ver que todo anduvo bien en el ordenamiento}
Var i:integer;
BEGIN
     ClrScr;
     Writeln('Ciudades ordenadas');
     For i:= 1 to c_ciudades do
     BEGIN
          write(ciudades[i,1],'   ', ciudades[i,2], '  ');
          writeln(cont_ciu[i])
     END;
     Readln();
END;
Function Bus_cod_ciu(cc: string):integer; {dado un codigo de ciudad devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS DICOTOMICA}
Var q:boolean;
    comi,fin,medio:integer;
BEGIN
     q:=FALSE;
     comi:=1;
     fin:=c_ciudades;
     REPEAT
           medio:=(comi+fin)DIV 2;
           IF ciudades[medio,1]=cc THEN q:=TRUE
                                   ELSE IF ciudades[medio,1]>cc THEN fin:=medio-1
                                                                ELSE comi:=medio+1;
     UNTIL (comi>fin) OR q;
     IF q THEN Bus_cod_ciu:=medio ELSE Bus_cod_ciu:=0
END;
Procedure Alta_ciudades;{ingreso de ciudades}
Var cod_ciudad:string[3];
    opcion:char;
BEGIN
     ClrScr;
     Writeln('Presione 0 para dejar de ingresar ciudades o cualquier tecla para seguir');
     Readln(opcion);
     While (opcion <>'0')and(max_ciu<>c_ciudades) do{si ya se llego al maximo de ciudades o se ingreso 0 no se agregan mas ciudades}
     BEGIN
          c_ciudades:=c_ciudades+1;
          REPEAT
                Write('Ingrese el codigo de la ciudad: ');
                Readln(cod_ciudad);
          UNTIL Bus_cod_ciu(cod_ciudad)=0; {valida que el codigo de ciudad sea unico}
          ciudades[c_ciudades,1]:=cod_ciudad;
          Write('Ingrese el nombre de la ciudad: ');
          Readln(ciudades[c_ciudades,2]);
          ordenar_ciudades();{despues de ingresar una nueva ciudad tengo que re ordenar el array}
          Mostrar_ciudades;
          ClrScr;
          Writeln('Presione 0 para dejar de ingresar ciudades o cualquier tecla para seguir');
          Readln(opcion);

     END;
     IF (max_ciu=c_ciudades)THEN
     BEGIN
          Writeln('Maximo de ciudades alcanzado');
          REadln();
    END;
END;
{PARTE EMPRESAS}
Function Bus_cod_em(ce:string):integer; {dado un codigo de empresa devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS SECUENCAL}
Var i:integer;
BEGIN
      i:=0;
      REPEAT
            i:=i+1;
      UNTIL (empresas[i,1]=ce) OR (i=(c_empresas-1));
      IF (empresas[i,1]=ce) AND (c_empresas<>1)THEN Bus_cod_em:=i
                                               ELSE Bus_cod_em:=0;
END;
Procedure Mostrar_empresas;{funcion auxiliar para mostrar empresas}
Var i:integer;
BEGIN
     ClrScr;
     Writeln('Empresas:');
     For i:= 1 to c_empresas do
          write(empresas[i,1],'   ', empresas[i,2], '  ', empresas[i,3], '  ', empresas[i,4], '  ', empresas[i,5], '  ', empresas[i,6]);
     Readln();
END;
Procedure Ciudad_mas_empresas;{muestra las ciudades con mas cantidad de empresas}
Var maximo,i:integer;
begin
maximo:=0;
for i := 1 to c_ciudades do  {esta parte es para saber cual es el maximo de empresas que hay en una ciudad}
  	begin
    		if (maximo<cont_ciu[i]) then
    					begin
      					maximo:=cont_ciu[i];
    					end;
  	end;
Writeln('La maxima cantidad de empresas que tiene una ciudad es de: ', maximo, '. Las ciudades que tienen dicha cantidad son: ');
for i:=1 to c_ciudades do {muestra todas las ciudades que tiene la cantidad maxima de empresas}
  				begin
    					if (cont_ciu[i]=maximo) then
    					begin
      					Writeln(ciudades[i,2]);
    					end;
end;
end;

Procedure Alta_empresas;{ingreso de empresas}
Var opcion:char;
    cod_ciudad:string[3];
BEGIN
     ClrScr;
     Writeln('Presione 0 para dejar de ingresar empresas');
     Readln(opcion);
     While (opcion<>'0') AND (max_e<>c_empresas) DO
           BEGIN
                c_empresas:=c_empresas+1;
                repeat
                      Writeln('Ingrese el codigo de la empresa: ');
                      Readln(empresas[c_empresas,1]);
                until Bus_cod_em(empresas[c_empresas,1])=0;{valida que el codigo de empresa sea unico}
                Writeln('Ingrese el nombre de la empresa: ');
                Readln(empresas[c_empresas,2]);
                Writeln('Ingrese direccion de la empresa: ');
                Readln(empresas[c_empresas,3]);
                Writeln('Ingrese el mail de la empresa: ');
                Readln(empresas[c_empresas,4]);
                Writeln('Ingrese el telefono de la empresa: ');
                Readln(empresas[c_empresas,5]);
                repeat
                      Writeln('Ingrese el codigo de la ciudad: ');
                      Readln(cod_ciudad);
                until Bus_cod_ciu(cod_ciudad)<>0; {valida que el codigo se ciudad sea uno existente}
                empresas[c_empresas,6]:=cod_ciudad;
                cont_ciu[Bus_cod_ciu(cod_ciudad)]:=cont_ciu[Bus_cod_ciu(cod_ciudad)]+1;{sumo 1 al contador de empresas de esa ciudad}
                Mostrar_empresas();{auxiliar}
                ClrScr;
                Writeln('Presione 0 para dejar de ingresar empresas');
                Readln(opcion);
           END;
     IF (max_e=c_empresas) THEN
                           Begin
                                Writeln('Maximo de empresas alcanzado');
                           End;
     Ciudad_mas_empresas();{llamada a funcion para mostrar las ciudades con mas empresas}
     REadln();
END;
{PARTE PROYECTOS}
Function Bus_cod_proy(cp:string):integer; {dado un codigo de proyecto devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS SECUENCAL}
var i:integer;
begin
i:=0;
repeat
    		i:=i+1;
until (proyectos[i,1]=cp) or (i=(c_proyectos-1));
 	if ((proyectos[i,1]=cp) and (c_proyectos<>1)) then Bus_cod_proy := i
        else Bus_cod_proy := 0;
end;
Procedure Alta_proy; {ingreso de proyectos}
Var opcion,i:Char;cod_ciudad:string[3];
BEGIN
     ClrScr;
     WRITELN('Presione 0 para dejar de ingresar proyectos');
     READLN(opcion);
     while (opcion<>'0') and (c_proyectos<>max_p) do
           begin
           c_proyectos:=c_proyectos+1;
           repeat
                 WRITELN('Ingrese codigo de proyecto');
                 READLN(proyectos[c_proyectos,1]);
           until Bus_cod_proy(proyectos[c_proyectos,1])=0; {valida que el codigo de proyecto sea unico}
           repeat
                 WRITELN('Ingrese el codigo de la empresa');
                 READLN(proyectos[c_proyectos,2]);
           until Bus_cod_em(proyectos[c_proyectos,2])<>0; {valida que el codigo de empresa exista}
           repeat
                 WRITELN('Ingrese la etapa del proyecto');
                 READLN(i);
           until (i='P') or (i='O') or (i='T');{valida la etapa}
           proyectos[c_proyectos,3]:= i;
           repeat
                 WRITELN('Ingrese el tipo de proyecto');
                 READLN(i);
           until (i='C') or (i='D') or (i='O') or (i='L');{valida el tipo}
           proyectos[c_proyectos,4] := i;
            repeat
                 WRITELN('Ingrese el codigo de la ciudad');
                 READLN(cod_ciudad);
           until Bus_cod_ciu(cod_ciudad)<>0; {valida que el codigo de ciudad exista}
           proyectos[c_proyectos,5]:=cod_ciudad;
           WRITELN('Ingrese la cantidad de productos del proyecto');
           READLN(pcant[c_proyectos]);
           ClrScr;
           WRITELN('Presione 0 para dejar de ingresar proyectos');
           READLN(opcion);
           end;
     if (max_p=c_proyectos) then WRITELN('Maximo de proyectos alcanzado');
END;
{PARTE PRODUCTOS}
Procedure Alta_prod;
BEGIN
     Writeln('En proceso');
END;
Procedure Menu_empresas;
Var opcion:char;
BEGIN
     REPEAT
           REPEAT
                 ClrScr;
                 Writeln('Menu empresas desarrolladoras'#13#10'Ingrese su opcion: '#13#10'1- Alta ciudades'#13#10'2-Alta empresas '#13#10'3-Alta proyectos'#13#10'4- Alta productos'#13#10'0- volver menu principal');
                 Readln(opcion);
           UNTIL(opcion>='0')AND(opcion<='4'); {valido opcion}
           CASE opcion OF
                '1': Alta_ciudades();
                '2': Alta_empresas();
                '3': ALta_proy();
                '4': ALTA_prod();
                ELSE
           END
     UNTIL(opcion ='0');
END;

{PARTE CLIENTES}
Procedure Alta_cliente;{ingreso de clientes}
Var opcion:char;

BEGIN
    ClrScr;
 	Writeln('Ingrese 0 para dejar de ingresar clientes');
 Readln(opcion);
 	While (opcion <> '0')and (max_cli<>c_clientes) do
		BEGIN
 			 c_clientes:=c_clientes+1;
 		 	Writeln('Ingrese nombre y apellido: ');
  			Readln(clientes[c_clientes,1]);
  			Writeln('Ingrese mail: ');
  			Readln(clientes[c_clientes,2]);
  			Write('Ingrese 0 para dejar de ingresar clientes');
  			Readln(opcion);
		END;
 	IF max_cli=c_clientes THEN Write('Maximo de clientes alcanzado');
END;

procedure Mostrar_etapa(etapa:string);{mustra segun la letra de la etapa la palabra correspondiente}
Var c:char;
BEGIN
c:=etapa[1];{como el case no se puede hacer con un string, y etapa es un string de una sola letra, se lo fuerza a ser char}
 Writeln('El estado de proyectos es: ');
 CASE c OF
      'P': Write('Preventa');
      'O': Write('Obras');
      'T': Write('Terminado');
 END
END;

Procedure Consulta_proyectos;{dado un tipo de proyecto muestra los proyectos de ese tipo}
var tipoproyecto:char;i,fila_em,fila_ciu:integer;
BEGIN
REPEAT
    ClrScr;
 	Write('Ingrese que tipo de proyecto desea conocer: ');
 	Readln(tipoproyecto);
 	UNTIL (tipoproyecto='C') OR (tipoproyecto='D') OR (tipoproyecto='O') OR (tipoproyecto='L');
 FOR i:=1 to (c_proyectos) do
     BEGIN
          IF (proyectos[i,4]) = (tipoproyecto)THEN
          BEGIN

              Writeln('Se encontro un proyecto del tipo deseado su codigo es: ',proyectos[i,1]);
              Mostrar_etapa(proyectos[i,3]);
              fila_em:=bus_cod_em(proyectos[i,2]); {te da la fila en la que se encontro el codigo de empresa en el array de empresas}
               Writeln('El nombre de la empresa es: ',empresas[fila_em,2]);{dada la fila de dicho codigo te muestra el nombre correspondiente}
               fila_ciu:=bus_cod_ciu(proyectos[i,5]);{te da la fila en la que se encontro el codigo de ciudad en el array de ciudaddes}
               Writeln('El nombre de la ciudad es: ',ciudades[fila_ciu,2]); {dada la fila de dicho codigo te muestra el nombre correspondiente}
          END;
    END;
END;
Procedure Menu_clientes;
Var opcion:char;
BEGIN
 REPEAT
		REPEAT
                ClrScr;
 			    Writeln('Menu clientes');
 			    Writeln('1. Alta de cliente');
                Writeln('2. Consulta de proyectos');
                Writeln('0. Volver al menu principal');
                Readln(opcion);
                UNTIL (opcion >= '0')OR(opcion <= '2');
        CASE opcion OF
             '1': Alta_cliente();
             '2': Consulta_proyectos();
  			ELSE
 		END
      UNTIL(opcion='0');
END;

BEGIN {Programa principal}
     Inicializar();
     REPEAT
           REPEAT
                 ClrScr;
                 writeln('Menu principal'#13#10'Ingrese:'#13#10'1-si es una empresa'+#13#10+'2-si es un cliente '+#13#10+'0-para salir');
                 readln(opcion);
           UNTIL (opcion>='0')AND (opcion<='2');
           CASE opcion OF
                '1': IF Ingreso_clave(clave_em)THEN Menu_empresas()
                                       ELSE writeln('Clave incorrecta');
                '2': IF Ingreso_clave(clave_cli)THEN Menu_clientes()
                                       ELSE writeln('Clave incorrecta');
                ELSE
           END
     UNTIL (opcion='0');
END.

