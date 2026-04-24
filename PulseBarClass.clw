    member()

    include('PulseBarClass.inc'),once
    map
    end

!==================================================================================================
PulseBarClass.Init      procedure(*WINDOW pWin, long pBaseX, long pBaseY)
!==================================================================================================
    code
    self.Win    &= pWin
    self.BaseX   = pBaseX
    self.BaseY   = pBaseY
    self.SetDefaults()
    self.Step    = 1

!==================================================================================================
PulseBarClass.SetDefaults procedure()
!  Asigna layout y colores por defecto
!==================================================================================================
    code
    self.BoxW        = 16
    self.BoxH        = 6
    self.Spacing     = 16
    self.BoxCount    = MAX_BOXES
    self.TimerInterval = 120

    ! "MAX_BOXES" tonos de verde
    self.BoxColor[1]  = 000A1F0AH
    self.BoxColor[2]  = 000F3310H
    self.BoxColor[3]  = 00144716H
    self.BoxColor[4]  = 001A5C1CH
    self.BoxColor[5]  = 00207222H
    self.BoxColor[6]  = 00278A29H
    self.BoxColor[7]  = 002EA330H
    self.BoxColor[8]  = 0035BB37H
    self.BoxColor[9]  = 003CD33EH
    self.BoxColor[10] = 004AE759H
    self.BoxColor[11] = 0071F07FH
    self.BoxColor[12] = 00A8F5B7H

!==================================================================================================
PulseBarClass.SetColors procedure( *long[] pArray, long pCount)
!  Permite asignar una paleta externa
!==================================================================================================
i   long
    code
    if pCount <= 0 OR pCount > MAX_BOXES
        return
    end

    self.BoxCount = pCount
    loop i = 1 TO pCount
        self.BoxColor[i] = pArray[i]
    end

!==================================================================================================
PulseBarClass.Start     procedure(long pTimerInterval)
!  Activa el TIMER y dibuja todo
!==================================================================================================
    code
    if pTimerInterval > 0
        self.TimerInterval = pTimerInterval
    end

    if not self.Win &= NULL
        self.Win{PROP:TIMER} = self.TimerInterval
    end

    self.Step = 1
    self.RedrawAll()
    self.HighlightStep(self.Step)

!==================================================================================================
PulseBarClass.Stop      procedure()
!==================================================================================================
    code
    if not self.Win &= NULL
        self.Win{PROP:TIMER} = 0
    end

!==================================================================================================
PulseBarClass.RedrawAll procedure()
!  Dibuja todos los cuadros con sus colores
!==================================================================================================
i   long
    code   
    loop i = 1 to self.BoxCount
        SetPenColor( Color:Black )
        Box( self.GetBoxX(i), self.BaseY, self.BoxW, self.BoxH, self.BoxColor[i] )
    end

!==================================================================================================
PulseBarClass.NextStep  procedure()
!  Avanza el pulso al siguiente cuadro
!==================================================================================================
    code
    if self.BoxCount <= 0
        return
    end
    self.Step = (self.Step % self.BoxCount) + 1
    self.HighlightStep(self.Step)

!==================================================================================================
PulseBarClass.HighlightStep procedure( long pIndex )
!  Resalta el cuadro actual y "apaga" el anterior
!==================================================================================================
prevIndex long
    code
    if pIndex < 1 or pIndex > self.BoxCount
        return
    end
    ! Calcula el índice anterior (con wrap-around)
    if pIndex = 1
        prevIndex = self.BoxCount
    else
        prevIndex = pIndex - 1
    end

    ! Cuadro actual: borde blanco
    SetPenColor(Color:White)
    Box(self.GetBoxX(pIndex), self.BaseY, self.BoxW, self.BoxH)

    ! Cuadro anterior: borde negro
    SetPenColor(Color:Black)
    Box(self.GetBoxX(prevIndex), self.BaseY, self.BoxW, self.BoxH)

!==================================================================================================
PulseBarClass.GetBoxX   procedure(long pIndex)!,long
!==================================================================================================
    code
    return self.BaseX + (pIndex * self.Spacing)

!==================================================================================================
PulseBarClass.TakeEvent procedure()!,byte
!  Llamar desde el ACCEPT cuando recibas EVENT:Timer.
!  Devuelve 1 si procesó el evento, 0 si no.
!==================================================================================================
    code
    if EVENT() = EVENT:Timer
        self.NextStep()
        return true
    END
    return 0

!==================================================================================================
PulseBarClass.Construct     procedure()
    code
    
!==================================================================================================
PulseBarClass.Destruct      procedure()
    code
    
!==================================================================================================
