    member()

    include( 'FiscalTools.inc' ),once
    include( 'FiscalTypes.inc' ),once
    include( 'cJson.inc' ),once    
    
    map
    end !* map *

! -------------------------------------------------------------------------------------------------    
! TYPES
! -------------------------------------------------------------------------------------------------
TQattrib            Queue,type
attribute               cstring(64)
                    end !* queue *    
! -------------------------------------------------------------------------------------------------    
! CLASS
! -------------------------------------------------------------------------------------------------    
FlagClass           class(),type
flag                    long,private
idx                     long,private
Qatributos              &TQattrib

add                     procedure( long _flg, string _value )
set                     procedure()
hasNext                 procedure(),long
getNext                 procedure(),string
init                    procedure( long _flg )
done                    procedure()
                    end !* class *    

! ------------------------------------------------------------------------------------------------
! FiscalTools   class()
! Function Tools
! (c) 2025 - Gustavo Saracca
! ------------------------------------------------------------------------------------------------
FiscalTools.get_cmd_zona procedure( string _zona, long _linea, string _text, long _flags )!,string
MAX_ATTRIB          equate(8)

Zona                group
ConfigurarZona          group,name('ConfigurarZona')
NumeroLinea                 cstring(4),name('NumeroLinea')
Atributos                   cstring(32),DIM(MAX_ATTRIB),name('Atributos')
Descripcion                 cstring(256),name('Descripcion')
Estacion                    cstring(32),name('Estacion')
IdentificadorZona           cstring(32),name('IdentificadorZona')
                        end !* group *
                    end !* group *
jRoot				&cJSON
rta                 cstring(1000)
Flag                FlagClass
i                   long
    code
    clear( rta )
    clear( zona )
    zona.ConfigurarZona.NumeroLinea =  _linea

    Flag.Init( _flags )
    Flag.Add( FLAG:DELETE,  Atributos:BorradoTexto )
    Flag.Add( FLAG:WIDE,    Atributos:DobleAncho )
    Flag.Add( FLAG:CENTER,  Atributos:Centrado )
    Flag.Add( FLAG:BOLD,    Atributos:Negrita )
    i = 1
    Flag.Set()
    loop
        if Flag.hasNext()
            zona.ConfigurarZona.Atributos[i] = Flag.getNext()
        elsif i >= MAX_ATTRIB
            break
        else
            break
        end !* if *
        i = i + 1
    end !* loop *
    Flag.Done()

    zona.ConfigurarZona.Descripcion =   clip(_text)
    zona.ConfigurarZona.Estacion    =   'EstacionPorDefecto'
    zona.ConfigurarZona.IdentificadorZona = clip(_zona)

    jRoot &= json::CreateObject( Zona, true, |
        '[{"name":"*","IgnoreEmptyObject":true,"IgnoreEmptyArray":true,"EmptyString":"ignore"},' & |
         '{"name":["ConfigurarZona","NumeroLinea","Atributos","Descripcion","Estacion","IdentificadorZona"], "JsonName":"*"}]')
    if not jRoot &= NULL
        rta = jRoot.ToString(true)
        jRoot.Delete()
    end !* if *

    return rta

FlagClass.add       procedure( long _flg, string _value )
    code
    if band( self.flag, _flg )
        clear( self.Qatributos )
        self.Qatributos = clip(_value)
        add( self.Qatributos )
    end !* if *

FlagClass.set       procedure()
    code
    self.idx = 1

FlagClass.hasNext   procedure()!,long
is_next             long
    code
    is_next = false
    if self.idx <= records( self.Qatributos )
        is_next = true
    end !* if *

    return is_next

FlagClass.getNext       procedure()!,string
rtaStr                  cstring(64)
    code
    clear( rtaStr )
    get( self.Qatributos, self.idx )
    if not errorcode()
        rtaStr = self.Qatributos.attribute
    end !* if *
    self.idx = self.idx + 1

    return rtaStr

FlagClass.Init      procedure( long _flg )
    code
    self.flag   =   _flg
    self.idx    =   0
    self.Qatributos &= new( TQattrib )
    clear( self.Qatributos )
    free( self.Qatributos )

FlagClass.Done      procedure()
    code
    self.flag = 0
    self.idx = 0
    if not self.Qatributos &= NULL
        clear( self.Qatributos )
        free( self.Qatributos )
        dispose( self.Qatributos )
    end !* if *

!* end *