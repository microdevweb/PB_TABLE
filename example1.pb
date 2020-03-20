XIncludeFile "include/tb/tb.pbi"
UsePNGImageDecoder()
Enumeration 
  #FORM
  #CONTAINER
  #FIC
  #ST_FN
  #ST_SN
  #ST_AGE
  #ST_SIZE
  #ST_WEIGHT
EndEnumeration

Structure person
  firstName.s
  surname.s
  age.l
  size.f
  weight.d
  icon.l
EndStructure

Global NewList myPeople.person(),
               img_warning = CatchImage(#PB_Any,?war),
               img_phone = CatchImage(#PB_Any,?phone),  
               img_busnes = CatchImage(#PB_Any,?bus)


Procedure.s getFirstName(*this.person)
  With *this
    ProcedureReturn \firstName
  EndWith
EndProcedure

Procedure.s getSurName(*this.person)
  With *this
    ProcedureReturn \surname
  EndWith
EndProcedure

Procedure getAge(*this.person)
  With *this
    ProcedureReturn \age
  EndWith
EndProcedure

Procedure.f getSize(*this.person)
  With *this
    ProcedureReturn \size
  EndWith
EndProcedure

Procedure.d getWeight(*this.person)
  With *this
    ProcedureReturn \weight
  EndWith
EndProcedure

Procedure setName(*this.person,value.s)
  With *this
    \firstName = value
    SetGadgetText(#ST_FN,\firstName)
  EndWith
EndProcedure

Procedure setSurname(*this.person,value.s)
  With *this
    \surname = value
    SetGadgetText(#ST_SN,\surname)
  EndWith
EndProcedure

Procedure setAge(*this.person,value)
  With *this
    \age = value
    SetGadgetText(#ST_AGE,Str(value))
  EndWith
EndProcedure

Procedure setSize(*this.person,value.f)
  With *this
    \size = value
    SetGadgetText(#ST_SIZE,StrF(value))
  EndWith
EndProcedure

Procedure setWeight(*this.person,value.d)
  With *this
    \weight = value
    SetGadgetText(#ST_WEIGHT,StrD(value))
  EndWith
EndProcedure

Procedure getIcon(*this.person)
  With *this
    ProcedureReturn \icon
  EndWith
EndProcedure

Procedure exit()
  End
EndProcedure

Procedure makeData(table.TB::table)
  With myPeople()
    AddElement(myPeople())
    \firstName = "Pierre"
    \surname = "Bielen"
    \age = 55
    \size = 175.10
    \weight = 80.623
    \icon = img_busnes
    table\addLine(@myPeople())
    AddElement(myPeople())
    \firstName = "André"
    \surname = "Dupond"
    \age = 48
    \size = 165.25
    \weight = 70.428
    \icon = img_warning
    table\addLine(@myPeople())
    AddElement(myPeople())
    \firstName = "Paul"
    \surname = "Godelaine"
    \age = 49
    \size = 170.388
    \weight = 90.758
    \icon = img_phone
    table\addLine(@myPeople())
    AddElement(myPeople())
    \firstName = "Eric"
    \surname = "Bosly"
    \age = 50
    \size = 164.189
    \weight = 110.25
    table\addLine(@myPeople())
    For i = 1 To 100
      AddElement(myPeople())
      \firstName = "name "+Str(i)
      \surname = "surname"+Str(i)
      \age = Random(65,20)
      \size = 180.23
      \weight = 70.999
      table\addLine(@myPeople())
    Next
  EndWith
EndProcedure

Procedure fillFic(*this.person)
  With *this
    SetGadgetText(#ST_FN,\firstName)
    SetGadgetText(#ST_SN,\surname)
    SetGadgetText(#ST_AGE,Str(\age))
    SetGadgetText(#ST_SIZE,StrF(\size))
    SetGadgetText(#ST_WEIGHT,StrD(\weight))
  EndWith
EndProcedure

Procedure start()
  Protected table.TB::table,y = 10
  Protected *cs.TB::stringColumn,*ci.TB::integerColumn,*cf.TB::floatColumn,*cd.TB::doubleColumn,
            *cc.TB::imageColumn
  OpenWindow(#FORM,0,0,800,600,"Example version 1.0.b3",#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  ContainerGadget(#CONTAINER,10,10,400,580)
  table = TB::newTable(#CONTAINER)
  table\setTitle("List of customer")
  *cs = table\addColumn(TB::newStringColumn("Firstname",0.30,@getFirstName()))
  *cs\setEditable(@setName())
  *cs = table\addColumn(TB::newStringColumn("Surname",0.30,@getSurName()))
  *cs\setEditable(@setSurname())
  *ci = table\addColumn(TB::newIntegerColumn("Age",0.2,@getAge()))
  *ci\setEditable(@setAge())
  *cf = table\addColumn(TB::newFloatColumn("Size",0.2,@getSize()))
  *cf\setEditable(@setSize())
  *cd = table\addColumn(TB::newDoubleColumn("Weight",0.2,@getWeight()))
  *cd\setEditable(@setWeight())
  *cc = table\addColumn(TB::newImageColumn("Status",0.2,@getIcon()))
  *cc\setSize(0.6)
  makeData(table)
  table\setSelectCallback(@fillFic())
  table\show()
  CloseGadgetList()
  ContainerGadget(#FIC,GadgetWidth(#CONTAINER)+20,10,WindowWidth(#FORM)- GadgetWidth(#CONTAINER) - 30,580)
  TextGadget(#PB_Any,10,y,GadgetWidth(#FIC) - 20,30,"Firstname")
  y + 30
  StringGadget(#ST_FN,10,y,GadgetWidth(#FIC) - 20,30,"")
  y + 40
  TextGadget(#PB_Any,10,y,GadgetWidth(#FIC) - 20,30,"Surname")
  y + 30
  StringGadget(#ST_SN,10,y,GadgetWidth(#FIC) - 20,30,"")
  y + 40
  TextGadget(#PB_Any,10,y,GadgetWidth(#FIC) - 20,30,"Age")
  y + 30
  StringGadget(#ST_AGE,10,y,GadgetWidth(#FIC) - 20,30,"")
  y + 40
  TextGadget(#PB_Any,10,y,GadgetWidth(#FIC) - 20,30,"Size")
  y + 30
  StringGadget(#ST_SIZE,10,y,GadgetWidth(#FIC) - 20,30,"")
  y + 40
  TextGadget(#PB_Any,10,y,GadgetWidth(#FIC) - 20,30,"Weight")
  y + 30
  StringGadget(#ST_WEIGHT,10,y,GadgetWidth(#FIC) - 20,30,"")
  CloseGadgetList()
  BindEvent(#PB_Event_CloseWindow,@exit(),#FORM)
EndProcedure

start()

Repeat :WaitWindowEvent():ForEver

DataSection
  war:
  IncludeBinary "images/warning.png"
  phone:
  IncludeBinary "images/phone.png"
  bus:
  IncludeBinary "images/busnes.png"
EndDataSection

; IDE Options = PureBasic 5.72 LTS Beta 1 (Windows - x64)
; CursorPosition = 111
; FirstLine = 92
; Folding = --+
; EnableXP