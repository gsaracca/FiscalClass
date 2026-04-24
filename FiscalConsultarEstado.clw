! --------------------------------------------------------------------------------------------------
! CLASS : FiscalConsultarEstado
! --------------------------------------------------------------------------------------------------
    member()

    include( 'FiscalConsultarEstado.inc' )
    include( 'cJson.inc' ),once

FiscalConsultarEstado.SetComprobante procedure( string _comprobante )
    code
    self.comprobante = _comprobante

FiscalConsultarEstado.GetComprobante procedure()!,string
    code
    return self.comprobante

FiscalConsultarEstado.GetEstadoInterno procedure()!,string
    code
    return self.EstadoInterno

FiscalConsultarEstado.GetComprobanteEnCurso procedure()!,string
    code
    return self.ComprobanteEnCurso

FiscalConsultarEstado.GetCodigoComprobante procedure()!,string
    code
    return self.CodigoComprobante

FiscalConsultarEstado.GetNumeroUltimoComprobante procedure()!,long
    code
    return self.NumeroUltimoComprobante

FiscalConsultarEstado.GetCantidadEmitidos procedure()!,long
    code
    return self.CantidadEmitidos

FiscalConsultarEstado.GetCantidadCancelados procedure()!,long
    code
    return self.CantidadCancelados

FiscalConsultarEstado.Encode procedure()!,protected,virtual
RequestGroup            group
ConsultarEstado             group,name('ConsultarEstado')
CodigoComprobante               cstring(64),name('CodigoComprobante')
                            end !* group *
                        end !* group *
jParser				    cJSONFactory
jRoot				    &cJSON
    code
    clear( RequestGroup )
    RequestGroup.ConsultarEstado.CodigoComprobante = self.GetComprobante()
    
    jRoot &= json::CreateObject( RequestGroup, TRUE, |
            '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
             '{"name":["ConsultarEstado","CodigoComprobante"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString(true) )
		jRoot.Delete()
    end !* if *

FiscalConsultarEstado.Decode procedure()!,long,protected,virtual
ResponseGroup           group
ConsultarEstado             group,name('ConsultarEstado')
Secuencia                       cstring(16),name('Secuencia')
Estado                          like(EstadoType)
EstadoAuxiliar                  group,dim(12),name('EstadoAuxiliar')
                                end !* group *
EstadoInterno                   cstring(64),name('EstadoInterno')
ComprobanteEnCurso              cstring(64),name('ComprobanteEnCurso')
CodigoComprobante               cstring(64),name('CodigoComprobante')
NumeroUltimoComprobante         cstring(16),name('NumeroUltimoComprobante')
CantidadEmitidos                cstring(16),name('CantidadEmitidos')
CantidadCancelados              cstring(16),name('CantidadCancelados')
                            end !* group *
                        end !* group *
jParser				    cJSONFactory
rta                     long
	code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        self.EstadoInterno = ResponseGroup.ConsultarEstado.EstadoInterno
        self.ComprobanteEnCurso = ResponseGroup.ConsultarEstado.ComprobanteEnCurso
        self.CodigoComprobante = ResponseGroup.ConsultarEstado.CodigoComprobante
        self.NumeroUltimoComprobante = ResponseGroup.ConsultarEstado.NumeroUltimoComprobante
        self.CantidadEmitidos = ResponseGroup.ConsultarEstado.CantidadEmitidos
        self.CantidadCancelados = ResponseGroup.ConsultarEstado.CantidadCancelados        
        rta = FISCAL_OK
    else        
        rta = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta

FiscalConsultarEstado.Clean procedure()
    code
    self.SetComprobante( '' )
    self.EstadoInterno = ''
    self.ComprobanteEnCurso = ''
    self.CodigoComprobante = ''
    
    self.NumeroUltimoComprobante = 0
    self.CantidadEmitidos = 0
    self.CantidadCancelados = 0

FiscalConsultarEstado.Construct procedure()
    code
    self.clean()    
    self.SetCommand( 'ConsultarEstado' )
    
FiscalConsultarEstado.Destruct  procedure()
    code
    self.clean()

!* end *