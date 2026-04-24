! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCierreX
!
! Gustavo Saracca (c) - 2025
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalCierreX_ )
_FiscalCierreX_  EQUATE(1)

    include( 'FiscalCommand.inc' ),once
    
FiscalCierreX               class(FiscalCommand),type,module( 'FiscalCierreX.clw' ),link( 'FiscalCierreX.clw' )
numero                          long,private
fecha_inicio                    long,private
hora_inicio                     long,private
fecha_cierre                    long,private
hora_cierre                     long,private
! ----------------------------------------------------------------------------------
SetNumero                       procedure( long _numero )
GetNumero                       procedure(),long
! ----------------------------------------------------------------------------------
SetFechaInicio                  procedure( *cstring _fecha )
GetFechaInicio                  procedure(),long
! ----------------------------------------------------------------------------------
SetHoraInicio                   procedure( *cstring _hora )
GetHoraInicio                   procedure(),long
! ----------------------------------------------------------------------------------
SetFechaCierre                  procedure( *cstring _fecha )
GetFechaCierre                  procedure(),long
! ----------------------------------------------------------------------------------
SetHoraCierre                   procedure( *cstring _hora )
GetHoraCierre                   procedure(),long
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