package body def_monitor is

   protected body BaboonsMonitor is
    entry bnNthLock when (counterSouth = 0) and (counterNorth < MaxBaboons) is
    begin
      counterNorth := counterNorth + 1;
    end bnNthLock;

    procedure readerUnlock is
    begin
      counterNorth := counterNorth - 1;
    end readerUnlock;

    entry bnSthLock when (counterNorth = 0) and (counterSouth < MaxBaboons) is
    begin
      counterSouth := counterSouth + 1;
    end bnSthLock;

    procedure bnSthUnlock is
    begin
      counterSouth := counterSouth - 1;
    end bnSthUnlock;

  end BaboonsMonitor;

end def_monitor;
