program test;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form2},
  PersenDanNilai in 'PersenDanNilai.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
