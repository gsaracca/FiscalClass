! --------------------------------------------------------------------------------------------------
! CLASS : FiscalAuditNumber
! --------------------------------------------------------------------------------------------------
    member()

    include( 'FiscalAuditNumber.inc' ),once
    include( 'cJson.inc' ),once

FiscalAuditNumber.SetDesde      procedure( long _desde )
    code
    self.desde = _desde
    
FiscalAuditNumber.SetHasta      procedure( long _hasta )
    code
    self.hasta = _hasta

FiscalAuditNumber.SetDetallado  procedure( long _detallado )
    code
    self.is_detallado = _detallado
    
FiscalAuditNumber.GetDetallado  procedure()!,string
sMode       cstring(64)
    code
    if self.is_detallado
        sMode = 'ReporteAuditoriaDiscriminado'
    else
        sMode = 'ReporteAuditoriaGlobal'
    end !* if *
    return sMode    
        
FiscalAuditNumber.Encode        procedure()!,virtual
RequestGroup            group
ReportarZetasPorNumeroZeta  group,name('ReportarZetasPorNumeroZeta')
ZetaInicial                     cstring(16),name('ZetaInicial')
ZetaFinal                       cstring(16),name('ZetaFinal')
Reporte                         cstring(64),name('Reporte')
                            end 
                        end 
jRoot				    &cJSON
    code
    clear( RequestGroup )
    RequestGroup.ReportarZetasPorNumeroZeta.ZetaInicial = self.desde
    RequestGroup.ReportarZetasPorNumeroZeta.ZetaFinal = self.hasta
    RequestGroup.ReportarZetasPorNumeroZeta.Reporte = self.GetDetallado()
    
    jRoot &= json::CreateObject( RequestGroup, true, | 
        '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & | 
         '{"name":["ReportarZetasPorNumeroZeta","ZetaInicial","ZetaFinal","Reporte"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString( true ) )
        jRoot.Delete()
    end !* if *

FiscalAuditNumber.Decode        procedure()!,long,virtual
    code
    return false

FiscalAuditNumber.Construct     procedure()
    code

FiscalAuditNumber.Destruct      procedure()
    code
