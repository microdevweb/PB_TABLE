;{-------------------------------------------
; AUTHOR    : microdev
; DATE      : 2020-03-15
; CLASS     : _table
; VERSION   : 
; PROCESS   : 
;}-------------------------------------------

Module _TABLE
  EnableExplicit
  
  Declare draw(*this._members)
  Declare eventScrollH()
  Declare eventScrollV()
  Declare makeLines(*this._members)
  Declare eventCanvas()
  Declare show(*this._members)
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

	;{-------------------------------------------
	; CONSTRUCTOR   : new
	; PARAMETER     : 
	;}-------------------------------------------
	Procedure new(container)
		Protected *this._members = AllocateStructure(_members)
		With *this
			\methods = ?S_MET 
			\colors\bg = TB::defaultColors\table_background
			\colors\fg = TB::defaultColors\table_front
			\titleColors\bg = TB::defaultColors\title_background
			\titleColors\fg = TB::defaultColors\title_front
			\titleFont = TB::defaultFont\title_font
			\titleHeight = TB::defaultSize\title_height
			\lineHeight = TB::defaultSize\line_height
			\lineFont = TB::defaultFont\lineFont
			\pairColors\bg = TB::defaultColors\pair_line_background
			\pairColors\fg = TB::defaultColors\pair_line_front
			\dootColors\bg = TB::defaultColors\doot_line_background
			\dootColors\fg = TB::defaultColors\doot_line_front
			\selectedColors\bg = TB::defaultColors\selected_line_background
			\selectedColors\fg = TB::defaultColors\selected_line_front
			\selectedLineFont = TB::defaultFont\selectedFont
			\container = container
			\columnTitleHeight = TB::defaultSize\column_height
			Protected w = GadgetWidth(\container),
			         h = GadgetHeight(\container)
			w = _TB::dpiX(w)
			h = _TB::dpiY(h)
			\idCanvas = CanvasGadget(#PB_Any,0,0,w,h,#PB_Canvas_Keyboard|#PB_Canvas_Container)
			SetGadgetData(\idCanvas,*this)
			\scrollV = ScrollBarGadget(#PB_Any,w - TB::defaultSize\scroll_size,0,
			                           TB::defaultSize\scroll_size,h - TB::defaultSize\scroll_size,0,0,20,#PB_ScrollBar_Vertical)
			SetGadgetData(\scrollV,*this)
			BindGadgetEvent(\scrollV,@eventScrollV())
			HideGadget(\scrollV,#True)
			\scrollH = ScrollBarGadget(#PB_Any,0,h - TB::defaultSize\scroll_size,
			                           w - TB::defaultSize\scroll_size,TB::defaultSize\scroll_size,
			                           0,0,20)
			SetGadgetData(\scrollH,*this)
			HideGadget(\scrollH,#True)
			BindGadgetEvent(\scrollH,@eventScrollH())
			CloseGadgetList()
			\image = CreateImage(#PB_Any,w,h)
			makeLines(*this)
			BindGadgetEvent(\idCanvas,@eventCanvas())
			ProcedureReturn *this
		EndWith
	EndProcedure
	
	;{ EVENT METHODS
	Procedure eventScrollH()
	  Protected *this._members = GetGadgetData(EventGadget())
	  With *this
	    draw(*this)
	  EndWith
	EndProcedure
	
	Procedure onALine(*this._members,my)
	  With *this
	    Protected y 
	    
	    ForEach \mylines()
	      y = \mylines()\y 
	      If Len(\title)
	        y + \titleHeight
	      EndIf
	      If my >= y And my <= y + \lineHeight And \mylines()\data
	        ProcedureReturn \mylines()
	      EndIf
	    Next
	    ProcedureReturn 0
	  EndWith
	EndProcedure
	
	Procedure refreshLine(*this._members)
	  With *this
	    ForEach \mylines()
	      StartVectorDrawing(ImageVectorOutput(\image))
	      _LINE::_draw(\mylines())
	      StopVectorDrawing()
	    Next
	  EndWith
	EndProcedure
	
	Procedure onAColumn(*this._members,mx,*x)
	  With *this
	    Protected w = GadgetWidth(\idCanvas),wc.d,x.d,xc
	    If \scrollHOn
	        xc = GetGadgetState(\scrollH)
	      EndIf
	    ForEach \myColumns()
	      wc = w * \myColumns()\width
	      If mx+xc >= x And mx+xc <= x+wc
	        PokeL(*x,x)
	        ProcedureReturn \myColumns()
	      EndIf
	      x + wc
	    Next
	    ProcedureReturn 0
	  EndWith
	EndProcedure
	
	Procedure eventCanvas()
	  Protected *this._members = GetGadgetData(EventGadget())
	  With *this
	    Static mx,my
	    Static *line._LINE::_members,*column._COLUMN::_members
	    Select EventType()
	      Case #PB_EventType_MouseEnter
	        SetActiveGadget(\idCanvas)
	      Case #PB_EventType_MouseMove
	        mx = GetGadgetAttribute(\idCanvas,#PB_Canvas_MouseX)
	        my = GetGadgetAttribute(\idCanvas,#PB_Canvas_MouseY)
	        ; look if on a line
	        *line = onALine(*this,my)
	        If *line
	          SetGadgetAttribute(\idCanvas,#PB_Canvas_Cursor,#PB_Cursor_Hand)
	          ProcedureReturn 
	        EndIf
	        SetGadgetAttribute(\idCanvas,#PB_Canvas_Cursor,#PB_Cursor_Default)
	      Case #PB_EventType_LeftClick
	        If *line
	          \current = *line\data
	          refreshLine(*this)
	          draw(*this)
	          If \selectCallback
	            \selectCallback(*line\data)
	          EndIf
	        EndIf
	      Case #PB_EventType_LeftDoubleClick
	        If *line
	          \current = *line\data
	          refreshLine(*this)
	          draw(*this)
	          Protected cx
	          *column = onAColumn(*this,mx,@cx)
	          If *column
	            If *column\_seter
	              *column\_seter(*column,*line,cx)
	            EndIf
	          EndIf
	        EndIf
	      Case #PB_EventType_MouseWheel
	        Protected delta = GetGadgetAttribute(\idCanvas,#PB_Canvas_WheelDelta)
	        If delta < 0
	          If GetGadgetState(\scrollV) < GetGadgetAttribute(\scrollV,#PB_ScrollBar_Maximum)
	            SetGadgetState(\scrollV,GetGadgetState(\scrollV)+1)
	            PostEvent(#PB_Event_Gadget,EventWindow(),\scrollV)
	            ForEach \myColumns()
	              If IsGadget(\myColumns()\id)
	                PostEvent(#PB_Event_Gadget,EventWindow(),\myColumns()\id,#PB_EventType_LostFocus)
	              EndIf
	            Next
	          EndIf
	        Else
	          If GetGadgetState(\scrollV) > 0
	            SetGadgetState(\scrollV,GetGadgetState(\scrollV)-1)
	            PostEvent(#PB_Event_Gadget,EventWindow(),\scrollV)
	            ForEach \myColumns()
	              If IsGadget(\myColumns()\id)
	                PostEvent(#PB_Event_Gadget,EventWindow(),\myColumns()\id,#PB_EventType_LostFocus)
	              EndIf
	            Next
	          EndIf
	        EndIf
	    EndSelect
	  EndWith
	EndProcedure
	
	Procedure assignLine(*this._members)
	  With *this
	    Protected index
	    ForEach \mylines()
	      index = ListIndex(\mylines())
	      If \scrollVOn
	        index + GetGadgetState(\scrollV)
	      EndIf
	      If SelectElement(\myData(),index)
	        _LINE::setData(\mylines(),\myData())
	      Else
	        _LINE::setData(\mylines(),0)
	      EndIf
	    Next
	  EndWith
	EndProcedure
	
	Procedure eventScrollV()
	  Protected *this._members = GetGadgetData(EventGadget())
	  With *this
	    assignLine(*this)
	    show(*this)
	  EndWith
	EndProcedure
	;}
	
	;{ PRIVATE METHODS
	
	Procedure drawCorner(*this._members)
	  With *this
	    If \scrollHOn Or \scrollVOn
	      Protected x = GadgetWidth(\idCanvas) - TB::defaultSize\scroll_size,
	                y = GadgetHeight(\idCanvas) - TB::defaultSize\scroll_size,
	                s = TB::defaultSize\scroll_size
	      VectorSourceColor($FFE5E5E5)
	      AddPathBox(x,y,s,s)
	      FillPath()
	    EndIf
	  EndWith
	EndProcedure
	
	Procedure drawTitle(*this._members)
	  With *this
	    If Not Len(\title) : ProcedureReturn :EndIf
	    VectorFont(FontID(\titleFont))
	    Protected w = GadgetWidth(\idCanvas),
	              txt.s = _TB::concatene(\title,w),
	              yc = (\titleHeight / 2) - (VectorTextHeight(txt) / 2)
	              
	    If \scrollVOn
	      w - TB::defaultSize\scroll_size
	    EndIf
	    VectorSourceColor(\titleColors\fg)
	    MovePathCursor(0,yc)
	    DrawVectorParagraph(txt,w,VectorTextHeight(txt),#PB_VectorParagraph_Center)
	  EndWith
	EndProcedure
	
	Procedure drawColumnTitle(*this._members)
	  With *this 
	    Protected x
	    ForEach \myColumns()
	      x + _COLUMN::_drawTitle(\myColumns(),x,*this)
	    Next
	  EndWith
	EndProcedure
	
	Procedure drawLine(*this._members)
	  With *this
	    ForEach \mylines()
	      _LINE::_draw(\mylines())
	    Next
	  EndWith
	EndProcedure
	
	Procedure drawContent(*this._members)
	  With *this
	    StartVectorDrawing(ImageVectorOutput(\image))
	    VectorSourceColor(\colors\bg)
	    FillVectorOutput()
	    drawColumnTitle(*this)
	    drawLine(*this)
	    StopVectorDrawing()
	  EndWith
	EndProcedure
	
	Procedure draw(*this._members)
	  With *this
	    Protected y,x 
	    StartVectorDrawing(CanvasVectorOutput(\idCanvas))
	    VectorSourceColor(\colors\bg)
	    FillVectorOutput()
	    drawTitle(*this)
	    If Len(\title)
	      y = \titleHeight
	    EndIf
	    If \scrollHOn
	      x = 0 - GetGadgetState(\scrollH)
	    EndIf
	    MovePathCursor(x,y)
	    DrawVectorImage(ImageID(\image))
	    drawCorner(*this)
	    StopVectorDrawing()
	  EndWith
	EndProcedure
	
	Procedure enableScrollH(*this._members)
	  With *this
	    Protected w = GadgetWidth(\idCanvas),
	              wt
	    ForEach \myColumns()
	      wt + w * \myColumns()\width
	    Next
	    If wt > w
	      SetGadgetAttribute(\scrollH,#PB_ScrollBar_Maximum,wt - w)
	      HideGadget(\scrollH,#False)
	      \scrollHOn = #True
	    Else
	      HideGadget(\scrollH,#True)
	      \scrollHOn = #False
	      SetGadgetState(\scrollH,0)
	    EndIf
	  EndWith
	EndProcedure
	
	Procedure makeLines(*this._members)
	  With  *this
	    ForEach \mylines()
	      FreeStructure(\mylines())
	    Next
	    ClearList(\mylines())
	    Protected h = ImageHeight(\image),
	              n = Round(h / \lineHeight,#PB_Round_Up),i,y = \columnTitleHeight
	    If Len(\title)
	      y + \titleHeight
	    EndIf
	    For i = 1 To n
	      AddElement(\mylines())
	      \mylines() = _LINE::new(i,0,y,*this)
	      y + \lineHeight
	    Next
	  EndWith
	EndProcedure
	
	Procedure enableScrollV(*this._members)
	  With *this
	    Protected nl = ListSize(\mylines()), ; number lines showed
	              nd = ListSize(\myData())   ; number lines of data
	    If nd > nl 
	      HideGadget(\scrollV,#False)
	      SetGadgetAttribute(\scrollV,#PB_ScrollBar_Maximum,nd)
	      \scrollVOn = #True
	    Else
	      HideGadget(\scrollV,#True)
	      \scrollVOn = #False
	    EndIf
	    SetGadgetState(\scrollV,0)
	  EndWith
	EndProcedure
	;}
	
	;{ GETTERS AND SETTERS
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

	Procedure getTitleBgColors(*this._members)
	  With *this
	    ProcedureReturn \titleColors\bg
	  EndWith
	EndProcedure
	
	Procedure setTitleBgColors(*this._members,color)
	  With *this
	    \titleColors\bg = color
	  EndWith
	EndProcedure
	
	Procedure getTitleFgColors(*this._members)
	  With *this
	    ProcedureReturn \titleColors\fg
	  EndWith
	EndProcedure
	
	Procedure setTitleFgColors(*this._members,color)
	  With *this
	    \titleColors\fg = color
	  EndWith
	EndProcedure
	
	Procedure getBgPairColors(*this._members)
	  With *this
	    ProcedureReturn \pairColors\bg
	  EndWith
	EndProcedure
	
	Procedure setBgPairColors(*this._members,color)
	  With *this
	    \pairColors\bg = color
	  EndWith
	EndProcedure

  Procedure getFgPairColors(*this._members)
	  With *this
	    ProcedureReturn \pairColors\fg
	  EndWith
	EndProcedure
	
	Procedure setFgPairColors(*this._members,color)
	  With *this
	    \pairColors\fg = color
	  EndWith
	EndProcedure
	
	Procedure getBgDootColors(*this._members)
	  With *this
	    ProcedureReturn \dootColors\bg
	  EndWith
	EndProcedure
	
	Procedure setBgDootColors(*this._members,color)
	  With *this
	    \dootColors\bg = color
	  EndWith
	EndProcedure

  Procedure getFgDootColors(*this._members)
	  With *this
	    ProcedureReturn \dootColors\fg
	  EndWith
	EndProcedure
	
	Procedure setFgDootColors(*this._members,color)
	  With *this
	    \dootColors\fg = color
	  EndWith
	EndProcedure
	
	Procedure getBgSelectedColors(*this._members)
	  With *this
	    ProcedureReturn \selectedColors\bg
	  EndWith
	EndProcedure
	
	Procedure setBgSelectedColors(*this._members,color)
	  With *this
	    \selectedColors\bg = color
	  EndWith
	EndProcedure

  Procedure getFgSelectedColors(*this._members)
	  With *this
	    ProcedureReturn \selectedColors\fg
	  EndWith
	EndProcedure
	
	Procedure setFgSelectedColors(*this._members,color)
	  With *this
	    \selectedColors\fg = color
	  EndWith
	EndProcedure
	
	Procedure getTitleFont(*this._members)
	  With *this
	    ProcedureReturn \titleFont
	  EndWith
	EndProcedure
	
	Procedure setTitleFont(*this._members,titleFont)
	  With *this
	    \titleFont = titleFont
	  EndWith
	EndProcedure
	
	Procedure getTitleHeight(*this._members)
	  With *this
	    ProcedureReturn \titleHeight
	  EndWith
	EndProcedure
	
	Procedure setTitleHeight(*this._members,height)
	  With *this
	    \titleHeight = height
	  EndWith
	EndProcedure

	Procedure getLineHeight(*this._members)
	  With *this
	    ProcedureReturn \lineHeight
	  EndWith
	EndProcedure
	
	Procedure setLineHeight(*this._members,height)
	  With *this
	    \lineHeight = height
	  EndWith
	EndProcedure
	
	Procedure getLineFont(*this._members)
	  With *this
	    ProcedureReturn \lineFont
	  EndWith
	EndProcedure
	
	Procedure setLineFont(*this._members,font)
	  With *this
	    \lineFont = font
	  EndWith
	EndProcedure

	Procedure getSelectedLineFont(*this._members)
	  With *this
	    ProcedureReturn \selectedLineFont
	  EndWith
	EndProcedure
	
	Procedure setSelectedLineFont(*this._members,font)
	  With *this
	    \selectedLineFont = font
	  EndWith
	EndProcedure

	Procedure getColumnTitleHeight(*this._members)
	  With *this
	    ProcedureReturn \columnTitleHeight
	  EndWith
	EndProcedure
	
	Procedure setColumnTitleHeight(*this._members,height)
	  With *this
	    \columnTitleHeight = height
	  EndWith
	EndProcedure




	;}
	
	;{ PUBLIC METHODS
  ;{ -------------------------------------------
  ; METHOD     : show
  ; PARAMETERS : 
  ; RETURN     : 
  ; PROCESS    : 
  ;} -------------------------------------------
	Procedure show(*this._members)
	  With *this
	    enableScrollH(*this)
	    drawContent(*this)
	    draw(*this)
	  EndWith
	EndProcedure
	
	;{ -------------------------------------------
  ; METHOD     : addColumn
  ; PARAMETERS : 
  ; RETURN     : 
  ; PROCESS    : 
  ;} -------------------------------------------
	Procedure addColumn(*this._members,*column)
	  With *this
	    Protected wt,w = GadgetWidth(\idCanvas)
	    AddElement(\myColumns())
	    \myColumns() = *column
	    ForEach \myColumns()
	      wt + w * \myColumns()\width
	    Next
	    If wt > w
	      ResizeImage(\image,wt,#PB_Ignore)
	    EndIf
	    ProcedureReturn *column
	  EndWith
	EndProcedure
	
	
	;{-------------------------------------------
	; METHOD     : addLine
	; PARAMETERS : 
	; RETURN     : 
	; PROCESS    : 
	;}-------------------------------------------
	Procedure addLine(*this._members,*data)
	  With *this
	    Protected index 
	    
	    AddElement(\myData())
	    index = ListIndex(\myData())
	    If \scrollVOn
	      index + GetGadgetState(\scrollV)
	    EndIf
		  \myData() = *data
		  If index > -1 And SelectElement(\mylines(),index)
		    _LINE::setData(\mylines(),*data)
		  EndIf
		  enableScrollV(*this)
		  ProcedureReturn ListIndex(\myData())
		EndWith
	EndProcedure

	Procedure setSelectCallback(*this._members,*callback)
	  With *this
	    \selectCallback = *callback
	  EndWith
	EndProcedure

	;}
	
	DataSection
	  S_MET:
	  Data.i @getTitle()
	  Data.i @setTitle()
    Data.i @getTitleBgColors()
    Data.i @setTitleBgColors()
    Data.i @getTitleFgColors()
    Data.i @setTitleFgColors()
    
    Data.i @getBgPairColors()
    Data.i @setBgPairColors()
    Data.i @getFgPairColors()
    Data.i @setFgPairColors()
    
    Data.i @getBgDootColors()
    Data.i @setBgDootColors()
    Data.i @getFgDootColors()
    Data.i @setFgDootColors()
    
    Data.i @getBgSelectedColors()
    Data.i @setBgSelectedColors()
    Data.i @getFgSelectedColors()
    Data.i @setFgSelectedColors()
    
    Data.i @getTitleFont()
    Data.i @setTitleFont()
    
    Data.i @getTitleHeight()
    Data.i @setTitleHeight()

    Data.i @getLineHeight()
    Data.i @setLineHeight()
    
    Data.i @getLineFont()
    Data.i @setLineFont()
    
    Data.i @getSelectedLineFont()
    Data.i @setSelectedLineFont()

    Data.i @getColumnTitleHeight()
    Data.i @setColumnTitleHeight()

    
    Data.i @show()
    Data.i @addColumn()
    Data.i @addLine()
    Data.i @setSelectCallback()
		E_MET:
	EndDataSection
EndModule
; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 656
; FirstLine = 197
; Folding = CAAgA7---A9
; EnableXP