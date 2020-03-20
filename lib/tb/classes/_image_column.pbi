;{-------------------------------------------
; AUTHOR    : microdev
; DATE      : 2020-03-20
; CLASS     : _image_column
; VERSION   : 
; PROCESS   : 
;}-------------------------------------------
Module _IMAGE_COLUMN
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
	
	;{ ABSTRACT METHODS
	Procedure.s _geter(*this._members,*data)
	  With *this
	    If \geter
	      ProcedureReturn  Str(\geter(*data))
	    EndIf
	  EndWith
	EndProcedure
	
	;{-------------------------------------------
	; CONSTRUCTOR   : new
	; PARAMETER     : 
	;}-------------------------------------------
	Procedure new(title.s,width.d,*geter)
		Protected *this._members = AllocateStructure(_members)
		With *this
		  _COLUMN::super()
		  \title = title
		  \width = width
		  \geter = *geter
		  \_geter = @_geter()
		  \image = #True
		  \size = 1
			ProcedureReturn *this
		EndWith
	EndProcedure
	
	;{ GETTERS AND SETTERS
	Procedure getGeter(*this._members)
	  With *this
	    ProcedureReturn \geter
	  EndWith
	EndProcedure
	
	Procedure setGeter(*this._members,*geter)
	  With *this
	    \geter = *geter
	  EndWith
	EndProcedure
	
	Procedure.d getSize(*this._members)
	  With *this
	    ProcedureReturn \size
	  EndWith
	EndProcedure
	
	Procedure setSize(*this._members,size.d)
	  With *this
	    \size = size
	    If \size > 1
	      \size = 1
	    EndIf
	  EndWith
	EndProcedure


	
	;}
	
	DataSection
		S_MET:
    Data.i @getGeter()
    Data.i @setGeter()
    Data.i @getSize()
    Data.i @setSize()
		E_MET:
	EndDataSection
EndModule
; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 42
; FirstLine = 22
; Folding = ---
; EnableXP