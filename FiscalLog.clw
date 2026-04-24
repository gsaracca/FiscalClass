    member()

    include( 'FiscalLog.inc' ),once

    map
    end !* map *

fiscal_log          file,driver('ascii','/CLIP=on'),create
record                  record
line                        string(4000)
                        end !* record
                    end !* file *

FiscalLog.SetFileName   procedure( string _fname )
iToday      long
iYear       long
iMonth      long
    code
    iToday = today()
    iYear = year( iToday )
    iMonth = Month( iToday )

    self.fname = clip(_fname) & |
                    '_' & format( iYear,  @n04 ) & |
                    '_' & format( iMonth, @n02 ) & '.log'
                    
FiscalLog.GetFileName   procedure()!,string
    code
    return self.fname

FiscalLog.SetOn procedure( long _on )
    code
    self.log_on = _on
    
FiscalLog.GetOn procedure()!,long
    code
    return self.log_on

FiscalLog.init procedure()
    code
    self.SetOn( false )

FiscalLog.open   procedure()
    code
    if self.GetOn() 
        fiscal_log{ prop:name } = self.GetFileName()
        if not exists( self.GetFileName() )
            create( fiscal_log )
        end !* if *
        open( fiscal_log )
    end !* if *

FiscalLog.WriteTimeStamp  procedure()
    code
    clear( fiscal_log.record )
    fiscal_log.line = format(today(),@d06) & '-' & format(clock(),@T04)
    add( fiscal_log )

FiscalLog.write  procedure( *cstring _log )
    code
    if self.GetOn()
        self.WriteTimeStamp()

        clear( fiscal_log.record )
        fiscal_log.line = clip(_log)
        add( fiscal_log )
    end !* if *

FiscalLog.write procedure( string _log )
    code
    if self.GetOn()
        self.WriteTimeStamp()

        clear( fiscal_log.record )
        fiscal_log.line = clip(_log)
        add( fiscal_log )
    end !* if *

FiscalLog.close  procedure()
    code
    if self.GetOn()
        close(fiscal_log)
    end !* if *

!* end *