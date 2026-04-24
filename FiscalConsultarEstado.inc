! --------------------------------------------------------------------------------------------------
! CLASS : FiscalConsultarEstado
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalConsultarEstado_ )
_FiscalConsultarEstado_ EQUATE(1)

    include( 'FiscalCommand.inc' ),once

! --------------------------------------------------------------------------------------------------
! FiscalConsultarEstado : class()
! --------------------------------------------------------------------------------------------------
FiscalConsultarEstado       class(FiscalCommand),type,module( 'FiscalConsultarEstado.clw' ),link( 'FiscalConsultarEstado.clw' )
comprobante                     cstring(64),private
EstadoInterno                   cstring(64),private
ComprobanteEnCurso              cstring(64),private
CodigoComprobante               cstring(64),private
NumeroUltimoComprobante         long,private
CantidadEmitidos                long,private
CantidadCancelados              long,private

SetComprobante                  procedure( string _comprobante )
GetComprobante                  procedure(),string

GetEstadoInterno                procedure(),string
GetComprobanteEnCurso           procedure(),string
GetCodigoComprobante            procedure(),string
GetNumeroUltimoComprobante      procedure(),long
GetCantidadEmitidos             procedure(),long
GetCantidadCancelados           procedure(),long
! ----------------------------------------------------------------------------------
Encode                          procedure(),protected,virtual
Decode                          procedure(),long,protected,virtual
! ----------------------------------------------------------------------------------
Clean                           procedure(),private
! ----------------------------------------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
                            end !* class *

  _EndOfInclude_

!* end *