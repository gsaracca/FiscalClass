! --------------------------------------------------------------------------------------------------
! CLASS : FiscalCopiarComprobante
!
! Gustavo Saracca (c) - 2026
! --------------------------------------------------------------------------------------------------
    member

    include( 'FiscalCopiarComprobante.inc' ),once
    include( 'cJson.inc' ),once

    map
    end !* map *
! --------------------------------------------------------------------------------------------------    
FiscalCopiarComprobante.SetComprobante  procedure( string _comprobante )
    code
    self.CodigoComprobante = clip(_comprobante)
    
FiscalCopiarComprobante.GetComprobante  procedure()!,string
    code
    return self.CodigoComprobante

FiscalCopiarComprobante.SetNumero   procedure( long _numero )
    code
    self.NumeroComprobante = _numero
    
FiscalCopiarComprobante.GetNumero   procedure()!,long    
    code
    return self.NumeroComprobante
! --------------------------------------------------------------------------------------------------
FiscalCopiarComprobante.Encode   procedure()!,virtual
RequestGroup            group
CopiarComprobante           group,name('CopiarComprobante')
CodigoComprobante               cstring(16),name('CodigoComprobante')
NumeroComprobante               cstring(64),name('NumeroComprobante')
                            end !* group *
                        end !* group 
jRoot			        &cJSON
    code 
    clear( RequestGroup )
    RequestGroup.CopiarComprobante.CodigoComprobante = self.GetComprobante()
    RequestGroup.CopiarComprobante.NumeroComprobante = self.GetNumero()
    
    jRoot &= json::CreateObject(RequestGroup, true, | 
      '[{{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & | 
       '{{"name":["CopiarComprobante","CodigoComprobante","NumeroComprobante"], "JsonName":"*"}]')    
    if not jRoot &= NULL
        self.SetRequest( jRoot.ToString(true) )
        jRoot.Delete()
    end !* if *    
    
FiscalCopiarComprobante.Decode   procedure()!,long,virtual
ResponseGroup       group
Cancelar                group,name('CopiarComprobante')
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
FiscalCopiarComprobante.Clean        procedure()!,private
    code
    
! ----------------------------------------------------------------------------------
FiscalCopiarComprobante.Construct    procedure()
    code
    self.clean()
    self.SetCommand( 'CopiarComprobante' )
    
FiscalCopiarComprobante.Destruct     procedure()
    code
    self.clean()
    
! ----------------------------------------------------------------------------------