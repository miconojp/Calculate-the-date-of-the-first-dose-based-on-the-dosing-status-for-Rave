options fullstimer=1;

/************************************************/
/* 　投与状況のデータセットから初回投与日を算出する　　　　*/
/************************************************/

*実行環境ROOT　※適宜変更してください;
%let RT_PATH=C:\Users\micono\Desktop;

*データの場所　※適宜変更してください;
%let Raw	= &RT_PATH.\1 ;
%let OUT	= &RT_PATH.\1 ;

*ライブラリ登録;
libname RAW " &Raw." access = readonly;
libname OUT " &OUT.";

*日付変換マクロ;
%macro DATECONV(VAR=);
	&VAR.=datepart(&VAR.);
	format &VAR. yymmdd10.;
%mend;

*データセットをソートする;
proc sort data=raw.EX(where=(S_EXDOSE>0)) out=EX;
	by SUBJECT;
run;

*初回投与日を算出;
proc means data=EX noprint;
	var	S_EXSTDTC;
	by	SUBJECT ;
	output	out=EX_ST(drop=_type_ _freq_)
			min=RFSTDTC;
;
run;
*初回投与日のフォーマットを修正;
data EX_ST2;
	set EX_ST;
	%DATECONV(VAR=RFSTDTC)
run;


*データをCSVにエクスポート　※適宜変更してください;
PROC EXPORT DATA= work.EX_ST2
OUTFILE= "&OUT.\1.csv"
DBMS=CSV REPLACE ; PUTNAMES=YES;
RUN;
