program apiRestHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  FireDAC.Comp.Client,
  Data.DB,
  FireDAC.DApt,
  Horse.Jhonson,
  Horse.BasicAuthentication,
  Controller.Cliente in 'Controller\Controller.Cliente.pas',
  Model.Connection in 'Model\Model.Connection.pas',
  Model.Cliente in 'Model\Model.Cliente.pas',
  Model.Usuario in 'Model\Model.Usuario.pas',
  Controller.Usuario in 'Controller\Controller.Usuario.pas',
  Model.Ordem_Servico in 'Model\Model.Ordem_Servico.pas',
  Controller.Ordem_Servico in 'Controller\Controller.Ordem_Servico.pas';

begin
  THorse.Use(Jhonson());
  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    var
      Usuario: TUsuario;
    begin
      Usuario := TUsuario.Create;
      Result := Usuario.ValidarAcesso(AUsername, APassword);
    end));

  Controller.Cliente.Registry;
  Controller.Usuario.Registry;
  Controller.Ordem_Servico.Registry;

  THorse.Listen(9000, procedure
  begin
    Writeln( 'API iniciada na porta: ', IntToStr(THorse.Port));
  end);

end.
