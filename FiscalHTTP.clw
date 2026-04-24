    member()

    include( 'FiscalHTTP.inc' ),once
    include( 'FiscalLog.inc' ),once
    include( 'FiscalConfig.inc' ),once

    include( 'LibCurl.inc' ),once
    include( 'cJson.inc' ),once

    map
        DebugStr( string _msg )
        module('Windows API')
            DebugString( *cstring lpOutputString),pascal,raw,name('OutputDebugStringA')
        end !* module *    
    end !* map *

DebugStr                procedure( string _msg )
prefix                  string('[FiscalCommand] ')
cs                      cstring(LEN(_msg) + len(prefix) + 1)
  CODE
  cs = prefix & _msg
  DebugString( cs )    

FiscalHTTP.GenURL   procedure()
http_protocol       cstring('http')
http_path           cstring('fiscal.json')
    code
    self.url = http_protocol & '://' & FiscalConfig.GetIP() & '/' & http_path
    
FiscalHTTP.SetCurlCode procedure( long _code )
    code
    self.curl_code = _code
    
FiscalHTTP.SetCurlResponseCode procedure( long _code )
    code
    self.curl_response_code = _code
    
FiscalHTTP.SetCurlResponseMessage procedure( string _msg )
    code
    self.curl_response_message = clip(_msg)

FiscalHTTP.GetCurlCode procedure()!,long
    code
    return self.curl_code
    
FiscalHTTP.GetCurlResponseCode procedure()!,long
    code
    return self.curl_response_code
    
FiscalHTTP.GetCurlResponseMessage procedure()!,string
    code
    return self.curl_response_message
    
FiscalHTTP.IsANetworkError procedure()!,long
is_an_error     long
    code
    is_an_error = true
    case self.GetCurlResponseCode()
        of 000 to 199                       ! 1xx informational response
        of 200 to 299                       ! 2xx success
            is_an_error = false
        of 300 to 399                       ! 3xx redirection errors
        of 400 to 499                       ! 4xx client error
        of 500 to 599                       ! 5xx server error
        else                                ! xxx Non-standard errors
    end !* case *
    return is_an_error
    
! ----------------------------------------------------
FiscalHTTP.SetRequest procedure( string _request )!,protected
    code
    self.request = json::ToUtf8(_request)
    
FiscalHTTP.GetResponse procedure()!,*cstring,protected
    code
    return json::FromUtf8( self.response )
    
! ----------------------------------------------------       
FiscalHTTP.clean    procedure()
    code
    self.url = ''
    self.request = ''
    self.response = ''
    self.SetCurlCode( 0 )
    self.SetCurlResponseCode( 0 )
    self.SetCurlResponseMessage( '' )

FiscalHTTP.Run       procedure()!,long
curl                    TCurlClass
Tlog                    FiscalLog
rta                     CURLcode
responseBuff            &IDynStr
level                   long
    code
    self.GenURL()

    Tlog.Init()
    Tlog.SetOn( FiscalConfig.IsLog() )
    Tlog.SetFileName( FiscalConfig.GetLogFileName() )
    Tlog.open()
    Tlog.write( 'URL -> ' & self.url )
    Tlog.write( self.request )
    
    ! ------------------------------------------------------------------------------
    ! SetUp CURL & Headers
    ! ------------------------------------------------------------------------------
    curl.Init()
    curl.FreeHttpHeaders()
    curl.AddHttpHeader( 'Content-Type: application/json' )
    rta = curl.SetHttpHeaders()
    ! ------------------------------------------------------------------------------
    ! SetUp Request & Protocol
    ! ------------------------------------------------------------------------------
    rta = curl.SetCustomRequest( 'POST' )
    rta = curl.SetDefaultProtocol( 'https' )
    ! ------------------------------------------------------------------------------
    ! CALL Printer
    ! ------------------------------------------------------------------------------
    responseBuff &= NewDynStr()
    rta = curl.SendRequest( self.url, self.request, responseBuff )
    self.SetCurlCode( rta )
    self.SetCurlResponseCode( curl.GetResponseCode() )
    self.SetCurlResponseMessage( curl.StrError(rta) )    
    if rta = CURLE_OK               
        self.response = responseBuff.Str()
        if self.IsANetworkError()
            level = HTTP:CURL_ERROR
        else
            level = HTTP:CURL_OK
        end !* if *
        Tlog.write( self.response )        
    else
        Tlog.write(  'CURL Rta: ' & self.GetCurlCode() & |
                     ' - [' & self.GetCurlResponseCode() & '] ' & |
                     'CURL Error: ' & self.GetCurlResponseMessage() & '<13,10>' )
        level = HTTP:NET_ERROR                        
    end !* if *   
    DisposeDynStr( responseBuff )
    
    Tlog.Close()
    curl.CleanUp()

    return level

FiscalHTTP.Construct    procedure()
    code
    self.clean()

FiscalHTTP.Destruct procedure()
    code
    self.clean()

!* end *
