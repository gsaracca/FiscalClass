    member()

    include( 'FiscalConfig.inc' ),once

    map
        MsgBoxBase( string )
    end !* map *

MsgBox                  &MsgProcType
FiscalGroup             group
IP                          cstring(32)
Marca                       long
Model                       long
Pref                        long
NC                          long
Serial                      cstring(64)
                        end !* group *
LogGroup                group
Enable                       long
FileName                     cstring(1000)
                        end !* group *

MsgBoxBase              procedure( string _msg )
    code
    message( clip(_msg), 'Fiscal-Config', ICON:Hand, '>>> &Continuar <<<', 1, MSGMODE:FIXEDFONT + MSGMODE:CANCOPY )

FiscalConfig.SetMarca           procedure( long _marca )
    code
    FiscalGroup.Marca = _marca

FiscalConfig.SetModel           procedure( long _model )
    code
    FiscalGroup.model = _model

FiscalConfig.SetPref            procedure( long _pref )
    code
    FiscalGroup.pref = _pref

FiscalConfig.SetNC              procedure( long _nc )
    code
    FiscalGroup.NC = _nc

FiscalConfig.SetSerial          procedure( string _serial )
    code
    FiscalGroup.serial = clip(_serial)

FiscalConfig.SetIP              procedure( string _ip )
    code
    FiscalGroup.ip = clip(_ip)

FiscalConfig.GetMarca           procedure()!,long
    code
    return FiscalGroup.marca

FiscalConfig.GetMarcaStr        procedure()!,string
sMarca          cstring(256)
    code
    case self.GetMarca()
    of 1
        sMarca = 'Epson'
    of 2
        sMarca = 'Hasar'
    of 9
        sMarca = 'No Print'
    else
        sMarca = 'Desconocida'
    end !* case *

    return sMarca

FiscalConfig.GetModel           procedure()!,long
    code
    return FiscalGroup.model

FiscalConfig.GetModelStr        procedure()!,string
sModel          cstring(256)
    code
    case self.GetModel()
    of 1
        sModel = 'TM2000AF'
    of 2
        sModel = 'TM2000AF'
    of 3
        sModel = 'N/A-3'
    of 4
        sModel = 'TMU220AF'
    of 5
        sModel = 'N/A-5'
    of 6
        sModel = 'LX-300'
    of 7
        sModel = 'SMH/P 441F'
    of 8
        sModel = 'P-1100'
    of 9
        sModel = 'Virtual'
    else
        sModel = 'Desconocido'
    end !* case *

    return sModel

FiscalConfig.GetPref        procedure()!,long
    code
    return FiscalGroup.Pref

FiscalConfig.GetNC          procedure()!,long
    code
    return FiscalGroup.NC

FiscalConfig.GetSerial      procedure()!,string
    code
    return FiscalGroup.Serial

FiscalConfig.GetSerialPrefix procedure()!,string
    code
    return sub( self.GetSerial(), 1, 2 )

FiscalConfig.GetIP          procedure()!,string
    code
    return FiscalGroup.ip

FiscalConfig.CheckMarcaSerial   procedure()!,long
is_ok                           long
    code
    is_ok = false
	if self.GetSerial() = 'ABCDEF0000000001'
	    is_ok = true
	else
		case self.GetSerialPrefix()
			of 'HH' orof 'HS'
				if self.GetMarca() = 2
					is_ok = true
				end !* if *
			of 'PE'
				if self.GetMarca() = 1
					is_ok = true
				end !* if *
		end !* case *
	end !* if *

    return is_ok
! --------------------------------------------------------------------------------------------------
FiscalConfig.SetLog             procedure( long _log )
    code
    LogGroup.Enable = _log

FiscalConfig.IsLog              procedure()!,long
    code
    return LogGroup.Enable

FiscalConfig.SetLogFileName     procedure( string _fname )
    code
    LogGroup.FileName = clip(_fname)

FiscalConfig.GetLogFileName     procedure()!,string
    code
    return LogGroup.FileName
! --------------------------------------------------------------------------------------------------    
FiscalConfig.SetMsgBox          procedure( *MsgProcType _proc )  
    code
    MsgBox &= _proc

FiscalConfig.Message            procedure( string _msg )    
    code
    MsgBox( _msg )
    
! --------------------------------------------------------------------------------------------------
FiscalConfig.clean              procedure()
fiscal_log                      long
    code
    clear( FiscalGroup )
    clear( LogGroup )    

! --------------------------------------------------------------------------------------------------
FiscalConfig.Construct          procedure()
    code
    self.Clean()
    self.SetMsgBox( MsgBoxBase )

FiscalConfig.Destruct           procedure()
    code
    self.Clean()

!* end *
