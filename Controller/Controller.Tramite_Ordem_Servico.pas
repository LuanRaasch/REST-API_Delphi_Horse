unit Controller.Tramite_Ordem_Servico;

interface

uses Horse, System.JSON, System.SysUtils, Model.Tramite_Ordem_Servico, FireDAC.Comp.Client,
     Data.DB, DataSet.Serialize;

procedure Registry;

implementation

procedure ListarTramiteOrdemServicoID(Req: THorseRequest; Res: THorseResponse);
var
  tramiteOrdemServico: TTramite_Ordem_Servico;
  query: TFDQuery;
  arrayTramiteOrdemServico: TJSONArray;
  erro: String;
  begin
    try
      tramiteOrdemServico := TTramite_Ordem_Servico.Create;
      tramiteOrdemServico.ID_ORDEM_SERVICO_REF := Req.Params['id'].ToInteger;
    except
      res.Send('Erro ao conectar com o banco').Status(500);
      Exit;
    end;

    try
      query := tramiteOrdemServico.ListarTramiteOdemServico('', erro);

      if query.RecordCount > 0 then
        begin
          arrayTramiteOrdemServico := query.ToJSONArray();
          res.Send<TJSONArray>(arrayTramiteOrdemServico);
        end
      else
        res.Send('Nenhum trâmite encontrado').Status(404);

    finally
      query.Free;
      tramiteOrdemServico.Free;
    end;
  end;

procedure AddTramiteOrdemServico(Req: THorseRequest; Res: THorseResponse);
var
  tramiteOrdemServico: TTramite_Ordem_Servico;
  body : TJSONValue;
  objTramiteOrdemServico: TJSONObject;
  erro: String;
  begin
    try
      tramiteOrdemServico := TTramite_Ordem_Servico.Create;
    except
      res.Send('Erro ao conectar com o banco de dados').Status(500);
      Exit;
    end;

    try
      try
        body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

        tramiteOrdemServico.ID_ORDEM_SERVICO_REF  := body.GetValue<Integer>('idOrdemServicoRef', 0);
        tramiteOrdemServico.ID_USUARIO_CRIADOR := body.GetValue<Integer>('idUsuarioCriador', 0);
        tramiteOrdemServico.TRAMITE_DESCRICAO  := body.GetValue<String>('tramiteDescricao','');
        tramiteOrdemServico.DATA_EMISSAO  := body.GetValue<TDateTime>('dataEmissao', Now);
        tramiteOrdemServico.ANEXO := body.GetValue<String>('anexo', '');

        tramiteOrdemServico.InserirTramiteOdemServico(erro);

        body.Free;

        if erro <> '' then
          raise Exception.Create(erro);

      except on ex:exception do
        begin
          res.Send(ex.Message).Status(400);
          Exit;
        end;
      end;

      objTramiteOrdemServico := TJSONObject.Create;
      objTramiteOrdemServico.AddPair('idTramiteOrdemServico', tramiteOrdemServico.ID_TRAMITE_ORDEM_SERVICO.ToString);

      res.Send<TJSONObject>(objTramiteOrdemServico).Status(201);
    finally
      tramiteOrdemServico.Free;
    end;
  end;

  procedure Registry;
  begin
    THorse.Get('/ordemservico/tramite/:id', ListarTramiteOrdemServicoID);
    THorse.Post('/ordemservico/tramite', AddTramiteOrdemServico);
  end;

end.
