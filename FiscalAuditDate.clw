! --------------------------------------------------------------------------------------------------
! CLASS : FiscalAuditDate
! --------------------------------------------------------------------------------------------------
    member()
    
    include( 'FiscalAuditDate.inc' ),once
    include( 'cJson.inc' ),once

! --------------------------------------------------------------------------------------------------
! CLASS : FiscalAuditDate
! --------------------------------------------------------------------------------------------------

FiscalAuditDate.SetDesde      procedure( long _desde )
    code
    self.desde = _desde
    
FiscalAuditDate.SetHasta      procedure( long _hasta )
    code
    self.hasta = _hasta

FiscalAuditDate.SetDetallado  procedure( long _detallado )
    code
    self.is_detallado = _detallado
    
FiscalAuditDate.GetDetallado    procedure()!,string
sMode       cstring(64)
    code
    if self.is_detallado
        sMode = 'ReporteAuditoriaDiscriminado'
    else
        sMode = 'ReporteAuditoriaGlobal'
    end !* if *
    return sMode 
    
FiscalAuditDate.Encode        procedure()!,virtual
RequestGroup        group
ReportarZetasPorFecha   group,name('ReportarZetasPorFecha')
FechaInicial                cstring(16),name('FechaInicial')
FechaFinal                  cstring(16),name('FechaFinal')
Reporte                     cstring(64),name('Reporte')
                        end !* group *
                    end !* group *
jRoot				&cJSON
    code   
    clear( RequestGroup )
    RequestGroup.ReportarZetasPorFecha.FechaInicial = self.DateToFiscal( self.desde )
    RequestGroup.ReportarZetasPorFecha.FechaFinal = self.DateToFiscal( self.hasta )
    RequestGroup.ReportarZetasPorFecha.Reporte = self.GetDetallado()
    
    jRoot &= json::CreateObject( RequestGroup, true, |
            '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
             '{"name":["ReportarZetasPorFecha","FechaInicial","FechaFinal","Reporte"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString( true ) )
        jRoot.Delete()
    end !* if *    
    
FiscalAuditDate.Decode        procedure()!,long,virtual
    code
    return false

FiscalAuditDate.Construct     procedure()
    code

FiscalAuditDate.Destruct      procedure()
    code

