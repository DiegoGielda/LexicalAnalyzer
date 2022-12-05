unit formMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.JumpList;

type
  TfrmMain = class(TForm)
    gridMain: TGridPanel;
    gridResult: TGridPanel;
    sgridResult: TStringGrid;
    gridSearchedWord: TGridPanel;
    edtAdd: TEdit;
    btnAdd: TButton;
    lbxWords: TListBox;
    lblReconhecidas: TLabel;
    edtSearch: TEdit;
    lblIdentifier: TLabel;
    procedure lbxWordsClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgridResultDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLinePosition: Integer;

    FLineHorizontal: Integer;
    FLineVertical: Integer;

    FLineSearchedPhrase: string;
    FListItens: TStringList;
    FCorreto: Boolean;

    procedure FillStringGridReuse;
    procedure AssembleStringGrid;
    procedure CleanStringGrid(pHeader: Boolean = True);
    procedure SentenceRecognition(pSentence: string);

    function QueryValueField(Acol, aRow: Integer):string;
    function PesquisarColuna(pCaractere: string): Integer;
    procedure Local(pCaractere: string; out pColuna, pLinha: Integer);
    function GetLast(pText: string): string;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.CleanStringGrid(pHeader: Boolean = True);
var
  lCountCol, lCountRow: Integer;
begin
  for lCountCol := 0 to sgridResult.ColCount - 1 do
  begin
    for lCountRow := 0 to sgridResult.RowCount - 1 do
    begin
      if pHeader then
      begin
        sgridResult.Cells[lCountCol, lCountRow] := '';
      end
      else
      begin
        sgridResult.Cells[lCountCol + 1, lCountRow + 1] := '';
      end;
    end;
  end;
end;

procedure TfrmMain.edtSearchKeyPress(Sender: TObject; var Key: Char);
var
  lCountWordLine, lSizeWord: Integer;
  lLineSearchedPhrase, lSymbol, lWord, lLine, lSpace: String;
  lDeleteButton: Boolean;
begin

  FCorreto := false;

  if not (key in [#8, #32, #65..#90, #97..#122]) then
  begin
    Key := #0;
    Abort;
  end;

  if (Word(Key) = VK_SPACE) then
  begin
    FLineVertical := 0;
    FLineHorizontal := 0;
    edtSearch.Text := edtSearch.Text + ' ';
    Abort;
  end;

//
//
//  lDeleteButton := (Word(Key) = VK_BACK);
//
//  if (Word(Key) = VK_SPACE) or lDeleteButton then
//  begin
//    lSpace := edtSearch.Text;
//    if lDeleteButton and (lSpace[Length(lSpace)] = ' ')then
//    begin
//      edtSearch.Text := Copy(lSpace, 1, Length(lSpace) - 1);
//      edtSearch.SetFocus;
//      abort;
//    end;
//  end;

  lDeleteButton := (Word(Key) = VK_BACK);

  if lDeleteButton and ((Length(edtSearch.Text) = 1) or (Length(edtSearch.Text) = 0)) then
  begin
    FLineVertical := 0;
    FLineHorizontal := 0;
    //FLinePosition := 0;
    edtSearch.Text := '';
    CleanStringGrid;
    AssembleStringGrid;
    FillStringGridReuse;
    Abort;
  end;

  lSizeWord := 1;
  if lDeleteButton then // apagar
  begin
    lLineSearchedPhrase := edtSearch.Text;
    lSizeWord := Length(lLineSearchedPhrase);
    lLineSearchedPhrase := Copy(lLineSearchedPhrase, 1, lSizeWord -1);

    lLineSearchedPhrase := UpperCase(lLineSearchedPhrase);
    lSizeWord := Length(lLineSearchedPhrase);
    lSymbol := lLineSearchedPhrase[lSizeWord];
  end
  else
  begin
    lSymbol := UpperCase(Key);
    lLineSearchedPhrase := UpperCase(edtSearch.Text + lSymbol);
  end;

  lLineSearchedPhrase := GetLast(lLineSearchedPhrase);


  // Pegar o local do caractere comparado
  lSizeWord := Length(lLineSearchedPhrase);

  // Verificar coluna para cada linha
  for lCountWordLine := 0 to lbxWords.Count -1 do
  begin
    lWord := UpperCase(lbxWords.Items[lCountWordLine]);
    lWord := Copy(lWord, 1, lSizeWord);
    if (lWord = lLineSearchedPhrase) then
    begin
      SentenceRecognition(lLineSearchedPhrase);
      FCorreto := True;

      if (Word(Key) = VK_BACK) then
      begin
        lLine := Copy(sgridResult.Cells[FLineVertical, FLineHorizontal], 2, 4);
        local('q'+ IntToStr(StrToIntDef(lLine, 0) -1), FLineVertical, FLineHorizontal);
      end
      else
      if (lSizeWord = 1) then
      begin
        FLineVertical := PesquisarColuna(lSymbol);
        FLineHorizontal := 1;
      end
      else
      begin
        lLine := Copy(sgridResult.Cells[FLineVertical, FLineHorizontal], 2, 4);
        local('q'+ IntToStr(StrToIntDef(lLine, 0) + 1), FLineVertical, FLineHorizontal);
      end;

      CleanStringGrid;
      AssembleStringGrid;
      FillStringGridReuse;
      exit;
    end
    else
    begin
      FLineVertical := FLineVertical;
      FLineHorizontal := FLineHorizontal;

      Inc(FLinePosition);

      CleanStringGrid;
      AssembleStringGrid;
      FillStringGridReuse;
    end;
  end;

end;

procedure TfrmMain.FillStringGridReuse;
var
  lContListBox, lContCaractere, lColunaGrid, lLinhaGrid, lFinal, lTotalQ, lTotalLinhas: Integer;
  lPalavraLista, lSimbolo, lCaractereColuna, lSimboloInicial, lSimboloCelula: string;
  lValorLinha, lValorCelula: Integer;
begin
  lTotalQ := 0;
  for lContListBox := 0 to lbxWords.Count - 1 do
  begin
    lPalavraLista := UpperCase(lbxWords.Items[lContListBox]); /// Palavra inteira
    lLinhaGrid := 1;
    lTotalLinhas := 1;

    for lContCaractere := 1 to Length(lPalavraLista) do
    begin
      lSimbolo := lPalavraLista[lContCaractere]; // caractere por palavra

      lColunaGrid := PesquisarColuna(lSimbolo); /// Coluna no grid
      lSimboloCelula := sgridResult.Cells[lColunaGrid, lLinhaGrid];

      if (lSimboloCelula = '') and (lLinhaGrid < lTotalQ) then
      begin
        sgridResult.Cells[lColunaGrid, lLinhaGrid] := 'q' + IntToStr(lTotalQ);
        lLinhaGrid := lTotalQ;
        Inc(lTotalQ);
      end
      else
      if (Pos('q', lSimboloCelula) > 0) and (lSimboloCelula <> 'q0') then
      begin
        lLinhaGrid := StrToInt(Copy(lSimboloCelula, 2, 4)) + 1;
      end
      else
      if (lSimboloCelula = '') then
      begin
        sgridResult.Cells[lColunaGrid, lLinhaGrid] := 'q' + IntToStr(lTotalQ);
        Inc(lTotalQ);

      end
      else
      if (lSimboloCelula = '-') then
      begin
        while lSimboloCelula <> '' do
        begin

          if Pos('*', sgridResult.Cells[0, lLinhaGrid]) > 0 then
          begin
            lValorLinha := StrToInt(Copy(sgridResult.Cells[0, lLinhaGrid], 3, 3));
            if (lValorLinha = lTotalQ - 1) then
            begin
              Exit;
            end;
          end;

          Inc(lLinhaGrid);
          lSimboloCelula := sgridResult.Cells[lColunaGrid, lLinhaGrid];
        end;
        sgridResult.Cells[lColunaGrid, lLinhaGrid] := 'q' + IntToStr(lTotalQ);
        Inc(lTotalQ);
      end;

      Inc(lLinhaGrid);

    end;

    sgridResult.Cells[0, lLinhaGrid] := '*' + sgridResult.Cells[0, lLinhaGrid];
    for lFinal := 1 to sgridResult.RowCount - 1 do
    begin
      sgridResult.Cells[lFinal, lLinhaGrid] := '-';
    end;
  end;
end;

procedure TfrmMain.AssembleStringGrid;
var
  lCount: Integer;
  lAlphabet: string;
begin
  lAlphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  for lCount := 1 to Length(lAlphabet) do
  begin
    sgridResult.Cells[lCount, 0] := lAlphabet[lCount];
  end;

  sgridResult.Cells[0, 1] := 'S';
  for lCount := 2 to 200 do
  begin
    sgridResult.Cells[0, lCount] := 'q' + IntToStr(lCount -2);
  end;
end;

procedure TfrmMain.btnAddClick(Sender: TObject);
var
  lWord: string;
begin
  lWord := Trim(edtAdd.Text);
  if (lWord <> '') then
  begin
    lbxWords.Items.Add(lWord);
    edtAdd.Text := '';
  end;

  CleanStringGrid;
  AssembleStringGrid;
  FillStringGridReuse;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FListItens := TStringList.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FListItens);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  CleanStringGrid;
  AssembleStringGrid;

  FLineHorizontal := 0;
  FLineVertical := 0;
end;

function TfrmMain.GetLast(pText: string): string;
begin
  Result := pText;
  repeat
    Delete(Result, 1, Pos(' ',Result));
  until Pos(' ', Result) = 0;
end;

procedure TfrmMain.lbxWordsClick(Sender: TObject);
begin
  lbxWords.DeleteSelected;
end;

procedure TfrmMain.Local(pCaractere: string; out pColuna, pLinha: Integer);
var
  lCountCol, lCountRow: Integer;
begin
  for lCountCol := 0 to sgridResult.ColCount - 1 do
  begin
    for lCountRow := 0 to sgridResult.RowCount - 1 do
    begin
      if pCaractere = sgridResult.Cells[lCountCol, lCountRow] then
      begin
        pColuna := lCountCol;
        pLinha := lCountRow;
      end;
    end;
  end;
end;

function TfrmMain.PesquisarColuna(pCaractere: string): Integer;
var
  lCont: Integer;
begin
  Result := 0;
  for lCont := 1 to sgridResult.ColCount - 1 do
  begin
    if pCaractere = sgridResult.Cells[lCont, 0] then
    begin
      Result := lCont;
    end;
  end;
end;

function TfrmMain.QueryValueField(Acol, aRow: Integer): string;
begin
  Result := sgridResult.Cells[Acol, aRow];
end;

procedure TfrmMain.SentenceRecognition(pSentence: string);
var
  lCount: Integer;
begin
  for lCount := 0 to lbxWords.Count - 1 do
  begin
    if (Pos(pSentence, lblReconhecidas.Caption) = 0) and (pSentence = lbxWords.Items[lCount]) then
    begin
      lblReconhecidas.Caption := lblReconhecidas.Caption + '  ' + pSentence;
    end;
  end;
end;

procedure TfrmMain.sgridResultDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  lCalcHeight, lCalcWidth : integer;
begin

  if gdFixed in State then
  begin
    sgridResult.Canvas.Font.Style := [fsbold];
    sgridResult.Canvas.Font.Size := 11;
    sgridResult.Canvas.Font.Color := RGB(255, 255, 255);

    sgridResult.Canvas.Brush.Color := RGB(42, 48, 56);
  end
  else
  begin
    sgridResult.Canvas.Font.Size := 10;
    sgridResult.Canvas.Font.Color := RGB(255, 103, 0); // laranja

    sgridResult.Canvas.Brush.Color := RGB(25, 29, 34);
  end;


  if (FLineVertical > 0) and (FLineHorizontal > 0) and (FLineVertical = ACol) and (FLineHorizontal = ARow) then
  begin
    sgridResult.Canvas.Font.Style := [fsbold];
    sgridResult.Canvas.Font.Size := 10;
    sgridResult.Canvas.Font.Color := RGB(0, 0, 0);

    if FCorreto then
      sgridResult.Canvas.Brush.Color := RGB(60, 195, 192)
    else
      sgridResult.Canvas.Brush.Color := RGB(255, 35, 0);
  end;

  sgridResult.Canvas.FillRect(Rect);

  lCalcHeight := sgridResult.Canvas.TextHeight(sgridResult.Cells[ACol, ARow]);
  lCalcHeight := Rect.Top + (Rect.Bottom - Rect.Top - lCalcHeight) div 2;

  lCalcWidth := sgridResult.Canvas.TextWidth(sgridResult.Cells[ACol, ARow]);
  lCalcWidth := Rect.Left + (Rect.Right - Rect.Left - lCalcWidth) div 2;

  sgridResult.Canvas.TextRect(Rect, lCalcWidth, lCalcHeight, sgridResult.Cells[ACol, ARow]);
end;

end.
