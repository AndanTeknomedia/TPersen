unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,PersenDanNilai,
  Vcl.ComCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    PersenDanNilai1: TPersenDanNilai;
    Button2: TButton;
    Button3: TButton;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure PersenDanNilai1NilaiChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    PDN: TPersenDanNilai;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}


procedure TForm2.Button1Click(Sender: TObject);
begin
  PersenDanNilai1.Persen := 22.45;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  with TJangkaWaktu.Create(self) do
  begin
    Parent := self;
    Left := 10;
    top := 0;

  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  with TDateTimePicker.Create(Panel1) do
  begin
    Parent := Panel1;
    Align := alClient;
  end;
end;

procedure TForm2.PersenDanNilai1NilaiChange(Sender: TObject);
begin
  ShowMessage(FloatToStr(PersenDanNilai1.Nilai));
end;

end.
