! --------------------------------------------------------------------------------------------------
! CLASS : FiscalAuditDate
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalAuditDate_ )
_FiscalAuditDate_  EQUATE(1)

    include( 'FiscalCommand.inc' ),once

! --------------------------------------------------------------------------------------------------
! FiscalAuditDate : class()
! --------------------------------------------------------------------------------------------------
FiscalAuditDate             class(FiscalCommand),type,module( 'FiscalAuditDate.clw' ),link( 'FiscalAuditDate.clw' )
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