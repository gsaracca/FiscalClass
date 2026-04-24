    member()

    include( 'FiscalInicializacion.inc' ),once
    include( 'FiscalConfig.inc' ),once
    include( 'cjson.inc' ),once

    map
    end !* map

FiscalInicializacion.GetCUIT          procedure()!,string
    code
    return self.CUIT

FiscalInicializacion.GetRazonSocial   procedure()!,string
    code
    return self.RazonSocial

FiscalInicializacion.GetSerial        procedure()!,string
    code
    return self.Serial

FiscalInicializacion.GetPrefijo       procedure()!,long
    code
    return self.Prefijo

FiscalInicializacion.GetFechaInicio   procedure()!,long
    code
    return self.fecha_inicio

FiscalInicializacion.GetIIBB          procedure()!,string
    code
    return self.iibb

FiscalInicializacion.GetIVA           procedure()!,string
    code
    return self.iva

FiscalInicializacion.GetFechaCompleta procedure()!,long
    code
    return self.fecha_inicio_completa
    
! -------------------------------------------------------------------------------------------------
FiscalInicializacion.Encode procedure()!,protected,virtual
RequestGroup                    group
ConsultarDatosInicializacion        group,name('ConsultarDatosInicializacion')
                                    end !* group *
                                end !* group *
jParser				    cJSONFactory
jRoot				    &cJSON
	code
    jRoot &= json::CreateObject( RequestGroup, TRUE, |
            '[{{"name":"*","IgnoreEmptyObject":false,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
            '{{"name":["ConsultarDatosInicializacion","Reporte"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString(true) )
		jRoot.Delete()
    end !* if *

FiscalInicializacion.Decode procedure()!,long,protected,virtual
ResponseGroup               group
ConsultarDatosInicializacion    group,name('ConsultarDatosInicializacion')
Secuencia                           cstring(64),name('Secuencia')
Estado                              like(EstadoType)
CUIT                                cstring(64),name('CUIT')
RazonSocial                         cstring(256),name('RazonSocial')
Registro                            cstring(64),name('Registro')
NumeroPos                           cstring(16),name('NumeroPos')
FechaInicioActividades              cstring(64),name('FechaInicioActividades')
IngBrutos                           cstring(64),name('IngBrutos')
ResponsabilidadIVA                  cstring(64),name('ResponsabilidadIVA')
FechaInicioActividadesCompleta      cstring(64),name('FechaInicioActividadesCompleta')
                                end !* group *
                            end !* group *
jParser				cJSONFactory
rta                 long
	code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        self.cuit = clip( ResponseGroup.ConsultarDatosInicializacion.CUIT )
        self.RazonSocial = clip( ResponseGroup.ConsultarDatosInicializacion.RazonSocial )
        self.Serial = clip( ResponseGroup.ConsultarDatosInicializacion.Registro )
        self.Prefijo = ResponseGroup.ConsultarDatosInicializacion.NumeroPos
        self.fecha_inicio = self.FiscalToDate( ResponseGroup.ConsultarDatosInicializacion.FechaInicioActividades )
        self.IIBB = clip( ResponseGroup.ConsultarDatosInicializacion.IngBrutos )
        self.IVA = clip( ResponseGroup.ConsultarDatosInicializacion.ResponsabilidadIVA )
        self.fecha_inicio_completa = self.FiscalToDate( ResponseGroup.ConsultarDatosInicializacion.FechaInicioActividadesCompleta )
        rta = FISCAL_OK
    else
        rta = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta
! -------------------------------------------------------------------------------------------------
FiscalInicializacion.Clean  procedure()!,private
    code
    self.CUIT = ''
    self.RazonSocial = ''
    self.Serial = ''
    self.Prefijo = 0
    self.fecha_inicio = 0
    self.fecha_inicio_completa = 0
    self.iibb = ''
    self.iva = ''
    
! -------------------------------------------------------------------------------------------------
FiscalInicializacion.Construct   procedure()
    code
    self.clean()
    self.SetCommand( 'ConsultarDatosInicializacion' )    

FiscalInicializacion.Destruct   procedure()
    code
    self.clean()

!* end *