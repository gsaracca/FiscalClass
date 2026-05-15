! --------------------------------------------------------------------------------------------------
! CLASS : FiscalOrchestra
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _PulseBarClass_ )
_PulseBarClass_     EQUATE(1)

MAX_BOXES           equate(12)

PulseBarClass       class,type,module( 'PulseBarClass.clw' ),link( 'PulseBarClass.clw' )
Win                     &Window                 ! Ventana donde dibuja
BoxColor                long,dim(MAX_BOXES)     ! Colores de fondo
BoxCount                long                    ! Cantidad de cuadros (1..12)
BaseX                   long        ! X base
BaseY                   long        ! Y base
BoxW                    long        ! Ancho del cuadro
BoxH                    long        ! Alto del cuadro
Spacing                 long        ! Separación entre cuadros
Step                    long        ! Paso actual (1..BoxCount)
TimerInterval           long        ! Intervalo del TIMER (ms)

Init                    procedure( *Window pWin, long pBaseX, long pBaseY )
SetDefaults             procedure()                 ! Layout y colores por defecto
SetColors               procedure( *long[] pArray, long pCount )
Start                   procedure( long pTimerInterval )
Stop                    procedure()
RedrawAll               procedure()
NextStep                procedure()
HighlightStep           procedure(long pIndex)
GetBoxX                 procedure(long pIndex),long
TakeEvent               procedure(),byte            ! Llamar desde el ACCEPT (EVENT:Timer)

Construct               procedure()
Destruct                procedure()
                    end !* class *

_EndOfInclude_