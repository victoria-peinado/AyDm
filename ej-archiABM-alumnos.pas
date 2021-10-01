program ejABMalumnos;
uses crt;
type
       notas= array[1..5]of real;
       unAlumno= RECORD
       Legajo: integer;
       NombApell: string[20];
       dni:string[8];
       Direccion:string[30];
       Carrera:char;
       N:Notas;
       prome:real;
      end;
       Alumnos= file of unAlumno;
   var
     Als:Alumnos;
     A,B:unAlumno;
     n1:integer;
     op,rta:char;
     acum:real;
     k, error,leg, i,j:integer;
     band2,band1,band:boolean;
     doc:string[8];
     inferior, superior, medio: integer;

function BuscaDico (L:integer):boolean;
begin
reset (Als);
 inferior:=0;
 superior:=filesize(Als)-1;
 band:= false;
 while (inferior<=superior) and (band=false) do
 begin
 medio:=(inferior+superior) div 2;
 seek(Als,medio);
 read(Als,A);
  if l=A.legajo
      then  band:=true
         else if l<A.legajo
         then superior:=medio-1
         else inferior:=medio+1;
 end;
 if band
 then buscaDico:= true
 else buscaDico:= false;
end;


procedure asignabre;
begin
assign (Als,'D:\AEDD\Alumnos.dat');    // asigno nombre de variable lógica del archivo con el lugar físico donde lo voy a guardar
{$I-}                            // anula la visión del error si no existe el archivo físico
reset(Als);                      // intento posicionarme al comienzo del archivo
if ioresult=2 then rewrite(Als); // si el resultado es distinto de cero, debe crearlo fisicamente porque no existe
              //else seek (Als, filesize(Als)); // si existe me posiciono al final del archivo
{$I+}                            // habilita nuevamente la función input output error.
end;

procedure Validar;
begin
band2:= false;
repeat
band1:= false;
repeat
{$i-}     //deshabilita mensajes de error
 repeat  write('ingrese Legajo entre 1000 y 9999 o-   0 SALE:  ');
    readln(leg);
 until  (ioresult =0 ); //controlo que ingrese un entero
 {$i+}
  if   ((leg <= 9999)AND (leg>= 1000))or (leg=0)
    then band1:= true;
until (band1) ;


//antes de cargar el registro con sus datos voy a buscar que no haya guardado antes el mismo legajo
// busqueda secuencial
 if leg <> 0
      then
      begin
      seek(Als,0);
    while (not Eof(Als)) and  (A.legajo <> Leg) do
    read(Als,A);
    if   A.legajo= Leg
         then
            begin writeln ('codigo existente, no puede ingresar otro alumno con el mismo Legajo');
                  band2:=false;
            end
         else band2:= true;
        end;
 if leg=0 then band2:= true;
until (band2= true);
end;

procedure altas;
begin
clrscr;
seek(Als,filesize(Als));   //paro el puntero al final del archivo
gotoxy(30,2); writeln ('Altas de registros de ALUMNOS nuevos');
gotoxy(30,3); writeln ('................................' );
writeln( );
validar;
while leg <>0 do
      begin
       write ('Ingrese Nombre y Apellido: ');
       readln (A.NombApell);
       repeat
        write('ingrese DNI:');// ingreso DNI y valido que sea numerico
        readln(doc);
        VAL(doc,n1,error);
        if error<> 0
           then
               begin
                    writeln ('hay un error en la posicion ',error, ' de la cadena numerica');
                    band:=false;
                end
                else
                begin
                A.dni:= doc;
                band:=true;
                end;
       until (band= true);
       write ('Ingrese Direccion: ');
       readln (A.Direccion);
       write ('Ingrese Carrera S-sistemas  Q-Quimica   C-Civil    M-Mecanica: ');
       repeat
          readln (A.carrera);
       until  ((A.carrera='S')or   (A.carrera='Q')or   (A.carrera='C')or (A.carrera='M')or
                  (A.carrera='s')or (A.carrera='q')or (A.carrera='c')or (A.carrera='m'));
      writeln ('Ingrese las 5 notas del parcial entre 1 y 10: ');
      acum:= 0;
      for k:= 1 to 5 do
          begin
             {$i-}
             repeat
             write ('NOTA ',k,' :'); readln (A.N[k]);
             until ( ioresult =0) and (A.N[k] >=1) AND (A.N[k] <=10);
            {$i+};
            acum:= acum +  A.N[k]
          end;
        A.prome:= acum/5;
        A.legajo:= leg;
      write(Als,A);  //grabo el registro completo en el archivo, el puntero ya lo posicioné antes al final del archivo
      writeln( );
      writeln( );
       validar;
     end;
end;
// * * * * * * * consulta  de un Alumno ingresado por teclado
procedure consultas;
begin
reset(Als);
clrscr;
gotoxy(30,2); writeln ('Consulta de un ALUMNO');
gotoxy(30,3); writeln ('......................' );
writeln( );
write('   Ingrese LEGAJO:  ');
readln(Leg);  //no lo valido porque ingrese cualquier nro de legajo igual lo tengo que buscar...
writeln ( );

while not (eof(Als)) and (leg <> A.legajo )do  // búsqueda SECUENCIAL
    // begin
      read (Als,A) ;  //tener en cuenta que el read me avanza solo el puntero
      //end;
if leg = A.legajo
     then
     begin
     writeln (' Legajo del Alumno: ', A.legajo);
                   writeln (' Nombre y Apellido:     ', A.NombApell);
                   writeln (' carrera que esta cursando:   ', A.carrera);
                   writeln (' Direccion : ', A.direccion);
                   for i:= 1 to 5 do
                        writeln ('  Nota',i,':', A.N[i]:0:2) ;
                   writeln (' Promedio :', A.Prome:0:2)
     end
      else
        begin write ('Alumno no encontrado');
               writeln( );
        end;
readln();
end;


// * * * * * * * modificacion DE UN CAMPO DEL REGISTRO
procedure modifica;
begin
clrscr;
gotoxy(30,2); writeln ('ACTUALIZAION de DIRECCION de UN ALUMNO');
gotoxy(30,3); writeln ('..................................'); //LO BUSCO, LO ENCUENTRO, MODIFICO, RETROCEDO  Y GRABO
writeln( );
write('  Ingrese Legajo entre 1000 y 9999  :');  // no lo valido porque si ingresa un numero incorrecto no lo va a encontrar
readln(leg);
reset (Als); //el puntero queda en el registro 0
while not(eof(Als))and (leg <> A.legajo) do      //búsqueda secuencial
      read (Als,A) ;
if (A.legajo=leg )
           then
              begin
                   writeln (' Legajo actual del Alumno: ', A.legajo);
                   writeln (' Nombre y Apellido:     ', A.NombApell);
                   writeln (' carrera actual que esta cursando:   ', A.carrera);
                   writeln ( );
                   writeln (' Direccion actual: ', A.Direccion);
                   writeln();
                   write (' Ingrese nueva direccion:     ');
                   readln(A.Direccion);
                   if filepos(Als) =0
                   then   begin
                   seek(Als,filesize(Als)-1);  //RETROCEDO EL PUNTERO desde el eof para atras
                   write(Als,A);  //GRABO LA MODIFICACIÓN
                   writeln();
                   writeln('      Registro modificado');
                   readln( );end
                   else     begin seek(Als,filepos(Als)-1);  //RETROCEDO EL PUNTERO desde donde está para atras
                   write(Als,A);  //GRABO LA MODIFICACIÓN
                   writeln();
                   writeln('      Registro modificado');
                   readln( ); end
             end
             else  begin write('legajo No encontrado');readln();end;
 end;

// * * * * * * * listado de ALUMNOS CON PROMEDIO MAYOR A 8
procedure listado;
begin
clrscr;
writeln ('Legajo      Nombre y Apellido   Promedio ');
writeln('------------------------------------------');
writeln( );
reset (Als);
while not (eof(Als)) do
     begin   //recorro todo el archivo
      read (Als,A) ;  //traigo el registro a memoria
      if A.prome > 8
        then
        writeln (' ',A.Legajo,'   ',A.NombApell:20,'  ',A.prome:0:2);
       end;
   readln();
end;

 // * * * * * * * listado de  todos los ALUMNOS
procedure Todos;
begin
clrscr;
writeln ('Reg  Legajo      Nombre y Apellido    Direccion   ');
writeln('------------------------------------------------------------');
writeln( );
reset (Als);
while not (eof(Als)) do
     begin   //recorro todo el archivo
      read (Als,A) ;
      //if  A.legajo <> 0 then //traigo el registro a memoria
      writeln (filepos(Als)-1,' ',A.Legajo,'   ',A.NombApell:20,'  ',A.direccion);
      end;
   readln();
end;

// * * * * * * * * * *  bajas logicas
procedure baja_logica;
begin
//reset(Als);
seek (Als,0);
clrscr;
gotoxy(30,2); writeln ('Bajas logicas de registros de Alumnos');
gotoxy(30,3); writeln ('_______________________________________' );
writeln( );

write('  Ingrese codigo entre 1000 y 9999:  ');
Readln (leg);
while not (eof(Als)) and (leg <> A.legajo )do  // búsqueda SECUENCIAL
    read (Als,A) ;
if eof(Als)and (A.legajo<> leg)
then
  begin
      writeln();
      write('   Legajo no encontrado');
      readln();
   end
   else
     begin  if (leg = A.legajo)
               then
                 begin
                   writeln ( );
                    writeln (' Legajo del Alumno: ', A.legajo);
                   writeln (' Nombre y Apellido:     ', A.NombApell);
                   writeln (' carrera que esta cursando:   ', A.carrera);
                   writeln ( );
                   writeln (' Direccion: ', A.direccion);
                   writeln (' Promedio de notas: ', A.prome:0:2);
                   writeln();
                   write ('Seguro desea dar de baja este registro?<S/N>: ');
                   repeat
                        read(rta);
                   until (rta='S')or  (rta='N') or (rta='s')or (rta='n');
                   if (rta = 'N') or (rta='n')
                    then  begin writeln();write('Tranquilo...No se efectivizo la baja'); readln();end
                    else  //rta es si
                    begin
                    //writeln('cantidad de reg:', filesize(Als));   readln();
                          //cambia el legajo por cero
                                         if (filepos(Als)=0)   //es fin de archivo
                                             then
                                              begin A.legajo :=0 ;
                                                   seek(Als,Filesize(Als)-1);
                                                   write(Als,A);
                                                   write('Registro dado de baja'); readln();
                                               end
                                               else // no es fin de archivo
                                                begin
                                                    A.legajo :=0 ; readln();
                                                    seek(Als,Filepos(Als)-1);
                                                    write(Als,A);
                                                    write('Registro dado de baja'); readln();
                                                end ;

                 end;
             end;
          end;
         readln();
End;

procedure ordena;
begin
reset (Als);
for i:= 0 to filesize(Als)-2 do
       for j := i+1 to filesize(Als)-1 do
          begin
          Seek (Als ,i  );
          READ (Als, A);
          Seek (Als , j );
          READ (Als, B);
          if A.legajo  > B.legajo
              then
                  begin
                     Seek (Als ,i  );
                     Write (Als, B);
                     Seek (Als , j );
                     write (Als, A);
                   end;
         end;
end;
 procedure pruebadico;
 begin
  clrscr;
 band:= false;
 repeat
{$i-}     //deshabilita mensajes de error
 repeat
 writeln();
 write('       Ingrese Legajo entre 1000 y 9999  :');
    readln(leg);
 until  (ioresult =0 ); //controlo que ingrese un entero
 {$i+}
  if   (leg <= 9999)AND (leg>= 1000)
    then band:= true;
  until band= true;
//antes de cargar el registro con sus datos voy a buscar que no haya guardado antes el mismo legajo
// busqueda dicotomica
ordena; // para hacer dicotomica tiene que estar ordenado
   if buscaDico(Leg)
      then
      begin writeln();writeln('   El legajo esta en el registro nro:', medio, 'y el puntero esta en el registro:', Filepos(Als));end
      else  begin writeln();writeln('     El legajo no existe');end;
readln();
end;



BEGIN
asignabre;
repeat
      textcolor(15);
      textbackground(1);
      clrscr;
      gotoxy (10,2); writeln ('MENU DE OPCIONES ');
      gotoxy (10,3); writeln ('------------------');
      gotoxy (12,5); writeln ('1- Nuevas Altas');
      gotoxy (12,6); writeln ('2- Consultas');
      gotoxy (12,7); writeln ('3- Modifica direccion');
      gotoxy (12,8); writeln ('4- Listado de promedios mayor a 8');
      gotoxy (12,9); writeln ('5- Listado de todos los alumnos');
      gotoxy (12,10); writeln ('6- Baja Logica colocando ceros');
      gotoxy (12,11); writeln ('7- listado ordenado por nro de legajo');
      gotoxy (12,12); writeln ('8- ordena y busca Dicotomica(Prueba)');
      gotoxy (12,13); writeln ('0- Fin');
      gotoxy (12,14); write ('Ingrese su Opcion:  ');
      repeat
            readln (op)
      until (op>= '0')  and (op<='8');
      case op of
           '1': altas;
           '2': consultas;
           '3': modifica ;
           '4': listado;
           '5': Todos;
           '6': baja_logica;
           '7': begin ordena; Todos;end;
           '8': PruebaDico;
           '0': close(Als);   //cierro el archivo antes de salir
      end;
 until op = '0';
END.

