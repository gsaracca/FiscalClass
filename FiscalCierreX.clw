! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCierreX
!
! Gustavo Saracca (c) - 2025
! --------------------------------------------------------------------------------------------------
    member

    include( 'FiscalCierreX.inc' ),once
    include( 'cJson.inc' ),once

    map
    end !* map *

! --------------------------------------------------------------------------------------------------
FiscalCierreX.SetNumero      procedure( long _numero )
    code
    self.numero = _numero

FiscalCierreX.GetNumero      procedure()!,long
    code
    return self.numero

! ----------------------------------------------------------------------------------
FiscalCierreX.SetFechaInicio procedure( *cstring _fecha )
    code
    self.fecha_inicio = self.FiscalToDate( _fecha )

FiscalCierreX.GetFechaInicio procedure()!,long
    code
    return self.fecha_inicio

! ----------------------------------------------------------------------------------
FiscalCierreX.SetHoraInicio procedure( *cstring _hora )
    code
    self.hora_inicio = self.FiscalToTime( _hora )

FiscalCierreX.GetHoraInicio procedure()!,long
    code
    return self.hora_inicio

! ----------------------------------------------------------------------------------
FiscalCierreX.SetFechaCierre procedure( *cstring _fecha )
    code
    self.fecha_cierre = self.FiscalToDate( _fecha )

FiscalCierreX.GetFechaCierre procedure()!,long
    code
    return self.fecha_cierre

! ----------------------------------------------------------------------------------
FiscalCierreX.SetHoraCierre procedure( *cstring _hora )
    code
    self.hora_cierre = self.FiscalToTime( _hora )

FiscalCierreX.GetHoraCierre procedure()!,long
    code
    return self.hora_cierre

! ----------------------------------------------------------------------------------
FiscalCierreX.Encode procedure()
RequestGroup            group
CerrarJornadaFiscal         group,name('CerrarJornadaFiscal')
Reporte                         cstring(64),name('Reporte')
                            end !* group *
                        end !* group *
jParser				    cJSONFactory
jRoot				    &cJSON
	code
	RequestGroup.CerrarJornadaFiscal.Reporte = 'ReporteX'
    jRoot &= json::CreateObject( RequestGroup, TRUE, |
            '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
             '{"name":["CerrarJornadaFiscal","Reporte"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString(true) )
		jRoot.Delete()
    end !* if *

FiscalCierreX.Decode         procedure()
ResponseGroup               group
CerrarJornadaFiscal             group,name('CerrarJornadaFiscal')
Secuencia                           cstring(16),name('Secuencia')
Estado                              like(EstadoType)
Reporte                             cstring(64),name('Reporte')
Numero                              cstring(16),name('Numero')
FechaInicio                         cstring(16),name('FechaInicio')
HoraInicio                          cstring(16),name('HoraInicio')
FechaCierre                         cstring(16),name('FechaCierre')
HoraCierre                          cstring(16),name('HoraCierre')
DF_Total                            cstring(16),name('DF_Total')
DF_TotalIVA                         cstring(16),name('DF_TotalIVA')
DF_TotalTributos                    cstring(16),name('DF_TotalTributos')
DF_CantidadEmitidos                 cstring(16),name('DF_CantidadEmitidos')
NC_Total                            cstring(16),name('NC_Total')
NC_TotalIVA                         cstring(16),name('NC_TotalIVA')
NC_TotalTributos                    cstring(16),name('NC_TotalTributos')
NC_CantidadEmitidos                 cstring(16),name('NC_CantidadEmitidos')
DNFH_CantidadEmitidos               cstring(16),name('DNFH_CantidadEmitidos')
                                end !* group *
                            end !* group *
jParser				        cJSONFactory
rta                         long
    code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        self.SetNumero( ResponseGroup.CerrarJornadaFiscal.Numero )
        self.SetFechaInicio( ResponseGroup.CerrarJornadaFiscal.FechaInicio )
        self.SetHoraInicio ( ResponseGroup.CerrarJornadaFiscal.HoraInicio  )
        self.SetFechaCierre( ResponseGroup.CerrarJornadaFiscal.FechaCierre )
        self.SetHoraCierre ( ResponseGroup.CerrarJornadaFiscal.HoraCierre  )
        rta = FISCAL_OK
    else
        rta = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta

FiscalCierreX.Clean  procedure()
    code
    self.numero = 0
    self.fecha_inicio = 0
    self.hora_inicio = 0
    self.fecha_cierre = 0
    self.hora_cierre = 0    

FiscalCierreX.Construct procedure()
    code
    self.clean()
    self.SetCommand( 'CerrarJornadaFiscal' )    

FiscalCierreX.Destruct procedure()
    code
    self.clean()

!* end *
