{Gayozo Alejandro,Carboni Daniel,Peinado Victoria. Todos comision 109}
program ordenarCadena(input,output);
uses crt;
Const
{CLAVES}
clave_em='Hola123';
clave_cli='Soy cliente';
TYPE
// tipos recod y file para ciudad
ciudad = record
              cod_ciudad: string[3];
              nombre: string[25];
              cant_e:integer;
              cant_c:integer;
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
               cant:integer;
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
//tipos de datos para productos
producto = record
                 cod_prod:string[3];
                 cod_proy:string[3];
                 precio:string[8];
                 estado:boolean;
                 detalle:string;
           end;
productos = file of producto;
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
//variables para droductos
pd:producto;
apd:productos;
//opcion del menu
opcion:char;
n1,error:integer;

Procedure Inicializar; {asigna y abre archivos, tambien limpia contadores}
BEGIN
     assign(aciu,'C:\TP3\CIUDADES.DAT');
     assign(ae,'C:\TP3\EMPRESAS-CONSTRUCTORAS.DAT');
     assign(apy,'C:\TP3\PROYECTOS.DAT');
     assign(acli,'C:\TP3\CLIENTES.DAT');
     assign(apd,'C:\TP3\PRODUCTOS.DAT');
     {$I-} // abro archivos y si no existen los creo
           reset(aciu);
           if ioresult= 2 then rewrite (aciu);
           reset(ae);
           if ioresult= 2 then rewrite(ae);
           reset(apy);
           if ioresult= 2 then rewrite(apy);
           reset(acli);
           if ioresult= 2 then rewrite(acli);
           reset(apd);
           if ioresult= 2 then rewrite(apd);
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
                TextBackGround (0);
                TextColor (6);
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
          TextBackGround (0);
          TextColor (6);
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
Function Bus_cod_ciu(cc: string[3]):integer; {dado un codigo de ciudad devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS DICOTOMICA}
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
          TextBackGround (0);
          TextColor (6);
     REPEAT
           Write('Ingrese el codigo de la ciudad o 0 para salir: ');
           Readln(cod_ciudad);
     UNTIL (cod_ciudad='0')or(Bus_cod_ciu(cod_ciudad)=0); {valida que el codigo de ciudad sea unico}
     While (cod_ciudad <>'0') do
     BEGIN
          ciu.cod_ciudad:=cod_ciudad;
          Write('Ingrese el nombre de la ciudad: ');
          Readln(ciu.nombre);
          ciu.cant_e:=0;
          ciu.cant_c:=0;
          write(aciu,ciu);
          ordenar_ciudades();{despues de ingresar una nueva ciudad tengo que re ordenar el array}
          Mostrar_ciudades; {auxiliar muestra las ciudades ordenadas}
          ClrScr;
               TextBackGround (0);
               TextColor (6);
          REPEAT
                Write('Ingrese el codigo de la ciudad: ');
                Readln(cod_ciudad);
          UNTIL (cod_ciudad='0')or(Bus_cod_ciu(cod_ciudad)=0); {valida que el codigo de ciudad sea unico}
     END;
END;







{PARTE EMPRESAS}
Function Bus_cod_em(ce:string[3]):integer; {dado un codigo de empresa devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS SECUENCAL}
BEGIN
     IF (filesize(ae)=0) THEN Bus_cod_em:=0
     else Begin
               seek(ae,0);
               read(ae,e);
               While not (eof(ae)) and (ce<>e.cod_emp) do
                     read(ae,e);
               IF ce=e.cod_emp THEN Bus_cod_em:=filepos(ae)
                                              ELSE Bus_cod_em:=0;
          end
END;
Function existeme(me:string):boolean;
var aux:empresa;
BEGIN
     IF (filesize(ae)=0) THEN existeme:=false
     else Begin
                seek(ae,0);
                read(ae,aux);
                While not (eof(ae)) and (me<>aux.mail) do
                      read(ae,aux);
                IF me=aux.mail THEN existeme:=true
                          ELSE existeme:=false;
          end;

END;




Procedure Mostrar_empresas;{funcion auxiliar para mostrar empresas}
BEGIN
     ClrScr;
          TextBackGround (0);
          TextColor (6);
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
    mail:string;
BEGIN

     ClrScr;
          TextBackGround (0);
          TextColor (6);
     repeat
           Writeln('Ingrese el codigo de la empresa o 0 para salir: ');
           Readln(aux);
     until (aux='0')or (Bus_cod_em(aux)=0);{valida que el codigo de empresa sea unico}
     While (aux<>'0')DO
           BEGIN
                e.cod_emp:=aux;
                GotoXY(50, 8); WRITELN('--------------------------------');
                GotoXY(50, 9);Writeln('Ingrese el nombre de la empresa: ');
                GotoXY(50, 10); WRITELN('--------------------------------');
                Readln(e.nombre);
                GotoXY(50, 12); WRITELN('--------------------------------');
                GotoXY(50, 13);Writeln('Ingrese direccion de la empresa: ');
                GotoXY(50, 14); WRITELN('--------------------------------');
                Readln(e.direccion);
                GotoXY(50, 16); WRITELN('--------------------------------');
                GotoXY(50, 17);Writeln('Ingrese el mail de la empresa: ');   //falta validar
                GotoXY(50, 18); WRITELN('--------------------------------');
                Repeat
                      Readln(mail);
                      If (existeme(mail)=true)
                                             Then Writeln('Ingrese un mail no registrado');
                Until (existeme(mail)=false);
                e.mail:=mail;
                GotoXY(50, 20); WRITELN('--------------------------------');
                GotoXY(50, 21);Writeln('Ingrese el telefono de la empresa: ');
                GotoXY(50, 22); WRITELN('--------------------------------');
                Readln(e.telefono);
                repeat
                      Writeln('Ingrese el codigo de la ciudad: ');
                      Readln(aux);
                until Bus_cod_ciu(aux)<>0; {valida que el codigo se ciudad sea uno existente}
                e.cod_ciudad:=aux;
                e.cant:=0;
                seek(ae,filesize(ae)); //puntero al final del archivo
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
Function Bus_cod_proy(cp:string[3]):integer; {dado un codigo de proyecto devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS SECUENCAL}
begin
     IF (filesize(apy)=0) THEN Bus_cod_proy:=0
     else Begin
               seek(apy,0);
               read(apy,py);
               While not (eof(apy)) and (cp<>py.cod_proy) do
                     read(apy,py);
               IF cp=py.cod_proy THEN Bus_cod_proy:=filepos(apy)
                                              ELSE Bus_cod_proy:=0;
          end
end;
Procedure Mostrar_proyectos;{funcion auxiliar para mostrar proyectos}
BEGIN
     ClrScr;
          TextBackGround (0);
          TextColor (6);
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
Var i:Char;aux:string[3];cantidades:string;error:integer;
BEGIN
     ClrScr;
          TextBackGround (0);
          TextColor (6);
     seek(apy,filesize(apy));
     repeat
           GotoXY(55, 7);WRITELN('Ingrese codigo de proyecto o 0 para salir');
           READLN(aux);
     until (aux='0') or (Bus_cod_proy(aux)=0); {valida que el codigo de proyecto sea }
     while (aux<>'0')  do
           begin
           py.cod_proy:=aux;
           repeat
                GotoXY(50, 9); WRITELN('--------------------------------');
                GotoXY(50, 10); WRITELN('Ingrese el codigo de la empresa');
                GotoXY(50, 11); WRITELN('--------------------------------');
                 READLN(aux);
           until Bus_cod_em(aux)<>0; {valida que el codigo de empresa exista}
           py.cod_emp:=aux;
           repeat
                 GotoXY(50, 9); WRITELN('--------------------------------');
                 GotoXY(50, 10);WRITELN('Ingrese la etapa del proyecto');
                 GotoXY(50, 11); WRITELN('--------------------------------');
                 READLN(i);
                 i:=Upcase(i);
           until (i='P') or (i='O') or (i='T');{valida la etapa}
           py.etapa:= i;
           repeat
                 GotoXY(50, 9); WRITELN('--------------------------------');
                 GotoXY(50, 10);WRITELN('Ingrese el tipo de proyecto');
                 GotoXY(50, 11); WRITELN('--------------------------------');
                 READLN(i);
                 i:=Upcase(i);
           until (i='C') or (i='D') or (i='O') or (i='L');{valida el tipo}
           py.tipo := i;
            repeat
                 GotoXY(50, 9); WRITELN('--------------------------------');
                 GotoXY(50, 10); WRITELN('Ingrese el codigo de la ciudad');
                 GotoXY(50, 11); WRITELN('--------------------------------');
                 READLN(aux);
           until Bus_cod_ciu(aux)<>0; {valida que el codigo de ciudad exista}
           py.cod_ciudad:=aux;
           repeat
                 GotoXY(50, 9); WRITELN('--------------------------------');
                 GotoXY(50, 10);WRITELN('Ingrese la cantidad de productos del proyecto');
                 GotoXY(50, 11); WRITELN('--------------------------------');
                 READLN(cantidades);
                 val(cantidades,py.cant[1],error);
           until error=0;
           py.cant[2]:=0;
           py.cant[3]:=0;
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
Function Bus_cod_prod(cp:string):integer; {dado un codigo de producto devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS SECUENCAL}
begin
     IF (filesize(apd)=0) THEN Bus_cod_prod:=0
     else Begin
               seek(apd,0);
               read(apd,pd);
               While not (eof(apd)) and (cp<>pd.cod_prod) do
                     read(apd,pd);
               IF cp=pd.cod_prod THEN Bus_cod_prod:=filepos(apd)
                                              ELSE Bus_cod_prod:=0;
          end
end;
Procedure Mostrar_productos;{funcion auxiliar para mostrar productos}
Var aux:string[10];
BEGIN
     ClrScr;
     TextBackGround (0);
     TextColor (6);
     seek(apd,0);
     Writeln('Productos:');
     writeln('Codigo  Codigo_proy  Precio  Estado ');
     while not(eof(apd))do
     BEGIN
          read(apd,pd);
          if(pd.estado)
                       then aux:='Vendido'
                       else aux:='Disponible';
          writeln(pd.cod_prod,'      ',pd.cod_proy,'       ',pd.precio,'   ',aux);
     END;
     Readln();
END;
Function vali_proy(cp:string[3]):boolean; {dado un codigo de proyecto devuelve la "fila" en la que se encontro, o 0 si no se encontro.BUS SECUENCAL}
Var c:integer;
begin
     c:=0;
     if(Bus_cod_proy(cp))<>0
         then
             begin
                  // py.cant[1]= cant productos
                  if(filesize(apd)=0)and (py.cant[1]<> 0)
                     then vali_proy:=true
                     else if(py.cant[1]=0)then vali_proy:=false
                                               else begin
                                                         seek(apd,0);
                                                         read(apd,pd);
                                                         if (pd.cod_proy = cp)then c:=c+1; 

                                                         while not(eof(apd)) and (c<py.cant[1]) do
                                                               begin  
                                                                      read(apd,pd);
                                                                      if (pd.cod_proy = cp)then c:=c+1;
                                                               end;
                                                         if c<py.cant[1] then vali_proy:=true
                                                            else begin
                                                                      writeln('Este proyecto no tiene mas productos disponibles');
                                                                      vali_proy:=false;
                                                                  end;
                                                    end;
             end
                              else begin writeln('No existe un proyecto con dicho codigo'); vali_proy:=false;end;
end;
Procedure Alta_prod; {ingreso de productos}
Var i:string[8];aux,aux1:string[3];num:integer;
BEGIN
     ClrScr;
     TextBackGround (0);
     TextColor (6);
     repeat
           WRITELN('Ingrese codigo de producto o 0 para salir');
           READLN(aux1);
     until (aux1='0') or (Bus_cod_prod(aux1)=0);
     while (aux1<>'0')  do
           begin

                repeat
                  pd.cod_prod:=aux1;    WRITELN('Ingrese el codigo del proyecto');
                      READLN(aux);
                until (vali_proy(aux));
                pd.cod_prod:=aux1;
                pd.cod_proy:=aux;
                repeat
                      WRITELN('Ingrese el precio');
                      READLN(i);
                      val(i,num,error);
                until error=0;{valida que sea un numero}
                pd.precio:= i;
                pd.estado:=false;
                WRITELN('Ingrese la descripcion del producto');
                READLN(pd.detalle);
                seek(apd,filesize(apd));
                write(apd,pd);
                Mostrar_productos();{funcion auxiliar que muestras los productos}
                ClrScr;
                repeat
                      WRITELN('Ingrese codigo de producto o 0 para salir');
                      READLN(aux1);
                until (aux1='0') or (Bus_cod_prod(aux1)=0);
           end;
END;
Procedure Estadisticas();
Var aux:integer;
begin ClrScr;
     Writeln('Las empresas con consultas mayores a 10 fueron');
     writeln('Codigo Nombre');
     seek(ae,0);
     while not(eof(ae))do
           begin
                read(ae,e);
                if(e.cant>= 10)
                   then Writeln(e.cod_emp,'      ',e.nombre);
           end;
     readkey;ClrScr;
     Writeln('La ciudad/es con mas consultas es/son:  ');
     if(filesize(aciu)=0)then writeln('No hay ninguna ciudad cargada')
        else
            begin
                 seek(aciu,0);
                 read(aciu,ciu);
                 aux:=ciu.cant_c;
                 While not(eof(aciu))do
                       begin
                            read(aciu,ciu);
                            if(ciu.cant_c > aux)then aux:=ciu.cant_c;
                       end;
                 seek(aciu,0);
                 While not(eof(aciu))do
                       Begin
                            read(aciu,ciu);
                            if(ciu.cant_c=aux) then Writeln(ciu.nombre,'(',ciu.cod_ciudad,')');
                       end;
                writeln('La cantidad de consultas es :',aux);
            end;
     readkey;ClrScr;
     Writeln('Los proyectos que vendieron todos los productos son: ');
     writeln('Codigo Cant_productos');
     seek(apy,0);
     while not(eof(apy))do
           begin
                read(apy,py);
                if(py.cant[1]=py.cant[3])then
                writeln(py.cod_proy,'       ',py.cant[1]);
           end;

     readkey;ClrScr;
end;
Procedure Menu_empresas;
Var opcion:char;
BEGIN
     REPEAT
           REPEAT
                 ClrScr;
                 TextBackGround (0);
                 TextColor (6);
                 Writeln('Menu empresas desarrolladoras'#13#10'Ingrese su opcion: '#13#10'1- Alta ciudades'#13#10'2- Alta empresas '#13#10'3- Alta proyectos'#13#10'4- Alta productos'#13#10'5- Estadisticas '#13#10'0- volver menu principal');
                 Readln(opcion);
           UNTIL(opcion>='0')AND(opcion<='5'); {valido opcion}
           CASE opcion OF
                '1': Alta_ciudades();
                '2': Alta_empresas();
                '3': ALta_proy();
                '4': ALTA_prod();
                '5': Estadisticas();
                ELSE
           END
     UNTIL(opcion ='0');
END;

{PARTE CLIENTES}
Function existe(d:string):boolean; //funcion que se fija si existe un cliente daddo un dni
BEGIN
     IF (filesize(acli)=0) THEN existe:=false else
     begin
          seek(acli,0);
          read(acli,cli);
          While not (eof(acli)) and (d<>cli.dni) do
                 read(acli,cli);
          IF d=cli.dni THEN existe:=true
                       ELSE existe:=false;
    end
END;
Function existemc(mc:string):boolean; //funcion que se fija se ya existe un cliente con el dni
var aux:cliente;
BEGIN
     IF (filesize(acli)=0) THEN existemc:=false else
     begin
          seek(acli,0);
          read(acli,aux);
          While not (eof(acli)) and (mc<>aux.mail) do
                read(acli,aux);
          IF mc=aux.mail THEN existemc:=true
                         ELSE existemc:=false;
     end
END;
Function validarnumero (doc:string):boolean;//valida que un numero sea un entero
Begin
validarnumero:=false;
VAL(doc,n1,error);
                  If error<>0
                     Then validarnumero:=false
                     else validarnumero:=true;
end;

Procedure Mostrar_clientes;{funcion auxiliar para mostrar clientes}
BEGIN
     ClrScr;
     TextBackGround (0);
     TextColor (6);
     seek(acli,0);
     Writeln('Clientes:');
     while not(eof(acli))do
     begin
           read(acli,cli);
           writeln(cli.dni,'  ',cli.nombre,'  ',cli.mail)
     end;
     Readln();
END;
procedure Mostrar_etapa(c:char);{mustra segun la letra de la etapa la palabra correspondiente}
BEGIN
 Write('La etapa de proyectos es: ');
 CASE c OF
      'P': Writeln('Preventa');
      'O': Writeln('Obras');
      'T': Writeln('Terminado');
 END;
END;
Procedure Mostrar_prod_proy(cp:string);
begin
     seek(apd,0);
     ClrScr;
     Writeln('PRODUCTOS del proyecto ', cp,' :');
     while not(eof(apd))do
     begin
          read(apd,pd);
          if(pd.cod_proy=cp)AND not(pd.estado)
          then begin
                    Writeln('Codigo del producto: ',pd.cod_prod);
                    Writeln('Caracteristicas: ',pd.detalle);
                    writeln('Precio: ',pd.precio);
                    writeln();
               end;

     end;
end;
Procedure Consulta_proyectos;{dado un tipo de proyecto muestra los proyectos de ese tipo}
var tipoproyecto:char;fila_em,fila_ciu:integer;aux:string[3];
BEGIN
     seek(apy,0);
     REPEAT
           ClrScr;
           TextBackGround (0);
           TextColor (6);
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
              writeln();

          END;

    END;
    repeat
    writeln('Ingrese el codigo del proyecto que desea consultar o 0 para salir');
    readln(aux);
    until (Bus_cod_proy(aux)<>0) or (aux='0') ;
    if (aux<>'0') then
    begin
    Mostrar_prod_proy(aux);
    fila_em:=bus_cod_em(py.cod_emp); {te da la fila en la que se encontro el codigo de empresa en el array de empresas}
    seek(ae,fila_em-1);
    read(ae,e);
    fila_ciu:=bus_cod_ciu(py.cod_ciudad);{te da la fila en la que se encontro el codigo de ciudad en el array de ciudaddes}
    seek(aciu,fila_ciu-1);
    read(aciu,ciu);

    //suma 1 a cant de consultas y lo graba
    py.cant[2]:=py.cant[2]+1;
    seek(apy,filepos(apy)-1);
    write(apy,py);
    //suma 1 cant de consultas empresa y lo graba
    e.cant:=e.cant+1;
    seek(ae,filepos(ae)-1);
    write(ae,e);
    //suma 1 cant de consultas ciudades y lo graba
    ciu.cant_c:=ciu.cant_c+1;
    seek(aciu,filepos(aciu)-1);
    write(aciu,ciu);
    Readln();
    end;
END;
Procedure Venta();
var aux:string[3];opcion:char;
Begin
     repeat
           writeln('Ingrese el codigo del producto a compar o 0 para salir');
           readln(aux);
     until (Bus_cod_prod(aux)<>0) or (aux='0');
     if (aux<>'0')then
     begin
     if(pd.estado)then writeln('Ese producto ya se encuentra vendido')
     else
         begin
              writeln('Detalle: ',pd.detalle);
              writeln('Precio: ',pd.precio);
              writeln();
              writeln('Si desea confirmar la compra presione 1');
              readln(opcion);
              if opcion='1' then begin
                                      Writeln('COMPRA CONFIRMADA.');
                                      writeln('Le llegara al mail:  ',cli.mail);
                                      readkey;
                                      pd.estado:=true;
                                      seek(apd,filepos(apd)-1);
                                      write(apd,pd);
                                      if (Bus_cod_proy(pd.cod_proy)<>0)
                                         then begin
                                                   py.cant[3]:=py.cant[3]+1;
                                                   seek(apy,filepos(apy)-1);
                                                   write(apy,py);
                                              end;
                                 end;
         end;
     end;
End;
Procedure Menu_clientes2();
Var opcion:char;
Begin
 REPEAT
		REPEAT
                ClrScr;
                TextBackGround (0);
                TextColor (6);
                GotoXY(55, 5); Writeln('Bienbenido ',cli.nombre,'  !!');
                GotoXY(55,6); Writeln('Ingrese su opcion');
                GotoXY(50, 7); Writeln('------------------------');
                GotoXY(50,8); Writeln('a. Consulta de Proyecto');
                GotoXY(50,9); Writeln('------------------------');
                GotoXY(50,10); Writeln('b. Comprar Producto');
                GotoXY(50,11); Writeln('------------------------');
                GotoXY(50,12); Writeln('0. Volver al alta de clientes');
                GotoXY(50,13);Readln(opcion);
                opcion:=Upcase(opcion);
                UNTIL (opcion = '0')OR(opcion >= 'A')OR(opcion <= 'B');
        CASE opcion OF
             'A': Consulta_proyectos();
             'B': Venta();
  			ELSE
 		END
      UNTIL(opcion='0');
end;
Procedure Alta_cliente;{ingreso de clientes}
Var mail:string;
doc:string[8];
BEGIN
error:=error;
    ClrScr;
     TextBackGround (0);
     TextColor (6);

    Repeat
          writeln('Ingrese su DNI o "0" para salir:');// ingreso DNI y valido que sea numerico
          readln(doc);
          If not(validarnumero(doc))
                                    Then Writeln('hay un error en la posicion ',error, ' de la cadena numerica');
    Until (validarnumero(doc));

    While (doc<>'0') do
          BEGIN
               If existe(doc)Then menu_clientes2()
                  else
                  begin
                       cli.dni:= doc;
                       Writeln('Ingrese nombre y apellido: ');
                       Readln(cli.nombre);
                       Writeln('Ingrese mail: ');
                       Repeat
                             Readln(mail);
                             If (existemc(mail)=true)
                                                   Then Writeln('Ingrese un mail no registrado');
                       Until (existemc(mail)=false);
                       cli.mail:=mail;
                       seek(acli,filesize(acli));
                       write(acli,cli);
                       Mostrar_clientes();{fincion auxiliar para mostrar clientes}
                   end;
                       ClrScr;
                       Repeat
                             writeln('Ingrese su DNI o "0" para salir:');// ingreso DNI y valido que sea numerico
                             readln(doc);
                             If not(validarnumero(doc))
                                    Then Writeln('hay un error en la posicion ',error, ' de la cadena numerica');
                       Until (validarnumero(doc));


          end;
END;
Procedure Menu_clientes;
Var opcion:char;
BEGIN
 REPEAT
		REPEAT
                ClrScr;
                TextBackGround (0);
                TextColor (6);
 			   GotoXY(55, 5); Writeln('MENU CLIENTES');
               GotoXY(50, 6); Write('------------------------');
 			   GotoXY(50, 7); Writeln('1. Alta de cliente');
               GotoXY(50, 8); Write('------------------------');
               GotoXY(50, 9); Writeln('0. Volver al menu principal');
                Readln(opcion);
                UNTIL (opcion >= '0')OR(opcion <= '1');
        CASE opcion OF
             '1': Alta_cliente();
  			ELSE
 		END
      UNTIL(opcion='0');
END;

BEGIN {Programa principal}
     TextBackGround (0);
     TextColor (6);
     Inicializar();
     REPEAT
           REPEAT
                 ClrScr;
                 GotoXY(55, 7); write('MENU PRINCIPAL');
                 GotoXY(50, 9); Write('------------------------');
                 GotoXY(50, 10); Write('1- Empresa');
                 GotoXY(50, 11); Write('------------------------');
                 GotoXY(50, 12); Write('2- Clientes');
                 GotoXY(50, 13); Write('------------------------');
                 GotoXY(50, 14); Write('0- Salir');
                 GotoXY(50, 15); Write('------------------------');
                 GotoXY(50, 16); Write('Elija una opcion:');
                 GotoXY(50, 17); Write('------------------------');

                 GotoXY(60, 18);readln(opcion);
           UNTIL (opcion>='0')AND (opcion<='2');

        DelLine;
        GotoXY(50,30); Write('CARGANDO.../');
        delay(350);
        DelLine;
        GotoXY(50,30); Write('CARGANDO...-');
        delay(350);
        DelLine;
        GotoXY(50,30); Write('CARGANDO...\');
        delay(350);
        DelLine;
        GotoXY(50,30); Write('CARGANDO...|');
        delay(350);





           CASE opcion OF
                '1': IF Ingreso_clave(clave_em)THEN Menu_empresas()

                                       ELSE
                                           BEGIN
                                                 TextColor (12);
                                                 writeln('Clave incorrecta');
                                                 readln();
                                                 TextColor (6);
                                           END;
                '2': IF Ingreso_clave(clave_cli)THEN Menu_clientes()
                                       ELSE
                                           BEGIN
                                                TextColor (12);
                                                writeln('Clave incorrecta');
                                                readln();
                                                TextColor (6);
                                           END;
                '0':begin
                         close(aciu);
                         close(ae);
                         close(apy);
                         close(acli);
                         close(apd);
                    end;
           END
     UNTIL (opcion='0');
END.

