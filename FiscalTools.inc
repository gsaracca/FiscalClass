! --------------------------------------------------------------------------------------------------
! CLASS : FiscalOrchestra
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalTools_ )
_FiscalTools_       EQUATE(1)

FiscalTools     class(),module( 'FiscalTools.clw' ),link( 'FiscalTools.clw' )
get_cmd_zona            procedure( string _zona, long _linea, string _text, long _flags ),string    
                end !* class *
                
! ----------------------|
!   IdentificadorZona:  |
! ----------------------|
!   ZonaFantasia        |
!   ZonaDomicilioEmisor |
!   Zona1Encabezado     |
!   Zona2Encabezado     |
!   Zona1Cola           |
!   Zona2Cola           |
! ----------------------|

! ------------------------------------------------------------------|
!   Atributos Identificador Bit Descripción:                        |
! ------------------------------------------------------------------|
!   BorradoTexto    | 1 |   Borrado de texto / Línea no programada. |
!   DobleAncho      | 2 |   Texto en doble ancho.                   |
!   Centrado        | 3 |   Texto centrado.                         |
!   Negrita         | 4 |   Texto en negrita.                       |
!   N/D             | 5 |   Sin usar                                |
!   N/D             | 6 |   Sin usar                                |
!   N/D             | 7 |   Sin usar                                |
!   N/D             | 8 |   Sin usar                                |
! ------------------------------------------------------------------|

! ------------------------------------------------------------------|
!   Identificadores Válidos Tipos de Estación                       |
! ------------------------------------------------------------------|
!   EstacionTicket (*)  | T | Estación de impresión sobre rollo.    |
!   EstacionSlip (**)   | S | Estación de impresión Slip / Tractor. |
!   EstacionPorDefecto  | D | Estación de impresión principal.      |
! ------------------------------------------------------------------|
! * Sólo para modelos:                                              |
!       P-HAS-5100-FAR v1.00,                                       |
!       SMH/PT-1000F v1.00,                                         |
!       SMH/PT-250F v1.00,                                          |
!       SMH/PT-250F v2.00.                                          |
! ------------------------------------------------------------------|
! ** Sólo para modelos P-HAS-3100-FAR v1.00.                        |
! ------------------------------------------------------------------|
                

    _EndOfInclude_
    
!* end *
