program ADS_DoublyLinkedList;

uses crt,SysUtils;

type
  plista_d = ^tosoba;
  tosoba = record
    imie:string[25];
    nazwisko:string[40];
    wiek:byte;
    PESEL:string[11];
    nast,pop:plista_d;
  end;

procedure dodajMechanizm(var pocz:plista_d;nowy:plista_d);
var
  liczba:plista_d;
begin
  if(pocz = nil) then
  begin
    nowy^.nast:=nil;
    nowy^.pop:=nil;
    pocz:=nowy;
  end else
  begin
    liczba:=pocz;
    while (liczba <> nil) do
    begin
      if(nowy^.nazwisko <= liczba^.nazwisko) then
      begin
        if(liczba^.pop = nil) then
        begin
          nowy^.pop:=nil;
          nowy^.nast:=liczba;
          liczba^.pop:=nowy;
          pocz:=nowy;
          break;
        end else
        begin
          nowy^.pop:=liczba^.pop;
          nowy^.nast:=liczba;
          liczba^.pop^.nast:=nowy;
          liczba^.pop:=nowy;
          break;
        end;
      end else
      begin
        if(liczba^.nast = nil) then
        begin
          nowy^.nast:=nil;
          nowy^.pop:=liczba;
          liczba^.nast:=nowy;
          break;
        end;
      end;
      liczba:=liczba^.nast;
    end;
  end;
end;

procedure dodajOsobe(var pocz:plista_d; czySprawdzac:boolean);
var
  nowy:plista_d;
  liczba:plista_d;
begin
  ClrScr;
  writeln('------------------------------ DODAJ -----------------------------');
  new(nowy);
  if(nowy = nil) then
  begin
    writeln('Nie udalo sie zaalokowac pamieci!');
    writeln();
    writeln('Aby wrocic do MENU, wcisnij ENTER...');
    readln();
    exit;
  end;
  writeln('+ Podaj imie');
  readln(nowy^.imie);
  writeln('+ Podaj nazwisko');
  readln(nowy^.nazwisko);
  writeln('+ Podaj wiek');
  readln(nowy^.wiek);
  repeat
    writeln('+ Podaj PESEL');
    readln(nowy^.PESEL);
  until (length(nowy^.PESEL) = 11);
  if(czySprawdzac) then
  begin
    liczba:=pocz;
    while (liczba <> nil) do
    begin
      if((liczba^.imie = nowy^.imie) and (liczba^.nazwisko = nowy^.nazwisko) and (liczba^.wiek = nowy^.wiek) and (liczba^.PESEL = nowy^.PESEL)) then
      begin
        writeln();
        writeln('Dokladnie taki sam element juz istnieje!');
        writeln('Anulowano dodawanie');
        writeln();
        writeln('Aby wrocic do MENU, wcisnij ENTER...');
        readln();
        exit;
      end;
      liczba:=liczba^.nast;
    end;
  end;
  dodajMechanizm(pocz,nowy);
end;

procedure usunWszystko(var pocz:plista_d);
var
  temp:plista_d;
begin
  while (pocz <> nil) do
  begin
    temp:=pocz;
    pocz:=pocz^.nast;
    dispose(temp);
  end;
end;

procedure wypiszOsoby(pocz:plista_d);
begin
  ClrScr;
  writeln('----------------------------- WYPISZ -----------------------------');
  if(pocz = nil) then
  begin
    writeln('Lista osob jest pusta!');
  end else
  begin
    while (pocz <> nil) do
    begin
      writeln('------------------------------------------------------------------');
      writeln('Nazwisko i imie: ',pocz^.nazwisko,' ',pocz^.imie);
      writeln('Wiek: ',pocz^.wiek,', PESEL: ',pocz^.PESEL);
      writeln('------------------------------------------------------------------');
      pocz:=pocz^.nast;
    end;
  end;
  writeln();
  writeln('Aby wrocic do MENU, wcisnij ENTER...');
  readln();
end;

procedure usunPoNazwisku(var pocz:plista_d;czyWszystkie:boolean);
var
  czyUsunieto:boolean;
  liczba,temp:plista_d;
  nazwisko:string[40];
begin
  ClrScr;
  writeln('------------------------------ USUN ------------------------------');
  if(pocz = nil) then
  begin
    writeln('Lista osob jest pusta!');
    writeln();
    writeln('Aby wrocic do MENU, wcisnij ENTER...');
    readln();
    exit;
  end;
  writeln('+ Podaj nazwisko');
  readln(nazwisko);
  czyUsunieto:=false;
  liczba:=pocz;
  while (liczba<>nil) do
  begin
    if(nazwisko = liczba^.nazwisko) then
    begin
      temp:=liczba;
      if(liczba^.pop = nil) then
      begin
        pocz:=liczba^.nast;
        if(pocz <> nil) then pocz^.pop:=nil;
      end else liczba^.pop^.nast:=liczba^.nast;
      if(liczba^.nast = nil) then
      begin
        if(liczba^.pop <> nil) then liczba^.pop^.nast:=nil;
      end else liczba^.nast^.pop:=liczba^.pop;
      liczba:=liczba^.nast;
      dispose(temp);
      czyUsunieto:=true;
      if(not czyWszystkie) then break else continue;
    end;
    liczba:=liczba^.nast;
  end;
  writeln();
  if(czyUsunieto) then writeln('Znaleziono i usunieto!') else writeln('Nie znaleziono pasujacych elementow!');
  writeln();
  writeln('Aby wrocic do MENU, wcisnij ENTER...');
  readln();
end;

procedure edytujOsobe(var pocz:plista_d);
var
  n:byte;
  szukany:string[40];
  liczba,edytowany:plista_d;
  czyZatwierdzono:boolean;
  decyzja:char;
begin
  ClrScr;
  writeln('----------------------------- EDYCJA -----------------------------');
  if(pocz = nil) then
  begin
    writeln('Lista osob jest pusta!');
    writeln();
    writeln('Aby wrocic do MENU, wcisnij ENTER...');
    readln();
    exit;
  end;
  writeln('1) Wyszukaj po imieniu');
  writeln('2) Wyszukaj po nazwisku');
  writeln('3) Wyszukaj po nr PESEL');
  repeat
    readln(n);
  until ((n > 0) and (n < 4));
  ClrScr;
  writeln('----------------------------- EDYCJA -----------------------------');
  repeat
    if(n = 1) then writeln('+ Podaj imie') else
    begin
      if(n = 2) then writeln('+ Podaj nazwisko') else writeln('+ Podaj PESEL');
    end;
    readln(szukany);
  until ((n < 3) or ((n = 3) and (length(szukany) = 11)));
  czyZatwierdzono:=false;
  liczba:=pocz;
  while (liczba <> nil) do
  begin
    if(((szukany = liczba^.imie) and (n = 1)) or ((szukany = liczba^.nazwisko) and (n = 2)) or ((szukany = liczba^.PESEL) and (n = 3))) then
    begin
      ClrScr;
      writeln('----------------------------- EDYCJA -----------------------------');
      writeln('Znaleziono pasujacy element: ');
      writeln();
      writeln('Nazwisko i imie: ',liczba^.nazwisko,' ',liczba^.imie);
      writeln('Wiek: ',liczba^.wiek,', PESEL: ',liczba^.PESEL);
      writeln();
      repeat
        writeln('Edytowac ta osobe? Jesli nie, wyszukiwanie bedzie kontynuowane. (T/N)');
        readln(decyzja);
        decyzja:=lowercase(decyzja);
      until ((decyzja = 't') or (decyzja = 'n'));
      if(decyzja = 't') then
      begin
        czyZatwierdzono:=true;
        break;
      end;
    end;
    liczba:=liczba^.nast;
  end;
  if(not czyZatwierdzono) then
  begin
    ClrScr;
    writeln('----------------------------- EDYCJA -----------------------------');
    writeln('Nie znaleziono takiej osoby!');
    writeln();
    writeln('Aby wrocic do MENU, wcisnij ENTER...');
    readln();
    exit;
  end;
  repeat
    repeat
      ClrScr;
      writeln('----------------------------- EDYCJA -----------------------------');
      writeln('Nazwisko i imie: ',liczba^.nazwisko,' ',liczba^.imie);
      writeln('Wiek: ',liczba^.wiek,', PESEL: ',liczba^.PESEL);
      writeln();
      writeln('1) Edytuj imie');
      writeln('2) Edytuj nazwisko');
      writeln('3) Edytuj wiek');
      writeln('4) Edytuj PESEL');
      writeln();
      writeln('0) Wroc do MENU');
      readln(n);
    until (n < 5);
    if(n = 0) then exit;
    ClrScr;
    writeln('----------------------------- EDYCJA -----------------------------');
    writeln('Nazwisko i imie: ',liczba^.nazwisko,' ',liczba^.imie);
    writeln('Wiek: ',liczba^.wiek,', PESEL: ',liczba^.PESEL);
    writeln();
    if(n = 1) then
    begin
      writeln('+ Podaj nowe imie');
      readln(liczba^.imie);
    end else
    begin
      if(n = 2) then
      begin
        writeln('+ Podaj nowe nazwisko');
        readln(liczba^.nazwisko);
        edytowany:=liczba;
        if(liczba^.pop = nil) then
        begin
          pocz:=liczba^.nast;
          if(pocz <> nil) then pocz^.pop:=nil;
        end else liczba^.pop^.nast:=liczba^.nast;
        if(liczba^.nast = nil) then
        begin
          if(liczba^.pop <> nil) then liczba^.pop^.nast:=nil;
        end else liczba^.nast^.pop:=liczba^.pop;
        dodajMechanizm(pocz,edytowany);
      end else
      begin
        if(n = 3) then
        begin
          writeln('+ Podaj nowy wiek');
          readln(liczba^.wiek);
        end else
        begin
          repeat
            writeln('+ Podaj nowy PESEL');
            readln(liczba^.PESEL);
          until (length(liczba^.PESEL) = 11);
        end;
      end;
    end;
    writeln('Zapisano zmiany!');
    writeln();
    writeln('Aby kontynuowac, wcisnij ENTER...');
    readln();
  until (n = 0);
end;

procedure zapiszDoPliku(pocz:plista_d);
var
  n:byte;
  t:textfile;
  s:string[40];
begin
  repeat
    ClrScr;
    writeln('----------------------------- ZAPISZ -----------------------------');
    if(pocz = nil) then
    begin
      writeln('Lista osob jest pusta!');
      writeln();
      writeln('Aby wrocic do MENU, wcisnij ENTER...');
      readln();
      exit;
    end;
    writeln('1) Zapisz wszystkie osoby');
    writeln('2) Zapisz osoby o wybranym nazwisku');
    writeln('3) Zapisz tylko osoby pelnoletnie');
    readln(n);
  until ((n > 0) and (n < 4));
  if(n = 2) then
  begin
    writeln();
    writeln('+ Podaj nazwisko');
    readln(s);
  end;
  assignfile(t,'osoby.txt');
  rewrite(t);
  while (pocz <> nil) do
  begin
    if ((n = 1) or ((n = 2) and (pocz^.nazwisko = s)) or ((n = 3) and (pocz^.wiek >= 18))) then writeln(t,'Nazwisko: ',pocz^.nazwisko,', Imie: ',pocz^.imie,', Wiek: ',pocz^.wiek,', PESEL: ',pocz^.PESEL);
    pocz:=pocz^.nast;
  end;
  closefile(t);
  writeln();
  writeln('Zapisano!');
  writeln();
  writeln('Aby wrocic do MENU, wcisniej ENTER...');
  readln();
end;

procedure odczytPliku();
var
  t:textfile;
  s:string;
begin
  ClrScr;
  writeln('----------------------------- WYPISZ -----------------------------');
  if(not fileExists('osoby.txt')) then
  begin
    writeln('Plik nie istnieje!');
    writeln();
    writeln('Aby wrocic do MENU, wcisniej ENTER...');
    readln();
    exit;
  end;
  writeln();
  assignfile(t,'osoby.txt');
  reset(t);
  while (not eof(t)) do
  begin
    readln(t,s);
    writeln(s);
  end;
  closefile(t);
  writeln();
  writeln('Aby wrocic do MENU, wcisniej ENTER...');
  readln();
end;

var
  pocz:plista_d;
  n:byte;
begin
  pocz:=nil;
  repeat
    ClrScr;
    writeln('------------------------------ MENU ------------------------------');
    writeln('1) Dodaj nowa osobe bez sprawdzania');
    writeln('2) Dodaj nowa osobe ze sprawdzaniem czy dana osoba juz istnieje');
    writeln('3) Usun jedna osobe o podanym nazwisku');
    writeln('4) Usun wszystkie osoby o podanym nazwisku');
    writeln('5) Edytuj dana osobe');
    writeln('6) Wypisz liste osob');
    writeln('7) Zapisz do pliku');
    writeln('8) Wypisz zawartosc pliku');
    writeln();
    writeln('0) Wyjscie');
    readln(n);
    case n of
    1:dodajOsobe(pocz, false); //false - bez sprawdzania
    2:dodajOsobe(pocz, true); //true - ze sprawdzaniem
    3:usunPoNazwisku(pocz, false); //false - tylko pierwsza osobe
    4:usunPoNazwisku(pocz, true); //true - wszystkie osoby
    5:edytujOsobe(pocz);
    6:wypiszOsoby(pocz);
    7:zapiszDoPliku(pocz);
    8:odczytPliku();
    end;
  until (n = 0);
  usunWszystko(pocz);
end.

