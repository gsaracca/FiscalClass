! -------------------------------------------------------------------------------------------------
! CLASS : Fiscal
! -------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalInicializacion_ )
_FiscalInicializacion_    EQUATE(1)

    include( 'FiscalCommand.inc' ),once

FiscalInicializacion        class(FiscalCommand),type,module( 'FiscalInicializacion.clw' ),link( 'FiscalInicializacion.clw' )
CUIT                            cstring(64),private
RazonSocial                     cstring(256),private
Serial                          cstring(64),private
Prefijo                         long,private
fecha_inicio                    long,private
fecha_inicio_completa           long,private
iibb                            cstring(64),private
iva                             cstring(64),private
! -------------------------------------------------------------------------------------------------
GetCUIT                         procedure(),string
GetRazonSocial                  procedure(),string
GetSerial                       procedure(),string
GetPrefijo                      procedure(),long
GetFechaInicio                  procedure(),long
GetIIBB                         procedure(),string
GetIVA                          procedure(),string
GetFechaCompleta                procedure(),long
! -------------------------------------------------------------------------------------------------
Encode                          procedure(),protected,virtual
Decode                          procedure(),long,protected,virtual
! -------------------------------------------------------------------------------------------------
Clean                           procedure(),private
! -------------------------------------------------------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
                            end !* 

_EndOfInclude_
