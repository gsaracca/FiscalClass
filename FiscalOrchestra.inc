! --------------------------------------------------------------------------------------------------
! CLASS : FiscalOrchestra
! --------------------------------------------------------------------------------------------------
  OMIT('_EndOfInclude_', _FiscalOrchestra_ )
_FiscalOrchestra_   EQUATE(1)

TQcmd                   queue,type
desc                        cstring(256)
id                          cstring(64)
cmd                         cstring(1000)
                        end !* queue *

FiscalOrchestra         class(),type,module( 'FiscalOrchestra.clw' ),link( 'FiscalOrchestra.clw' )
Qcmd                        &TQcmd,private
Fiscal                      &FiscalCommand,private
letra                       cstring(16),private
Comprobante                 cstring(64),private
Copias                      long,private
ModoDisplay                 cstring(64),private
Title                       cstring(256),private

is_ok                       long,private
idx                         long,private
high                        long,private
! ------------------------------------------------------------------------------------------------
clean                       procedure(),private
add_cmd                     procedure( string _id, string _desc, string _cmd ),private
! ------------------------------------------------------------------------------------------------
SetComprobante              procedure( string _comprobante ),private
GetComprobante              procedure(),string,private

SetLetra                    procedure( string _letra ),private
GetLetra                    procedure(),string,private

SetCopias                   procedure( long _copias )
GetCopias                   procedure(),long,private

SetModoDisplay              procedure( string _modo_display )
GetModoDisplay              procedure(),string

SetTitle                    procedure( string _title )
GetTitle                    procedure(),string
! ------------------------------------------------------------------------------------------------
MapPago                     procedure( string _type, *cstring _forma_pago ),long,private
AddPago                     procedure( string _type, string _text, string _importe ),private
ClipText                    procedure( string _text ),string,private
ClipMoney                   procedure( string _money ),real,private
! ------------------------------------------------------------------------------------------------
CargarDatosCliente          procedure( string _rs, string _doc, string _tiva, string _tdoc, string _dom ),private
! ------------------------------------------------------------------------------------------------
Init                        procedure( string _title )

Cliente                     procedure( string _letra, string _doc, string _tiva, string _nombre, string _dom )

Titulo                      procedure( string _tipo ),private
TituloFC                    procedure()                             ! Ticket - Factura.
TituloNC                    procedure()                             ! Ticket - Nota de Crédito.

Texto                       procedure( string _texto )              ! Hasta 4x antes del ITEM
Item                        procedure( string _desc, string _cant, string _precio, string _tasa )

Percepcion                  procedure( string _text, string _base, string _importe )
Bonif                       procedure( string _text, string _importe )
Pago                        procedure( string _type, string _text, string _importe )
Ajuste                      procedure( string _text, string _importe )
Cierre                      procedure()

TituloNF                    procedure()                             ! Ticket - No Fiscal.
TextoNF                     procedure( string _text )
CierreNF                    procedure()

ZonaFoot                    procedure( long _zona, long _line, string _msg, long _flags )
ZonaHead                    procedure( long _zona, long _line, string _msg, long _flags )
ZonaDomicilioEmisor         procedure( long _line, string _msg, long _flags )
ZonaFantasia                procedure( long _line, string _msg, long _flags )
! ------------------------------------------------------------------------------------------------
IsOk                        procedure(),long
Start                       procedure( long _high )
Open                        procedure()
TimerOn                     procedure()
TimerOff                    procedure()
InLoop                      procedure(),long
NextStep                    procedure()
Close                       procedure()
AskAbort                    procedure(),long
SelectLine                  procedure( long _line )
! ------------------------------------------------------------------------------------------------
Cancelar                    procedure()
GetUltimo                   procedure(),long
! ------------------------------------------------------------------------------------------------
Construct                   procedure()
Destruct                    procedure()
! ------------------------------------------------------------------------------------------------
Run                         procedure(),long
! ------------------------------------------------------------------------------------------------
                        end !* class *

  _EndOfInclude_

!* end *
