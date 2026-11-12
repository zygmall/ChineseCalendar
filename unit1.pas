unit Unit1;

{$mode objfpc}{$H+}
//{$MODE Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,DateUtils,
  CnMonthCalendar,CnCalendar;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Label2Click(Sender: TObject);

    procedure OnMyCalendarChange(Sender: TObject;var CurrentDate:TDateTime);

  private
           MyCalendar : TCnMonthCalendar;
           procedure ShowSelectDay( SelectDay: TDateTime);

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
        MyCalendar := TCnMonthCalendar.Create(Form1);
        MyCalendar.Parent:=Self;

  MyCalendar.Left := 0;
  MyCalendar.Top := 0;
  MyCalendar.Width :=Form1.Width;
  MyCalendar.Height :=Trunc(Form1.ClientHeight*0.9);

  Label1.Height :=Trunc(Form1.ClientHeight*0.1);

  MyCalendar.CalColors.TitleBackColor:=clMoneyGreen;

  MyCalendar.ShowYearButton :=true;
  MyCalendar.ShowMonthButton :=true;


  MyCalendar.OnDateChange:=@OnMyCalendarChange;


  ShowSelectDay(Date()) ;




end;

procedure TForm1.FormResize(Sender: TObject);
begin

   MyCalendar.Left:= 0;
   MyCalendar.Top := 0;
   MyCalendar.Width:=Form1.Width;
   MyCalendar.Height:=Trunc(Form1.Height*0.9);


  Label1.Height :=Trunc(Form1.ClientHeight*0.1);

  Label3.Left:= ClientWidth-Label3.Width;
  Edit1.Left:=  Label3.Left-Edit1.Width;
  Label2.Left:= Edit1.Left-Label2.Width;

    Label2.Top:= ClientHeight - Label1.Height div 2 -10;
    Label3.Top:= ClientHeight - Label1.Height div 2 -10;;
    Edit1.Top:= ClientHeight - Label1.Height div 2 -14;


end;

procedure TForm1.Label2Click(Sender: TObject);
begin
    //返回今天
   MyCalendar.Date :=  Date();
end;

procedure TForm1.ShowSelectDay( SelectDay:TDateTime);
var
   sChnDate : string ;
   iyear, imonth, iday :Word ;
   iChnyear, iChnmonth, iChnday :Integer ;
   IsChnLeapMonth : Boolean;
   i :Integer ;
begin
    MyCalendar.Date :=  SelectDay;

    DecodeDate(SelectDay,iyear, imonth, iday) ;

    Edit1.Text:=IntToStr(Round(SelectDay-Date()));

    Label1.Caption:= 'zyg+string(SelectDay)';
    //  {* 获得某公历年月日的农历年月日和是否闰月}
    GetLunarFromDay(iyear, imonth, iday, iChnyear, iChnmonth, iChnday  ,IsChnLeapMonth);
    sChnDate := '';
    sChnDate:= sChnDate+'<农历'+ IntToStr(iChnyear)+'>';
    sChnDate:= sChnDate+SCnShengXiaoArray[GetShengXiaoFromYear(iChnyear)];
    sChnDate:= sChnDate+'('+SCnTianGanArray[GetGanFromYear(iChnyear)]+SCnDiZhiArray[GetZhiFromYear(iChnyear)]+')年';
    // 从数字获得农历月名称, 1-12
    sChnDate:= sChnDate+GetLunarMonthFromNumber(iChnmonth, IsChnLeapMonth)+GetLunarDayFromNumber(iChnday);

   //是否节气日
   i:= GetJieQiFromDay(iyear, imonth, iday);
   if i>=0 then
   begin
     sChnDate:= sChnDate+ '('+SCnJieQiArray[i]+')';
   end;

   Label1.Caption:= sChnDate;



end;
procedure TForm1.OnMyCalendarChange( Sender: TObject;var CurrentDate:TDateTime);
begin
      ShowSelectDay(CurrentDate);
end;
end.

