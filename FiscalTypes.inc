! -----------------------------------------------------------------------------
! FISCAL : TYPES
! -----------------------------------------------------------------------------

  OMIT('_EndOfInclude_', _FISCAL_TYPES_ )
_FISCAL_TYPES_  EQUATE(1)

! -------------------------------------------------------------------------------------------------
! Tipos de Impresoras
! -------------------------------------------------------------------------------------------------
Fiscal_TM2000AF             equate(1)
Fiscal_TM2000AFplus         equate(2)
Fiscal_ND_3                 equate(3)
Fiscal_TMU220AF             equate(4)
Fiscal_ND_5                 equate(5)
Fiscal_LX300                equate(6)
Fiscal_Hasar_441            equate(7)
Fiscal_Hasar_1000           equate(8)
! -------------------------------------------------------------------------------------------------
! CONSTANTES GENERALES
! -------------------------------------------------------------------------------------------------
MAX_JORNADAS_FISCALES       equate(3650)
MAX_LINE_LENGTH             equate(50)      ! Longitud máxima de un texto
! -------------------------------------------------------------------------------------------------
! Zonas de Impresión.
! -------------------------------------------------------------------------------------------------
MAX_ZONA_FANTASIA           equate(2)       ! ZonaFantasia F Zona de nombre de fantasía. Líneas 1 y 2.
MAX_ZONA_DOMICILIO_EMISOR   equate(4)       ! ZonaDomicilioEmisor O Zona de domicilio del emisor. Líneas 1 a 4.
MAX_ZONA_HEAD_1             equate(3)       ! Zona1Encabezado H Zona 1 de encabezado. Líneas 1 a 3.
MAX_ZONA_HEAD_2             equate(3)       ! Zona2Encabezado h Zona 2 de encabezado. Líneas 1 a 3.
MAX_ZONA_FOOT_1             equate(4)       ! Zona1Cola T Zona 1 de cola. Líneas 1 a 4.
MAX_ZONA_FOOT_2             equate(6)       ! Zona2Cola t Zona 1 de cola. Líneas 1 a 6.
! -------------------------------------------------------------------------------------------------
! Zonas de Impresión.
! -------------------------------------------------------------------------------------------------
HSR:ZonaFantasia            equate('ZonaFantasia')          ! F -> Zona de nombre de fantasía. Líneas 1 y 2.
HSR:ZonaDomicilioEmisor     equate('ZonaDomicilioEmisor')   ! O -> Zona de domicilio del emisor. Líneas 1 a 4.
HSR:Zona1Encabezado         equate('Zona1Encabezado')       ! H -> Zona 1 de encabezado. Líneas 1 a 3.
HSR:Zona2Encabezado         equate('Zona2Encabezado')       ! h -> Zona 2 de encabezado. Líneas 1 a 3.
HSR:Zona1Cola               equate('Zona1Cola')             ! T -> Zona 1 de cola. Líneas 1 a 4.
HSR:Zona2Cola               equate('Zona2Cola')             ! t -> Zona 1 de cola. Líneas 1 a 6
! -------------------------------------------------------------------------------------------------
! Atributos de la Impresión.
! -------------------------------------------------------------------------------------------------
Atributos:BorradoTexto      equate('BorradoTexto')  ! 1 -> Borrado de texto / Línea no programada.
Atributos:DobleAncho        equate('DobleAncho')    ! 2 -> Texto en doble ancho.
Atributos:Centrado          equate('Centrado')      ! 3 -> Texto centrado.
Atributos:Negrita           equate('Negrita')       ! 4 -> Texto en negrita.
! -------------------------------------------------------------------------------------------------
! Flags Impresión/"tipos de letra".
! -------------------------------------------------------------------------------------------------
FLAG:NONE                   equate( 00000B )
FLAG:DELETE                 equate( 00001B )
FLAG:WIDE                   equate( 00010B )
FLAG:CENTER                 equate( 00100B )
FLAG:BOLD                   equate( 01000B )
! -------------------------------------------------------------------------------------------------
! ModoDisplay
! -------------------------------------------------------------------------------------------------
ModoDisplay:DisplayNo       equate('DisplayNo')     ! 0 No escribe en display de cliente.
ModoDisplay:DisplaySi       equate('DisplaySi')     ! 1 Escribe en display de cliente.
ModoDisplay:DisplayRep      equate('DisplayRep')    ! 2 Incrementa contador de repetición.
! -------------------------------------------------------------------------------------------------
! Operaciones de Pago
! -------------------------------------------------------------------------------------------------
ModoPago:Pagar              equate( 'Pagar' )               ! "T" Operación de pago.
ModoPago:Anular             equate( 'Anular' )              ! "R" Anulación de un pago previo.

TipoPago:CobroAnticipo      equate( 'CobroAnticipo' )       ! "A" Operación de cobro de anticipo/seña.
TipoPago:BonificacionIVA    equate( 'BonificacionIVA' )     ! "B" Operación de bonificación a un IVA determinado.
TipoPago:DescuentoAnticipo  equate( 'DescuentoAnticipo' )   ! "D" Operación de descuento de anticipo/seña.
TipoPago:DevolucionEnvases  equate( 'DevolucionEnvases' )   ! "E" Operación de devolución de envases.
TipoPago:RecargoIVA         equate( 'RecargoIVA' )          ! "R" Operación de recargo a un IVA determinado.
! -------------------------------------------------------------------------------------------------
! Tipos de Pago
! -------------------------------------------------------------------------------------------------
MedioPago:Cambio                        equate( 'Cambio' )                      !  0 Cambio.
MedioPago:CartaDeCreditoDocumentario    equate( 'CartaDeCreditoDocumentario' )  !  1 Carta de Crédito Documentario.
MedioPago:CartaDeCreditoSimple          equate( 'CartaDeCreditoSimple' )        !  2 Carta de Crédito Simple.
MedioPago:Cheque                        equate( 'Cheque' )                      !  3 Cheque.
MedioPago:ChequeCancelatorios           equate( 'ChequeCancelatorios' )         !  4 Cheque Cancelatorio.
MedioPago:CreditoDocumentario           equate( 'CreditoDocumentario' )         !  5 Crédito Documentario.
MedioPago:CuentaCorriente               equate( 'CuentaCorriente' )             !  6 Cuenta Corriente.
MedioPago:Deposito                      equate( 'Deposito' )                    !  7 Depósito.
MedioPago:Efectivo                      equate( 'Efectivo' )                    !  8 Efectivo.
MedioPago:EndosoDeCheque                equate( 'EndosoDeCheque' )              !  9 Endoso de Cheque.
MedioPago:FacturaDeCredito              equate( 'FacturaDeCredito' )            ! 10 Factura de Crédito.
MedioPago:GarantiaBancaria              equate( 'GarantiaBancaria' )            ! 11 Garantía Bancaria.
MedioPago:Giro                          equate( 'Giro' )                        ! 12 Giro.
MedioPago:LetraDeCambio                 equate( 'LetraDeCambio' )               ! 13 Letra de Cambio.
MedioPago:MedioDePagoDeComercioExterior equate( 'MedioDePagoDeComercioExterior')! 14 Medio de Pago de Comercio Exterior.
MedioPago:OrdenDePagoDocumentaria       equate( 'OrdenDePagoDocumentaria' )     ! 15 Orden de Pago Documentaria.
MedioPago:OrdenDePagoSimple             equate( 'OrdenDePagoSimple' )           ! 16 Orden de Pago Simple.
MedioPago:PagoContraReembolso           equate( 'PagoContraReembolso' )         ! 17 Pago Contra Reembolso.
MedioPago:RemesaDocumentaria            equate( 'RemesaDocumentaria' )          ! 18 Remesa Documentaria.
MedioPago:RemesaSimple                  equate( 'RemesaSimple' )                ! 19 Remesa Simple.
MedioPago:TarjetaDeCredito              equate( 'TarjetaDeCredito' )            ! 20 Tarjeta de Crédito.
MedioPago:TarjetaDeDebito               equate( 'TarjetaDeDebito' )             ! 21 Tarjeta de Débito.
MedioPago:Ticket                        equate( 'Ticket' )                      ! 22 Ticket.
MedioPago:TransferenciaBancaria         equate( 'TransferenciaBancaria' )       ! 23 Transferencia Bancaria.
MedioPago:TransferenciaNoBancaria       equate( 'TransferenciaNoBancaria' )     ! 24 Transferencia No Bancaria.
MedioPago:OtrosMediosPago               equate( 'OtrosMediosPago' )             ! 99 Otro Medio de Pago.
! -------------------------------------------------------------------------------------------------
! Condiciones IVA
! -------------------------------------------------------------------------------------------------
FIS:NoGravado                           equate( 'NoGravado' )       ! 1 No Gravado.
FIS:Exento                              equate( 'Exento' )          ! 2 Exento.
FIS:Gravado                             equate( 'Gravado' )         ! 7 Gravado.
! -------------------------------------------------------------------------------------------------
ImpuestosInternosFijos:Si               equate( 'Si' )              ! S Afirmativo
ImpuestosInternosFijos:No               equate( 'No' )              ! N Negativo
! -------------------------------------------------------------------------------------------------
! Código de Comprobantes
! -------------------------------------------------------------------------------------------------
Comprobante:NoDocumento		            equate('NoDocumento' )                      ! 0 Valor interno especial..
Comprobante:FacturaA                    equate('FacturaA' )                         ! 1 Factura 'A'.
Comprobante:NotaDeDebitoA               equate('NotaDeDebitoA' )                    ! 2 Nota de Débito 'A'.
Comprobante:NotaDeCreditoA              equate('NotaDeCreditoA' )                   ! 3 Nota de Crédito 'A'.
Comprobante:ReciboA                     equate('ReciboA' )                          ! 4 Recibo 'A'.
Comprobante:FacturaB                    equate('FacturaB' )                         ! 6 Factura 'B'.
Comprobante:NotaDeDebitoB               equate('NotaDeDebitoB' )                    ! 7 Nota de Débito 'B'.
Comprobante:NotaDeCreditoB              equate('NotaDeCreditoB' )                   ! 8 Nota de Crédito 'B'.
Comprobante:ReciboB                     equate('ReciboB' )                          ! 9 Recibo 'B'.
Comprobante:FacturaC                    equate('FacturaC' )                         ! 11 Factura 'C'.
Comprobante:NotaDeDebitoC               equate('NotaDeDebitoC' )                    ! 12 Nota de Débito 'C'.
Comprobante:NotaDeCreditoC              equate('NotaDeCreditoC' )                   ! 13 Nota de Crédito 'C'.
Comprobante:ReciboC                     equate('ReciboC' )                          ! 15 Recibo 'C'.
Comprobante:FacturaM                    equate('FacturaM' )                         ! 51 Factura 'M'.
Comprobante:NotaDeDebitoM               equate('NotaDeDebitoM' )                    ! 52 Nota de Débito 'M'.
Comprobante:NotaDeCreditoM              equate('NotaDeCreditoM' )                   ! 53 Nota de Crédito 'M'.
Comprobante:ReciboM                     equate('ReciboM' )                          ! 54 Recibo 'M'.
Comprobante:InformeDiarioDeCierre       equate('InformeDiarioDeCierre' )            ! 80 Informe Diario de Cierre 'Z'.
Comprobante:TiqueFacturaA               equate('TiqueFacturaA' )                    ! 81 Tique Factura 'A'.
Comprobante:TiqueFacturaB               equate('TiqueFacturaB' )                    ! 82 Tique Factura 'B'.
Comprobante:Tique                       equate('Tique' )                            ! 83 Tique.
Comprobante:RemitoR                     equate('RemitoR' )                          ! 91 Remito 'R'.
Comprobante:TiqueNotaCredito            equate('TiqueNotaCredito' )                 !110 Tique Nota de Crédito.
Comprobante:TiqueFacturaC               equate('TiqueFacturaC' )                    !111 Tique Factura 'C'.
Comprobante:TiqueNotaCreditoA           equate('TiqueNotaCreditoA' )                !112 Tique Nota de Crédito 'A'.
Comprobante:TiqueNotaCreditoB           equate('TiqueNotaCreditoB' )                !113 Tique Nota de Crédito 'B'.
Comprobante:TiqueNotaCreditoC           equate('TiqueNotaCreditoC' )                !114 Tique Nota de Crédito 'C'.
Comprobante:TiqueNotaDebitoA            equate('TiqueNotaDebitoA' )                 !115 Tique Nota de Débito 'A'.
Comprobante:TiqueNotaDebitoB            equate('TiqueNotaDebitoB' )                 !116 Tique Nota de Débito 'B'.
Comprobante:TiqueNotaDebitoC            equate('TiqueNotaDebitoC' )                 !117 Tique Nota de Débito 'C'.
Comprobante:TiqueFacturaM               equate('TiqueFacturaM' )                    !118 Tique Factura 'M'.
Comprobante:TiqueNotaCreditoM           equate('TiqueNotaCreditoM' )                !119 Tique Nota de Crédito 'M'.
Comprobante:TiqueNotaDebitoM            equate('TiqueNotaDebitoM' )                 !120 Tique Nota de Débito 'M'.
Comprobante:RemitoX                     equate('RemitoX' )                          !901 Remito 'X'.
Comprobante:ReciboX                     equate('ReciboX' )                          !902 Recibo 'X'.
Comprobante:PresupuestoX                equate('PresupuestoX' )                     !903 Presupuesto 'X'.
Comprobante:InformeDeAuditoria          equate('InformeDeAuditoria' )               !904 Informe de Auditoría.
Comprobante:ComprobanteDonacion         equate('ComprobanteDonacion' )              !907 Comprobante Donación.
Comprobante:Generico                    equate('Generico' )                         !910 Documento Genérico.
Comprobante:MensajeCF                   equate('MensajeCF' )                        !923 Mensaje del Controlador Fiscal.
Comprobante:EstadisticaDeVentaHorariaYPorRubro equate('EstadisticaDeVentaHorariaYPorRubro' )!937 Reporte de acumulados de caja.
Comprobante:DetalleDeVentas             equate('DetalleDeVentas' )                  !940 Detalle de Ventas (Reporte 'X').
Comprobante:CambioIVA                   equate('CambioIVA' )                        !950 Cambio de alícuotas de IVA.
Comprobante:CambiofechaHora             equate('CambiofechaHora' )                  !951 Cambio de Fecha y Hora.
Comprobante:CambioCategorizacionIVA     equate('CambioCategorizacionIVA' )          !952 Cambio de categoría frente a IVA.
Comprobante:CambioInscripcionIngBrutos  equate('CambioInscripcionIngBrutos' )       !953 Cambio Inscripción en Ingresos Brutos.
Comprobante:PruebaPerifericos           equate('PruebaPerifericos' )                !954 Comprobante de prueba de periféricos.
! -------------------------------------------------------------------------------------------------
! Tipo Documento
! -------------------------------------------------------------------------------------------------
TipoCUIT                        equate( 'TipoCUIT' )		! "C" C.U.I.T. (Clave Unica de Identificación Tributaria).
TipoCUIL                        equate( 'TipoCUIL' ) 		! "L" C.U.I.L. (Clave Unica de Identificación Laboral).
TipoLE                          equate( 'TipoLE' )			! "0" Libreta de Enrolamiento.
TipoLC                          equate( 'TipoLC' )			! "1" Libreta Cívica.
TipoDNI			                equate( 'TipoDNI' )			! "2" Documento Nacional de Identidad.
TipoPasaporte                   equate( 'TipoPasaporte' ) 	! "3" Pasaporte.
TipoCI                          equate( 'TipoCI' )			! "4" Cédula de Identidad.
TipoNinguno                     equate( 'TipoNinguno' ) 	! " " (espacio) Sin identificar.
! -------------------------------------------------------------------------------------------------
! BARCODE: Códigos
! -------------------------------------------------------------------------------------------------
BARCODE:CodigoDeBorrado		    equate( 'CodigoDeBorrado' )		    ! 0 Borra el código almacenado.
BARCODE:CodigoTipoEAN13		    equate( 'CodigoTipoEAN13 ' )		! 1 Código EAN13.
BARCODE:CodigoTipoEAN8 		    equate( 'CodigoTipoEAN8 ' )		    ! 2 Código EAN8.
BARCODE:CodigoTipoUPCA 	        equate( 'CodigoTipoUPCA' )		    ! 3 Código UPCA.
BARCODE:CodigoTipoI2OF5		    equate( 'CodigoTipoI2OF5' )		    ! 4 Código INTERLEAVE 2 de 5.

BARCODE:ImprimeNumerosCodigo    equate( 'ImprimeNumerosCodigo' )    ! "N" Imprime los números debajo del código de barras.
BARCODE:NoImprimeNumerosCodigo  equate( 'NoImprimeNumerosCodigo' )  ! " "(espacio) No imprime los números debajo del código de barras.

BARCODE:ImprimeCodigo           equate( 'ImprimeCodigo' )           ! "P" Imprime el código de barras en el momento.
BARCODE:ProgramaCodigo          equate( 'ProgramaCodigo' )          ! "G" Programa el código de barras para imprimirlo en el cierre del comprobante.
! -------------------------------------------------------------------------------------------------
! ResponsabilidadIVA
! -------------------------------------------------------------------------------------------------
IVA:ResponsableInscripto        equate( 'ResponsableInscripto' )    ! "I" Responsable Inscripto.
IVA:ResponsableExento           equate( 'ResponsableExento' )       ! "E" Responsable Exento.
IVA:NoResponsable               equate( 'NoResponsable' )           ! "A" No Responsable.
IVA:ConsumidorFinal             equate( 'ConsumidorFinal' )         ! "C" Consumidor Final.
IVA:NoCategorizado              equate( 'NoCategorizado' )          ! "T2 Sujeto No Categorizado.
IVA:Monotributo                 equate( 'Monotributo' )             ! "M" Monotributista.
IVA:MonotributoSocial           equate( 'MonotributoSocial' )       ! "S" Monotributista Social.
IVA:Eventual                    equate( 'Eventual' )                ! "V" Pequeño Contribuyente Eventual.
IVA:EventualSocial              equate( 'EventualSocial' )          ! "W" Pequeño Contribuyente Eventual Social.
! -------------------------------------------------------------------------------------------------
! CUIT Sujeto No Categorizado
! -------------------------------------------------------------------------------------------------
CUIT:SujetoNoCategorizado       equate( '23000000000' )
! -------------------------------------------------------------------------------------------------
! Carga LOGO
! -------------------------------------------------------------------------------------------------
! Modelo            Ancho   Alto  |
! ---------------------------------
! SMH/PT-1000F       552     240  |
! SMH/PT-250F        576     240  |
! P-HAS-5100-FAR     576     290  |
! ---------------------------------
LOGO:ComienzoCargaLogo          equate( 'ComienzoCargaLogo' )       ! "I" Inicio de carga de logotipo del emisor.
LOGO:CargaLogoEnCurso           equate( 'CargaLogoEnCurso' )        ! "C" Carga en transcurso.
LOGO:FinCargaLogo               equate( 'FinCargaLogo' )            ! "F" Ultimo paquete del logotipo del emisor.
! -------------------------------------------------------------------------------------------------
! Estación
! -------------------------------------------------------------------------------------------------
FIS:EstacionTicket                  equate( 'EstacionTicket' )          ! (*) T Estación de impresión sobre rollo.
FIS:EstacionSlip                    equate( 'EstacionSlip' )            ! (**) S Estación de impresión Slip / Tractor.
FIS:EstacionPorDefecto              equate( 'EstacionPorDefecto' )      ! "D" Estación de impresión principal.
! -------------------------------------------------------------------------------------------------
! Código Tributos
! -------------------------------------------------------------------------------------------------
FIS:SinImpuestos                    equate( 'SinImpuestos' )            ! 0 Sin impuestos.
FIS:ImpuestosNacionales             equate( 'ImpuestosNacionales' )     ! 1 Impuestos Nacionales.
FIS:ImpuestosProvinciales           equate( 'ImpuestosProvinciales' )   ! 2 Impuestos Provinciales.
FIS:ImpuestosMunicipales            equate( 'ImpuestosMunicipales' )    ! 3 Impuestos Municipales.
FIS:ImpuestosInternos               equate( 'ImpuestosInternos' )       ! 4 Impuestos Internos.
FIS:IIBB                            equate( 'IIBB' )                    ! 5 Ingresos Brutos.
FIS:PercepcionIVA                   equate( 'PercepcionIVA' )           ! 6 Percepción IVA.
FIS:PercepcionIIBB                  equate( 'PercepcionIIBB' )          ! 7 Percepción Ingresos Brutos.
FIS:PercepcionImpuestosMunicipales  equate( 'PercepcionImpuestosMunicipales' ) ! 8 Percepción Impuestos Municipales.
FIS:OtrasPercepciones               equate( 'OtrasPercepciones' )       ! 9 Otras Percepciones.
FIS:ImpuestoInternoItem             equate( 'ImpuestoInternoItem' )     ! 10 Impuesto Interno
! -------------------------------------------------------------------------------------------------
! ModoBaseTotal
! -------------------------------------------------------------------------------------------------
FIS:ModoPrecioBase  equate( 'ModoPrecioBase' )          ! "B" Precio base especificado.
FIS:ModoPrecioTotal equate( 'ModoPrecioTotal' )         ! "T" Precio total especificado.
! -------------------------------------------------------------------------------------------------
! Artículos Con Funciones Específicas
! -------------------------------------------------------------------------------------------------
ART_7790001001030   equate( '7790001001030' )   ! Descuentos y bonificaciones comerciales.
                                                ! Cuando se trate de una bonificación general.
                                                ! Cuando se trate de una bonificación sobre IVA e impuestos
                                                ! internos, o de una devolución de envases.
ART_7790001001047   equate( '7790001001047' )   ! Conceptos financieros. Cuando se trate de un recargo financiero.
ART_7790001001054   equate( '7790001001054' )   ! Ventas varias.
ART_7790001001061   equate( '7790001001061' )   ! Bienes de uso.
ART_7790001001078   equate( '7790001001078' )   ! Servicios prestados.
ART_7790001001085   equate( '7790001001085' )   ! Fletes.
ART_7790001001092   equate( '7790001001092' )   ! Alquileres.
ART_7790001001115   equate( '7790001001115' )   ! Depósito y servicios de logística.
ART_7790001001122   equate( '7790001001122' )   ! Repuestos y accesorios.
ART_7790001001139   equate( '7790001001139' )   ! Ajustes impositivos. 
                                                ! Cuando se trate de un ajuste (positivo o negativo).
ART_7790001001146   equate( '7790001001146' )   ! Actividades comerciales no codificadas.
ART_7790001001153   equate( '7790001001153' )   ! Venta de material de rezago.
ART_7790001001856   equate( '7790001001856' )   ! Cuando se trate de operaciones de cobro/descuento 
                                                ! de anticipos/señas.
! -------------------------------------------------------------------------------------------------

!AjusteNeg D Operación de ajuste negativo (-).
!AjustePos R Operación de ajuste positivo (+).
!BonificacionGeneral B Operación de bonificación general.
  _EndOfInclude_
! ---------------------------------------------------------------------------------------
! CondicionIVA
! ---------------------------------------------------------------------------------------
!IIVariableKIVA 0 Impuesto interno, variable por coeficiente.
!IIVariablePorcentual % Impuesto interno, variable por porcentaje.
!IIFijoKIVA + Impuesto interno, fijo por coeficiente.
!IIFijoMonto $ Impuesto interno, fijo por monto.

! ---------------------------------------------------------------------------------------
! CodigoProducto
! ---------------------------------------------------------------------------------------
!7790001001030 Descuentos y bonificaciones comerciales. Cuando se trate de una bonificación sobre IVA e
!               impuestos internos, o de una devolución de envases.
!7790001001047 Conceptos financieros. Cuando se trate de un recargo financiero.
!7790001001856 Cuando se trate de operaciones de cobro/descuento de anticipos/señas.
! ---------------------------------------------------------------------------------------
! Operacion
! ---------------------------------------------------------------------------------------
!BonificacionIVA B Operación de bonificación a un IVA determinado.
!RecargoIVA R Operación de recargo a un IVA determinado.
!DevolucionEnvases E Operación de devolución de envases.
!CobroAnticipo A Operación de cobro de anticipo/seña.
!DescuentoAnticipo D Operación de descuento de anticipo/seña.