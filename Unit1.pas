unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, WebView2, Winapi.ActiveX,
  Vcl.Edge, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    pnlBarreAdresse: TPanel;
    ActionList1: TActionList;
    eAdresse: TButtonedEdit;
    imgGo: TImage;
    StatusBar1: TStatusBar;
    pnlTools: TPanel;
    Splitter1: TSplitter;
    EdgeBrowser: TEdgeBrowser;
    actGo: TAction;
    imgBack: TImage;
    actBack: TAction;
    imgForward: TImage;
    actForward: TAction;
    imgRefresh: TImage;
    actRefresh: TAction;
    tbZoom: TTrackBar;
    pnlZoom: TPanel;
    lblZoom: TLabel;
    Panel1: TPanel;
    btnExecuterJS: TButton;
    eJavascript: TEdit;
    mJavascriptResults: TMemo;
    imgPhoto: TImage;
    SaveDialog1: TSaveDialog;
    imgHTML: TImage;
    procedure actGoExecute(Sender: TObject);
    procedure imgGoClick(Sender: TObject);
    procedure eAdresseKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actBackExecute(Sender: TObject);
    procedure imgBackClick(Sender: TObject);
    procedure EdgeBrowserCreateWebViewCompleted(Sender: TCustomEdgeBrowser;
      AResult: HRESULT);
    procedure EdgeBrowserNavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: TOleEnum);
    procedure EdgeBrowserNavigationStarting(Sender: TCustomEdgeBrowser;
      Args: TNavigationStartingEventArgs);
    procedure actForwardExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure imgRefreshClick(Sender: TObject);
    procedure imgForwardClick(Sender: TObject);
    procedure tbZoomChange(Sender: TObject);
    procedure btnExecuterJSClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdgeBrowserExecuteScript(Sender: TCustomEdgeBrowser;
      AResult: HRESULT; const AResultObjectAsJson: string);
    procedure eJavascriptKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure imgPhotoClick(Sender: TObject);
    procedure imgHTMLClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.NetEncoding;

procedure TForm1.actBackExecute(Sender: TObject);
begin
  EdgeBrowser.GoBack;
end;

procedure TForm1.actForwardExecute(Sender: TObject);
begin
  EdgeBrowser.GoForward;
end;

procedure TForm1.actGoExecute(Sender: TObject);
begin
  EdgeBrowser.Navigate(eAdresse.Text);
end;

procedure TForm1.actRefreshExecute(Sender: TObject);
begin
  EdgeBrowser.Refresh;
end;

procedure TForm1.btnExecuterJSClick(Sender: TObject);
begin
  EdgeBrowser.ExecuteScript(eJavascript.Text);
end;

procedure TForm1.eAdresseKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then actGo.Execute;
end;

procedure TForm1.EdgeBrowserCreateWebViewCompleted(
  Sender: TCustomEdgeBrowser; AResult: HRESULT);
begin
  StatusBar1.Panels[0].Text := 'Prêt';
end;

procedure TForm1.EdgeBrowserExecuteScript(Sender: TCustomEdgeBrowser;
  AResult: HRESULT; const AResultObjectAsJson: string);
begin
  mJavascriptResults.Clear;
  if AResultObjectAsJson <> 'null' then begin
    mJavascriptResults.Text := TNetEncoding.URL.Decode(AResultObjectAsJson).DeQuotedString('"');
  end;
end;

procedure TForm1.EdgeBrowserNavigationCompleted(Sender: TCustomEdgeBrowser;
  IsSuccess: Boolean; WebErrorStatus: TOleEnum);
begin
   StatusBar1.Panels[0].Text := 'Page chargée';
   eAdresse.Text := EdgeBrowser.LocationURL;
   Form1.caption := 'TEdgeBrowser Démo - ' + EdgeBrowser.DocumentTitle;
end;

procedure TForm1.EdgeBrowserNavigationStarting(Sender: TCustomEdgeBrowser;
  Args: TNavigationStartingEventArgs);
begin
  StatusBar1.Panels[0].Text := 'Chargement en cours...';
end;

procedure TForm1.eJavascriptKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then btnExecuterJS.Click;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  actGO.Execute;
end;

procedure TForm1.imgBackClick(Sender: TObject);
begin
  actBack.Execute;
end;

procedure TForm1.imgForwardClick(Sender: TObject);
begin
  actForward.Execute;
end;

procedure TForm1.imgGoClick(Sender: TObject);
begin
  actGo.Execute;
end;

procedure TForm1.imgHTMLClick(Sender: TObject);
begin
  EdgeBrowser.NavigateToString('<html><head><title>Du contenu HTML</title></head><body><div id="delphi">Présentation du <b>TEdgeBrowser</b> !</div></body></html>');
end;

procedure TForm1.imgPhotoClick(Sender: TObject);
begin
  if SaveDialog1.Execute then begin
    if ExtractFileExt(SaveDialog1.FileName).ToLower = '.png' then
      EdgeBrowser.CapturePreview(SaveDialog1.FileName, TCustomEdgeBrowser.TPreviewFormat.PNG)
    else
      EdgeBrowser.CapturePreview(SaveDialog1.FileName, TCustomEdgeBrowser.TPreviewFormat.JPEG);
  end;
end;

procedure TForm1.imgRefreshClick(Sender: TObject);
begin
  actRefresh.Execute;
end;

procedure TForm1.tbZoomChange(Sender: TObject);
begin
  EdgeBrowser.ZoomFactor := tbZoom.Position/10;
  lblZoom.caption := (tbZoom.Position * 10).ToString  + ' %';
end;

end.
