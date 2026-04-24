    member()

    include( 'FiscalOrchestra.inc' ),once
    include( 'FiscalTypes.inc' ),once

    include( 'FiscalTools.inc' ),once
    include( 'FiscalCommand.inc' ),once
    include( 'FiscalConfig.inc' ),once
    include( 'FiscalCancelar.inc' ),once
    include( 'FiscalConsultarEstado.inc' ),once

    include( 'cJson.inc' ),once
    include( 'PulseBarClass.inc' ),once
    include( 'KeyCodes.Clw' ),once

    map
        module( '' )
            sleep( long ),pascal
        end !* module *
        WrStr( string _msg )
    end !* map *

! ------------------------------------------------------------------------------------------------
! CONST
! ------------------------------------------------------------------------------------------------  
TIMER_ON        equate(10)
TIMER_OFF       equate(0)    
! ------------------------------------------------------------------------------------------------
! WINDOW
! ------------------------------------------------------------------------------------------------      
sMsg        cstring(256)
FiscalWin WINDOW('Imprimiendo'),AT(,,274,189),CENTER,GRAY,IMM,FONT('Arial',10,, |
            FONT:bold),DOUBLE
        STRING(@s199),AT(2,4,270,12),USE(sMsg),TRN,CENTER,FONT('Courier New',14, |
                ,FONT:bold)
        LIST,AT(2,28,270,158),USE(?ListCMD),FLAT,VSCROLL,FONT('Courier New',10,, |
                FONT:regular,CHARSET:ANSI),FORMAT('120C~Descipción~@s254@')
    END
! ------------------------------------------------------------------------------------------------
! NotifyClass
! ------------------------------------------------------------------------------------------------          
MyNotifyClass   class(NotifyClass)
PulseBar            &PulseBarClass,private
Open                procedure( long x, long y )
Notify              procedure( long _intento, long _max_retry ),virtual
Construct           procedure()
Destruct            procedure()
                end !* class *

MyNotifyClass.Open  procedure( long x, long y )
    code
    ! Inicializa el control sobre esta ventana, en la coordenada (39,26)
    self.PulseBar.Init( FiscalWin, x, y )
    ! Si quisieras cambiar el timer:
    ! PulseBar.Start(150)
    self.PulseBar.Start(0)

MyNotifyClass.Notify procedure( long _intento, long _max_retry )
ForeColor       long
BackColor       long
j               long
    code
    if _intento > 1
        if (_intento % 2) = 0
            ForeColor = Color:Black
            BackColor = COLOR:Yellow
        else
            ForeColor = Color:White
            BackColor = Color:Red
        end !* if *
        WrStr( 'Controlador Ocupado (' & _intento & '/' & _max_retry & ')' )
    else
        ForeColor = Color:White
        BackColor = Color:Blue
    end !* if *
    loop j = 1 to 2
        ?ListCMD{ PROPLIST:TextSelected, j } = ForeColor
        ?ListCMD{ PROPLIST:BackSelected, j } = BackColor
    end !* loop *
    display( ?ListCMD )
    self.PulseBar.NextStep()

MyNotifyClass.Construct procedure()
    code
    self.PulseBar &= new(PulseBarClass)

MyNotifyClass.Destruct procedure()
    code
    if not self.PulseBar &= null
        dispose( self.PulseBar )
    end !* if *

FiscalOrchestra.add_cmd procedure( string _id, string _desc, string _cmd )
desc        cstring(255)
    code        
    clear( self.Qcmd )
    
    desc = clip(_desc)
    if clip(desc) = ''
        desc = '--'
    end !* if *
    self.Qcmd.desc  =   clip(desc)
    
    self.Qcmd.id    =   clip(_id)
    self.Qcmd.cmd   =   clip(_cmd)
    add( self.Qcmd )

! ------------------------------------------------------------------------------------------------
FiscalOrchestra.SetComprobante  procedure( string _comprobante )!,private
    code
    self.comprobante = clip(_comprobante)

FiscalOrchestra.GetComprobante  procedure()!,string,private
    code
    return self.comprobante

FiscalOrchestra.SetLetra        procedure( string _letra )!,private
    code
    self.letra = upper(_letra[1])

FiscalOrchestra.GetLetra        procedure()!,string,private
    code
    return self.letra

FiscalOrchestra.SetCopias       procedure( long _copias )
    code
    if _copias > 1
        _copias = _copias - 1
    else
        _copias = 0
    end !* if *
    self.Copias = _copias

FiscalOrchestra.GetCopias       procedure()!,long,private
    code
    return self.Copias

FiscalOrchestra.SetModoDisplay  procedure( string _modo_display )
    code
    self.ModoDisplay = clip(_modo_display)

FiscalOrchestra.GetModoDisplay  procedure()!,string
    code
    return self.ModoDisplay

FiscalOrchestra.SetTitle        procedure( string _title )
    code
    self.title = clip(_title)

FiscalOrchestra.GetTitle        procedure()!,string
    code
    return self.title

! ------------------------------------------------------------------------------------------------
FiscalOrchestra.ClipText        procedure( string _text )!,string,private
rta     cstring(256)
i       long
    code
    rta = ''
    loop i = 1 to len(_text)
        if val(_text[i]) >= 32
            rta = rta & _text[i]
        end !* if *
    end !* loop *
    return clip( left( rta, MAX_LINE_LENGTH ) )

FiscalOrchestra.ClipMoney       procedure( string _money )!,real,private
money           decimal(30,2)
    code
    money = abs(clip(_money))
    return money

! ------------------------------------------------------------------------------------------------
FiscalOrchestra.Init procedure( string _title )
    code
    self.clean()
    self.Title = clip(_title)

FiscalOrchestra.CargarDatosCliente  procedure( string _rs, string _doc, string _tiva, string _tdoc, string _dom )!,private
RequestGroup        group
CargarDatosCliente      group,name('CargarDatosCliente')
RazonSocial                 cstring(256),name('RazonSocial')
NumeroDocumento             cstring(64),name('NumeroDocumento')
ResponsabilidadIVA          cstring(64),name('ResponsabilidadIVA')
TipoDocumento               cstring(16),name('TipoDocumento')
Domicilio                   cstring(256),name('Domicilio')
                        end !* group *
                    end !* group *
jRoot				&cJSON
str_tdoc            cstring(64)
str_doc             cstring(64)
str_tiva            cstring(64)
str_dom             cstring(64)
i                   long
    code
    str_tdoc    =   clip(left(_tdoc))                   ! Tipo Documento
    str_doc     =   deformat(clip(_doc))                ! Número Documento
    str_tiva    =   clip(left(_tiva))                   ! Tipo de IVA Cliente
    str_dom     =   self.ClipText( _dom )               ! Domicilio Cliente
    if clip(str_dom) = ''
        str_dom = 'Calle S/N'
    end !* if *

    clear( RequestGroup )
    RequestGroup.CargarDatosCliente.RazonSocial = self.ClipText( _rs )
    RequestGroup.CargarDatosCliente.NumeroDocumento = str_doc
    RequestGroup.CargarDatosCliente.ResponsabilidadIVA = str_tiva
    RequestGroup.CargarDatosCliente.TipoDocumento = str_tdoc
    RequestGroup.CargarDatosCliente.Domicilio = str_dom

    jRoot &= json::CreateObject( RequestGroup, TRUE, |
      '[{"name":"*","IgnoreEmptyObject":false,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
       '{"name":["CargarDatosCliente","RazonSocial","NumeroDocumento","ResponsabilidadIVA",' & |
       '"TipoDocumento","Domicilio"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.add_cmd( 'CargarDatosCliente', 'Cliente: ' & clip(_rs), jRoot.ToString( true ) )
        jRoot.Delete()
    end !* if *

! ------------------------------------------------------------------------------------------------
FiscalOrchestra.Cliente procedure( string _letra, string _doc, string _tiva, string _nombre, string _dom )
    code
    self.SetLetra( _letra )
    if self.GetLetra() = 'A'
        self.CargarDatosCliente( _nombre, _doc, IVA:ResponsableInscripto, TipoCUIT, _dom )
    elsif clip(_tiva) = 'EX'
        self.CargarDatosCliente( _nombre, _doc, IVA:ResponsableExento, TipoCUIT, _dom )
    elsif clip(_nombre) <> ''
        self.CargarDatosCliente( _nombre, CUIT:SujetoNoCategorizado, IVA:ConsumidorFinal, TipoDNI, _dom )
    else
        self.CargarDatosCliente( 'Consumidor Final', CUIT:SujetoNoCategorizado, IVA:ConsumidorFinal, TipoDNI, _dom )
    end !* if *

FiscalOrchestra.Titulo      procedure( string _tipo )               ! PRIVATE !
RequestGroup        group
AbrirDocumento          group,name('AbrirDocumento')
CodigoComprobante           cstring(128),name('CodigoComprobante')
                        end !* group *
                    end !* group *
jRoot				&cJSON
	code
	self.SetComprobante( _tipo )

	clear( RequestGroup )
	RequestGroup.AbrirDocumento.CodigoComprobante = clip(_tipo)

    jRoot &= json::CreateObject( RequestGroup, true, |
        '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
         '{"name":["AbrirDocumento","CodigoComprobante"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.add_cmd( 'AbrirDocumento', 'Abriendo Comprobante', jRoot.ToString( true ) )
        jRoot.Delete()
    end !* if *

FiscalOrchestra.TituloFC    procedure()
    code
    self.Titulo( 'TiqueFactura' & self.GetLetra() )

FiscalOrchestra.TituloNC    procedure()                 ! Ticket - Nota de Crédito.
    code
    self.Titulo( 'TiqueNotaCredito' & self.letra )

FiscalOrchestra.Texto   procedure( string _texto )
RequestGroup            group
ImprimirTextoFiscal         group,name('ImprimirTextoFiscal')
Atributos                       cstring(64),dim(4),name('Atributos')
Texto                           cstring(64),name('Texto')
ModoDisplay                     cstring(32),name('ModoDisplay')
                            end !* group *
                        end !* group *
jRoot				    &cJSON
	code
	if clip(_texto) <> ''
        clear( RequestGroup )
        RequestGroup.ImprimirTextoFiscal.Atributos[1] = ''
        RequestGroup.ImprimirTextoFiscal.Texto = self.ClipText( _texto )
        RequestGroup.ImprimirTextoFiscal.ModoDisplay = self.GetModoDisplay()

        jRoot &= json::CreateObject( RequestGroup, true, |
            '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
             '{"name":["ImprimirTextoFiscal","Atributos","Texto","ModoDisplay"], "JsonName":"*"}]')
        if not jRoot &= NULL
            self.add_cmd( 'ImprimirTextoFiscal', clip(_texto), jRoot.ToString( true ) )
            jRoot.Delete()
        end !* if *
    end !* if *

FiscalOrchestra.Item    procedure(  string _desc, string _cant, string _precio, string _tasa )
RequestGroup            group
ImprimirItem                group,name('ImprimirItem')
Descripcion                     cstring(60),name('Descripcion')
Cantidad                        cstring(16),name('Cantidad')
PrecioUnitario                  cstring(32),name('PrecioUnitario')
CondicionIVA                    cstring(64),name('CondicionIVA')
AlicuotaIVA                     cstring(64),name('AlicuotaIVA')
OperacionMonto                  cstring(64),name('OperacionMonto')
TipoImpuestoInterno             cstring(64),name('TipoImpuestoInterno')
MagnitudImpuestoInterno         cstring(64),name('MagnitudImpuestoInterno')
ModoDisplay                     cstring(64),name('ModoDisplay')
ModoBaseTotal                   cstring(64),name('ModoBaseTotal')
UnidadReferencia                cstring(16),name('UnidadReferencia')
CodigoProducto                  cstring(64),name('CodigoProducto')
CodigoInterno                   cstring(64),name('CodigoInterno')
UnidadMedida                    cstring(64),name('UnidadMedida')
                            end !* group *
                        end !* group *
jRoot				    &cJSON
	code
	clear( RequestGroup )
	RequestGroup.ImprimirItem.Descripcion = self.ClipText(_desc)
	RequestGroup.ImprimirItem.Cantidad = _cant
	RequestGroup.ImprimirItem.PrecioUnitario = _precio
	RequestGroup.ImprimirItem.CondicionIVA = FIS:Gravado
	RequestGroup.ImprimirItem.AlicuotaIVA = self.ClipMoney( _tasa )
	RequestGroup.ImprimirItem.OperacionMonto = 'ModoSumaMonto'
	RequestGroup.ImprimirItem.TipoImpuestoInterno = 'IIVariableKIVA'
	RequestGroup.ImprimirItem.MagnitudImpuestoInterno = self.ClipMoney( '0.00' )
	RequestGroup.ImprimirItem.ModoDisplay = self.GetModoDisplay()
	RequestGroup.ImprimirItem.ModoBaseTotal = FIS:ModoPrecioTotal
	RequestGroup.ImprimirItem.UnidadReferencia = '1'
	RequestGroup.ImprimirItem.CodigoProducto = ART_7790001001061        ! Bienes de Uso
	RequestGroup.ImprimirItem.CodigoInterno = ''
	RequestGroup.ImprimirItem.UnidadMedida = 'Unidad'

    jRoot &= json::CreateObject( RequestGroup, true, |
      '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
       '{"name":["ImprimirItem","Descripcion","Cantidad","PrecioUnitario","CondicionIVA",' & |
       '"AlicuotaIVA","OperacionMonto","TipoImpuestoInterno","MagnitudImpuestoInterno",' & |
       '"ModoDisplay","ModoBaseTotal","UnidadReferencia","CodigoProducto","CodigoInterno",' & |
       '"UnidadMedida"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.add_cmd( 'ImprimirItem', 'Item: ' & clip(_desc), jRoot.ToString( true ) )
        jRoot.Delete()
    end !* if *

FiscalOrchestra.Percepcion      procedure( string _text, string _base, string _importe )
RequestGroup        group
ImprimirOtrosTributos   group,name('ImprimirOtrosTributos')
Codigo                      cstring(64),name('Codigo')
Descripcion                 cstring(256),name('Descripcion')
BaseImponible               cstring(64),name('BaseImponible')
Importe                     cstring(64),name('Importe')
                        end !* group *
                    end !* group *
jRoot				&cJSON
    code
    clear( RequestGroup )
    RequestGroup.ImprimirOtrosTributos.Codigo = FIS:IIBB
    RequestGroup.ImprimirOtrosTributos.Descripcion = self.ClipText( _text )
    RequestGroup.ImprimirOtrosTributos.BaseImponible = self.ClipMoney( _base )
    RequestGroup.ImprimirOtrosTributos.Importe = self.ClipMoney( _importe )

    jRoot &= json::CreateObject( RequestGroup, true, |
      '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
       '{"name":["ImprimirOtrosTributos","Codigo","Descripcion","BaseImponible","Importe"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.add_cmd( 'ImprimirOtrosTributos', clip(_text), jRoot.ToString( true ) )
        jRoot.Delete()
    end | !* if *

! ------------------------------------------------------------------------------------------------
FiscalOrchestra.Bonif   procedure( string _text, string _importe )
RequestGroup        group
ImprimirAjuste          group,name('ImprimirAjuste')
Descripcion                 cstring(256),name('Descripcion')
Monto                       cstring(64),name('Monto')
ModoDisplay                 cstring(64),name('ModoDisplay')
ModoBaseTotal               cstring(64),name('ModoBaseTotal')
CodigoProducto              cstring(64),name('CodigoProducto')
Operacion                   cstring(64),name('Operacion')
                        end !* group *
                    end !* group *
jRoot				&cJSON
    code
    clear( RequestGroup )
    RequestGroup.ImprimirAjuste.Descripcion = self.ClipText( _text )
    RequestGroup.ImprimirAjuste.Monto = self.ClipMoney( _importe )
    RequestGroup.ImprimirAjuste.ModoDisplay = self.GetModoDisplay()
    RequestGroup.ImprimirAjuste.ModoBaseTotal = FIS:ModoPrecioTotal
    RequestGroup.ImprimirAjuste.CodigoProducto = '7790001001030'
    RequestGroup.ImprimirAjuste.Operacion = 'BonificacionGeneral'

    jRoot &= json::CreateObject( RequestGroup, true, |
      '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
       '{"name":["ImprimirAjuste","Descripcion","Monto","ModoDisplay","ModoBaseTotal",' & |
       '"CodigoProducto","Operacion"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.add_cmd( 'ImprimirAjuste', clip(_text), jRoot.ToString( true ))
        jRoot.Delete()
    end !* if *

! ------------------------------------------------------------------------------------------------
FiscalOrchestra.MapPago procedure( string _type, *cstring _forma_pago )!,long,private
is_ok       long
    code
    is_ok = true
    _forma_pago = ''
    case clip(_type)
        of 'EFE'
            _forma_pago = MedioPago:Efectivo
        of 'TRJ' orof 'QR' orof 'QRI'
            _forma_pago = MedioPago:TarjetaDeCredito
        of 'CCP' orof 'PCC'
            _forma_pago = MedioPago:CuentaCorriente
        of 'CHK'
            _forma_pago = MedioPago:ChequeCancelatorios
        of 'DEP'
            _forma_pago = MedioPago:Deposito
        of 'DOC'
            _forma_pago = MedioPago:CreditoDocumentario
        of 'PNC'
            _forma_pago = MedioPago:FacturaDeCredito
        of 'POC'
            _forma_pago = MedioPago:OrdenDePagoSimple
        of 'XNC' orof 'XOC' orof 'OTR' orof 'IMP' orof 'DEB' |      ! Exceso/Otros/Imputaciones
            orof 'DOL' orof 'REAL' orof 'EURO'                      ! Moneda Extranjera
            _forma_pago = MedioPago:OtrosMediosPago
        else
            is_ok = false
    end !* case *

    return is_ok

FiscalOrchestra.AddPago procedure( string _type, string _text, string _importe )!,private
RequestGroup        group
ImprimirPago            group,name('ImprimirPago')
Descripcion                 cstring(256),name('Descripcion')
Monto                       cstring(64),name('Monto')
Operacion                   cstring(64),name('Operacion')
ModoDisplay                 cstring(64),name('ModoDisplay')
DescripcionAdicional        cstring(64),name('DescripcionAdicional')
CodigoFormaPago             cstring(64),name('CodigoFormaPago')
Cuotas                      cstring(16),name('Cuotas')
Cupones                     cstring(16),name('Cupones')
Referencia                  cstring(64),name('Referencia')
                        end !* group *
                    end !* group *
FormaPago           cstring(64)
jRoot				&cJSON
    code
    if self.MapPago( _type, FormaPago )
        clear( RequestGroup )
        RequestGroup.ImprimirPago.Descripcion           = self.ClipText( _text )
        RequestGroup.ImprimirPago.Monto                 = self.ClipMoney( _importe )
        RequestGroup.ImprimirPago.Operacion             = ModoPago:Pagar
        RequestGroup.ImprimirPago.ModoDisplay           = self.GetModoDisplay()
        RequestGroup.ImprimirPago.DescripcionAdicional  = ''
        RequestGroup.ImprimirPago.CodigoFormaPago       = FormaPago
        RequestGroup.ImprimirPago.Cuotas                = 0
        RequestGroup.ImprimirPago.Cupones               = ''
        RequestGroup.ImprimirPago.Referencia            = ''

        jRoot &= json::CreateObject( RequestGroup, true, |
            '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
             '{"name":["ImprimirPago","Descripcion","Monto","Operacion","ModoDisplay",' & |
               '"DescripcionAdicional","CodigoFormaPago","Cuotas","Cupones","Referencia"],' & |
               '"JsonName":"*"}]')
        if not jRoot &= NULL
            self.add_cmd( 'ImprimirPago', clip(_text), jRoot.ToString( true ) )
            jRoot.Delete()
        end !* if *
    end !* if *

FiscalOrchestra.Pago    procedure( string _type, string _text, string _importe )
    code
    case clip(_type)
        of 'DSC' orof 'PRO'
            self.Ajuste( _text, _importe )
            !self.Bonif( _text, _importe )
        else
            self.AddPago( _type, _text, _importe )
    end !* case *

! ------------------------------------------------------------------------------------------------
FiscalOrchestra.Ajuste          procedure( string _text, string _importe )
RequestGroup        group
ImprimirAnticipoBonificacionEnvases  group,name('ImprimirAnticipoBonificacionEnvases')
Descripcion                 cstring(256),name('Descripcion')
Monto                       cstring(64),name('Monto')
CondicionIVA                cstring(64),name('CondicionIVA')
AlicuotaIVA                 cstring(64),name('AlicuotaIVA')
TipoImpuestoInterno         cstring(64),name('TipoImpuestoInterno')
MagnitudImpuestoInterno     cstring(64),name('MagnitudImpuestoInterno')
ModoDisplay                 cstring(64),name('ModoDisplay')
ModoBaseTotal               cstring(64),name('ModoBaseTotal')
CodigoProducto              cstring(64),name('CodigoProducto')
Operacion                   cstring(64),name('Operacion')
                        end !* group *
                    end !* group *
jRoot				&cJSON
str_op_mode         cstring(64)
    code
    if _importe < 0
        str_op_mode = TipoPago:DescuentoAnticipo
    else
        str_op_mode = TipoPago:RecargoIVA
    end !* if *

    clear( RequestGroup )
    RequestGroup.ImprimirAnticipoBonificacionEnvases.Descripcion    = self.ClipText(_text)
    RequestGroup.ImprimirAnticipoBonificacionEnvases.Monto          = self.ClipMoney(_importe)
    RequestGroup.ImprimirAnticipoBonificacionEnvases.CondicionIVA   = FIS:Gravado
    RequestGroup.ImprimirAnticipoBonificacionEnvases.AlicuotaIVA    = self.ClipMoney( '21.00' )
    RequestGroup.ImprimirAnticipoBonificacionEnvases.TipoImpuestoInterno = '0'
    RequestGroup.ImprimirAnticipoBonificacionEnvases.MagnitudImpuestoInterno = self.ClipMoney( '0.00' )
    RequestGroup.ImprimirAnticipoBonificacionEnvases.ModoDisplay    = self.GetModoDisplay()
    RequestGroup.ImprimirAnticipoBonificacionEnvases.ModoBaseTotal  = FIS:ModoPrecioTotal
    RequestGroup.ImprimirAnticipoBonificacionEnvases.CodigoProducto = ART_7790001001047 ! Conceptos Financieros
    RequestGroup.ImprimirAnticipoBonificacionEnvases.Operacion      = str_op_mode

    jRoot &= json::CreateObject( RequestGroup, true, |
      '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
       '{"name":["ImprimirAnticipoBonificacionEnvases","Descripcion","Monto","CondicionIVA",' & |
       '"AlicuotaIVA","TipoImpuestoInterno","MagnitudImpuestoInterno","ModoDisplay",' & |
       '"ModoBaseTotal","CodigoProducto","Operacion"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.add_cmd( 'ImprimirAnticipoBonificacionEnvases', clip(_text), jRoot.ToString( true ) )
        jRoot.Delete()
    end !* if *

! ------------------------------------------------------------------------------------------------
FiscalOrchestra.Cierre  procedure()
RequestGroup        group
CerrarDocumento         group,name('CerrarDocumento')
Copias                      cstring(16),name('Copias')
DireccionEMail              cstring(256),name('DireccionEMail')
                        end !* group *
                    end !* group *
jRoot				&cJSON
	code
	clear( RequestGroup )
	RequestGroup.CerrarDocumento.Copias = self.GetCopias()
	RequestGroup.CerrarDocumento.DireccionEMail = ''

    jRoot &= json::CreateObject( RequestGroup, true, |
      '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
       '{"name":["CerrarDocumento","Copias","DireccionEMail"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.add_cmd( 'CerrarDocumento', 'Cerrar Documento', jRoot.ToString( true ))
        jRoot.Delete()
    end !* if *

FiscalOrchestra.TituloNF    procedure()
    code
    self.Titulo( Comprobante:Generico )

FiscalOrchestra.TextoNF     procedure( string _text )
RequestGroup                group
ImprimirTextoGenerico           group,name('ImprimirTextoGenerico')
Atributos                           group,dim(8),name('Atributos')
                                    end !* group *
Texto                               cstring(256),name('Texto')
ModoDisplay                         cstring(32),name('ModoDisplay')
                                end !* group *
                            end !* group *
jRoot				        &cJSON
    code
    if clip(_text) <> ''
        clear( RequestGroup )
        RequestGroup.ImprimirTextoGenerico.Texto = clip(_text)
        RequestGroup.ImprimirTextoGenerico.ModoDisplay = self.GetModoDisplay()

        jRoot &= json::CreateObject( RequestGroup, true, |
            '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
             '{"name":["ImprimirTextoGenerico","Atributos","Texto","ModoDisplay"], "JsonName":"*"}]')
        if not jRoot &= NULL
            self.add_cmd( 'ImprimirTextoGenerico', clip(_text), jRoot.ToString( true ) )
            jRoot.Delete()
        end !* if *
    end !* if *

FiscalOrchestra.CierreNF        procedure()
i               long
    code
    loop i = 1 to MAX_ZONA_HEAD_1
        self.ZonaHead( 1, i, '', FLAG:DELETE )
    end !* loop *
    loop i = 1 to MAX_ZONA_HEAD_2
        self.ZonaHead( 2, i, '', FLAG:DELETE )
    end !* loop *
    loop i = 1 to MAX_ZONA_FOOT_1
        self.ZonaFoot( 1, i, '', FLAG:DELETE )
    end !* loop *
    loop i = 1 to MAX_ZONA_FOOT_2
        self.ZonaFoot( 2, i, '', FLAG:DELETE )
    end !* loop *
    self.Cierre()

FiscalOrchestra.ZonaHead        procedure( long _zona, long _line, string _msg, long _flags )
Zona            cstring(64)
jSonCommand     cstring(4000)
    code
    Zona = 'Zona' & _zona & 'Encabezado'
    jSonCommand = FiscalTools.get_cmd_zona( Zona, _line, _msg, _flags )
    self.add_cmd( 'ConfigurarZona', _msg, jSonCommand )

FiscalOrchestra.ZonaFoot        procedure( long _zona, long _line, string _msg, long _flags )
Zona            cstring(64)
jSonCommand     cstring(4000)
    code
    Zona = 'Zona' & _zona & 'Cola'
    jSonCommand = FiscalTools.get_cmd_zona( Zona, _line, _msg, _flags )      
    self.add_cmd( 'ConfigurarZona', _msg, jSonCommand )

FiscalOrchestra.ZonaDomicilioEmisor procedure( long _line, string _msg, long _flags )
jSonCommand     cstring(4000)
    code
    jSonCommand = FiscalTools.get_cmd_zona( HSR:ZonaDomicilioEmisor, _line, _msg, _flags )
    self.add_cmd( 'ConfigurarZona', _msg, jSonCommand )

FiscalOrchestra.ZonaFantasia    procedure( long _line, string _msg, long _flags )
jSonCommand     cstring(4000)
    code
    jSonCommand = FiscalTools.get_cmd_zona( HSR:ZonaFantasia, _line, _msg, _flags )
    self.add_cmd( 'ConfigurarZona', _msg, jSonCommand )

! ------------------------------------------------------------------------------------------------   
FiscalOrchestra.Run         procedure()!,long
numero      long
    code
    self.Fiscal.SetOnRetryNotify( MyNotifyClass )

    self.Start( records( self.Qcmd ) )
    self.TimerOn()
    accept
        case event()
            of EVENT:AlertKey
                if self.AskAbort()
                    self.Cancelar()
                    post( EVENT:CloseWindow )
                    break
                end !* if *
            of EVENT:OpenWindow
                self.Open()
            of EVENT:Timer
                self.TimerOff()
                if self.InLoop()
                    self.NextStep()
                else
                    post( EVENT:CloseWindow )
                end
                self.TimerOn()
            else
        end !* case *
    end !* accept *
    self.Close()

    numero = self.GetUltimo()

    return numero

FiscalOrchestra.IsOk   procedure()!,long
    code
    return self.is_ok

FiscalOrchestra.Start   procedure( long _high )
    code
    open( FiscalWin )
    Alert( EscKey )
    
    ?ListCMD{ PROPLIST:DefHdrTextColor } = COLOR:Black
    ?ListCMD{ PROPLIST:DefHdrBackColor } = COLOR:LightGray
    ?ListCMD{ PROPLIST:Grid } = COLOR:LightGray
    
    self.idx = 1
    self.high = _high
    self.is_ok = true

FiscalOrchestra.TimerOn  procedure()
    code
    FiscalWin{ PROP:TIMER } = TIMER_ON

FiscalOrchestra.TimerOff procedure()
    code
    FiscalWin{ PROP:TIMER } = TIMER_OFF

FiscalOrchestra.AskAbort   procedure()!,long
is_abort    long
    code
    is_abort = false
    if Message( '¿ Realmente desea cancelar la impresión ?', |
                '- Consulta -', |
                ICON:Question, |
                '&Si|&No',, |
                MSGMODE:SYSMODAL+MSGMODE:CANCOPY+MSGMODE:FIXEDFONT) = 1
        is_abort = true
    end !* if *

    return is_abort

FiscalOrchestra.SelectLine  procedure( long _line )
    code
    select( ?ListCMD, _line )
    display( ?ListCMD )

FiscalOrchestra.Open     procedure()
    code
    MyNotifyClass.Open( 30, 19 )
    FiscalWin{ prop:text } = 'Imprimiendo [' & self.GetTitle() & ']'
    WrStr( '>> Iniciando ' & self.GetTitle() & ' <<' )
    ?ListCMD{ PROP:LineHeight } = 10
    ?ListCMD{ prop:from } = self.Qcmd
    self.SelectLine( self.idx )

FiscalOrchestra.InLoop  procedure()!,long
looped      long
    code
    if self.idx <= self.high
        looped = true
    else
        looped = false
    end !* if *
    return looped

FiscalOrchestra.NextStep    procedure()
    code
    self.SelectLine( self.idx )
    WrStr( 'Imprimiendo ' & self.GetTitle() & ' (' & self.idx & '/' & self.high & ')' )
    get( self.Qcmd, self.idx )
    self.Fiscal.SetCommand( self.Qcmd.id )
    self.Fiscal.SetRequest( self.Qcmd.cmd )
    if self.Fiscal.Run() <> FISCAL_OK
        if self.Fiscal.IsDocumentoAbierto()    
            self.Cancelar()
        end !* if *
        post( EVENT:CloseWindow )        
    end !* if *
    self.idx = self.idx + 1

FiscalOrchestra.Cancelar   procedure()
Cancel      FiscalCancelar
    code
    if Cancel.Run() = FISCAL_OK
        FiscalConfig.Message( '|Documento actual cancelado.|' )
    else
        FiscalConfig.Message( '|No fue posible cancelar el documento abierto.|' )
    end !* if *
    self.is_ok = false

FiscalOrchestra.Close    procedure()
    code
    close( FiscalWin )

FiscalOrchestra.GetUltimo   procedure()!,long
ConsEstado  FiscalConsultarEstado
rta         long
    code
    rta = 0
    if self.IsOk()
        ConsEstado.SetComprobante( self.GetComprobante() )
        if ConsEstado.Run() = FISCAL_OK
            rta = ConsEstado.GetNumeroUltimoComprobante()
        end !* if *
    end !* if *
    return rta

WrStr   procedure( string _text )
    code
    sMsg = clip(_text)
    display( ?sMsg )
    
! ------------------------------------------------------------------------------------------------       
FiscalOrchestra.clean       procedure()
    code
    self.SetLetra( 'X' )
    self.SetComprobante( '' )
    self.SetCopias( 1 )
    self.SetModoDisplay( ModoDisplay:DisplayNo )
    self.SetTitle( '' )

    clear( self.Qcmd )
    free( self.Qcmd )

FiscalOrchestra.Construct   procedure()
    code
    self.Qcmd &= new(TQcmd)
    self.Fiscal &= new(FiscalCommand)
    self.clean()

FiscalOrchestra.Destruct    procedure()
    code
    if not self.Qcmd &= NULL
        dispose( self.Qcmd )
    end !* if *
    
    if not self.Fiscal &= NULL
        dispose( self.Fiscal )
    end !* if *
! ------------------------------------------------------------------------------------------------       