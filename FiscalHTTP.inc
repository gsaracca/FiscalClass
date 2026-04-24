! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCommand
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalHTTP_ )
_FiscalHTTP_    EQUATE(1)

! --------------------------------------------------------------------------------------------------
! CONST
! --------------------------------------------------------------------------------------------------
HTTP:CURL_OK                EQUATE(00000H)
HTTP:CURL_ERROR             EQUATE(00001H)
HTTP:NET_ERROR              EQUATE(00010H)
! --------------------------------------------------------------------------------------------------
! FiscalHTTP : class()
! --------------------------------------------------------------------------------------------------
FiscalHTTP                  class,type,module( 'FiscalHTTP.clw' ),link( 'FiscalHTTP.clw' )
url                             cstring(1000),private
request                         cstring(64000),private
response                        cstring(64000),private

curl_code                       long,private
curl_response_code              long,private
curl_response_message           cstring(256),private
! ----------------------------------------------------
GenURL                          procedure(),private
! ----------------------------------------------------
SetCurlCode                     procedure( long _code )
SetCurlResponseCode             procedure( long _code )
SetCurlResponseMessage          procedure( string _msg )

GetCurlCode                     procedure(),long
GetCurlResponseCode             procedure(),long
GetCurlResponseMessage          procedure(),string

IsANetworkError                 procedure(),long
! ----------------------------------------------------
SetRequest                      procedure( string _request )
GetResponse                     procedure(),string,protected
! ----------------------------------------------------
clean                           procedure(),protected
Run                             procedure(),long
! ----------------------------------------------------
Construct                       procedure()
Destruct                        procedure()
                            end !* class *

  _EndOfInclude_

!* end *