    member()

    include( 'FiscalClass.inc' ),once
    include( 'FiscalConfig.inc' ),once    
    include( 'FiscalInicializacion.inc' ),once

    map
        module('\SOURCE\OSG\GROUP\GROUP.DLL')
            ZVar_GetAndSet( string, string ),string,DLL
        end !* module *
        module('..\access\access.lib')
            make_export_log_path(),string,dll
            MsgWarn( string ),dll
            MsgError( string ),dll
            MsgErrorSQL( *cstring ),dll
            WriteTXT( string, string, long ),dll
        end !* module *
    end !* map *
    pragma('link(..\group\group.lib)')
    pragma('link(..\access\access.lib)')

FiscalClass.LoadIP  procedure()
vPDF                file,driver( 'MSSQL', '/TURBOSQL=TRUE' ),pre(v)
record                  record
ip                          cstring(64)                        end !* record *
                    end !* file *
sql_cmd             cstring(1000)
is_ok               long
    code
    FiscalConfig.SetIP( '' )
    is_ok = false

    sql_cmd = |
        'select <13,10>' & |
            '<9>[IP] = pcfg.fiscal_ip <13,10>' & |
            '<9>into #temp <13,10>' & |
        'from <13,10>' & |
            '<9>pdf_config pcfg <13,10>' & |
        'where <13,10>' & |
            '<9>(pcfg.pdf = ' & self.GetPdF() & ') <13,10>' & |
        'select * from #temp <13,10>'

    WriteTXT( 'fiscal_get_pdf_config.sql', sql_cmd, true )

    vPDF{ prop:owner } = self.GetConnectionString()
    open( vPDF )
    vPDF{ prop:sql } = sql_cmd
    if errorcode()
        MsgErrorSQL( sql_cmd )
    else
        loop
            next( vPDF )
            if errorcode()
                break
            elsif vPDF.ip <> ''
                FiscalConfig.SetIP( vPDF.ip )
                is_ok = true
                break
            end !* if *
        end !* if *
    end !* if *
    close( vPDF )

    return is_ok

FiscalClass.LoadFiscal  procedure()!,long
Fiscal                  FiscalInicializacion
fname                   cstring(1000)
is_ok                   long
    code
    fname = make_export_log_path() & 'log\gs_fiscal_start'
    FiscalConfig.SetLogFileName( fname ) 
    
    is_ok = false
    if Fiscal.Run() = FISCAL_OK
        FiscalConfig.SetSerial( Fiscal.GetSerial() )
        FiscalConfig.SetPref( Fiscal.GetPrefijo() )

        fname = make_export_log_path() & 'log\gs_fiscal_' & Fiscal.GetSerial()
        FiscalConfig.SetLogFileName( fname )
        is_ok = true
    end !* end *
    return is_ok

FiscalClass.LoadParams  procedure()!,long
view_data       file,driver( 'MSSQL', '/TURBOSQL=TRUE' ),pre(v)
record              record
pref                    long
if_nc                   long
marca                   long
modelo                  long
                    end !* record *
                end !* file *
sql_cmd         cstring(1000)
is_ok           long
    code
    is_ok = false
    sql_cmd = |
            'select <13,10>' & |
                '<9>[pref]   = pf.prefijo,     <13,10>' & |
                '<9>[if_nc]  = pf.if_print_nc, <13,10>' & |
                '<9>[marca]  = pf.marca,       <13,10>' & |
                '<9>[modelo] = pf.modelo       <13,10>' & |
                'into #temp <13,10>' & |
            'from <13,10>' & |
                '<9>pdf_fiscales pf <13,10>' & |
            'where <13,10>' & |
                '<9>(pf.fiscal = <39>' & FiscalConfig.GetSerial() & '<39>) <13,10>' & |
            'select * from #temp <13,10>'

    WriteTXT( 'fiscal_get_pdf_fiscales.sql', sql_cmd, true )

    view_data{ prop:owner } = self.GetConnectionString()
    open( view_data )
    view_data{ prop:sql } = sql_cmd
    if errorcode()
        MsgErrorSQL( sql_cmd )
    else
        loop
            next( view_data )
            if errorcode()
                break
            else
                self.config_prefijo = v:pref
                FiscalConfig.SetNC( v:if_nc )
                FiscalConfig.SetMarca( v:marca )
                FiscalConfig.SetModel( v:modelo )
                is_ok = true
                break
            end !* if *
        end !* loop *
    end !* if *
    close( view_data )

    return is_ok

FiscalClass.SetPdF      procedure( long _pdf )
    code
    self.pdf = _pdf

FiscalClass.GetPdF      procedure()!,long
    code
    return self.pdf
    
FiscalClass.GetPrefijo  procedure()!,long
    code
    return self.config_prefijo

FiscalClass.SetConnectionString procedure( string _cs )
    code
    self.connection_string = clip(_cs)

FiscalClass.GetConnectionString procedure()!,string
    code
    return self.connection_string

FiscalClass.Clean       procedure()
    code
    self.SetPdF( 0 )
    self.SetConnectionString( '' )
    self.config_prefijo = 0    

FiscalClass.Open        procedure()
is_open                 long
    code
    FiscalConfig.SetLog( ZVar_GetAndSet( 'Fiscal.Log', 0 ) )
    is_open = false
    if not self.LoadIP()
        MsgWarn( '|Cuidado,...|' & |
                 '|La impresora asignada a esta punto de facturación [' & format( self.GetPdF(), @p<<#.##p ) & '] no tiene una IP asignada.|' )
    elsif not self.LoadFiscal()
        MsgError( '|Error,...|' & |
                  '|Al obtener el comando de inicialización para la impresora [' & FiscalConfig.GetIP() & '].|' )
    elsif not self.LoadParams()
        MsgError( '|Error,...|' & |
                  '|La impresora con el número de serie [' & FiscalConfig.GetSerial() & '] no está configurada en el sistema.|' )
    elsif self.GetPrefijo() <> FiscalConfig.GetPref()
        MsgWarn( '|Cuidado,...|' & |
                    '|Inconsistencia en los prefijos de la impresora [' & FiscalConfig.GetSerial() & ']' & |
                    '|' & |                    
                    '|* Prefijo Impresora: ' & format( FiscalConfig.GetPref(), @n05 ) & |
                    '|* Prefijo Sistema: ' & format( self.GetPrefijo(), @n05 ) & |
                    '|' & |
                    '|El prefijo de la impresora no coíncide con el prefijo configurado en el sistema.|' )
    elsif not FiscalConfig.CheckMarcaSerial()
        MsgWarn( '|Cuidado,...|' & |
                 '|La impresora fiscal [' & FiscalConfig.GetSerial() & '].|' & |
                 '|Parecer ser una (' & FiscalConfig.GetMarca() & ') [' & FiscalConfig.GetMarcaStr() & '].|' & |
                 '|Lo cual no corresponde a la actual configuración.|' )
    else
        is_open = true
    end !* if *
    return is_open
    
! --------------------------------------------------------------------------------------------------
FiscalClass.Construct   procedure()
    code
    self.clean()

FiscalClass.Destruct    procedure()
    code
    self.clean()

!* end *