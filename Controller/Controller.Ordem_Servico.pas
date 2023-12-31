unit Controller.Ordem_Servico;

interface

uses Horse, System.JSON, System.SysUtils, Model.Ordem_Servico, FireDAC.Comp.Client,
     Data.DB, DataSet.Serialize;

procedure Registry;

implementation

procedure ListarOrdemServico(Req: THorseRequest; Res: THorseResponse);
var
  ordemServico: TOrdem_Servico;
  query: TFDQuery;
  erro: String;
  arrayOrdemServico: TJSONArray;
  begin
    try
      ordemServico := TOrdem_Servico.Create;
    except
      res.Send('Erro ao conectar com o banco').Status(500);
      Exit;
    end;

    try
      query := ordemServico.ListarOdemServico('', erro);

      arrayOrdemServico := query.ToJSONArray();

      res.Send<TJSONArray>(arrayOrdemServico);
    finally
      query.Free;
      ordemServico.Free;
    end;
  end;

procedure ListarOrdemServicoID(Req: THorseRequest; Res: THorseResponse);
var
  ordemServico: TOrdem_Servico;
  query: TFDQuery;
  objOrdemServico: TJSONObject;
  erro: String;
  begin
    try
      ordemServico := TOrdem_Servico.Create;
      ordemServico.ID_ORDEM_SERVICO := Req.Params['id'].ToInteger;
    except
      res.Send('Erro ao conectar com o banco').Status(500);
      Exit;
    end;

    try
      query := ordemServico.ListarOdemServico('', erro);

      if query.RecordCount > 0 then
        begin
          objOrdemServico := query.ToJSONObject;
          res.Send<TJSONObject>(objOrdemServico);
        end
      else
        res.Send('Ordem de servi�o n�o encontrada').Status(404);

    finally
      query.Free;
      ordemServico.Free;
    end;
  end;

procedure AddOrdemServico(Req: THorseRequest; Res: THorseResponse);
var
  ordemServico: TOrdem_Servico;
  body : TJSONValue;
  objOrdemServico: TJSONObject;
  erro: String;
  begin
    try
      ordemServico := TOrdem_Servico.Create;
    except
      res.Send('Erro ao conectar com o banco de dados').Status(500);
      Exit;
    end;

    try
      try
        body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

        ordemServico.ID_USUARIO_CRIADOR  := body.GetValue<Integer>('idUsuarioCriador', 0);
        ordemServico.ID_TECNICO_RESPONSAVEL := body.GetValue<Integer>('idTecnicoResponsavel', 0);
        ordemServico.ID_EMPRESA  := body.GetValue<Integer>('idEmpresa', 0);
        ordemServico.DESCRICAO  := body.GetValue<String>('descricao', '');
        ordemServico.DATA_CRIACAO := body.GetValue<TDateTime>('dataCriacao', Now);
        ordemServico.STATUS  := body.GetValue<String>('status', '');
        ordemServico.PRIORIDADE := body.GetValue<String>('prioridade', '');
        ordemServico.FORMA_ATENDIMENTO  := body.GetValue<String>('formaAtendimento', '');

        ordemServico.InserirOdemServico(erro);

        body.Free;

        if erro <> '' then
          raise Exception.Create(erro);

      except on ex:exception do
        begin
          res.Send(ex.Message).Status(400);
          Exit;
        end;
      end;

      objOrdemServico := TJSONObject.Create;
      objOrdemServico.AddPair('idOrdemServico', ordemServico.ID_ORDEM_SERVICO.ToString);

      res.Send<TJSONObject>(objOrdemServico).Status(201);
    finally
      ordemServico.Free;
    end;
  end;

procedure EditOrdemServico(Req: THorseRequest; Res: THorseResponse);
var
  ordemServico: TOrdem_Servico;
  body : TJSONValue;
  objOrdemServico: TJSONObject;
  erro: String;
  begin
    try
      ordemServico := TOrdem_Servico.Create;
    except
      res.Send('Erro ao conectar com o banco de dados').Status(500);
      Exit;
    end;

    try
      try
        body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

//        cliente.ID_CLIENTE  := body.GetValue<Integer>('idCliente', 0);
//        cliente.NOME        := body.GetValue<String>('nome', '');
//        cliente.EMAIL       := body.GetValue<String>('email', '');
//        cliente.FONE        := body.GetValue<String>('fone', '');

        ordemServico.EditarOdemServico(erro);

        body.Free;

        if erro <> '' then
          raise Exception.Create(erro);

      except on ex:exception do
        begin
          res.Send(ex.Message).Status(400);
          Exit;
        end;
      end;

      objOrdemServico := TJSONObject.Create;
      objOrdemServico.AddPair('idOrdemServico', ordemServico.ID_ORDEM_SERVICO.ToString);

      res.Send<TJSONObject>(objOrdemServico).Status(200);
    finally
      ordemServico.Free;
    end;
  end;

procedure FecharOrdemServico(Req: THorseRequest; Res: THorseResponse);
var
  ordemServico: TOrdem_Servico;
  body : TJSONValue;
  objOrdemServico: TJSONObject;
  erro: String;
  begin
    try
      ordemServico := TOrdem_Servico.Create;
    except
      res.Send('Erro ao conectar com o banco de dados').Status(500);
      Exit;
    end;

    try
      try
        body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

          ordemServico.ID_ORDEM_SERVICO  := body.GetValue<Integer>('idOrdemServico', 0);
          ordemServico.DATA_FECHAMENTO := body.GetValue<TDateTime>('dataFechamento', Now);

        ordemServico.FecharOdemServico(erro);

        body.Free;

        if erro <> '' then
          raise Exception.Create(erro);

      except on ex:exception do
        begin
          res.Send(ex.Message).Status(400);
          Exit;
        end;
      end;

      objOrdemServico := TJSONObject.Create;
      objOrdemServico.AddPair('idOrdemServico', ordemServico.ID_ORDEM_SERVICO.ToString);

      res.Send<TJSONObject>(objOrdemServico).Status(200);
    finally
      ordemServico.Free;
    end;
  end;

procedure Registry;
  begin
    THorse.Get('/ordemservico', ListarOrdemServico);
    THorse.Get('/ordemservico/:id', ListarOrdemServicoID);
    THorse.Post('/ordemservico', AddOrdemServico);
    THorse.Put('/ordemservico', EditOrdemServico);
    THorse.Put('/ordemservico/fechar', FecharOrdemServico);
  end;

end.
