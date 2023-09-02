unit Model.Tramite_Ordem_Servico;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, System.NetEncoding, System.Classes, FireDAC.Stan.Param, Model.Connection;

type
  TTramite_Ordem_Servico = class

  private
      FID_TRAMITE_ORDEM_SERVICO: Integer;
      FID_ORDEM_SERVICO_REF: Integer;
      FID_USUARIO_CRIADOR: Integer;
      FTRAMITE_DESCRICAO: String;
      FDATA_EMISSAO: TDateTime;
      //FANEXO: TBlobType;
      FANEXO: String;

  public
      constructor Create;
      destructor Destroy; override;

      property ID_TRAMITE_ORDEM_SERVICO : Integer read FID_TRAMITE_ORDEM_SERVICO write FID_TRAMITE_ORDEM_SERVICO;
      property ID_ORDEM_SERVICO_REF : Integer read FID_ORDEM_SERVICO_REF write FID_ORDEM_SERVICO_REF;
      property ID_USUARIO_CRIADOR : Integer read FID_USUARIO_CRIADOR write FID_USUARIO_CRIADOR;
      property TRAMITE_DESCRICAO : String read FTRAMITE_DESCRICAO write FTRAMITE_DESCRICAO;
      property DATA_EMISSAO : TDateTime read FDATA_EMISSAO write FDATA_EMISSAO;
      //property ANEXO : TBlobType read FANEXO write FANEXO;
      property ANEXO : String read FANEXO write FANEXO;

      function ListarTramiteOdemServico(order_by: String; out erro: String): TFDQuery;
      function InserirTramiteOdemServico(out erro: String): Boolean;
      function ExcluirTramiteOrdemServico(out erro: String): Boolean;
      function EditarTramiteOdemServico(out erro: String): Boolean;

      function decodificadorBase64(base64String: string): TBytes;

  end;

implementation

var
  anexoDefault : TByteField;

constructor TTramite_Ordem_Servico.Create;
begin
  Model.Connection.Connect;
end;

destructor TTramite_Ordem_Servico.Destroy;
begin
  Model.Connection.Disconect;
end;

function TTramite_Ordem_Servico.ListarTramiteOdemServico(order_by: String; out erro: String): TFDQuery;
var
  Query: TFDQuery;
begin
  try
    Query := TFDQuery.Create(nil);
    Query.Connection := Model.Connection.FConnection;

    with Query do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('SELECT * FROM TRAMITE_ORDEM_SERVICO WHERE ID_ORDEM_SERVICO_REF = :ID_ORDEM_SERVICO_REF');

        ParamByName('ID_ORDEM_SERVICO_REF').Value := ID_ORDEM_SERVICO_REF;

        if order_by = '' then
            SQL.Add('ORDER BY DATA_EMISSAO')
        else
          SQL.Add('ORDER BY DATA_EMISSAO' + order_by);

        Active := True;
      end;

      Query.RecordCount;

      erro := '';

      Result := Query;
  except on ex:Exception do
    begin
      erro := 'Erro ao consultar tramites: ' + ex.Message;
      Result := nil;
    end;

  end;
end;

function TTramite_Ordem_Servico.InserirTramiteOdemServico(out erro: String): Boolean;
var
  query : TFDQuery;
  anexoDecodificado : TBytes;
  MS:TMemoryStream;
begin
  //VALIDA��ES
  if TRAMITE_DESCRICAO.IsEmpty then
    begin
      Result := False;
      erro := 'Informe uma descri��o';
      Exit;
    end;

    try
      query := TFDQuery.Create(nil);
      query.Connection := Model.Connection.FConnection;

      MS := TMemoryStream.Create;

      with query do
        begin
          Active := False;
          SQL.Clear;
          SQL.Add('INSERT INTO TRAMITE_ORDEM_SERVICO (ID_ORDEM_SERVICO_REF, ID_USUARIO_CRIADOR, TRAMITE_DESCRICAO, DATA_EMISSAO, ANEXO)' +
                  'values (:ID_ORDEM_SERVICO_REF, :ID_USUARIO_CRIADOR, :TRAMITE_DESCRICAO, :DATA_EMISSAO, :ANEXO)');

          ParamByName('ID_ORDEM_SERVICO_REF').Value  := ID_ORDEM_SERVICO_REF;
          ParamByName('ID_USUARIO_CRIADOR').Value := ID_USUARIO_CRIADOR;
          ParamByName('TRAMITE_DESCRICAO').Value  := TRAMITE_DESCRICAO;
          ParamByName('DATA_EMISSAO').Value := DATA_EMISSAO;

          if (ANEXO = EmptyStr) then
            ParamByName('ANEXO').Clear
          else
            begin
              anexoDecodificado := decodificadorBase64(ANEXO);
              MS.WriteBuffer(anexoDecodificado[0], Length(anexoDecodificado));
              ParamByName('ANEXO').DataType := ftBlob;
              ParamByName('ANEXO').LoadFromStream(MS, ftBlob);

            end;

          ExecSQL;

          //BUSCA ID INSERIDO
          Params.Clear;
          SQL.Clear;
          SQL.Add('SELECT MAX (ID_TRAMITE_ORDEM_SERVICO) AS ID_TRAMITE_ORDEM_SERVICO FROM TRAMITE_ORDEM_SERVICO');
          SQL.Add('WHERE TRAMITE_DESCRICAO = :TRAMITE_DESCRICAO');
          ParamByName('TRAMITE_DESCRICAO').Value := TRAMITE_DESCRICAO;
          Active:= True;

          ID_TRAMITE_ORDEM_SERVICO := FieldByName('ID_TRAMITE_ORDEM_SERVICO').AsInteger;
        end;

        query.Free;
        erro := '';
        Result := True;
    except on ex:exception do
      begin
        erro := 'Erro ao cadastrar tramite: ' + ex.Message;
        Result := False;
      end;

    end;
end;

function TTramite_Ordem_Servico.EditarTramiteOdemServico(out erro: String): Boolean;
var
  query : TFDQuery;
begin
  try
    query := TFDQuery.Create(nil);
    query.Connection := Model.Connection.FConnection;

    with query do
      begin
        Active := False;
        SQL.Clear;
        SQL.Add('UPDATE TRAMITE_ORDEM_SERVICO SET TRAMITE_DESCRICAO = :TRAMITE_DESCRICAO, DATA_EMISSAO = :DATA_EMISSAO, ANEXO = :ANEXO ' +
                'WHERE ID_ORDEM_SERVICO_REF = :ID_ORDEM_SERVICO_REF AND ID_USUARIO_CRIADOR = :ID_USUARIO_CRIADOR;');

          ParamByName('ID_ORDEM_SERVICO_REF').Value  := ID_ORDEM_SERVICO_REF;
          ParamByName('ID_USUARIO_CRIADOR').Value := ID_USUARIO_CRIADOR;
          ParamByName('TRAMITE_DESCRICAO').Value  := TRAMITE_DESCRICAO;
          ParamByName('DATA_EMISSAO').Value := DATA_EMISSAO;
          ParamByName('ANEXO').Value  := ANEXO;

        ExecSQL;
      end;

    query.Free;
    erro := '';
    Result := True;

  except on ex:exception do
    begin
      erro := 'Erro ao editar tramite ' + ex.Message;
      Result := False;
    end;
  end;
end;

function TTramite_Ordem_Servico.ExcluirTramiteOrdemServico(out erro: String): Boolean;
begin
  //
end;

function TTramite_Ordem_Servico.decodificadorBase64(base64String: string): TBytes;
var
  binaryData: TBytes;
  base64Encoder: TBase64Encoding;
begin
  base64Encoder := TBase64Encoding.Create;
  try
    binaryData := base64Encoder.DecodeStringToBytes(base64String);
    // Agora, 'binaryData' cont�m os dados bin�rios do anexo.
    // Voc� pode usar esses dados para trabalhar com o campo BLOB.
  finally
    base64Encoder.Free;
  end;
  Result := binaryData;
end;

end.