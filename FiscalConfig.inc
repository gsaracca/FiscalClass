! --------------------------------------------------------------------------------------------------
! CLASS : FiscalConfig
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalConfig_ )
_FiscalConfig_  EQUATE(1)

! --------------------------------------------------------------------------------------------------
! TYPE
! --------------------------------------------------------------------------------------------------
    map
        MsgProcType( string ),type
    end !* map *        

! --------------------------------------------------------------------------------------------------
! FiscalConfig : class()
! --------------------------------------------------------------------------------------------------
FiscalConfig                class,module( 'FiscalConfig.clw' ),link( 'FiscalConfig.clw' )
! ----------------------------------------------------
clean                           procedure(),private
! ----------------------------------------------------
SetIP                           procedure( string _ip )
SetMarca                        procedure( long _marca )
SetModel                        procedure( long _model )
SetPref                         procedure( long _pref )
SetNC                           procedure( long _nc )
SetSerial                       procedure( string _serial )
! ----------------------------------------------------
GetIP                           procedure(),string
GetMarca                        procedure(),long
GetModel                        procedure(),long
GetPref                         procedure(),long
GetNC                           procedure(),long
GetSerial                       procedure(),string

GetMarcaStr                     procedure(),string
GetModelStr                     procedure(),string
GetSerialPrefix                 procedure(),string
! ----------------------------------------------------
SetLog                          procedure( long _log )
IsLog                           procedure(),long

SetLogFileName                  procedure( string _fname ) 
GetLogFileName                  procedure(),string
! ----------------------------------------------------
CheckMarcaSerial                procedure(),long
! ----------------------------------------------------
SetMsgBox                       procedure( *MsgProcType _proc )
Message                         procedure( string _msg )
! ----------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
                            end !* class *

  _EndOfInclude_
