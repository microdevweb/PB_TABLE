; ---------------------------------------------------------
; MODULE   : TB
; AUTHOR   : microdevWeb
; DATE     : 2020/03/15
; VERSION  : 1.0
; ---------------------------------------------------------
XIncludeFile "../../lib/tb/_tb.pbi"
DeclareModule TB
  Structure _default_colors
    table_background.l
    table_front.l
    doot_line_background.l
    doot_line_front.l
    pair_line_background.l
    pair_line_front.l
    selected_line_background.l
    selected_line_front.l
    column_background.l
    column_front.l
    title_background.l
    title_front.l
  EndStructure
  Structure _size
    title_height.l
    column_height.l
    line_height.l
    scroll_size.l
  EndStructure
  Structure _font
    title_font.l
    columnTitle.l
    lineFont.l
    selectedFont.l
  EndStructure
  Structure _toolTip
    bgColor.l
    fgColor.l
    font.l
  EndStructure
  Global defaultColors._default_colors
  Global defaultSize._size
  Global defaultFont._font
  Global defaultTooltip._toolTip
  Interface table
    getTitle.s()
    setTitle(title.s)
    getTitleBgColors()
    setTitleBgColors(color)
    getTitleFgColors()
    setTitleFgColors(color)
    
    getBgPairColors()
    setBgPairColors(color)
    getFgPairColors()
    setFgPairColors(color)
    
    getBgDootColors()
    setBgDootColors(color)
    getFgDootColors()
    setFgDootColors(color)
    
    getBgSelectedColors()
    setBgSelectedColors(color)
    getFgSelectedColors()
    setFgSelectedColors(color)
    
    getTitleFont()
    setTitleFont(font)
    
    getTitleHeight()
    setTitleHeight(height)
    
    getLineHeight()
    setLineHeight(height)
    
    getLineFont()
    setLineFont(font)
    
    getSelectedLineFont()
    setSelectedLineFont(font)
    
    getColumnTitleHeight()
    setColumnTitleHeight(height)
    
    getBgTooltipColors(color)
    setBgTooltipColors(color)
    
    getFgTooltipColors(color)
    setFgTooltipColors(color)
    
    getToolTipFont()
    setToolTipFont(font)
    
    show()
    addColumn(column)
    addLine(lineData)
    setSelectCallback(callback)
    resize()
  EndInterface
  Interface _column ; abstract class don't use it 
    getTitle()
		setTitle(title.s)
		getBgColors()
		setBgColors(color)
    getFgColors()
    setFgColors(color)
    getWidth.d()
    setWidth(width.d)
    enableTooltip(geter)
  EndInterface
  Interface stringColumn Extends _column
    getGeter()
    setGeter(geter)
    setEditable(seter)
	EndInterface
	Interface integerColumn Extends _column
    getGeter()
    setGeter(geter)
    setEditable(seter)
	EndInterface
	Interface floatColumn Extends _column
    getGeter()
    setGeter(geter)
    getNumberDecimal()
    setNumberDecimal(number)
    setEditable(seter)
  EndInterface
  Interface doubleColumn Extends _column
    getGeter()
    setGeter(geter)
    getNumberDecimal()
    setNumberDecimal(number)
    setEditable(seter)
  EndInterface
  Interface imageColumn Extends _column
    getGeter()
    setGeter(geter)
    getSize()
    setSize(size.d)
  EndInterface
  Declare newTable(container)
  Declare newStringColumn(title.s,width.d,*getter)
  Declare newIntegerColumn(title.s,width.d,*getter)
  Declare newFloatColumn(title.s,width.d,*getter,numberDecimal = 2)
  Declare newDoubleColumn(title.s,width.d,*getter,numberDecimal = 2)
  Declare newImageColumn(title.s,width.d,*getter)
EndDeclareModule
Module TB
  With defaultColors
    \table_background = $FF4F4F4F
    \table_front = $FFFFFFFF
    \column_background = $FF4D4D4D
    \column_front = $FFFFFFFF
    \doot_line_background = $FFADADAD
    \doot_line_front = $FF000000
    \pair_line_background = $FF4D4D4D
    \pair_line_front = $FFFFFFFF
    \selected_line_background = $FFFF901E
    \selected_line_front = $FFFFFFFF
    \title_background = $FF4F4F4F
    \title_front = $FFFFFFFF
  EndWith
  With defaultSize
    \title_height = 30
    \column_height = 30
    \line_height = 30
    \scroll_size = 15
  EndWith
  With defaultFont
    \title_font = LoadFont(#PB_Any,"arial",12,#PB_Font_HighQuality)
    \columnTitle = LoadFont(#PB_Any,"arial",10,#PB_Font_HighQuality)
    \lineFont = LoadFont(#PB_Any,"arial",10,#PB_Font_HighQuality)
    \selectedFont = LoadFont(#PB_Any,"arial",11,#PB_Font_HighQuality|#PB_Font_Bold)
  EndWith
  With defaultTooltip
    \bgColor = $FF5C5C5C
    \fgColor = $FFFFFFFF
    \font = LoadFont(#PB_Any,"arial",11,#PB_Font_HighQuality|#PB_Font_Italic)
  EndWith
  Procedure newTable(container)
    ProcedureReturn _TABLE::new(container)
  EndProcedure
  Procedure newStringColumn(title.s,width.d,*getter)
    ProcedureReturn _STRING_COLUMN::new(title,width,*getter)
  EndProcedure
  Procedure newIntegerColumn(title.s,width.d,*getter)
    ProcedureReturn _INTEGER_COLUMN::new(title,width,*getter)
  EndProcedure
  Procedure newFloatColumn(title.s,width.d,*getter,numberDecimal = 2)
    ProcedureReturn _FLOAT_COLUMN::new(title,width,*getter,numberDecimal)
  EndProcedure
  Procedure newDoubleColumn(title.s,width.d,*getter,numberDecimal = 2)
    ProcedureReturn _DOUBLE_COLUMN::new(title,width,*getter,numberDecimal)
  EndProcedure
  Procedure newImageColumn(title.s,width.d,*getter)
    ProcedureReturn _IMAGE_COLUMN::new(title,width,*getter)
  EndProcedure
EndModule
XIncludeFile "../../lib/tb/_tb_classes.pbi"
; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 97
; FirstLine = 55
; Folding = 6--
; EnableXP