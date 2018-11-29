unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Rtti, Pessoa, uTabela, Attributes;

type
  TfrmPrincipal = class(TForm)
    btnGetMethod: TButton;
    mmRtti: TMemo;
    btnGetField: TButton;
    btnGetProperty: TButton;
    btnGetPropertiesTypes: TButton;
    btnSetValue: TButton;
    btnTRttiMethodTypes: TButton;
    btnInvoke: TButton;
    btnRttiValidar: TButton;
    btnNomeTabela: TButton;
    btnCampo: TButton;
    procedure btnGetMethodClick(Sender: TObject);
    procedure btnGetFieldClick(Sender: TObject);
    procedure btnGetPropertyClick(Sender: TObject);
    procedure btnGetPropertiesTypesClick(Sender: TObject);
    procedure btnSetValueClick(Sender: TObject);
    procedure btnTRttiMethodTypesClick(Sender: TObject);
    procedure btnInvokeClick(Sender: TObject);
    procedure btnNomeTabelaClick(Sender: TObject);
    procedure btnRttiValidarClick(Sender: TObject);
    procedure btnCampoClick(Sender: TObject);
  private
    procedure PropertyTypeValue(AObj: TPessoa);
    procedure PropertySetValeu(AObj: TObject);
    procedure Invoke(AObj: TObject);
    procedure EscreverCampo(AObj: TObject);
    function Valida(AObj: TObject): boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnCampoClick(Sender: TObject);
var
  VPessoa: TPessoa;
begin
  mmRtti.Clear;

  VPessoa := TPessoa.Create;
  try
    VPessoa.Codigo := 100;
    VPessoa.Nome   := 'Jorge';

    Self.EscreverCampo(VPessoa);
  finally
    VPessoa.Free;
  end;
end;

procedure TfrmPrincipal.btnGetFieldClick(Sender: TObject);
var
  VCtx  : TRttiContext;
  VType : TRttiType;
  VField: TRttiField;
begin
  mmRtti.Clear;

  VCtx := TRttiContext.Create;
  try
    VType := VCtx.GetType(TPessoa);

    for VField in VType.GetFields do
      mmRtti.Lines.Add(VField.Name);
  finally
    VCtx.Free
  end;
end;

procedure TfrmPrincipal.btnGetMethodClick(Sender: TObject);
var
  VCtx : TRttiContext;
  VType: TRttiType;
  VMet : TRttiMethod;
begin
  mmRtti.Clear;

  VCtx := TRttiContext.Create;
  try
    VType := VCtx.GetType(TPessoa);

    for VMet in VType.GetMethods do
    begin
      if VMet.Parent.Name = 'TPessoa' then
        mmRtti.Lines.Add(VMet.Name);
    end;
  finally
    VCtx.Free;
  end;
end;

procedure TfrmPrincipal.btnGetPropertiesTypesClick(Sender: TObject);
var
  VPessoa: TPessoa;
begin
  mmRtti.Clear;

  VPessoa := TPessoa.Create;
  try
    VPessoa.Codigo := 1;
    VPessoa.Nome   := 'Márcio';

    Self.PropertyTypeValue(VPessoa);
  finally
    VPessoa.Free;
  end;
end;

procedure TfrmPrincipal.btnGetPropertyClick(Sender: TObject);
var
  VCtx : TRttiContext;
  VType: TRttiType;
  VProp: TRttiProperty;
begin
  mmRtti.Clear;

  VCtx := TRttiContext.Create;
  try
    VType := VCtx.GetType(TPessoa);

    for VProp in VType.GetProperties do
      mmRtti.Lines.Add(VProp.Name);
  finally
    VCtx.Free
  end;
end;

procedure TfrmPrincipal.btnInvokeClick(Sender: TObject);
var
  VPessoa: TPessoa;
begin
  mmRtti.Clear;

  VPessoa := TPessoa.Create;
  try
    VPessoa.Codigo := 15;
    VPessoa.Nome   := 'Gabriel';

    Self.Invoke(VPessoa);
  finally
    VPessoa.Free;
  end;
end;

procedure TfrmPrincipal.btnNomeTabelaClick(Sender: TObject);
var
  VCtx : TRttiContext;
  VType: TRttiType;
  VAtt : TCustomAttribute;
begin
  mmRtti.Clear;

  VCtx   := TRttiContext.Create();

  VType  := VCtx.GetType(TPessoa.ClassInfo);

  for VAtt in VType.GetAttributes() do
  begin
    if VAtt is TDataTableAttribute then
      mmRtti.Lines.Add(TDataTableAttribute(VAtt).Tabela);
  end;
end;

procedure TfrmPrincipal.btnRttiValidarClick(Sender: TObject);
var
  VPessoa: TPessoa;
begin
  mmRtti.Clear;

  VPessoa := TPessoa.Create;
  try
    VPessoa.Codigo := 100;
    VPessoa.Nome   := 'Gustavo';

    Self.Valida(VPessoa);
  finally
    VPessoa.Free;
  end;
end;

procedure TfrmPrincipal.btnSetValueClick(Sender: TObject);
var
  VPessoa: TPessoa;
begin
  mmRtti.Clear;

  VPessoa := TPessoa.Create;
  try
    VPessoa.Codigo := 10;
    VPessoa.Nome   := 'Vazio';

    mmRtti.Lines.Add(VPessoa.Nome);

    Self.PropertySetValeu(VPessoa);

    mmRtti.Lines.Add(VPessoa.Nome);
  finally
    FreeAndNil(VPessoa);
  end;
end;

procedure TfrmPrincipal.btnTRttiMethodTypesClick(Sender: TObject);
var
  VCtx : TRttiContext;
  VType: TRttiType;
  VMet : TRttiMethod;
  VPar : TRttiParameter;
begin
  mmRtti.Clear;

  VCtx := TRttiContext.Create;
  try
    VType := VCtx.GetType(TPessoa);

    for VMet in VType.GetMethods do
    begin
      //Ignora métodos que não foram implementados diretamente em TPessoa
      if VMet.Parent.Name <> 'TPessoa' then
        Continue;

      mmRtti.Lines.Add('Método ' + VMet.Name);

      if VMet.ReturnType <> nil then
        mmRtti.Lines.Add(' Retorno ' + VMet.ReturnType.ToString)
      else
        mmRtti.Lines.Add(' Retorno ' + 'Não tem.');

      mmRtti.Lines.Add(' Parâmetros');

      for VPar in VMet.GetParameters do
        mmRtti.Lines.Add('   ' + VPar.Name + ': ' + VPar.ParamType.ToString) ;

      mmRtti.Lines.Add('');
    end;
  finally
    VCtx.Free;
  end;
end;

procedure TfrmPrincipal.EscreverCampo(AObj: TObject);
var
  vCtx  : TRttiContext;
  vType : TRttiType;
  vProp : TRttiProperty;
  vAtrib: TCustomAttribute;
begin
  vCtx := TRttiContext.Create;
  try
    vType := VCtx.GetType(AObj.ClassInfo);

    for vProp in VType.GetProperties do
    begin
      for vAtrib in vProp.GetAttributes do
        mmRtti.Lines.Add(TDataFieldAttribute(VAtrib).Campo)
    end;
  finally
    vCtx.Free;
  end;
end;

procedure TfrmPrincipal.Invoke(AObj: TObject);
var
  vCtx : TRttiContext;
  vType: TRttiType;
  vMet : TRttiMethod;
  vPar : Array of TValue;
begin
  vCtx := TRttiContext.Create;
  try
    vType := VCtx.GetType(AObj.ClassType);
    vMet := VType.GetMethod('Insert');

    SetLength(VPar, 1);

    vPar[0] := 1;

    vMet.Invoke(AObj, VPar);
  finally
    VCtx.Free;
  end;
end;

procedure TfrmPrincipal.PropertySetValeu(AObj: TObject);
var
  vCtx : TRttiContext;
  vType: TRttiType;
  vProp: TRttiProperty;
begin
  vCtx := TRttiContext.Create;
  try
    vType := vCtx.GetType(AObj.ClassType);

    vProp := vType.GetProperty('Nome');

    vProp.SetValue(AObj, 'Octávio Augusto');
  finally
    VCtx.Free;
  end;
end;

procedure TfrmPrincipal.PropertyTypeValue(AObj: TPessoa);
var
  vCtx : TRttiContext;
  vType: TRttiType;
  vProp: TRttiProperty;
begin
  vCtx := TRttiContext.Create;
  try
    vType := vCtx.GetType(AObj.ClassType);

    for vProp in vType.GetProperties do
      mmRtti.Lines.Add(vProp.Name + ': ' + vProp.PropertyType.ToString + '= ' + vProp.GetValue(AObj).ToString);
  finally
    vCtx.Free
  end;
end;

function TfrmPrincipal.Valida(AObj: TObject): Boolean;
var
  vCtx  : TRttiContext;
  vType : TRttiType;
  vProp : TRttiProperty;
  vAtrib: TCustomAttribute;
begin
  Result := True;

  vCtx := TRttiContext.Create;
  try
    vType := VCtx.GetType(AObj.ClassInfo);

    for vProp in VType.GetProperties do
    begin
      for vAtrib in VProp.GetAttributes do
      begin
        if vAtrib is TDataFieldAttribute then
        begin
          (vAtrib as TDataFieldAttribute).Validar(VProp.GetValue(AObj));

          if TDataFieldAttribute(VAtrib).CampoObrigatorio then
            raise Exception.Create(TDataFieldAttribute(vAtrib).Mensagem);
        end;
      end;
    end;
  finally
    vCtx.Free;
  end;
end;

end.
