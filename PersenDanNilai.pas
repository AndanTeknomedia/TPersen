unit PersenDanNilai;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.DateUtils;

type
  TPersenDanNilai = class(TPanel)
  private
    FEPersen,
    FENilai: TEdit;
    FLabel: TLabel;
    FPersen,
    FValue: Double;
    FNilaiDasar: Double;
    FPemisahRibuan,
    FPemisahPecahan: Char;

    FonChange,
    FOnPersenChange,
    FOnNilaiDasarChanged,
    FOnNilaiChange: TNotifyEvent;
    FOnEnabled: TNotifyEvent;
    procedure OnPersenChanged(Sender: TObject);
    procedure OnValueChanged(Sender: TObject);
    procedure OnNilaiDasarChanged(Sender: TObject);
    procedure OnPersenExit(Sender: TObject);
    procedure OnNilaiExit(Sender: TObject);
    function  GetPersen: DOuble;
    function  GetNilai: Double;
    procedure SetPersen(Value: DOuble);
    procedure SetNilai(Value: DOuble);
    procedure SetNilaiDasar(Value: Double);
    procedure SetPemisahRibuan(value: Char);
    procedure SetPemisahPecahan(value: Char);

    procedure DoNilaiDasarChange;
    procedure DoPersenChange;
    procedure DoNilaiChange;
    procedure DoChange;

  protected
    function _FloatToStr(v: Double): String;
    function _StrToFloat(v: String): Double;
    procedure SetEnabled(Value: Boolean); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Change;
  published
    property Persen: Double read GetPersen write SetPersen;
    property Nilai: Double read GetNilai write SetNilai;
    property NilaiDasar: Double read FNilaiDasar write SetNilaiDasar;
    property PemisahRibuan: char read FPemisahRibuan write SetPemisahRibuan;
    property PemisahPecahan: char read FPemisahPecahan write SetPemisahPecahan;
    property OnNilaiChange: TNotifyEvent read FOnNilaiChange write FOnNilaiChange;
    property OnPersenChange: TNotifyEvent read FOnPersenChange write FOnPersenChange;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TOnDualDateChange = procedure (Sender: TObject; DateBegin, DateEnd: TDateTime; JmlHari: Integer) of object;
  TJangkaWaktu = class(TPanel)
  private
    FDP1,
    FDP2: TDateTimePicker;
    FDPJumlah: TEdit;
    FDPLabel,
    FDPLabel2: TLabel;
    FTanggalAwal: TDateTime;
    FTanggalAkhir: TDateTime;
    FOnChange: TOnDualDateChange;
    procedure onDateChanged(Sender: TObject);
    procedure SetTanggalAwal(const Value: TDateTime);
    procedure SetTanggalAkhir(const Value: TDateTime);
    function GetJumlahHari: Integer;
    procedure DoDateChange;
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure CreateWnd; override;


  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AfterConstruction; override;
    property JumlahHari: Integer read GetJumlahHari;

  published
    property TanggalAwal: TDateTime read FTanggalAwal write SetTanggalAwal;
    property TanggalAkhir: TDateTime read FTanggalAkhir write SetTanggalAkhir;

    property OnDateChange: TOnDualDateChange read FOnChange write FOnChange;
  end;


procedure Register;

implementation

{ TPersenDanNilai }

procedure TPersenDanNilai.Change;
begin
  DoChange;
end;

constructor TPersenDanNilai.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.ShowCaption := false;
  self.Caption := '';
  self.Height := 21;
  self.Constraints.MaxHeight := 21;
  self.Caption := '';
  self.BevelOuter := bvNone;
  self.Width := 230;


  FEPersen := TEdit.Create(self);
  FEPersen.Parent := self;
  FEPersen.Align := alLeft;
  FEPersen.Alignment := taRightJustify;
  FEPersen.Width := 65;

  FLabel := TLabel.Create(self);
  FLabel.Align := alLeft;
  FLabel.Left := FEPersen.Width;
  FLabel.AlignWithMargins := true;
  FLabel.Parent := self;
  with FLabel.Margins do
  begin
    Left := 0;
    top := 4;
    Right := 0;
    Bottom := 0;
  end;
  FLabel.Caption := ' %    = Rp ';

  FENilai := TEdit.Create(self);
  FENilai.Parent := self;
  FENilai.Color := clYellow;
  FENilai.Alignment := taRightJustify;
  FENilai.Align := alClient;
  FENilai.Left := FLabel.Width;

  FEPersen.OnChange := OnPersenChanged;
  FENilai.OnChange := OnValueChanged;
  FEPersen.OnExit := OnPersenExit;
  FENilai.OnExit := OnNilaiExit;

  self.PemisahPecahan := ',';
  self.PemisahRibuan := '.';

  SetNilaiDasar(0);
  SetPersen(0);
  // SetNilai(0);




end;

destructor TPersenDanNilai.Destroy;
begin
  FEPersen.Free;
  FENilai.Free;
  FLabel.Free;
  inherited Destroy;
end;

procedure TPersenDanNilai.DoChange;
begin
  if Assigned(FonChange) then
    FonChange(Self);
end;

procedure TPersenDanNilai.DoNilaiChange;
begin
  if Assigned(FOnNilaiChange) then
    FOnNilaiChange(self);
  DoChange;
end;

procedure TPersenDanNilai.DoNilaiDasarChange;
begin
  DoChange;
end;

procedure TPersenDanNilai.DoPersenChange;
begin
  if Assigned(FOnPersenChange) then
    FOnPersenChange(self);
  DoChange;
end;

function TPersenDanNilai.GetNilai: Double;
begin
  result := _StrToFloat(FENilai.Text);
end;

function TPersenDanNilai.GetPersen: DOuble;
begin
  result := _StrToFloat(FEPersen.Text);
end;

procedure TPersenDanNilai.OnNilaiDasarChanged(Sender: TObject);
begin
  DoNilaiDasarChange;
end;

procedure TPersenDanNilai.OnNilaiExit(Sender: TObject);
var
  v: Double;
begin
  FENilai.OnChange := nil;
  try
    v := _StrToFloat(FENilai.Text);

    FENilai.Text := _FloatToStr(v);
  finally
    FENilai.OnChange := OnValueChanged;
  end;
end;

procedure TPersenDanNilai.OnPersenChanged(Sender: TObject);
var
  _persen: Double;
begin
  FENilai.OnChange := nil;
  try
    _persen := _StrToFloat(FEPersen.Text);
    if NilaiDasar <> 0 then
      FENilai.Text := _FloatToStr(_persen/100*NilaiDasar)
    else
      FENilai.Text := _FloatToStr(0);
  finally
    FENilai.OnChange := OnValueChanged;
  end;
  DoPersenChange;
end;

procedure TPersenDanNilai.OnPersenExit(Sender: TObject);
var
  v: Double;
begin
  FEPersen.OnChange := nil;
  try
    v := _StrToFloat(FEPersen.Text);
    FEPersen.Text := _FloatToStr(v);
  finally
    FEPersen.OnChange := OnPersenChanged;
  end;
end;

procedure TPersenDanNilai.OnValueChanged(Sender: TObject);
var
  _nilai: Double;
begin

  FEPersen.OnChange := nil;
  try
    _nilai:= _StrToFloat(FENilai.Text);
    if NilaiDasar <> 0 then
      FEPersen.Text := _FloatToStr(_nilai/NilaiDasar*100)
    else
      FEPersen.Text := _FloatToStr(0);
  finally
    FEPersen.OnChange := OnPersenChanged;
  end;
  DoNilaiChange;
end;

procedure TPersenDanNilai.SetEnabled(Value: Boolean);
begin
  inherited SetEnabled(value);
  FEPersen.ReadOnly := Value;
  FENilai.ReadOnly:= Value;
  FEPersen.Font.Color := clBlack;
  FENilai.Font.Color := clBlack;
  if Value then
  begin
    FEPersen.Color := clWindow;
    FENilai.Color := clYellow;
  end
  else
  begin
    FEPersen.Color := clSilver;
    FENilai.Color := $007777BB;
  end;
end;

procedure TPersenDanNilai.SetNilai(Value: DOuble);
begin
  FEPersen.OnChange := nil;
  try
    FENilai.Text := _FloatToStr(Value);
  finally
    FEPersen.OnChange := OnValueChanged;
  end;
  OnValueChanged(FENilai);
end;

procedure TPersenDanNilai.SetNilaiDasar(Value: Double);
var
  f: TNotifyEvent;
begin
  if FNilaiDasar = value then
    exit;
  FNilaiDasar := Value;
  FENilai.OnChange := nil;
  FEPersen.OnChange := nil;
  try
    // if _StrToFloat(FEPersen.Text) = 0 then
    // FEPersen.Text := _FloatToStr(Value);
  finally
    FENilai.OnChange := OnValueChanged;
    FEPersen.OnChange := OnPersenChanged;
    FENilai.OnChange := OnNilaiDasarChanged;
  end;
  // OnNilaiDasarChanged(self);
  OnPersenChanged(FEPersen);
end;

procedure TPersenDanNilai.SetPemisahPecahan(value: Char);
begin
  if FPemisahPecahan = value then
    exit;
  FPemisahPecahan := value;
  OnPersenChanged(FEPersen);
end;

procedure TPersenDanNilai.SetPemisahRibuan(value: Char);
begin
  if FPemisahRibuan = value then
    exit;
  FPemisahRibuan := value;
  OnPersenChanged(FEPersen);
end;

procedure TPersenDanNilai.SetPersen(Value: DOuble);
begin
  FENilai.OnChange := nil;
  try
    FEPersen.Text := _FloatToStr(Value);
  finally
    FENilai.OnChange := OnValueChanged;
  end;
  OnPersenChanged(FEPersen);
end;

function TPersenDanNilai._FloatToStr(v: Double): String;
var
  d,t: CHar;
begin

  d := FormatSettings.DecimalSeparator;
  t:= FormatSettings.ThousandSeparator;
  try
    FormatSettings.DecimalSeparator := PemisahPecahan;
    FormatSettings.ThousandSeparator := PemisahRibuan;
    // Result := FloatToStr(v, FormatSettings);
    Result := FormatFloat('#,#0.####;-#,#0.####;0', v, FormatSettings);
  finally
    FormatSettings.DecimalSeparator := d;
    FormatSettings.ThousandSeparator := t;
  end;
end;

function TPersenDanNilai._StrToFloat(v: String): Double;
var
  s: String;
  i: integer;
  d,t: CHar;
begin
  d := FormatSettings.DecimalSeparator;
  t:= FormatSettings.ThousandSeparator;
  try
    s := v;
    for i := length(s) downto 1 do
      if not (s[i] in ['0'..'9',PemisahPecahan]) then
        delete(s,i,1);
    FormatSettings.DecimalSeparator := PemisahPecahan;
    FormatSettings.ThousandSeparator := PemisahRibuan;
    Result := StrToFloatDef(s, 0, FormatSettings);
  finally
    FormatSettings.DecimalSeparator := d;
    FormatSettings.ThousandSeparator := t;
  end;
end;

procedure Register;
begin
  RegisterComponents('Andan TeknoMedia', [
    TPersenDanNilai,
    TJangkaWaktu
  ]);
end;

{ TJangkaWaktu }

procedure TJangkaWaktu.AfterConstruction;
begin
  inherited;

end;

constructor TJangkaWaktu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

procedure TJangkaWaktu.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;

end;

procedure TJangkaWaktu.CreateWnd;
begin
  inherited;
  Height := 21;
  with Constraints do
  begin
    MaxHeight := 21;
    MinWidth  := 270;
  end;
  Caption := '';
  BevelOuter := bvNone;
  Width := 270;

  FDP1 := TDateTimePicker.Create(self);
  FDP1.Parent := self;
  FDP1.Width := 85;
  FDP1.Format := 'dd/MM/yyyy';
  FDP1.Align := alLeft;
  FDP1.Kind := TDateTimeKind.dtkDate;

  FDPLabel := TLabel.Create(self);
  FDPLabel.Parent := self;
  FDPLabel.Align := alLeft;
  FDPLabel.Left := FDP1.Width;
  FDPLabel.AlignWithMargins := true;

  with FDPLabel.Margins do
  begin
    Left := 0;
    top := 4;
    Right := 0;
    Bottom := 0;
  end;
  FDPLabel.Caption := ' s.d. ';

  FDP2 := TDateTimePicker.Create(self);
  FDP2.Parent := self;
  FDP2.Left := FDPLabel.BoundsRect.Right;
  FDP2.Width := 85;
  FDP2.Align := alLeft;
  FDP2.Format := 'dd/MM/yyyy';
  FDP2.Kind := TDateTimeKind.dtkDate;

  FDPLabel2 := TLabel.Create(self);
  FDPLabel2.Parent := self;
  FDPLabel2.Align := alLeft;
  FDPLabel2.Left := FDP2.BoundsRect.Right;
  FDPLabel2.AlignWithMargins := true;
  with FDPLabel2.Margins do
  begin
    Left := 0;
    top := 4;
    Right := 0;
    Bottom := 0;
  end;
  FDPLabel2.Caption := '  = ';

  FDPJumlah := TEdit.Create(self);
  FDPJumlah.Parent := self;
  FDPJumlah.Alignment := taRightJustify;
  FDPJumlah.Left := FDPLabel2.BoundsRect.Right;
  FDPJumlah.Width := 40;
  FDPJumlah.Align := alClient;
  FDPJumlah.ReadOnly := true;
  FDPJumlah.Color := clSilver;
  FDPJumlah.tabstop := false;


  FDP1.OnChange := onDateChanged;
  FDP2.OnChange := onDateChanged;
  TanggalAwal :=  Date;
  TanggalAkhir :=  Date;
end;

destructor TJangkaWaktu.Destroy;
begin
  FDP1.Free;
  FDP2.Free;
  FDPJumlah.free;
  FDPLabel.Free;
  FDPLabel2.Free;
  inherited Destroy;
end;

procedure TJangkaWaktu.DoDateChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self, FDP1.Date, FDP2.Date, GetJumlahHari);
end;

function TJangkaWaktu.GetJumlahHari: Integer;
begin
  Result := 1 + DaysBetween(FDP1.Date, FDP2.Date);
end;

procedure TJangkaWaktu.onDateChanged(Sender: TObject);
begin
  FDP1.OnChange := nil;
  FDP2.OnChange := nil;
  try
    if FDP1.Date> FDP2.Date then
      FDP2.Date := FDP1.Date;
    FDPJumlah.Text := IntToStr(GetJumlahHari)+' Hari';
  finally
    FDP1.OnChange := onDateChanged;
    FDP2.OnChange := onDateChanged;
  end;
  DoDateChange;
end;

procedure TJangkaWaktu.SetTanggalAkhir(const Value: TDateTime);
begin
  if FTanggalAkhir = Value then exit;
  FTanggalAkhir := Value;
  FDP2.Date := Value;
  onDateChanged(FDP2);
end;

procedure TJangkaWaktu.SetTanggalAwal(const Value: TDateTime);
begin
  if FTanggalAwal = Value then exit;
  FTanggalAwal := Value;
  FDP1.Date := Value;
  onDateChanged(FDP1);
end;

end.
