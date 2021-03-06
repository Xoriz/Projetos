unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, {FileCtrl, }DB, {DBTables,} DBClient, Grids,
  DBGrids, Mask, RxToolEdit{, {ToolEdit, RxToolEdit, ToolEdit},System.IOUtils;

type
  TFrmPrincipal = class(TForm)
    Panel1: TPanel;
    TblArquivos: TClientDataSet;
    TblArquivosNome: TStringField;
    TblArquivosCaminho: TStringField;
    DtsArquivos: TDataSource;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    Button2: TButton;
    Edt_PathPasta: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edt_PathFinal: TEdit;
    Edt_Cam: TDirectoryEdit;
    Edt_CamFinal: TDirectoryEdit;
    Button1: TButton;
    procedure EnumFolders(Root: String; Folders: TStrings);
    procedure EnumFiles(Pasta, Arquivo: String);
    procedure GerarTxt;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edt_CamChange(Sender: TObject);
    procedure Edt_CamFinalChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    function Completa(Nome : String;NumeroEspacos : Integer):String;
    function CompletaNumeros(Numero:String):String;
    function CompletaNumeros2(Numero:String):String;
    function CompletaNumeros3(Numero:String):String;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}


procedure TFrmPrincipal.Button2Click(Sender: TObject);
begin
   if (Edt_PathPasta.Text <> '') and (Edt_PathFinal.Text <> '') then
      GerarTxt
   else
   if (Edt_CamFinal.Text = '') then
      Edt_CamFinal.DoClick
   else
   if (Edt_Cam.Text = '') then
      Edt_Cam.DoClick;
end;

procedure TFrmPrincipal.EnumFolders(Root: String; Folders: TStrings);
   procedure Enum(dir: String);
   var
	 SR: TSearchRec;
	 ret: Integer;
   begin
	   if dir[length(dir)] <> '\' then
	      dir := dir + '\';

      ret := FindFirst(dir + '*.*', faDirectory, SR);
      if ret = 0 then
      try
         repeat
            if ((SR.Attr and faDirectory) <> 0) and ( SR.Name <> '.') and ( SR.Name <> '..') then
            begin
               folders.add( dir+SR.Name );
               Enum( dir + SR.Name );
            end;                                                           
            ret := FindNext( SR );
         until ret <> 0; 
      finally
	      SysUtils.FindClose(SR)
      end;
   end;
begin
   if root <> EmptyStr then
	   Enum(root);
end;
 
//usa EnumFolders para listar as Sub-Pastas e procuras por arquivos

procedure TFrmPrincipal.EnumFiles(Pasta, Arquivo: String);
var
  SR: TSearchRec;
  SubDirs : TStringList;
  ret, X, Tamanho : integer;
  sPasta : String;
begin
   Tamanho := Length(Pasta)+1;
   TblArquivos.Close;
   TblArquivos.CreateDataSet;

   if Pasta[Length(Pasta)] <> '\' then
      Pasta := Pasta + '\';
                                    
   try
      SubDirs := TStringList.Create;
      SubDirs.Add(Pasta);
      EnumFolders(Pasta, SubDirs);
      
      if SubDirs.Count > 0 then
      for X := 0 to SubDirs.Count -1 do
      begin
         sPasta:= SubDirs[X];
         if sPasta[Length(sPasta)] <> '\' then
            sPasta := sPasta + '\'; 

         ret := FindFirst(sPasta + Arquivo, faAnyFile, SR);
         if ret = 0 then
         try
            repeat
               if not (SR.Attr and faDirectory > 0) and (SR.Name <> 'ReleaseHelper.exe')then
               begin
                  TblArquivos.Append;
                  TblArquivosNome.AsString    := Trim(SR.Name);

                  if SPasta <> Pasta then
                     TblArquivosCaminho.AsString := Trim(Copy(SPasta,Tamanho,Length(SPasta)));

                  TblArquivos.Post;
               end;
               ret := FindNext(SR);
            until ret <> 0;

         finally
            SysUtils.FindClose(SR)
         end;
      end;
   finally
      SubDirs.Free;
   end;
end;

procedure TFrmPrincipal.GerarTxt;
var
   mArquivo : TextFile;
   mCaminhoArquivo, mQuantidadeArquivos : String;
   mMaiorNome, i : Integer;
begin
   mCaminhoArquivo := Edt_CamFinal.Text+'\VetorArquivosRelease.txt';
   mMaiorNome := 0;
   i := 1;
   mQuantidadeArquivos := IntToStr(TblArquivos.RecordCount);

   TblArquivos.DisableControls;
   TblArquivos.First;
   while not TblArquivos.Eof do
   begin
      if Length(TblArquivosNome.AsString) > mMaiorNome then
         mMaiorNome := Length(TblArquivosNome.AsString);

      TblArquivos.Next;
   end;

   TblArquivos.First;
   while not TblArquivos.Eof do
   begin
      try
         AssignFile(mArquivo,mCaminhoArquivo);
         if not FileExists(mCaminhoArquivo) then
            Rewrite(mArquivo)
         else
            Append(mArquivo);
         if Trim(TblArquivosCaminho.AsString) <> '' then
            WriteLn(mArquivo,'vArquivos['+CompletaNumeros(IntToStr(i))+Completa(TblArquivosNome.AsString,mMaiorNome)+ ' vArquivos['+CompletaNumeros2(IntToStr(i))+' vArquivos['+CompletaNumeros3(IntToStr(i)))
         else
            WriteLn(mArquivo,'vArquivos['+CompletaNumeros(IntToStr(i))+Completa(TblArquivosNome.AsString,mMaiorNome)+ ' vArquivos['+CompletaNumeros2(IntToStr(i)));
            
         Inc(i);
      finally
         CloseFile(mArquivo);
      end;
      TblArquivos.Next;
   end;
   TblArquivos.EnableControls;
   ShowMessage('Arquivo criado em: '+mCaminhoArquivo);
   Button1.Enabled := True;
end;

function TFrmPrincipal.Completa(Nome:String;NumeroEspacos : Integer):String;
begin
   result := Nome+''';';
   while Length(Result) < NumeroEspacos+2 do
      Result := Result + ' ';
end;

function TFrmPrincipal.CompletaNumeros(Numero:String):String;
var
   Aux : String;
   Espacos : Integer;
begin
   Espacos := Length(IntToStr(TblArquivos.RecordCount)) - Length(Numero);

   if Espacos = 0 then
      Aux := Numero+',1] := '''
   else
   if Espacos = 1 then
      Aux := Numero+',1]  := '''
   else
   if Espacos = 2 then
      Aux := Numero+',1]   := '''
   else
   if Espacos = 3 then
      Aux := Numero+',1]    := ''';

   Result := Aux;
end;

function TFrmPrincipal.CompletaNumeros2(Numero:String):String;
var
   Aux : String;
   Espacos : Integer;
begin
   Espacos := Length(IntToStr(TblArquivos.RecordCount)) - Length(Numero);

   if Espacos = 0 then
      Aux := Numero+',2] := ''S'';'
   else
   if Espacos = 1 then
      Aux := Numero+',2]  := ''S'';'
   else
   if Espacos = 2 then
      Aux := Numero+',2]   := ''S'';'
   else
   if Espacos = 3 then
      Aux := Numero+',2]    := ''S'';';

   Result := Aux;
end;

function TFrmPrincipal.CompletaNumeros3(Numero:String):String;
var
   Aux : String;
   Espacos : Integer;
begin
   Espacos := Length(IntToStr(TblArquivos.RecordCount)) - Length(Numero);

   if Espacos = 0 then
      Aux := Numero+',3] := '''+TblArquivosCaminho.AsString+''';'
   else
   if Espacos = 1 then
      Aux := Numero+',3]  := '''+TblArquivosCaminho.AsString+''';'
   else
   if Espacos = 2 then
      Aux := Numero+',3]   := '''+TblArquivosCaminho.AsString+''';'
   else
   if Espacos = 3 then
      Aux := Numero+',3]    := '''+TblArquivosCaminho.AsString+''';';

   Result := Aux;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
   Edt_Cam.InitialDir := ExtractFilePath(Application.ExeName);
   Edt_Cam.DoClick;
   Edt_PathPasta.Text := Edt_Cam.Text;
end;

procedure TFrmPrincipal.Edt_CamChange(Sender: TObject);
begin
   Edt_PathPasta.Text := Edt_Cam.Text;
   EnumFiles(Edt_Cam.Text,'*.*');
   FrmPrincipal.Caption := IntToStr(TblArquivos.RecordCount)+' arquivos encontrados!';
end;

procedure TFrmPrincipal.Edt_CamFinalChange(Sender: TObject);
begin
   Edt_PathFinal.Text := Edt_CamFinal.Text;
end;

procedure TFrmPrincipal.Button1Click(Sender: TObject);
var
   mJaDeletou : Boolean;
   mPastaAtual,
   mPastaRaiz : String;
begin
   mJaDeletou := False;
   TblArquivos.Filter := 'Caminho <> ''''';
   TblArquivos.Filtered := True;
   TblArquivos.First;
   mPastaRaiz  := Edt_PathPasta.Text;
   mPastaAtual := TblArquivosCaminho.AsString;

   while not TblArquivos.Eof do
   begin
      if FileExists(pchar(mPastaRaiz+TblArquivosCaminho.AsString+TblArquivosNome.AsString)) then
         if not MoveFile(pchar(mPastaRaiz+TblArquivosCaminho.AsString+TblArquivosNome.AsString),pchar(mPastaRaiz+'\'+TblArquivosNome.AsString)) then
            DeleteFile(pchar(mPastaRaiz+TblArquivosCaminho.AsString+TblArquivosNome.AsString));

      TblArquivos.Next;

      if mPastaAtual <> TblArquivosCaminho.AsString then
      begin
         if DirectoryExists(pchar(mPastaRaiz+mPastaAtual)) then
            RemoveDir(pchar(mPastaRaiz+mPastaAtual));

         mPastaAtual := TblArquivosCaminho.AsString;
      end;
   end;
   if DirectoryExists(pchar(mPastaRaiz+mPastaAtual)) then
      RemoveDir(pchar(mPastaRaiz+mPastaAtual));

   TblArquivos.First;
   while not TblArquivos.Eof do
   begin
      if DirectoryExists(pchar(mPastaRaiz+TblArquivosCaminho.AsString)) then
         TDirectory.Delete(pchar(mPastaRaiz+TblArquivosCaminho.AsString));

      if (pos('gnre',TblArquivosCaminho.AsString) > 0) and (not mJaDeletou) then
      begin
         TDirectory.Delete(pchar(mPastaRaiz+'\gnre\'));
         mJaDeletou := True;
      end;
      TblArquivos.Next;
   end;

   TblArquivos.Filtered := False;
   Button1.Enabled      := False;
end;

end.
