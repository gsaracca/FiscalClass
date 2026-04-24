! -----------------------------------------------------------------------------
! CLASS : TLogFiscal
! -----------------------------------------------------------------------------

  OMIT('_EndOfInclude_', _TLOG_FISCAL_ )
_TLOG_FISCAL_   EQUATE(1)

FiscalLog       class(),type,module( 'FiscalLog.clw' ),link( 'FiscalLog.clw' )
log_on              long,private
fname               cstring(1000),private

SetFileName         procedure( string _fname )
GetFileName         procedure(),string
SetOn               procedure( long _on )
GetOn               procedure(),long

init                procedure()
open                procedure()
writeTimeStamp      procedure(),private
write               procedure( *cstring _log )
write               procedure( string _log )
close               procedure()
            end !* class *
       
  _EndOfInclude_
  
!* end *