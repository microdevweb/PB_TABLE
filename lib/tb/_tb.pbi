; ---------------------------------------------------------
; MODULE   : TB
; AUTHOR   : microdevWeb
; DATE     : 2020/03/15
; VERSION  : 1.0
; ---------------------------------------------------------
DeclareModule _TB
  Structure _pos
    x.l
    y.l
    w.l
    h.l
  EndStructure
  Structure _colors
    fg.l
    bg.l
  EndStructure
  Declare.s concatene(text.s,widht.l)
EndDeclareModule

DeclareModule _COLUMN
  Prototype.s geter(*this,*data)
  Prototype seter(*this,*line,x)
  Prototype _draw(*this,x,y,*parent)
	Structure _members
	  *methods
	  width.d
	  title.s
	  colors._TB::_colors
	  font.l
	  *draw._draw
	  *_geter.geter
	  *_seter.seter
	  id.l
	  *data
	  *parent
	EndStructure
	Declare _super(*this._members,*s_daughter,*E_daughter)
	Macro super()
		_COLUMN::_super(*this,?S_MET,?E_MET)
	EndMacro
	Declare _drawTitle(*this._members,x,*parent)
	Declare.s _getValue(*this._members,*data)
EndDeclareModule

DeclareModule _STRING_COLUMN
  Prototype.s geter(*this)
  Prototype seter(*this,value.s)
	Structure _members Extends _COLUMN::_members
	  *geter.geter
	  *seter.seter
	EndStructure
	Declare _super(*this._members,*s_daughter,*E_daughter)
	Macro super()
		_STRING_COLUMN::_super(*this,?S_MET,?E_MET)
	EndMacro
	Declare new(title.s,width.d,*geter)
EndDeclareModule

DeclareModule _INTEGER_COLUMN
  Prototype geter(*this)
  Prototype seter(*this,value)
	Structure _members Extends _COLUMN::_members
	  *geter.geter
	  *seter.seter
	EndStructure
	Declare _super(*this._members,*s_daughter,*E_daughter)
	Macro super()
		_INTEGER_COLUMN::_super(*this,?S_MET,?E_MET)
	EndMacro
	Declare new(title.s,width.d,*geter)
EndDeclareModule

DeclareModule _FLOAT_COLUMN
  Prototype.f geter(*this)
  Prototype seter(*this,value.f)
	Structure _members Extends _COLUMN::_members
	  *geter.geter
	  numberDecimal.l
	  *seter.seter
	EndStructure
	Declare _super(*this._members,*s_daughter,*E_daughter)
	Macro super()
		_FLOAT_COLUMN::_super(*this,?S_MET,?E_MET)
	EndMacro
	Declare new(title.s,width.d,*geter,numberDecimal)
EndDeclareModule

DeclareModule _DOUBLE_COLUMN
  Prototype.d geter(*this)
  Prototype seter(*this,value.d)
	Structure _members Extends _COLUMN::_members
	  *geter.geter
	  numberDecimal.l
	  *seter.seter
	EndStructure
	Declare _super(*this._members,*s_daughter,*E_daughter)
	Macro super()
		_FLOAT_COLUMN::_super(*this,?S_MET,?E_MET)
	EndMacro
	Declare new(title.s,width.d,*geter,numberDecimal)
EndDeclareModule

DeclareModule _LINE
	Structure _members
	  *methods
	  n.l
	  *data
	  y.l
	  *parent
	EndStructure
	Declare _super(*this._members,*s_daughter,*E_daughter)
	Macro super()
		_LINE::_super(*this,?S_MET,?E_MET)
	EndMacro
	Declare new(n,*data,y,*parent)
	Declare _draw(*this._members,withStart.b = #False)
	Declare setData(*this._members,*data)
	Declare setN(*this._members,n)
EndDeclareModule

DeclareModule _TABLE
  Prototype callback(*this)
	Structure _members
	  *methods
	  container.l
	  idCanvas.l
	  scrollH.l
	  scrollV.l
	  colors._TB::_colors
	  pairColors._TB::_colors
	  dootColors._TB::_colors
	  selectedColors._TB::_colors
	  titleColors._TB::_colors
	  titleFont.l
	  titleHeight.l
	  lineHeight.l
	  lineFont.l
	  selectedLineFont.l
	  image.l
	  title.s
	  scrollVOn.b
	  scrollHOn.b
	  columnTitleHeight.l
	  List *myColumns._COLUMN::_members()
	  List *mylines._LINE::_members()
	  List *myData()
	  *current
	  *selectCallback.callback
	EndStructure
	Declare _super(*this._members,*s_daughter,*E_daughter)
	Macro super()
		_TABLE::_super(*this,?S_MET,?E_MET)
	EndMacro
	Declare new(container)
EndDeclareModule

Module _TB
  Procedure.s concatene(text.s,widht.l)
    Protected v.s = text
    While VectorTextWidth(v) > widht
      v = Left(v,Len(v) - 4)
      v + "..."
      If Len(v) <= 3
        ProcedureReturn v
      EndIf
    Wend
    ProcedureReturn  v
  EndProcedure
EndModule


; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 35
; FirstLine = 12
; Folding = Y8-P9
; EnableXP