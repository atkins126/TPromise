program sample;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {Form2},
  boss in '..\boss.json';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
