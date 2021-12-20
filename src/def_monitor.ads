package def_monitor is

    protected type BaboonsMonitor is
      entry bnNthLock;
      procedure bnNthUnlock;
      entry bnSthLock;
      procedure bnSthUnlock;
   private
      MaxBaboons: constant := 3;
      counterNorth : integer := 0;
      counterSouth : integer := 0;
    end BaboonsMonitor;

end def_monitor;
