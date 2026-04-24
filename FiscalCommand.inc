! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCommand
!
! 2025 - Gustavo Saracca ©
!
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalCommand_ )
_FiscalCommand_  EQUATE(1)

    include( 'FiscalHTTP.inc' ),once

! --------------------------------------------------------------------------------------------------
! Estado de la ejecución del último comando (RUN) - Flags
! --------------------------------------------------------------------------------------------------
FISCAL_OK                   EQUATE(000H)    ! OK - Sin errores
FISCAL_ERROR                EQUATE(001H)    ! ERROR - Hubo algún error (bandera general)
FISCAL_PRINTER_ERROR        EQUATE(002H)    ! PRINTER ERROR - Error de impresora
FISCAL_SYNTAX_ERROR         EQUATE(004H)    ! ERROR - Error de sintaxis (ABORT)
FISCAL_NET_ERROR            EQUATE(008H)    ! NETWORK ERROR (ABORT)
FISCAL_BUSY                 EQUATE(010H)    ! FISCAL RESPONSE "BUSY"
FISCAL_RESPONSE_ERROR       EQUATE(020H)    ! FISCAL RESPONSE "ERROR"
FISCAL_UNKNOWN              EQUATE(040H)    ! ERROR - DESCONOCIDO.
FISCAL_UNKNOWN_COMMAND      EQUATE(080H)    ! COMANDO NO RECONOCIDO.
FISCAL_AUX                  EQUATE(100H)    ! FISCAL STATUS AUXILIAR
FISCAL_INTERNAL             EQUATE(200H)    ! FISCAL STATUS INTERNAL
! --------------------------------------------------------------------------------------------------
! Message Definitions
! --------------------------------------------------------------------------------------------------
TQMessageDefinition         queue,type
id                              long
id_str                          cstring(64)
id_desc                         cstring(256)
error_id                        long
                            end !* queue *
! --------------------------------------------------------------------------------------------------
! FiscalMessagesClass()
!
! Mensajes de los Comandos de la Impresora.
! --------------------------------------------------------------------------------------------------
FiscalMessagesClass         class,type,module( 'FiscalCommand.clw' ),link( 'FiscalCommand.clw' )
QMessageDefinition              &TQMessageDefinition,private

AddMessage                      procedure( long _id, string _ids, string _desc, long _error_id ),private

GetErrorType                    procedure( string _ids ),long
GetDesc                         procedure( string _ids ),string

clean                           procedure()
construct                       procedure()     ! Construct
destruct                        procedure()     ! Destruct
                            end !* class *

TQmessages                  queue,type
message_id                      cstring(64)
                            end !* queue *
! --------------------------------------------------------------------------------------------------
! CONST
! --------------------------------------------------------------------------------------------------
MAX_PRINTER_STATE           equate(12)
MAX_FISCAL_STATE            equate(08)
! --------------------------------------------------------------------------------------------------
! TYPES
! --------------------------------------------------------------------------------------------------
EstadoType                  group,type,name('Estado')
Impresora                       cstring(64),DIM(MAX_PRINTER_STATE),name('Impresora')    ! max string(17)
Fiscal                          cstring(64),DIM(MAX_FISCAL_STATE),name('Fiscal')        ! max string(25),max array[1]
                            end !* group *
ErrorType                   group,type,name('Error')
Identificador                   cstring(64),name('Identificador')
Descripcion                     cstring(256),name('Descripcion')
Contexto                        cstring(1000),name('Contexto')
                            end !* group *
! --------------------------------------------------------------------------------------------------
! FiscalCommandClass : class()
!
! Solo realiza la llamada, sin ejecutar reintentos
! --------------------------------------------------------------------------------------------------
FiscalCommandClass          class(FiscalHTTP),type,module( 'FiscalCommand.clw' ),link( 'FiscalCommand.clw' )
secuencia                       long,private
command                         cstring(256),private
current_command                 cstring(256),private
error                           like(ErrorType),private
QAllMessages                    &TQmessages
QErrorMessages                  &TQmessages
FiscalMessages                  &FiscalMessagesClass
! -------------------------------------------------------------------------------------------------
SetSecuencia                    procedure( long _secuencia )
GetSecuencia                    procedure(),long

AddAllMessage                   procedure( string _id ),private
AddErrMessage                   procedure( string _id ),private
AddMessage                      procedure( string _id ),private
HasMessage                      procedure( string _message ),long,private

CountErrors                     procedure(),long

FiscalToDate                    procedure( *cstring _date ),long
FiscalToTime                    procedure( *cstring _time ),long
DateToFiscal                    procedure( long _date ),string
! -------------------------------------------------------------------------------------------------
SetCommand                      procedure( string _command )
GetCommand                      procedure(),string

SetCurrentCommand               procedure( string _command ),private
GetCurrentCommand               procedure(),string,protected
! -------------------------------------------------------------------------------------------------

! -------------------------------------------------------------------------------------------------
Encode                          procedure(),protected,virtual
Decode                          procedure(),long,protected,virtual

CountErrors                     procedure( long _filter ),long,private
DecodeSecuencia                 procedure( *cJSON jChild ),long,private
DecodeEstadoGroup               procedure( *cJson jChild ),long,private
DecodeEstados                   procedure( *EstadoType Estado ),private
DecodeOcupado                   procedure(),long,private
DecodeError                     procedure(),long,private
DecodeResponse                  procedure(),long,private

AddEstado                       procedure( string _estado )
GetEstadoErrors                 procedure(),string,protected
! -------------------------------------------------------------------------------------------------
SetErrorId                      procedure( string _id ),private
SetErrorDesc                    procedure( string _desc ),private
SetErrorContexto                procedure( string _context ),private

GetErrorId                      procedure(),string
GetErrorDesc                    procedure(),string
GetErrorContexto                procedure(),string
! -------------------------------------------------------------------------------------------------
IsDocumentoAbierto              procedure(),long
ShowMessage                     procedure( string _title )
! -------------------------------------------------------------------------------------------------
Run                             procedure(),long
! -------------------------------------------------------------------------------------------------
CleanError                      procedure(),private
CleanMessages                   procedure(),private
clean                           procedure(),private
! -------------------------------------------------------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
                            end !* class *

! --------------------------------------------------------------------------------------------------
! FiscalUltimoError : class()
! --------------------------------------------------------------------------------------------------
FiscalUltimoError           class(FiscalCommandClass),type,module( 'FiscalCommand.clw' ),link( 'FiscalCommand.clw' )
UltimoError                     cstring(256),private
Descripcion                     cstring(256),private
Contexto                        cstring(256),private

NumeroParametro                 long,private
NombreParametro                 cstring(256),private
! ----------------------------------------------------------------------------------
SetUltimoError                  procedure( string _param )
SetDescripcion                  procedure( string _param )
SetContexto                     procedure( string _param )

SetNumeroParametro              procedure( long _param )
SetNombreParametro              procedure( string _param )
! ----------------------------------------------------------------------------------
GetUltimoError                  procedure(),string
GetDescripcion                  procedure(),string
GetContexto                     procedure(),string

GetNumeroParametro              procedure(),long
GetNombreParametro              procedure(),string
! ----------------------------------------------------------------------------------
Encode                          procedure(),virtual
Decode                          procedure(),long,virtual
! ----------------------------------------------------------------------------------
clean                           procedure(),private
! ----------------------------------------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
! ----------------------------------------------------------------------------------
Run                             procedure(),long
                            end !* class *

! --------------------------------------------------------------------------------------------------
! FiscalOcupadoClass : class()
! --------------------------------------------------------------------------------------------------
FiscalOcupadoClass          class(FiscalCommandClass),type,module( 'FiscalCommand.clw' ),link( 'FiscalCommand.clw' )
Encode                          procedure(),virtual
Decode                          procedure(),long,virtual
! ----------------------------------------------------------------------------------
Clean                           procedure()
! ----------------------------------------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
! ----------------------------------------------------------------------------------
                            end !* class *

! --------------------------------------------------------------------------------------------------
! FiscalCommand : class()
!
! Ejecución de Comandos con reintentos.
! --------------------------------------------------------------------------------------------------             
NotifyClass                 class(),type,module( 'FiscalCommand.clw' ),link( 'FiscalCommand.clw' )
Notify                          procedure( long _intento, long _max_retry ),virtual
                            end !* class *

FiscalCommand               class(FiscalCommandClass),type,module( 'FiscalCommand.clw' ),link( 'FiscalCommand.clw' )
intentos                        long,private
WaitDelay                       long,private
WaitRetry                       long,private
Notify                          &NotifyClass,private

SetIntentos                     procedure( long _intentos ),private
StartIntentos                   procedure(),private
NextIntentos                    procedure(),private
GetIntentos                     procedure(),long,private

SetOnRetryNotify                procedure( *NotifyClass _OnRetry )
CallOnRetryNotify               procedure()

SetDelayBetweenWaitLines        procedure( long _delay )
SetSilentRetry                  procedure( long _retries )

WaitLine                        procedure(),private
WaitControler                   procedure(),long
! ----------------------------------------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
! ----------------------------------------------------------------------------------
Run                             procedure(),long
                            end !* class *

  _EndOfInclude_

!* end *
