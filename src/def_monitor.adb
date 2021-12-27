with Ada.Text_IO; use Ada.Text_IO;
package body def_monitor is

   protected body BaboonsMonitor is

    entry bnNthLock when (counterSouth = 0) and (counterNorth < MaxBaboons) is
    begin
      counterNorth := counterNorth + 1;
      Put_Line("***** En la cuerda hay" & counterNorth'Img & " direccion Sud *****");
    end bnNthLock;

    procedure bnNthUnlock is
    begin
      counterNorth := counterNorth - 1;
    end bnNthUnlock;

    entry bnSthLock when (counterNorth = 0) and (counterSouth < MaxBaboons) is
    begin
      counterSouth := counterSouth + 1;
      Put_Line("+++++ En la cuerda hay" & counterSouth'Img &" direccion Norte +++++");
    end bnSthLock;

    procedure bnSthUnlock is
    begin
      counterSouth := counterSouth - 1;
    end bnSthUnlock;

  end BaboonsMonitor;

end def_monitor;
