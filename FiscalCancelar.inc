! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCancelar
!
! Gustavo Saracca (c) - 2025
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalCancelar_ )
_FiscalCancelar_   EQUATE(1)

    include( 'FiscalCommand.inc' ),once
    
FiscalCancelar      class(FiscalCommand),type,module( 'FiscalCancelar.clw' ),link( 'FiscalCancelar.clw' )
! ----------------------------------------------------------------------------------
Encode                  procedure(),virtual
Decode                  procedure(),long,virtual
! ----------------------------------------------------------------------------------
Clean                   procedure(),private
! ----------------------------------------------------------------------------------
Construct               procedure()
Destruct                procedure()
! ----------------------------------------------------------------------------------
                    end !* class *


_EndOfInclude_