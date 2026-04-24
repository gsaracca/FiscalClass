! --------------------------------------------------------------------------------------------------
! CLASS : FiscalErrors
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalErrors_ )
_FiscalErrors_  EQUATE(1)
   
! --------------------------------------------------------------------------------------------------
! FiscalErrors : class()
! --------------------------------------------------------------------------------------------------
TQerrors                    queue,type
error_id                        cstring(64)
error_desc                      cstring(256)
                            end !* queue *

FiscalErrors                class(),type,module( 'FiscalErrors.clw' ),link( 'FiscalErrors.clw' )
Qerrors                         &TQerrors,private
AddError                        procedure( string _error_id, string _error_desc ),private
clean                           procedure(),private
GetErrorDesc                    procedure( string _error_id ),string
init                            procedure()
done                            procedure()
                            end !* class *                               

    _EndOfInclude_
    
!* end *