    member()

    include( 'FiscalTypes.inc' ),once
    include( 'FiscalCommand.inc' ),once
    include( 'FiscalConfig.inc' ),once

    include( 'LibCurl.inc' ),once
    include( 'cJson.inc' ),once

    map
        module('Windows API')
            WIN:DebugString( *cstring lpOutputString ),pascal,raw,name('OutputDebugStringA')
        end !* module *
        module( '' )
            sleep( long ),pascal
        end !* module *
        module( '..\access\access.lib' )
            MsgError( string )
        end !* module *
        DebugStr( string )
    end !* map *
    pragma('link(..\access\access.lib)')

! ------------------------------------------------------------------------------------------------
! CONST
! ------------------------------------------------------------------------------------------------  
FISCAL_DELAY_BETWEEN_LINES  EQUATE(50)      ! Tiempo de espera entre impresiones de línea en mseg.
FISCAL_SILENT_RETRY         EQUATE(12)      ! Intentos en silencio cuando el "Controlador Ocupado"    
! ------------------------------------------------------------------------------------------------
! TYPED CallBack
! ------------------------------------------------------------------------------------------------

! ------------------------------------------------------------------------------------------------
DebugStr            procedure( string _str )
cs                  cstring(256)
    code
    cs = clip(_str)
    WIN:DebugString( cs )

! ------------------------------------------------------------------------------------------------
FiscalMessagesClass.AddMessage  procedure( long _id, string _ids, string _desc, long _error_id )
    code
    clear( self.QMessageDefinition )
    self.QMessageDefinition.id = _id
    self.QMessageDefinition.id_str = clip(_ids)
    self.QMessageDefinition.id_desc = clip(_desc)
    self.QMessageDefinition.error_id = _error_id
    add( self.QMessageDefinition )

FiscalMessagesClass.GetErrorType    procedure( string _ids )!,long
rta             long
    code
    rta = -1
    clear( self.QMessageDefinition )
    self.QMessageDefinition.id_str = clip(_ids)
    get( self.QMessageDefinition, self.QMessageDefinition.id_str )
    if not errorcode()
        rta = self.QMessageDefinition.error_id
    end !* if *
    return rta

FiscalMessagesClass.GetDesc         procedure( string _ids )!,string
rta         cstring(256)
    code
    rta = 'Mensaje no definido o Mensaje no Encontrado'
    clear( self.QMessageDefinition )
    self.QMessageDefinition.id_str = clip(_ids)
    get( self.QMessageDefinition, self.QMessageDefinition.id_str )
    if not errorcode()
        rta = self.QMessageDefinition.id_desc
    end !* if *
    return rta

FiscalMessagesClass.Clean          procedure()
    code
    clear( self.QMessageDefinition )
    free( self.QMessageDefinition )

FiscalMessagesClass.Construct       procedure()
    code
    self.QMessageDefinition &= new(TQMessageDefinition)
    self.clean()
    self.AddMessage( 101, 'ImpresoraOcupada',         'Impresora ocupada.',          FISCAL_PRINTER_ERROR )
    self.AddMessage( 103, 'ErrorImpresora',           'Error impresora.',            FISCAL_PRINTER_ERROR )
    self.AddMessage( 104, 'ImpresoraOffLine',         'Impresora Offline.',          FISCAL_PRINTER_ERROR )
    self.AddMessage( 105, 'FaltaPapelJournal',        'Falta papel testigo.',        FISCAL_PRINTER_ERROR )
    self.AddMessage( 106, 'FaltaPapelReceipt',        'Falta papel comprobantes.',   FISCAL_PRINTER_ERROR )
    self.AddMessage( 109, 'TapaAbierta',              'Tapa abierta.',               FISCAL_PRINTER_ERROR )
    self.AddMessage( 115, 'CajonAbierto',             'Cajon abierto.',              FISCAL_PRINTER_ERROR )
    self.AddMessage( 116, 'OrLogico',                 'Se está dando un aviso.',     FISCAL_PRINTER_ERROR )

    self.AddMessage( 201, 'ErrorMemoriaFiscal',       'Error memoria fiscal.',       FISCAL_ERROR )
    self.AddMessage( 202, 'ErrorMemoriaTrabajo',      'Error memoria de trabajo.',   FISCAL_ERROR )
    self.AddMessage( 203, 'ErrorMemoriaAuditoria',    'Error memoria de auditoría, o cinta testigo digital (CTD).', FISCAL_ERROR )
    self.AddMessage( 204, 'ErrorGeneral',             'Error general.',              FISCAL_ERROR )
    self.AddMessage( 205, 'ErrorParametro',           'Error en parámetro.',         FISCAL_ERROR )
    self.AddMessage( 206, 'ErrorEstado',              'Error en estado actual.',     FISCAL_ERROR )
    self.AddMessage( 207, 'ErrorAritmetico',          'Error aritmético.',           FISCAL_ERROR )
    self.AddMessage( 208, 'MemoriaFiscalLlena',       'Memoria fiscal llena.',       FISCAL_ERROR )
    self.AddMessage( 209, 'MemoriaFiscalCasiLlena',   'Memoria fiscal casi llena.',  FISCAL_ERROR )
    self.AddMessage( 210, 'MemoriaFiscalInicializada','Memoria fiscal inicializada.',            FISCAL_OK )
    self.AddMessage( 213, 'DocumentoFiscalAbierto',   'Hay un documento fiscal (DF) abierto.',   FISCAL_OK )
    self.AddMessage( 214, 'DocumentoAbierto',         'Hay un documento abierto.',   FISCAL_OK )
    self.AddMessage( 216, 'ErrorEjecucion',           'Error de ejecución.',         FISCAL_ERROR )

    self.AddMessage( 301, 'MemoriaAuditoriaLlena',      'Si la memoria de auditoría está totalmente agotada.', FISCAL_AUX )
    self.AddMessage( 302, 'MemoriaAuditoriaCasiLlena',  'Si la memoria de auditoría está en agotamiento.', FISCAL_AUX )
    self.AddMessage( 303, 'DatosClienteAlmacenados',    'Si se ha cargado un cliente para facturar.', FISCAL_AUX )
    self.AddMessage( 304, 'CodigoBarrasAlmacenado',     'Si se ha cargado un código de barras.', FISCAL_AUX )
    self.AddMessage( 305, 'ModoEntrenamiento',          'Si el controlador fiscal no ha sido dado de alta fiscal.', FISCAL_AUX )
    self.AddMessage( 306, 'UltimoComprobanteFueCancelado','Si el último comprobante fue cancelado.', FISCAL_AUX )
    self.AddMessage( 307, 'CajeroActivo',               'Si un cajero está registrado en el sistema (sólo para puntos de venta).', FISCAL_AUX )

    self.AddMessage( 400, 'Desconocido',                'Estado controlador fiscal 2G desconocido.', FISCAL_INTERNAL )
    self.AddMessage( 401, 'NoInicializado',             'Controlador fiscal 2G no incializado.', FISCAL_INTERNAL )
    self.AddMessage( 402, 'InicioJornadaFiscal',        'En inicio de jornada fiscal (todavía no se emitió el primer comprobante de la jornada).', FISCAL_INTERNAL )
    self.AddMessage( 403, 'EnJornadaFiscal',            'En jornada fiscal (se ha emitido al menos un comprobante).', FISCAL_INTERNAL )
    self.AddMessage( 404, 'VendiendoItems',             'Documento abierto, vendiendo ítems.', FISCAL_INTERNAL )
    self.AddMessage( 405, 'ImprimiendoTextofiscal',     'Documento abierto, imprimiendo texto fiscal.', FISCAL_INTERNAL )
    self.AddMessage( 406, 'Pagando',                    'Documento abierto, pagando.', FISCAL_INTERNAL )
    self.AddMessage( 407, 'IngresandoOtrosTributos',    'Documento abierto, se recibió al menos un comando de impresión de otros tributos.', FISCAL_INTERNAL )
    self.AddMessage( 408, 'RealizandoOperacionAjuste',  'Documento abierto, se realizó una operación de ajuste.', FISCAL_INTERNAL )
    self.AddMessage( 409, 'RealizandoOperacionGlobalIVA','Documento abierto, se realizó una operación global sobre IVA.', FISCAL_INTERNAL )
    self.AddMessage( 410, 'RealizandoOperacionAnticipo','Documento abierto, se realizó una operación de anticipo/seña.', FISCAL_INTERNAL )
    self.AddMessage( 411, 'ImprimiendoLineasRecibo',    'Documento abierto, se imprimió una línea de concepto en Recibo "X".', FISCAL_INTERNAL )
    self.AddMessage( 412, 'ImprimiendoTextoNofiscal',   'Documento abierto, se imprimió una línea de texto genérico.', FISCAL_INTERNAL )
    self.AddMessage( 413, 'CintaAuditoriaCasiLlena',    'Memoria de auditoría (CTD -cinta testigo digital-) completa, esperando último Informe Diario de Cierre.', FISCAL_INTERNAL )
    self.AddMessage( 414, 'CintaAuditoriaLlena',        'Memoria de auditoría (CTD -cinta testigo digital-) completa.', FISCAL_INTERNAL )
    self.AddMessage( 415, 'ControladorFiscalEsperandoBaja','Controlador fiscal 2G esperando la baja.', FISCAL_INTERNAL )
    self.AddMessage( 416, 'ControladorFiscalDadoDeBaja','Controlador fiscal 2G dado de baja.', FISCAL_INTERNAL )
    self.AddMessage( 417, 'ControladorFiscalBloqueado', 'Controlador fiscal 2G bloqueado.', FISCAL_INTERNAL )

FiscalMessagesClass.Destruct        procedure()
    code
    if not self.QMessageDefinition &= NULL
        self.clean()
        dispose( self.QMessageDefinition )
    end !* if *

! --------------------------------------------------------------------------------------------------
! FiscalCommandClass : class()
! --------------------------------------------------------------------------------------------------
FiscalCommandClass.SetSecuencia procedure( long _secuencia )
    code
    self.secuencia = _secuencia

FiscalCommandClass.GetSecuencia procedure()!,long
    code
    return self.secuencia

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.AddErrMessage  procedure( string _id )
    code
    if self.FiscalMessages.GetErrorType( _id ) <> FISCAL_OK
        clear( self.QErrorMessages )
        self.QErrorMessages.message_id = clip(_id)
        get( self.QErrorMessages, self.QErrorMessages.message_id )
        if errorcode()
            clear( self.QErrorMessages )
            self.QErrorMessages.message_id = clip(_id)
            add( self.QErrorMessages )
        end !* if *
    end !* if *

FiscalCommandClass.AddAllMessage    procedure( string _id )
    code
    clear( self.QAllMessages )
    self.QAllMessages.message_id = clip(_id)
    get( self.QAllMessages, self.QAllMessages.message_id )
    if errorcode()
        clear( self.QAllMessages )
        self.QAllMessages.message_id = clip(_id)
        add( self.QAllMessages )
    end !* if *

FiscalCommandClass.AddMessage    procedure( string _id )
    code
    if clip(_id) <> ''
        self.AddErrMessage( _id )
        self.AddAllMessage( _id )
    end !* if *

FiscalCommandClass.HasMessage procedure( string _message )!,long
is_ok       long
    code
    is_ok = false

    clear( self.QAllMessages )
    self.QAllMessages.message_id = clip(_message)
    get( self.QAllMessages, self.QAllMessages.message_id )
    if not errorcode()
        is_ok = true
    end !* if *        

    return is_ok

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.SetCommand procedure( string _command )
    code
    self.command = clip(_command)

FiscalCommandClass.GetCommand procedure()!,string
    code
    return self.command

FiscalCommandClass.SetCurrentCommand procedure( string _command )!,string
    code
    self.current_command = clip(_command)

FiscalCommandClass.GetCurrentCommand procedure()!,string
    code
    return self.current_command

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.Encode        procedure()!,virtual
    code
    ! -- VIRTUAL --

FiscalCommandClass.Decode        procedure()!,long,virtual
    code
    ! -- VIRTUAL --
    return false

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.CountErrors   procedure( long _filter )!,long
rta         long
i           long
    code
    rta = 0
    loop i = 1 to self.CountErrors()
        get( self.QErrorMessages, i )
        if self.FiscalMessages.GetErrorType( self.QErrorMessages.message_id ) = _filter
            rta = rta + 1
        end !* if *
    end !* loop *
    return rta
! ------------------------------------------------------------------------------------------------
FiscalCommandClass.DecodeSecuencia   procedure( *cJson jChild )!,long
jSecuencia      &cJson
rta             long
    code
    rta = false
    jSecuencia &= jChild.GetObjectItem( 'Secuencia' )
    if not jSecuencia &= NULL
        self.secuencia = jSecuencia.GetValue()
        rta = true
    end !* if *
    
    return rta
    
! ------------------------------------------------------------------------------------------------
FiscalCommandClass.DecodeEstadoGroup  procedure( *cJson jChild )!,long
ResponseGroup   Like(EstadoType)
jEstado         &cJson
rta             long
    code
    rta = false
    jEstado &= jChild.ToGroup( 'Estado', ResponseGroup, false, '' )
    if not jEstado &= NULL
        self.DecodeEstados( ResponseGroup )
        rta = true
    end !* if *
    return rta
! ------------------------------------------------------------------------------------------------
FiscalCommandClass.DecodeEstados procedure( *EstadoType Estado )!,long
EstadoImpresora     cstring(64)
EstadoFiscal        cstring(64)
i                   long
    code
    self.CleanMessages()
    loop i = 1 to MAX_PRINTER_STATE
        EstadoImpresora = Estado.Impresora[i]
        self.AddMessage( EstadoImpresora )
    end !* loop *

    loop i = 1 to MAX_FISCAL_STATE
        EstadoFiscal = Estado.Fiscal[i]
        self.AddMessage( EstadoFiscal )
    end !* loop *
! ------------------------------------------------------------------------------------------------
FiscalCommandClass.DecodeOcupado procedure()!,long
ResponseGroup               group
ControladorOcupado              group,name('ControladorOcupado')
Secuencia                           cstring(16),name('Secuencia')
Estado                              like(EstadoType)
                                end !* group *
                            end !* group *
jParser				        cJSONFactory
rta_level                   long
    code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        self.DecodeEstados( ResponseGroup.ControladorOcupado.Estado )
        rta_level = FISCAL_BUSY
    else
        rta_level = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta_level
! ------------------------------------------------------------------------------------------------
FiscalCommandClass.DecodeError  procedure()!,long
ResponseGroup                   group
Error                               like(ErrorType)
                                end !* group *
jParser				            cJSONFactory
rta_level                       long
    code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        self.CleanError()
        self.SetErrorId( ResponseGroup.Error.Identificador )
        self.SetErrorDesc( ResponseGroup.Error.Descripcion )
        self.SetErrorContexto( ResponseGroup.Error.Contexto )
        rta_level = FISCAL_RESPONSE_ERROR
    else
        rta_level = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta_level
! ------------------------------------------------------------------------------------------------
FiscalCommandClass.DecodeResponse   procedure()!,long
CMD_ocupado                         cstring('ControladorOcupado')
CMD_error                           cstring('Error')
jParser				                cJSONFactory
jRoot				                &cJSON
jChild                              &cJSON
jSecuencia                          &cJSON
rta_level                           long
    code
    jRoot &= jParser.Parse( self.GetResponse() )
    if not jRoot &= NULL
        jChild &= jRoot.GetChild()
        self.current_command = jChild.GetName()
        case self.current_command
            of CMD_ocupado
                rta_level = self.DecodeOcupado()
            of CMD_error
                rta_level = self.DecodeError()
            of self.GetCommand()
                if not self.DecodeSecuencia( jChild )
                    rta_level = FISCAL_SYNTAX_ERROR
                elsif not self.DecodeEstadoGroup( jChild )
                    rta_level = FISCAL_SYNTAX_ERROR
                else
                    rta_level = self.decode()

                    if self.CountErrors( FISCAL_ERROR )
                        rta_level = rta_level + FISCAL_ERROR
                    end !* if *

                    if self.CountErrors( FISCAL_PRINTER_ERROR )
                        rta_level = rta_level + FISCAL_PRINTER_ERROR
                    end !* if *
                end !* if *
            else
                rta_level = FISCAL_UNKNOWN_COMMAND
        end !* case *
		jRoot.Delete()
    else
        FiscalConfig.Message( '|Fiscal.|' & |
                              '|Parser Error: ' & jParser.GetError() & |
                              '|En -> ' & jParser.GetErrorPosition() )
        rta_level = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta_level

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.GetEstadoErrors procedure()!,string
i               long
RtaEstados      cstring(1000)
    code
    RtaEstados = ''
    loop i = 1 to self.CountErrors()
        get( self.QErrorMessages, i )
        RtaEstados = clip(RtaEstados) & '|' & |
                     clip(self.QErrorMessages.message_id) & ' --> ' & |
                     clip(self.FiscalMessages.GetDesc( self.QErrorMessages.message_id ) )
    end !* loop *

    return RtaEstados

FiscalCommandClass.AddEstado    procedure( string _estado )
    code
    clear( self.QErrorMessages )
    self.QErrorMessages.message_id = clip(_estado)
    add( self.QErrorMessages )

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.CountErrors procedure()!,long
    code
    return records( self.QErrorMessages )

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.FiscalToDate         procedure( *cstring _date )!,long
    code
    return deformat( _date, @d011 )

FiscalCommandClass.FiscalToTime         procedure( *cstring _time )!,long
    code
    return deformat( _time, @t05 )
    
FiscalCommandClass.DateToFiscal         procedure( long _date )!,string
    code
    return format( _date, @d011 )

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.SetErrorId           procedure( string _id )!,private
    code
    self.error.Identificador = clip(_id)

FiscalCommandClass.SetErrorDesc         procedure( string _desc )!,private
    code
    self.error.Descripcion = clip(_desc)

FiscalCommandClass.SetErrorContexto     procedure( string _context )!,private
    code
    self.Error.Contexto = clip(_context)

FiscalCommandClass.GetErrorId           procedure()!,string
    code
    return self.error.Identificador

FiscalCommandClass.GetErrorDesc         procedure()!,string
    code
    return self.error.Descripcion

FiscalCommandClass.GetErrorContexto     procedure()!,string
    code
    return self.Error.Contexto

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.IsDocumentoAbierto   procedure()!,long
is_ok       long
    code
    is_ok = false

    if self.HasMessage( 'DocumentoAbierto' ) or |
       self.HasMessage( 'DocumentoFiscalAbierto' )
        is_ok = true
    end !* if *

    return is_ok

FiscalCommandClass.ShowMessage procedure( string _title )
messageStr          cstring(1000)
msgId               cstring(64)
i                   long
    code
    messageStr = ''
    if self.CountErrors() > 0
        loop i = 1 to self.CountErrors()
            get( self.QErrorMessages, i )
            msgId = self.QErrorMessages.message_id
            messageStr = messageStr & |
                        '|* [' & msgId & '] -> ' & self.FiscalMessages.GetDesc( msgId )
        end !* loop *
        FiscalConfig.message( clip(_title) & |
                 '|-- Mensajes de Error de la Impresora --|' & |
                 '|-> Comando: [' & self.GetCommand() & ']' & |
                 '|<- Respuesta: [' & self.GetCurrentCommand() & ']|' & |
                 messageStr & '|')
    end !* if *

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.Run procedure()!,long
level_http      long
level_return    long
    code
    self.encode()                                   ! Encode Command.

    SetCursor( CURSOR:Wait )
    level_http = parent.Run()                       ! Run execute the HTTP Call.
    SetCursor()

    case level_http
        of HTTP:CURL_OK                             ! OK.
            level_return = self.DecodeResponse()    ! Inside decode de bajo nivel.
        of HTTP:CURL_ERROR
        orof HTTP:NET_ERROR
            FiscalConfig.Message( '|Para el comando [' & self.GetCommand() & ']:|' & |
                    '|Se produjo un error en la conexión con la Impresora [' & FiscalConfig.GetIP() & ']|' & |
                    '|Código de Retorno: [' & self.GetCurlCode() & ']|' & |
                    '|Código de Respuesta: ' & self.GetCurlResponseCode() & |
                    '|Mensaje de Respuesta: ' & self.GetCurlResponseMessage() & '.|' )
            level_return = FISCAL_NET_ERROR
        else
            level_return = FISCAL_UNKNOWN
    end !* if *

    return level_return
! ------------------------------------------------------------------------------------------------
FiscalCommandClass.CleanError procedure()!,private
    code
    clear( self.Error )

FiscalCommandClass.CleanMessages procedure()
    code
    clear( self.QAllMessages )
    free( self.QAllMessages )

    clear( self.QErrorMessages )
    free( self.QErrorMessages )

FiscalCommandClass.clean procedure()
    code
    parent.clean()
    self.SetSecuencia( 0 )
    self.SetCommand( Comprobante:NoDocumento )
    self.CleanError()
    self.CleanMessages()

! ------------------------------------------------------------------------------------------------
FiscalCommandClass.Construct procedure()
    code
    self.QAllMessages   &= new(TQMessages)
    self.QErrorMessages &= new(TQmessages)
    self.FiscalMessages &= new(FiscalMessagesClass)
    self.clean()

FiscalCommandClass.Destruct procedure()
    code
    self.clean()
    if not self.QAllMessages &= NULL
        dispose( self.QAllMessages )
    end !* if *
    if not self.QErrorMessages &= NULL
        dispose( self.QErrorMessages )
    end !* if *
    if not self.FiscalMessages &= NULL
        dispose( self.FiscalMessages )
    end !* if *

! --------------------------------------------------------------------------------------------------
! FiscalUltimoError : class()
! --------------------------------------------------------------------------------------------------
FiscalUltimoError.SetUltimoError procedure( string _param )
    code
    self.UltimoError = clip(_param)

FiscalUltimoError.SetDescripcion procedure( string _param )
    code
    self.Descripcion = clip(_param)

FiscalUltimoError.SetContexto procedure( string _param )
    code
    self.Contexto = clip(_param)

FiscalUltimoError.SetNumeroParametro procedure( long _param )
    code
    self.NumeroParametro = _param

FiscalUltimoError.SetNombreParametro procedure( string _param )
    code
    self.NombreParametro = clip(_param)

! ------------------------------------------------------------------------------------------------
FiscalUltimoError.GetUltimoError procedure()!,string
    code
    return self.UltimoError

FiscalUltimoError.GetDescripcion procedure()!,string
    code
    return self.Descripcion

FiscalUltimoError.GetContexto procedure()!,string
    code
    return self.Contexto

FiscalUltimoError.GetNumeroParametro procedure()!,long
    code
    return self.NumeroParametro

FiscalUltimoError.GetNombreParametro procedure()!,string
    code
    return self.NombreParametro

! ------------------------------------------------------------------------------------------------
FiscalUltimoError.Encode procedure()!,virtual
RequestGroup                group
ConsultarUltimoError            group,name('ConsultarUltimoError')
                                end !* group *
                            end !* group *
jRoot				        &cJSON
	code
	! -----------------------------------------------------------------------------
	! ATENCION : jSonMapper genera "IgnoreEmptyObject":true
	!            debe cambiarse por "IgnoreEmptyObject":false
	! -----------------------------------------------------------------------------
    jRoot &= json::CreateObject( RequestGroup, TRUE, |
                    '[{"name":"*","IgnoreEmptyObject":false,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
                     '{"name":["ConsultarUltimoError"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString(true) )
        jRoot.Delete()
    end !* if *

FiscalUltimoError.Decode procedure()!,long,virtual
ResponseGroup               group
ConsultarUltimoError            group,name('ConsultarUltimoError')
Secuencia                           cstring(16),name('Secuencia')
Estado                              like(EstadoType)
UltimoError                         cstring(256),name('UltimoError')
NumeroParametro                     long,name('NumeroParametro')
Descripcion                         cstring(256),name('Descripcion')
Contexto                            cstring(256),name('Contexto')
NombreParametro                     cstring(256),name('NombreParametro')
                                end !* group *
                            end !* group *
jParser				        cJSONFactory
rta_level                   long
    code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        self.SetUltimoError( ResponseGroup.ConsultarUltimoError.ULtimoError )
        self.SetDescripcion( ResponseGroup.ConsultarUltimoError.Descripcion )
        self.SetContexto( ResponseGroup.ConsultarUltimoError.Contexto )

        self.SetNumeroParametro( ResponseGroup.ConsultarUltimoError.NumeroParametro )
        self.SetNombreParametro( ResponseGroup.ConsultarUltimoError.NombreParametro )
        rta_level = FISCAL_OK
    else
        rta_level = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta_level

FiscalUltimoError.clean  procedure()!,private
    code
    self.SetUltimoError( '' )
    self.SetNumeroParametro( 0 )
    self.SetDescripcion( '' )
    self.SetContexto( '' )
    self.SetNombreParametro( '' )

FiscalUltimoError.Construct procedure()
    code
    self.clean()
    self.SetCommand( 'ConsultarUltimoError' )

FiscalUltimoError.Destruct  procedure()
    code
    self.clean()

FiscalUltimoError.Run   procedure()!,long
params_msg              cstring(1000)
level                   long
    code
    params_msg = ''
    level = parent.Run()
    case level
        of  FISCAL_OK
            if self.GetNumeroParametro() > 1
                params_msg = '|Numero de Parámetro: ' & self.GetNumeroParametro() & |
                             '|Nombre del Parámetro: ' & self.GetNombreParametro()
            end !* if *
            FiscalConfig.Message( '|Ultimo Error.|' & |
                     '|Número de Secuencia: ' & self.GetSecuencia() & '|' & |
                     '|Error: [' & self.GetUltimoError() & ']' & |
                     '|Descripción: ' & self.GetDescripcion() & '|' & |
                     '|Contexto: ' & self.GetContexto() & '|' & |
                     params_msg )
    end !* case *

    return level

! --------------------------------------------------------------------------------------------------
! FiscalOcupadoClass : class()
! --------------------------------------------------------------------------------------------------
FiscalOcupadoClass.Encode       procedure()!,virtual
RequestGroup            group
ConsultarEstadoEspera       group,name('ConsultarEstadoEspera')
                            end !* group *
                        end !* group *
jRoot				    &cJSON
	code
    jRoot &= json::CreateObject( RequestGroup, true, |
      '[{"name":"*","IgnoreEmptyObject":false,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
       '{"name":["ConsultarEstadoEspera"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString(true) )
        jRoot.Delete()
    end !* if *

FiscalOcupadoClass.Decode       procedure()!,long,virtual
ResponseGroup           group
ControladorOcupado          group,name('ControladorOcupado')
Secuencia                       cstring(16),name('Secuencia')
Estado                          like(EstadoType)
                            end !* group *
                        end !* group *
jParser				    cJSONFactory
rta_level               long
    code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        rta_level = FISCAL_OK
    else
        rta_level = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta_level

FiscalOcupadoClass.Clean        procedure()
    code

FiscalOcupadoClass.Construct    procedure()
    code
    self.clean()
    self.SetCommand( 'ConsultarEstadoEspera' )

FiscalOcupadoClass.Destruct     procedure()
    code
    self.clean()

! --------------------------------------------------------------------------------------------------
! NotifyClass : class()
! --------------------------------------------------------------------------------------------------    
NotifyClass.Notify  procedure( long _intento, long _max_retry )!,virtual
    code
    ! VIRTUAL

! --------------------------------------------------------------------------------------------------
! FiscalCommand : class()
! --------------------------------------------------------------------------------------------------
FiscalCommand.SetIntentos procedure( long _intentos )!,private
    code
    self.intentos = _intentos
    self.CallOnRetryNotify()

FiscalCommand.StartIntentos procedure()!,private
    code
    self.SetIntentos( 1 )

FiscalCommand.NextIntentos procedure()!,private
    code
    self.SetIntentos( self.GetIntentos() + 1 )
    
FiscalCommand.GetIntentos procedure()!,long,private
    code
    return self.intentos    
    
FiscalCommand.SetOnRetryNotify procedure( *NotifyClass _OnRetry )
    code
    self.Notify &= _OnRetry
    
FiscalCommand.CallOnRetryNotify procedure()
    code
    if not self.Notify &= NULL
        self.Notify.Notify( self.GetIntentos(), self.WaitRetry )
    end !* if *    

FiscalCommand.SetDelayBetweenWaitLines procedure( long _delay )
    code
    self.WaitDelay = _delay
    
FiscalCommand.SetSilentRetry    procedure( long _retries )
    code
    self.WaitRetry = _retries
    
FiscalCommand.WaitLine procedure()
    code
    sleep( self.WaitDelay )
    Yield()    
   
FiscalCommand.WaitControler     procedure()!,long
FiscalOcupado   FiscalOcupadoClass
level           long
    code
    self.WaitLine()
    FiscalOcupado.SetCommand( self.GetCommand() )
    level = FiscalOcupado.Run()
    if self.GetIntentos() >= self.WaitRetry
        self.ShowMessage( |
            '|' & center('>>>>> El controlador Fiscal se encuentra ocupado <<<<<', 60 ) & '|' & |
            '|' & center('>>> Requiere atención del Operador <<<', 60 ) & '|' & |
            '|Error Level (' & level & ')' & |
            '|Intento (' & self.GetIntentos() & ')|' )
        self.StartIntentos()
    end !* if *    
    
    return level    
    
! ----------------------------------------------------------------------------------
FiscalCommand.Construct procedure()
    code
    self.SetDelayBetweenWaitLines( FISCAL_DELAY_BETWEEN_LINES )
    self.SetSilentRetry( FISCAL_SILENT_RETRY )
    self.Notify &= NULL
    
FiscalCommand.Destruct procedure()
    code
    self.Notify &= NULL    
    
! ----------------------------------------------------------------------------------    

FiscalCommand.Run   procedure()
UltimoError         FiscalUltimoError
level               long
level_error         long
    code    
    level = parent.Run()
    self.ShowMessage('|Error Level (' & level & ')|' )
    self.StartIntentos()
    loop
        case level
            of FISCAL_OK                                    ! OK.
                break
            of BAND( level, FISCAL_ERROR )                  ! ERROR (VER ULTIMO ERROR).
                level_error = UltimoError.Run()
                break
            of FISCAL_PRINTER_ERROR                         ! PRINTER ERROR (VER ULTIMO ERROR).
                break
            of FISCAL_SYNTAX_ERROR                          ! ERROR (ABORT).
                FiscalConfig.Message( 'FISCAL_SYNTAX_ERROR -> La respuesta no se pudo interpretar.' )
                break                                       ! jSon Parser Error.
            of FISCAL_NET_ERROR                             ! NETWORK ERROR (ABORT).
                break                                       ! CURL -> Error
            of FISCAL_BUSY                                  ! CONTROLADOR OCUPADO (REPETIR COMANDO).
                level = self.WaitControler()                
            of FISCAL_RESPONSE_ERROR                        ! FISCAL RESPONSE : "ERROR".
                FiscalConfig.Message( '|Ultimo Error.|' & |
                            '|Número de Secuencia: ' & self.GetSecuencia() & '|' & |
                            '|Error: [' & self.error.Identificador & ']' & |
                            '|Descripción: ' & self.error.Descripcion & '|' & |
                            '|Contexto: ' & self.error.Contexto )
                break
            of FISCAL_UNKNOWN                               ! ERROR - DESCONOCIDO.
                FiscalConfig.Message( '|Para el comando [' & self.GetCommand() & ']:|' & |
                     '|Se produjo un error "DESCONOCIDO" en la conexión con la Impresora [' & FiscalConfig.GetIP() & ']|' & |
                     '|Código de Retorno: [' & self.GetCurlCode() & ']|' & |
                     '|Código de Respuesta: ' & self.GetCurlResponseCode() & |
                     '|Mensaje de Respuesta: ' & self.GetCurlResponseMessage() & '.|' )
                break                                       ! CURL -> Error Desconocido.
            of FISCAL_UNKNOWN_COMMAND                       ! COMANDO NO RECONOCIDO
                FiscalConfig.Message( 'Comando [' & self.GetCurrentCommand() & '] desconocido.' )
                break
            else
                FiscalConfig.Message( 'Nivel de Error [' & level & '] Desconocido.' )
                break
        end !* if *
        self.NextIntentos()
    end !* loop *

    return level

!* END *