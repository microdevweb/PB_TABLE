;{-------------------------------------------
; AUTHOR    : microdev
; DATE      : 2020-03-16
; CLASS     : _integer_column
; VERSION   : 
; PROCESS   : 
;}-------------------------------------------
Module _INTEGER_COLUMN
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
	
	;{ EVENT ON STRING GADGET
	Procedure evStr()
	  Protected *this._members = GetGadgetData(EventGadget())
	  With *this
	    Protected *p._TABLE::_members = \parent
	    Select EventType()
	        Case #PB_EventType_Change
	          \seter(\data,Val(GetGadgetText(\id)))
	        Case #PB_EventType_LostFocus
	          UnbindGadgetEvent(\id,@evStr())
	          FreeGadget(\id)
	          PostEvent(#PB_Event_Gadget,EventWindow(),*p\idCanvas)
	    EndSelect
	  EndWith
	EndProcedure
	;}
	
	;{ ABSTRACT METHODS
	Procedure.s _geter(*this._members,*data)
	  With *this
	    If \geter
	      ProcedureReturn  Str(\geter(*data))
	    EndIf
	  EndWith
	EndProcedure
	
	Procedure _seter(*this._members,*line._LINE::_members,x)
	  With *this
	    If Not  \seter:ProcedureReturn :EndIf
	    Protected *p._TABLE::_members = *line\parent,w = GadgetWidth(*p\idCanvas),
	              wc = w * \width,h = *p\lineHeight, y = *line\y + *p\columnTitleHeight
	    If *p\scrollHOn
	      x - GetGadgetState(*p\scrollH)
	    EndIf
	    \parent = *p
	    OpenGadgetList(*p\idCanvas)
	    \id = StringGadget(#PB_Any,x,y,wc,h,Str(\geter(*line\data)))
	    \data = *line\data
	    SetGadgetData(\id,*this)
	    BindGadgetEvent(\id,@evStr())
	    SetActiveGadget(\id)
	    CloseGadgetList()
	  EndWith
	EndProcedure
	;}
	
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
		  \_seter = @_seter()
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


	;}
	;{ PUBLIC METHODS
	Procedure setEditable(*this._members,*seter)
	  With *this
	    \seter = *seter
	  EndWith
	EndProcedure
	
	;}
	DataSection
		S_MET:
		Data.i @getGeter()
		Data.i @setGeter()
    Data.i @setEditable()
		E_MET:
	EndDataSection
EndModule
; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 61
; FirstLine = 42
; Folding = ---
; EnableXP