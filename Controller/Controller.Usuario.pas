unit Controller.Usuario;

interface

uses Horse, System.JSON, System.SysUtils, Model.Cliente, Model.Usuario, FireDAC.Comp.Client,
     Data.DB, DataSet.Serialize;

procedure Registry;


implementation

procedure BuscarUsuario(Req: THorseRequest; Res: THorseResponse);
var
  Usuario:TUsuario;
  query: TFDQuery;
  erro: String;
  arrayUsuarios: TJSONArray;
  begin
    try
      Usuario := TUsuario.Create;
    except
      res.Send('Erro ao conectar com o banco').Status(500);
      Exit;
    end;

    try
      query := Usuario.Buscar(erro);

      arrayUsuarios := query.ToJSONArray();

      res.Send<TJSONArray>(arrayUsuarios);
    finally
      query.Free;
      Usuario.Free;
    end;
  end;

procedure Registry;
begin
  THorse.Get('/usuario/:nome/:senha', BuscarUsuario);
end;



end.
