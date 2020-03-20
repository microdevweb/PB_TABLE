;{-------------------------------------------
; AUTHOR    : microdev
; DATE      : 2020-03-16
; CLASS     : _column
; VERSION   : 
; PROCESS   : 
;}-------------------------------------------
Module _COLUMN
	; super constructor
	Procedure _super(*this._members,*s_daughter,*E_daughter)
		With *this
			; allocate memory
			Protected motherLen = ?E_MET - ?S_MET,
				daughterLen = *E_daughter - *s_daughter
			\methods = AllocateMemory(motherLen + daughterLen)
			; empilate methods address
			MoveMemory(?S_MET,\methods,motherLen)
			MoveMemory(*s_daughter,\methods + motherLen,daughterLen)
			; set default colors
			\colors\bg = TB::defaultColors\column_background
			\colors\fg = TB::defaultColors\column_front
			; set default font
			\font = TB::defaultFont\columnTitle
		EndWith
	EndProcedure
	
	;{ PROTECTED METHOD
	Procedure _drawTitle(*this._members,x,*parent._TABLE::_members)
	  With *this
	    Protected w.d = GadgetWidth(*parent\idCanvas) * \width
	    VectorSourceColor(\colors\bg)
	    AddPathBox(x,0,w,*parent\columnTitleHeight)
	    FillPath(#PB_Path_Preserve)
	    VectorSourceColor(*parent\colors\fg)
	    StrokePath(1)
	    VectorFont(FontID(\font))
	    Protected text.s = _TB::concatene(\title,w),
	              yc = (*parent\columnTitleHeight / 2) - (VectorTextHeight(text) / 2)
	    MovePathCursor(x,yc)
	    VectorSourceColor(\colors\fg)
	    DrawVectorParagraph(text,w,VectorTextHeight(text),#PB_VectorParagraph_Center)
	    ProcedureReturn w
	  EndWith
	EndProcedure
	
	Procedure.s _getValue(*this._members,*data)
	  With *this
	    If \_geter
	      ProcedureReturn  \_geter(*this,*data)
	    EndIf
	    ProcedureReturn ""  
	  EndWith
	EndProcedure
	;}
	
	;{ GEETTERS AND SETTERS
	Procedure.s getTitle(*this._members)
	  With *this
	    ProcedureReturn \title
	  EndWith
	EndProcedure
	
	Procedure setTitle(*this._members,title.s)
	  With *this
	    \title = title
	  EndWith
	EndProcedure
	
	Procedure getBgColors(*this._members)
	  With *this
	    ProcedureReturn \colors\bg
	  EndWith
	EndProcedure
	
	Procedure setBgColors(*this._members,color)
	  With *this
	    \colors\bg = colors
	  EndWith
	EndProcedure
	
	Procedure getFgColors(*this._members)
	  With *this
	    ProcedureReturn \colors\fg
	  EndWith
	EndProcedure
	
	Procedure setFgColors(*this._members,color)
	  With *this
	    \colors\fg = colors
	  EndWith
	EndProcedure

	Procedure.d getWidth(*this._members)
	  With *this
	    ProcedureReturn \width
	  EndWith
	EndProcedure
	
	Procedure setWidth(*this._members,width.d)
	  With *this
	    \width = width
	  EndWith
	EndProcedure

	;}
  ;{ PUBLIC METHODS
	Procedure enableTooltip(*this._members,*geter)
	  With *this
	    \tooltip = *geter
	  EndWith
	EndProcedure
	;}
	DataSection
		S_MET:
		Data.i @getTitle()
		Data.i @setTitle()
		Data.i @getBgColors()
		Data.i @setBgColors()
    Data.i @getFgColors()
    Data.i @setFgColors()
    Data.i @getWidth()
    Data.i @setWidth()
    Data.i @enableTooltip()
		E_MET:
	EndDataSection
EndModule
; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 122
; FirstLine = 98
; Folding = ----
; EnableXP