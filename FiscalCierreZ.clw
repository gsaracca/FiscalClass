! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCierreZ
! --------------------------------------------------------------------------------------------------
    member()

    include( 'FiscalCierreZ.inc' )
    include( 'cJson.inc' ),once

! --------------------------------------------------------------------------------------------------
FiscalCierreZ.SetNumero      procedure( long _numero )
    code
    self.numero = _numero

FiscalCierreZ.GetNumero      procedure()!,long
    code
    return self.numero

! ----------------------------------------------------------------------------------
FiscalCierreZ.SetFecha procedure( *cstring _fecha )
    code
    self.fecha = self.FiscalToDate( _fecha )

FiscalCierreZ.GetFecha procedure()!,long
    code
    return self.fecha

! ----------------------------------------------------------------------------------
FiscalCierreZ.GetDF_Total                     procedure()!,real
    code
    return self.DF.Total

FiscalCierreZ.GetDF_TotalGravado              procedure()!,real
    code
    return self.DF.TotalGravado

FiscalCierreZ.GetDF_TotalNoGravado            procedure()!,real
    code
    return self.DF.TotalNoGravado

FiscalCierreZ.GetDF_TotalExento               procedure()!,real
    code
    return self.DF.TotalExento

FiscalCierreZ.GetDF_TotalIVA                  procedure()!,real
    code
    return self.DF.TotalIVA

FiscalCierreZ.GetDF_TotalTributos             procedure()!,real
    code
    return self.DF.TotalTributos

FiscalCierreZ.GetDF_CantidadEmitidos          procedure()!,long
    code
    return self.DF.CantidadEmitidos

FiscalCierreZ.GetDF_CantidadCancelados        procedure()!,long
    code
    return self.DF.CantidadCancelados

FiscalCierreZ.GetNC_Total                     procedure()!,real
    code
    return self.NC.Total

FiscalCierreZ.GetNC_TotalGravado              procedure()!,real
    code
    return self.NC.TotalGravado

FiscalCierreZ.GetNC_TotalNoGravado            procedure()!,real
    code
    return self.NC.TotalNoGravado

FiscalCierreZ.GetNC_TotalExento               procedure()!,real
    code
    return self.NC.TotalExento

FiscalCierreZ.GetNC_TotalIVA                  procedure()!,real
    code
    return self.NC.TotalIVA

FiscalCierreZ.GetNC_TotalTributos             procedure()!,real
    code
    return self.NC.TotalTributos

FiscalCierreZ.GetNC_CantidadEmitidos          procedure()!,long
    code
    return self.NC.CantidadEmitidos

FiscalCierreZ.GetNC_CantidadCancelados        procedure()!,long
    code
    return self.NC.CantidadCancelados

FiscalCierreZ.GetDNFH_Total                   procedure()!,real
    code
    return self.DNFH.Total

FiscalCierreZ.GetDNFH_CantidadEmitidos        procedure()!,long
    code
    return self.DNFH.CantidadEmitidos

! ----------------------------------------------------------------------------------
FiscalCierreZ.Encode procedure()
RequestGroup            group
CerrarJornadaFiscal         group,name('CerrarJornadaFiscal')
Reporte                         cstring(64),name('Reporte')
                            end !* group *
                        end !* group *
jParser				    cJSONFactory
jRoot				    &cJSON
	code
	RequestGroup.CerrarJornadaFiscal.Reporte = 'ReporteZ'
    jRoot &= json::CreateObject( RequestGroup, TRUE, |
            '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
             '{"name":["CerrarJornadaFiscal","Reporte"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString(true) )
		jRoot.Delete()
    end !* if *

FiscalCierreZ.Decode procedure()
ResponseGroup               group
CerrarJornadaFiscal             group,name('CerrarJornadaFiscal')
Secuencia                           cstring(16),name('Secuencia')
Estado                              like(EstadoType)
Reporte                             cstring(64),name('Reporte')
Numero                              cstring(16),name('Numero')
Fecha                               cstring(16),name('Fecha')
DF_Total                            cstring(64),name('DF_Total')
DF_TotalGravado                     cstring(64),name('DF_TotalGravado')
DF_TotalNoGravado                   cstring(64),name('DF_TotalNoGravado')
DF_TotalExento                      cstring(64),name('DF_TotalExento')
DF_TotalIVA                         cstring(64),name('DF_TotalIVA')
DF_TotalTributos                    cstring(64),name('DF_TotalTributos')
DF_CantidadEmitidos                 cstring(16),name('DF_CantidadEmitidos')
DF_CantidadCancelados               cstring(16),name('DF_CantidadCancelados')
NC_Total                            cstring(64),name('NC_Total')
NC_TotalGravado                     cstring(64),name('NC_TotalGravado')
NC_TotalNoGravado                   cstring(64),name('NC_TotalNoGravado')
NC_TotalExento                      cstring(64),name('NC_TotalExento')
NC_TotalIVA                         cstring(64),name('NC_TotalIVA')
NC_TotalTributos                    cstring(64),name('NC_TotalTributos')
NC_CantidadEmitidos                 cstring(16),name('NC_CantidadEmitidos')
NC_CantidadCancelados               cstring(16),name('NC_CantidadCancelados')
DNFH_Total                          cstring(64),name('DNFH_Total')
DNFH_CantidadEmitidos               cstring(16),name('DNFH_CantidadEmitidos')
                                end !* group *
                            end !* group *
jParser				        cJSONFactory
rta                         long
    code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        self.SetNumero( ResponseGroup.CerrarJornadaFiscal.Numero )
        self.SetFecha( ResponseGroup.CerrarJornadaFiscal.Fecha )

        self.DF.Total = ResponseGroup.CerrarJornadaFiscal.DF_Total
        self.DF.TotalGravado = ResponseGroup.CerrarJornadaFiscal.DF_TotalGravado
        self.DF.TotalNoGravado = ResponseGroup.CerrarJornadaFiscal.DF_TotalNoGravado
        self.DF.TotalExento = ResponseGroup.CerrarJornadaFiscal.DF_TotalExento
        self.DF.TotalIVA = ResponseGroup.CerrarJornadaFiscal.DF_TotalIVA
        self.DF.TotalTributos = ResponseGroup.CerrarJornadaFiscal.DF_TotalTributos
        self.DF.CantidadEmitidos = ResponseGroup.CerrarJornadaFiscal.DF_CantidadEmitidos
        self.DF.CantidadCancelados = ResponseGroup.CerrarJornadaFiscal.DF_CantidadCancelados
        self.NC.Total = ResponseGroup.CerrarJornadaFiscal.NC_Total
        self.NC.TotalGravado = ResponseGroup.CerrarJornadaFiscal.NC_TotalGravado
        self.NC.TotalNoGravado = ResponseGroup.CerrarJornadaFiscal.NC_TotalNoGravado
        self.NC.TotalExento = ResponseGroup.CerrarJornadaFiscal.NC_TotalExento
        self.NC.TotalIVA = ResponseGroup.CerrarJornadaFiscal.NC_TotalIVA
        self.NC.TotalTributos = ResponseGroup.CerrarJornadaFiscal.NC_TotalTributos
        self.NC.CantidadEmitidos = ResponseGroup.CerrarJornadaFiscal.NC_CantidadEmitidos
        self.NC.CantidadCancelados = ResponseGroup.CerrarJornadaFiscal.NC_CantidadCancelados
        self.DNFH.Total = ResponseGroup.CerrarJornadaFiscal.DNFH_Total
        self.DNFH.CantidadEmitidos = ResponseGroup.CerrarJornadaFiscal.DNFH_CantidadEmitidos

        rta = FISCAL_OK
    else
        rta = FISCAL_SYNTAX_ERROR
    end !* if *
    
    return rta

FiscalCierreZ.Clean procedure()
    code
    clear( self.DF )
    clear( self.NC )
    clear( self.DNFH )

FiscalCierreZ.Construct procedure()
    code
    self.clean()
    self.SetCommand( 'CerrarJornadaFiscal' )    

FiscalCierreZ.Destruct procedure()
    code
    self.clean()

!* end *
