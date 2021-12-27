with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with def_monitor;
use def_monitor;

-- Compilar: gnatmake main.adb | .\main.exe

procedure Main is
   THREADS : constant integer := 10;        -- Numero de babuinos "total"
   MAX_PASS : constant integer := 3;        -- Numero de veces que un babuino pasa por la cuerda
   MIN_RANDOM: constant integer := 5;       -- Minimo valor aleatorio
   MAX_RANDOM: constant integer := 10;      -- Maximo valor aleatorio 

   -- Random number generator
   -- Use: Random(G)
   subtype RANDOM_RANGE is Integer range MIN_RANDOM .. MAX_RANDOM;

   package R is new
      Ada.Numerics.Discrete_Random (RANDOM_RANGE);
   use R;
   G : Generator;

   -- Tipo protegido para las tareas
   cuerda: BaboonsMonitor; --

   -- Init task
   task type babuino is
      entry Start(idx : in integer);
   end babuino;

   -- Task body
   task body babuino is
      My_Idx : integer;    -- Thread number 
      zona : integer;      -- 0: Norte, 1: Sur
      velocidad : integer; -- Velocidad del babuino

   begin
      accept Start (Idx : in integer) do
         My_Idx := Idx;
      end Start;

      -- Velocidad del babuino
      velocidad := Random(G);

      -- Declarar si eres babuino del norte o del sur  
      zona := 0;
      if (My_Idx <= THREADS / 2) then
         zona := 1;
      end if;

      -- Presentacion
      if (zona = 0) then
         Put_Line("Soy el Babuino"&My_Idx'img&" y vengo del NORTE, velocidad: "&velocidad'img);
      else
         Put_Line("   Soy el Babuino"&My_Idx'img&" y vengo del SUR, velocidad: "&velocidad'img);
      end if; 
      
      -- Pasadas de un babuino por la cuerda  
      for pass in 1..MAX_PASS loop
         -- Pasar por la cuerda 
         if (zona = 0) then
            -- Babuino del norte
            cuerda.bnNthLock;
            
            -- Cruzar
            delay(Duration(velocidad));

            cuerda.bnNthUnlock;
            Put_Line("Norte" & My_Idx'Img & " he llegado");
            
         else
            -- Babuino del sur
            cuerda.bnSthLock;

            -- Cruzar
            delay(Duration(velocidad));

            cuerda.bnSthUnLock;
            Put_Line("   Sur" & My_Idx'Img & " he llegado");
             
         end if;

         -- Volver a la zona correspondiente - delay
         delay(Duration(velocidad));
         if (zona = 0) then
            if (pass = MAX_PASS) then
               Put_Line("Norte"&My_Idx'img&": hace la vuelta"& pass'Img &" y acaba!!");
            else 
               Put_Line("Norte"&My_Idx'img&": vuelta"& pass'Img &" /"&MAX_PASS'Img);
            end if;

         else
            Put_Line("   Sur"&My_Idx'img&": vuelta"& pass'Img &" /"&MAX_PASS'Img);
         end if; 

      end loop; 
  end babuino;

   -- Array de babuinos
   type baboon_array is array (1..THREADS) of babuino;
   baboons: baboon_array;


begin
   Reset(G); -- Reset de la seed de los valores aleatorios 
   for Idx in 1..THREADS loop
      baboons(Idx).Start(Idx);
   end loop;


end Main;
