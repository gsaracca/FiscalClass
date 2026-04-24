! --------------------------------------------------------------------------------------------------
! CLASS : FiscalAuditNumber
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalAuditNumber_ )
_FiscalAuditNumber_  EQUATE(1)

    include( 'FiscalCommand.inc' ),once

! --------------------------------------------------------------------------------------------------
! FiscalAuditNumber : class()
! --------------------------------------------------------------------------------------------------
FiscalAuditNumber           class(FiscalCommand),type,module( 'FiscalAuditNumber.clw' ),link( 'FiscalAuditNumber.clw' )
desde                           long,private
hasta                           long,private
is_detallado                    long,private

SetDesde                        procedure( long _desde )
SetHasta                        procedure( long _hasta )
SetDetallado                    procedure( long _detallado )
GetDetallado                    procedure(),string,private

Encode                          procedure(),virtual
Decode                          procedure(),long,virtual

Construct                       procedure()
Destruct                        procedure()
                            end !* class *

  _EndOfInclude_

!* end *