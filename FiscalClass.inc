! -------------------------------------------------------------------------------------------------
! CLASS : FiscalClass
! -------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalClass_ )
_FiscalClass_    EQUATE(1)


FiscalClass         class(),type,module( 'FiscalClass.clw' ),link( 'FiscalClass.clw' )
pdf                     long,private
connection_string       cstring(1000),private
config_prefijo          long,private
! -------------------------------------------------------------------------------------------------
SetPdF                  procedure( long _pdf )
GetPdF                  procedure(),long
GetPrefijo              procedure(),long
! -------------------------------------------------------------------------------------------------    
SetConnectionString     procedure( string _cs )
GetConnectionString     procedure(),string
! -------------------------------------------------------------------------------------------------    
Clean                   procedure(),private
! -------------------------------------------------------------------------------------------------
Open                    procedure(),long
LoadIP                  procedure(),long                ! From Current PDF -> Get IP
LoadFiscal              procedure(),long                ! From Current IP -> Get Serial/Pref
LoadParams              procedure(),long                ! From Current Serial -> Get Model/Pref
! -------------------------------------------------------------------------------------------------
Construct               procedure()
Destruct                procedure()
                    end !* class *

_EndOfInclude_
    