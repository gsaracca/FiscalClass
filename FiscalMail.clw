

PF_send_mail    procedure( string _tcom, long _number )
str_cmd         cstring(250)
rta             string(64000)
str_json        cstring(64000)
g_first         group,pre(gf)
json                cstring(4000),name('ObtenerPrimerBloqueDocumento')
                end !* group *
g_next          group,pre(gn)
json                cstring(4000),name('ObtenerSiguienteBloqueDocumento')
                end !* group *
g_block         group,pre(gb)
Secuencia           cstring(250),name('Secuencia')
Estado              cstring(250),name('Estado')
Registro            cstring(250),name('Registro')
Informacion         cstring(2000),name('Informacion')
                end !* group *
firstJSON       JSONDataClass            ! JSON: id / name
blockJSON       JSONDataClass
nextJSON        JSONDataClass            ! JSON: id / name
str_tcom        cstring(64)
int_num         long
if_ok           long
str_fn          cstring(250)
    code
    !str_msg = '{{"EnviarDocumentoCorreo":{{"CodigoComprobante":"TiqueFacturaB","NumeroComprobante":"' & _number & '","DireccionEMail":"gsaracca@gmail.com"}}'

    if_ok = false
    str_tcom = clip(_tcom)
    int_num  = _number
    str_fn   = str_tcom & '-' & format(int_num,@n08 )

    if InitFiscal()
        str_cmd = '{{"CopiarComprobante":{{"CodigoComprobante" : "' & str_tcom & '","NumeroComprobante" : "' & int_num & '"}}'
        if fiscal_exec( GetIP(), str_cmd, rta )
            str_json = clip(rta)
            if clip(str_json) <> ''
                firstJSON.Construct()
                blockJSON.Construct()
                nextJSON.Construct()

                open_log( str_fn )

                str_cmd = '{{"ObtenerPrimerBloqueDocumento":{{' & |
                                '"NumeroInicial" : "' & int_num & '",' & |
                                '"NumeroFinal" : "' & int_num & '",' & |
                                '"CodigoComprobante":"' & str_tcom & '",' & |
                                '"Zipea":"NoComprime",' & |
                                '"XMLUnico" : "XMLUnico"}}'
                if fiscal_exec( GetIP(), str_cmd, rta )
                    str_json = clip(rta)
                    if str_json <> ''
                        firstJSON.FromJson( str_json, g_first )
                        blockJSON.FromJson( g_first.json, g_block )
                        write_log( g_block.Informacion )
                    end !* if *
                end !* if *

                if clip(g_block.Registro) <> 'BloqueFinal' and (str_json <> '')
                    loop
                        str_cmd = '{{"ObtenerSiguienteBloqueDocumento":{{}}'
                        if fiscal_exec( GetIP(), str_cmd, rta )
                            str_json = clip(rta)
                            if str_json = ''
                                break
                            else
                                nextJSON.FromJson( str_json, g_next )
                                blockJSON.FromJson( g_next.json, g_block )
                                write_log( g_block.Informacion )
                                if clip(g_block.Registro) = 'BloqueFinal'
                                    if_ok = true
                                    break
                                end !* if *
                            end !* if *
                        end !* if *
                    end !* loop *
                end !* if *

                close_log()

                firstJSON.Destruct()
                blockJSON.Destruct()
                nextJSON.Destruct()
            end !* if *
        end !* if *
        if if_ok
            MsgSucc( '|Listo,...|' & |
                     '|Se generó el archivo de referencia [' & str_fn & '],|' & |
                     '|El proceso ha concluído con éxito.|' )
        else
            MsgError( '|Error,...|' & |
                      '|Se ha encontrado un error al intentar imprimir nuevamente el comprobante.|')
        end !* if *
    end !* if *

! end
