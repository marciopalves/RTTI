unit Pessoa;

interface

uses
  System.SysUtils, uTabela, Attributes;

type
  [TDataTableAttribute('PESSOA')]
  TPessoa = class
  private
    FCodigo: Integer;
    FNome  : string;
    FCpf: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Insert(AId: Integer);

    function Update(AId: Integer): Boolean;

    property Codigo: Integer read FCodigo write FCodigo;

    [TDataFieldAttribute('PES_NOME', 'O campo "Nome" � de preenchimento obrigat�rio.', True)]
    property Nome: string read FNome   write FNome;
    property Cpf: string read FCpf write FCpf;
  end;

implementation

{ TPessoa }

constructor TPessoa.Create;
begin

end;

destructor TPessoa.Destroy;
begin

  inherited;
end;

procedure TPessoa.Insert(AId: Integer);
begin
  raise Exception.Create('Inserido com sucesso.');
end;

function TPessoa.Update(AId: Integer): Boolean;
begin
  Result := True;
end;

end.
