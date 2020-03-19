;{-------------------------------------------
; AUTHOR    : microdev
; DATE      : 2020-03-16
; CLASS     : _line
; VERSION   : 
; PROCESS   : 
;}-------------------------------------------
Module _LINE
  EnableExplicit
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
		EndWith
	EndProcedure
	
	;{ PROTECTED METHODS
	Procedure _draw(*this._members,withStart.b = #False)
	  With *this
	    Protected *p._TABLE::_members = \parent,n
	    If withStart
	      StartVectorDrawing(ImageVectorOutput(*p\image))
	    EndIf
	    Define *p._TABLE::_members = \parent
	    Protected w.d = ImageWidth(*p\image),c,x = 0,cf,
	              text.s,wc.d,yc
	    If \data And *p\current = *this\data
	      c = *p\selectedColors\bg
	      cf = *p\selectedColors\fg
	    Else
	      n = \n
	      If *p\scrollVOn
	        n  + GetGadgetState(*p\scrollV)
	      EndIf
	      If n % 2 ;doot
	        c = *p\dootColors\bg
	        cf = *p\dootColors\fg
	      Else
	        c = *p\pairColors\bg
	        cf = *p\pairColors\fg
	      EndIf
	    EndIf
	    VectorSourceColor(c)
	    AddPathBox(0,\y,w,*p\lineHeight)
	    FillPath()
	    If \data And *p\current = *this
	      VectorFont(FontID(*p\selectedLineFont))
	    Else
	      VectorFont(FontID(*p\lineFont))
	    EndIf
	    ForEach *p\myColumns()
	      wc = GadgetWidth(*p\idCanvas) * *p\myColumns()\width
	      If \data
	        VectorSourceColor(cf)
	        text = _COLUMN::_getValue(*p\myColumns(),\data)
	        yc = \y + ((*p\lineHeight / 2) - (VectorTextHeight(text) / 2))
	        MovePathCursor(x+8,yc)
	        DrawVectorParagraph(text,wc - 16,VectorTextHeight(text))
	      EndIf
	      VectorSourceColor(*p\colors\fg)
	      MovePathCursor(x + wc,\y)
	      AddPathLine(0,*p\lineHeight,#PB_Path_Relative)
	      StrokePath(1)
	      x + wc
	    Next
	    If withStart
	      StopVectorDrawing()
	    EndIf
	  EndWith
	EndProcedure
	
	Procedure setData(*this._members,*data)
	  With *this
	    \data = *data
	  EndWith
	EndProcedure
	
	Procedure setN(*this._members,n)
	  With *this
	    \n = n
	  EndWith
	EndProcedure
	;}
	;{-------------------------------------------
	; CONSTRUCTOR   : new
	; PARAMETER     : 
	;}-------------------------------------------
	Procedure new(n,*data,y,*parent._TABLE::_members)
		Protected *this._members = AllocateStructure(_members)
		With *this
		  \methods = ?S_MET 
		  \n = n
		  \data = *data
		  \y = y
		  \parent = *parent
			ProcedureReturn *this
		EndWith
	EndProcedure

	DataSection
		S_MET:
		
		E_MET:
	EndDataSection
EndModule
; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 32
; FirstLine = 23
; Folding = --
; EnableXP