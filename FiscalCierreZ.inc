! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCmdCierreZ
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalCierreZ_ )
_FiscalCierreZ_  EQUATE(1)

    include( 'FiscalCommand.inc' ),once

! --------------------------------------------------------------------------------------------------
! FiscalCierreX : class()
! --------------------------------------------------------------------------------------------------
FiscalCierreZ               class(FiscalCommand),type,module( 'FiscalCierreZ.clw' ),link( 'FiscalCierreZ.clw' )
numero                          long,private
fecha                           long,private
! ----------------------------------------------------------------------------------
DF                              group,private
Total                               decimal(30,2)
TotalGravado                        decimal(30,2)
TotalNoGravado                      decimal(30,2)
TotalExento                         decimal(30,2)
TotalIVA                            decimal(30,2)
TotalTributos                       decimal(30,2)
CantidadEmitidos                    long
CantidadCancelados                  long
                                end !* group *
NC                              group,private
Total                               decimal(30,2)
TotalGravado                        decimal(30,2)
TotalNoGravado                      decimal(30,2)
TotalExento                         decimal(30,2)
TotalIVA                            decimal(30,2)
TotalTributos                       decimal(30,2)
CantidadEmitidos                    long
CantidadCancelados                  long
                                end !* group *
DNFH                            group,private
Total                               decimal(30,2)
CantidadEmitidos                    long
                                end !* group *
! ----------------------------------------------------------------------------------
SetNumero                       procedure( long _numero )
GetNumero                       procedure(),long
! ----------------------------------------------------------------------------------
SetFecha                        procedure( *cstring _fecha )
GetFecha                        procedure(),long
! ----------------------------------------------------------------------------------
GetDF_Total                     procedure(),real
GetDF_TotalGravado              procedure(),real
GetDF_TotalNoGravado            procedure(),real
GetDF_TotalExento               procedure(),real
GetDF_TotalIVA                  procedure(),real
GetDF_TotalTributos             procedure(),real
GetDF_CantidadEmitidos          procedure(),long
GetDF_CantidadCancelados        procedure(),long

GetNC_Total                     procedure(),real
GetNC_TotalGravado              procedure(),real
GetNC_TotalNoGravado            procedure(),real
GetNC_TotalExento               procedure(),real
GetNC_TotalIVA                  procedure(),real
GetNC_TotalTributos             procedure(),real
GetNC_CantidadEmitidos          procedure(),long
GetNC_CantidadCancelados        procedure(),long

GetDNFH_Total                   procedure(),real
GetDNFH_CantidadEmitidos        procedure(),long
! ----------------------------------------------------------------------------------
Encode                          procedure(),virtual
Decode                          procedure(),long,virtual
! ----------------------------------------------------------------------------------
Clean                           procedure(),private
! ----------------------------------------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
                            end !* class *

  _EndOfInclude_

!* end *