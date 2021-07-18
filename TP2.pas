program ordenarCadena(input,output);
uses crt;
Const
clave_em='hola123';
clave_cli='soy cliente';
max_ciu=5;
max_e=10;
max_p=20;
max_cli=10;
TYPE
empr=array[1..max_e,1..6]of string[20];
ciu=array[1..max_ciu,1..2] of string[20];
cli=array[1..max_cli,1..2]of string[20];
proy=array[1..max_p,1..5]of string[10];
proy_cant=array[1..max_p]of integer;
ciu_cont=array[1..max_ciu]of integer;
VAR
empresas:empr;
ciudades:ciu;
clientes:cli;
proyectos:proy;
pcant:proy_cant;
cont_ciu:ciu_cont;{array con la cantidad empresas por ciudad}
c_empresas,c_ciudades,c_proyectos,c_clientes:integer;
opcion:char;
Procedure Inicializar;
Var i:integer;
BEGIN
     c_empresas:=0;
     c_ciudades:=0;
     c_proyectos:=0;
     c_clientes:=0;
     FOR i:= 1 to max_ciu DO cont_ciu[i]:=0;

END;
Function ingreso_clave(clave:string):boolean;
Var c:char;
    intento_clave:string;
    cont:integer;
BEGIN
     cont:=0;
     REPEAT
           ClrScr;
           intento_clave:='';
           Write('Ingrese la clave: ');
           c:= readkey;
           While c<>#13 do
           BEGIN
                intento_clave:=intento_clave+c;
                Write('*');
                c:=readkey
           END;
           Writeln;
           cont:=cont+1
     UNTIL(clave=intento_clave)OR (cont>=3);
     ingreso_clave:=(clave=intento_clave);
END;
Procedure ordenar_ciudades;
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
Function Bus_cod_ciu(cc: string):integer;
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
Procedure Alta_ciudades;
Var cod_ciudad:string[3];
    opcion:char;
BEGIN
     ClrScr;
     Writeln('Presione 0 para dejar de ingresar ciudades o cualquier tecla para seguir');
     Readln(opcion);
     While opcion <>'0' do
     BEGIN
          c_ciudades:=c_ciudades+1;
          REPEAT
                Write('Ingrese el codigo de la ciudad: ');
                Readln(cod_ciudad);
          UNTIL Bus_cod_ciu(cod_ciudad)=0;
          ciudades[c_ciudades,1]:=cod_ciudad;
          Write('Ingrese el nombre de la ciudad: ');
          Readln(ciudades[c_ciudades,2]);
          ordenar_ciudades();
          ClrScr;
          Writeln('Presione 0 para dejar de ingresar ciudades o cualquier tecla para seguir');
          Readln(opcion);

     END;
END;
Procedure Alta_empresas;
BEGIN

END;
Procedure Alta_proy;
BEGIN

END;
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
           UNTIL(opcion>='0')AND(opcion<='4');
           CASE opcion OF
                '1': Alta_ciudades();
                '2': Alta_empresas();
                '3': ALta_proy();
                '4': ALTA_prod();
                ELSE
           END
     UNTIL(opcion ='0');
END;

Procedure Menu_clientes;
BEGIN
END;
BEGIN
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

