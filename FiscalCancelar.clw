! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCancelar
!
! Gustavo Saracca (c) - 2025
! --------------------------------------------------------------------------------------------------
    member

    include( 'FiscalCancelar.inc' ),once
    include( 'cJson.inc' ),once

    map
    end !* map *

! --------------------------------------------------------------------------------------------------
FiscalCancelar.Encode   procedure()!,virtual
RequestGroup    group
Cancelar            group,name('Cancelar')
                    end !* group *
                end !* group *
jRoot			&cJSON
    code 
    jRoot &= json::CreateObject(RequestGroup, TRUE, | 
        '[{{"name":"*","IgnoreEmptyObject":false,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & | 
         '{{"name":["Cancelar"], "JsonName":"*"}]')
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString(true) )
        jRoot.Delete()
    end !* if *    
    
FiscalCancelar.Decode   procedure()!,long,virtual
ResponseGroup       group
Cancelar                group,name('Cancelar')
Secuencia                   cstring(16),name('Secuencia')
Estado                      like(EstadoType)
                        end !* group *
                    end !* group *
jParser             cJSONFactory
rta                 long
    code
    if jParser.ToGroup( self.GetResponse(), ResponseGroup, false, '' )
        rta = FISCAL_OK
    else
        rta = FISCAL_SYNTAX_ERROR
    end !* if *

    return rta    
! ----------------------------------------------------------------------------------
FiscalCancelar.Clean        procedure()!,private
    code
    
! ----------------------------------------------------------------------------------
FiscalCancelar.Construct    procedure()
    code
    self.clean()
    self.SetCommand( 'Cancelar' )    
    
FiscalCancelar.Destruct     procedure()
    code
    self.clean()
    
! ----------------------------------------------------------------------------------