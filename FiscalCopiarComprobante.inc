! --------------------------------------------------------------------------------------------------
! CLASS : Fiscal
!
! Gustavo Saracca (c) - 2026
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalCopiarComprobante_ )
_FiscalCopiarComprobante_   EQUATE(1)

    include( 'FiscalCommand.inc' ),once
    
FiscalCopiarComprobante class(FiscalCommand),type,module( 'FiscalCopiarComprobante.clw' ),link( 'FiscalCopiarComprobante.clw' )
CodigoComprobante       cstring(64),private
NumeroComprobante       long,private
! ----------------------------------------------------------------------------------
SetComprobante          procedure( string _comprobante )
GetComprobante          procedure(),string

SetNumero               procedure( long _numero )
GetNumero               procedure(),long
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