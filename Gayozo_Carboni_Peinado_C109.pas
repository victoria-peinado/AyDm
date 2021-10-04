{Gayozo Alejandro,Carboni Daniel,Peinado Victoria. Todos comision 109}
program ordenarCadena(input,output);
uses crt;
Const
{CLAVES}
clave_em='Hola123';
clave_cli='soy cliente';
TYPE
// tipos recod y file para ciudad
ciudad = record
              cod_ciudad: string[3];
              nombre: string[25];
              cant_e:integer;
        end;
ciudades = file of ciudad;
// tipos de datos para empresa
empresa = record
               cod_emp:string[3];
               nombre:string[25];
               mail:string[25];
               direccion:string[25];
               telefono:string[25];
               cod_ciudad:string[3];
         end;
empresas = file of empresa;
//tipos de datos para proyectos
proyecto = record
                 cod_proy:string[3];
                 cod_emp:string[3];
                 cod_ciudad:string[3];
                 etapa:char;
                 tipo:char;
                 cant: array[1..3]of integer;
           end;
proyectos = file of proyecto;
// tipos de datos para clientes
cliente = record
                dni:string[8];
                nombre:string[25];
                mail:string[25];
          end;
clientes= file of cliente;
VAR
{CREACION ARRAYS}
// variables para ciudad
ciu:ciudad;
aciu:ciudades;
//variables para empresa
e:empresa;
ae:empresas;
// variavles para proyecto
py:proyecto;
apy:proyectos;
// variavles para clientes
cli:cliente;
acli:clientes;
//opcion del menu
opcion:char;

Procedure Inicializar; {asigna y abre archivos, tambien limpia contadores}
BEGIN
     assign(aciu,'C:\TP3\CIUDADES.DAT');
     assign(ae,'C:\TP3\EMPRESAS-CONSTRUCTORAS.DAT');
     assign(apy,'C:\TP3\PROYECTOS.DAT');
     assign(acli,'C:\TP3\CLIENTES.DAT');
     {$I-} // abro archivos y si no existen los creo
           reset(aciu);
           if ioresult= 2 then rewrite (aciu);
           reset(ae);
           if ioresult= 2 then rewrite(ae);
           reset(apy);
           if ioresult= 2 then rewrite(apy);
           reset(acli);
           if ioresult= 2 then rewrite(acli);
     {$I+}
END;
Function ingreso_clave(clave:string):boolean; {dado un strin que es la clave correcta te devuelve true si se ngresa correctamente, se tienen 3 intentos}
Var c:char;
    intento_clave:string;
    cont,i:integer;
BEGIN
     cont:=0;{contador de intentos}
     REPEAT
           i:= 0;
           ClrScr;
           intento_clave:=''; {inicializamos la clave como un string vacio}
           Write('Ingrese la clave: ');
           c:= readkey;
           While c<>#13 do {mientras que el caracter ingressado no sea enter}
           BEGIN
                if (c=#8) and (i>0) then Begin
                                   i:=i-1;
                                    GotoXY(Wherex-1,Wherey);
                                    Write(' ');
                                   intento_clave:=copy(intento_clave,1,i);
                                    GotoXY(Wherex-1,Wherey);
                              End
                         else if(c<>#8) then Begin
                              intento_clave:=intento_clave+c;{le agregamos a intento el caracter ingresado}
                              Write('*');
                              i:=i+1;

                              end;
                 c:=readkey;
           END;
           Writeln;
           cont:=cont+1
     UNTIL(clave=intento_clave)OR (cont>=3);
     ingreso_clave:=(clave=intento_clave); {se asingna True si clave=intento_clave, o False en caso contrario}
END;
{PARTE CIUDADES}
Procedure ordenar_ciudades;{ordena ciudades de menor a mayor y deja los vacios al final}
Var i,j:integer;
    aux:ciudad; //registro axiliar para poder ordena

BEGIN
     seek(aciu,0);//apunto al inicio
     FOR i:= 0 to filesize(aciu)-2 do
         FOR j:=i+1 to filesize(aciu)-1 do
         BEGIN
              seek(aciu,i);
              read(aciu,ciu);
              seek(aciu,j);
              read(aciu,aux);
              IF ciu.cod_ciudad > aux.cod_ciudad THEN
              BEGIN
               seek(aciu,i);
               write(aciu,aux);
               seek(aciu,j);
               write(aciu,ciu);
             END;
         END;
END;

Procedure Mostrar_ciudades;{funcion axiliar para ver que todo anduvo bien en el ordenamiento}
BEGIN
     ClrScr;
     seek(aciu,0);
     Writeln('Ciudades ordenadas');
     writeln('Codigo  Nombre');
     while not(eof(aciu))do
     BEGIN
          read(aciu,ciu);
          writeln(ciu.cod_ciudad,'     ',ciu.nombre);
     END;
     Readln();
END;
Function Bus_cod_ciu(cc: string):integer; {dado un codigo de ciudad devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS DICOTOMICA}
Var q:boolean;
    comi,fin,medio:integer;
BEGIN
     q:=FALSE;
     comi:=0;
     medio:=0;
     fin:=filesize(aciu)-1;
     While (comi<=fin)and (q=false)do
     BEGIN
           medio:=(comi+fin)DIV 2;
           seek(aciu,medio);
           read(aciu,ciu);
           IF ciu.cod_ciudad=cc THEN q:=TRUE
                                   ELSE IF ciu.cod_ciudad>cc THEN fin:=medio-1
                                                                ELSE comi:=medio+1;
     END;
     IF q THEN Bus_cod_ciu:=medio+1 ELSE Bus_cod_ciu:=0 //te devuelve la pos+1 ya que el 0 es no se encontro
END;
Procedure Alta_ciudades;{ingreso de ciudades}
Var cod_ciudad:string[3];
BEGIN
     seek(aciu,filesize(aciu));//puntero al final del archivo
     ClrScr;
     REPEAT
           Write('Ingrese el codigo de la ciudad: ');
           Readln(cod_ciudad);
     UNTIL (cod_ciudad='0')or(Bus_cod_ciu(cod_ciudad)=0); {valida que el codigo de ciudad sea unico}
     While (cod_ciudad <>'0') do
     BEGIN
          ciu.cod_ciudad:=cod_ciudad;
          Write('Ingrese el nombre de la ciudad: ');
          Readln(ciu.nombre);
          write(aciu,ciu);
          ordenar_ciudades();{despues de ingresar una nueva ciudad tengo que re ordenar el array}
          Mostrar_ciudades; {auxiliar muestra las ciudades ordenadas}
          ClrScr;
          REPEAT
                Write('Ingrese el codigo de la ciudad: ');
                Readln(cod_ciudad);
          UNTIL (cod_ciudad='0')or(Bus_cod_ciu(cod_ciudad)=0); {valida que el codigo de ciudad sea unico}
     END;
END;
{PARTE EMPRESAS}
Function Bus_cod_em(ce:string):integer; {dado un codigo de empresa devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS SECUENCAL}
BEGIN
     seek(ae,0);
     While not (eof(ae)) and (ce<>e.cod_emp) do
           read(ae,e);

     IF (filesize(ae)=0) THEN Bus_cod_em:=0
                         ELSE IF ce=e.cod_emp THEN Bus_cod_em:=filepos(ae)
                                              ELSE Bus_cod_em:=0;
END;
Procedure Mostrar_empresas;{funcion auxiliar para mostrar empresas}
BEGIN
     ClrScr;
     seek(ae,0);
     Writeln('Listado Empresas');
     Writeln('Codigo Nombre Codigo_Ciudad');
     while not(eof(ae))do
     BEGIN
          read(ae,e);
          writeln(e.cod_emp,'  ',e.nombre,'  ',e.cod_ciudad);
     END;
     Readln();
END;
(*Procedure Ciudad_mas_empresas;{muestra las ciudades con mas cantidad de empresas}
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
end;*)

Procedure Alta_empresas;{ingreso de empresas}
Var
    aux:string[3];
BEGIN
     seek(ae,filesize(ae)); //puntero al final del archivo
     ClrScr;
     repeat
           Writeln('Ingrese el codigo de la empresa o 0 para salir: ');
           Readln(aux);
     until (aux='0')or (Bus_cod_em(aux)=0);{valida que el codigo de empresa sea unico}
     While (aux<>'0')DO
           BEGIN
                e.cod_emp:=aux;
                Writeln('Ingrese el nombre de la empresa: ');
                Readln(e.nombre);
                Writeln('Ingrese direccion de la empresa: ');
                Readln(e.direccion);
                Writeln('Ingrese el mail de la empresa: ');   //falta validar
                Readln(e.mail);
                Writeln('Ingrese el telefono de la empresa: ');
                Readln(e.telefono);
                repeat
                      Writeln('Ingrese el codigo de la ciudad: ');
                      Readln(aux);
                until Bus_cod_ciu(aux)<>0; {valida que el codigo se ciudad sea uno existente}
                e.cod_ciudad:=aux;
                write(ae,e);                        //guardo todo en el archivo empresas
                //seek(aciu,Bus_cod_ciu(aux)-1);//traigo la ciudad a memoria
                //read(aciu,ciu);
                ciu.cant_e:=ciu.cant_e+1;
                seek(aciu,filepos(aciu)-1);
                write(aciu,ciu);                     //guardo la ciudad con su registro editado
                Mostrar_empresas();{funcion auxiliar para mostrar las empresa}
                ClrScr;
                repeat
                      Writeln('Ingrese el codigo de la empresa o 0 para salir: ');
                      Readln(aux);
                until (aux='0')or (Bus_cod_em(aux)=0);{valida que el codigo de empresa sea unico}
           END;
END;
{PARTE PROYECTOS}
Function Bus_cod_proy(cp:string):integer; {dado un codigo de proyecto devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS SECUENCAL}
begin
     seek(apy,0);
     while not(eof(apy)) and (cp<>py.cod_proy) do
           read(apy,py);
     if filesize(apy)=0 then Bus_cod_proy:=0
                        else if cp=py.cod_proy then Bus_cod_proy:=filepos(ae)
                                               else Bus_cod_proy:=0;
end;
Procedure Mostrar_proyectos;{funcion auxiliar para mostrar proyectos}
BEGIN
     ClrScr;
     seek(apy,0);
     Writeln('Proyectos:');
     writeln('Codigo  Tipo  Etapa  Cod_E  Cod_ciu Cant');
     while not(eof(apy))do
     BEGIN
          read(apy,py);
          writeln(py.cod_proy,'       ',py.tipo,'   ',py.etapa,'  ',py.cod_emp,'  ',py.cod_ciudad,'   ',py.cant[1]);
     END;
     Readln();
END;
Procedure Alta_proy; {ingreso de proyectos}
Var i:Char;aux:string[3];
BEGIN
     ClrScr;
     seek(apy,filesize(apy));
     repeat
           WRITELN('Ingrese codigo de proyecto o 0 para salir');
           READLN(aux);
     until (aux='0') or (Bus_cod_proy(aux)=0); {valida que el codigo de proyecto sea }
     while (aux<>'0')  do
           begin
           py.cod_proy:=aux;
           repeat
                 WRITELN('Ingrese el codigo de la empresa');
                 READLN(aux);
           until Bus_cod_em(aux)<>0; {valida que el codigo de empresa exista}
           py.cod_emp:=aux;
           repeat
                 WRITELN('Ingrese la etapa del proyecto');
                 READLN(i);
                 i:=Upcase(i);
           until (i='P') or (i='O') or (i='T');{valida la etapa}
           py.etapa:= i;
           repeat
                 WRITELN('Ingrese el tipo de proyecto');
                 READLN(i);
                 i:=Upcase(i);
           until (i='C') or (i='D') or (i='O') or (i='L');{valida el tipo}
           py.tipo := i;
            repeat
                 WRITELN('Ingrese el codigo de la ciudad');
                 READLN(aux);
           until Bus_cod_ciu(aux)<>0; {valida que el codigo de ciudad exista}
           py.cod_ciudad:=aux;
           WRITELN('Ingrese la cantidad de productos del proyecto');
           READLN(py.cant[1]);
           write(apy,py);
           Mostrar_proyectos();{funcion auxiliar que muestras los proyectos}
           ClrScr;
           repeat
                 WRITELN('Ingrese codigo de proyecto o 0 para salir');
                 READLN(aux);
           until (aux='0') or (Bus_cod_proy(aux)=0); {valida que el codigo de proyecto sea }
     
           end;
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
                 Writeln('Menu empresas desarrolladoras'#13#10'Ingrese su opcion: '#13#10'1- Alta ciudades'#13#10'2- Alta empresas '#13#10'3- Alta proyectos'#13#10'4- Alta productos'#13#10'0- volver menu principal');
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
Procedure Mostrar_clientes;{funcion auxiliar para mostrar clientes}
BEGIN
     ClrScr;
     seek(acli,0);
     Writeln('Clientes:');
     while not(eof(acli))do
     begin
           read(acli,cli);
           writeln(cli.dni,'  ',cli.nombre,'  ',cli.mail)
     end;
     Readln();
END;
Procedure Alta_cliente;{ingreso de clientes}
BEGIN
    ClrScr;
    seek(acli,filesize(acli));
    writeln('Ingrese su DNI o = para salir');
    readln(cli.dni);                           //validar DNI
 	While cli.dni <> '0' do
		BEGIN
 		 	Writeln('Ingrese nombre y apellido: ');
  			Readln(cli.nombre);
  			Writeln('Ingrese mail: ');
  			Readln(cli.mail);
            write(acli,cli);
            Mostrar_clientes();{fincion auxiliar para mostrar clientes}
            ClrScr;
            writeln('Ingrese su DNI o = para salir');
            readln(cli.dni);                           //validar DNI
		END;
END;

procedure Mostrar_etapa(c:char);{mustra segun la letra de la etapa la palabra correspondiente}
BEGIN
 Writeln('El estado de proyectos es: ');
 CASE c OF
      'P': Writeln('Preventa');
      'O': Writeln('Obras');
      'T': Writeln('Terminado');
 END
END;

Procedure Consulta_proyectos;{dado un tipo de proyecto muestra los proyectos de ese tipo}
var tipoproyecto:char;fila_em,fila_ciu:integer;
BEGIN
     seek(apy,0);
     REPEAT
           ClrScr;
           Write('Ingrese que tipo de proyecto desea conocer: ');
           Readln(tipoproyecto);
           tipoproyecto:=Upcase(tipoproyecto);
     UNTIL (tipoproyecto='C')  OR (tipoproyecto='D') OR (tipoproyecto='O') OR (tipoproyecto='L') ;
     while not(eof(apy)) do
     BEGIN
          read(apy,py);
          IF  py.tipo= (tipoproyecto)THEN
          BEGIN

              Writeln('Se encontro un proyecto del tipo deseado su codigo es: ',py.cod_proy);
              Mostrar_etapa(py.etapa);
              fila_em:=bus_cod_em(py.cod_emp); {te da la fila en la que se encontro el codigo de empresa en el array de empresas}
              seek(ae,fila_em-1);
              read(ae,e);
              Writeln('El nombre de la empresa es: ',e.nombre);{dada la fila de dicho codigo te muestra el nombre correspondiente}
              fila_ciu:=bus_cod_ciu(py.cod_ciudad);{te da la fila en la que se encontro el codigo de ciudad en el array de ciudaddes}
              seek(aciu,fila_ciu-1);
              read(aciu,ciu);
              Writeln('El nombre de la ciudad es: ',ciu.nombre); {dada la fila de dicho codigo te muestra el nombre correspondiente}

          END;

    END;
    Readln();
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
     TextBackGround (1);
     TextColor (15);
     Inicializar();
     REPEAT
           REPEAT
                 ClrScr;
                 writeln('Menu principal'#13#10'Ingrese:'#13#10'1- Si es una empresa'+#13#10+'2- Si es un cliente '+#13#10+'0- Salir');
                 readln(opcion);
           UNTIL (opcion>='0')AND (opcion<='2');
           CASE opcion OF
                '1': IF Ingreso_clave(clave_em)THEN Menu_empresas()
                                       ELSE
                                           BEGIN
                                                 TextColor (12);
                                                 writeln('Clave incorrecta');
                                                 readln();
                                                 TextColor (15);
                                           END;
                '2': IF Ingreso_clave(clave_cli)THEN Menu_clientes()
                                       ELSE
                                           BEGIN
                                                TextColor (12);
                                                writeln('Clave incorrecta');
                                                readln();
                                                TextColor (15);
                                           END;
                '0':begin
                         close(aciu);
                         close(ae);
                    end;
           END
     UNTIL (opcion='0');
END.

