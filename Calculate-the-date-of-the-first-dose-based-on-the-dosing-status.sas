options fullstimer=1;

/************************************************/
/* �@���^�󋵂̃f�[�^�Z�b�g���珉�񓊗^�����Z�o����@�@�@�@*/
/************************************************/

*���s��ROOT�@���K�X�ύX���Ă�������;
%let RT_PATH=C:\Users\micono\Desktop;

*�f�[�^�̏ꏊ�@���K�X�ύX���Ă�������;
%let Raw	= &RT_PATH.\1 ;
%let OUT	= &RT_PATH.\1 ;

*���C�u�����o�^;
libname RAW " &Raw." access = readonly;
libname OUT " &OUT.";

*���t�ϊ��}�N��;
%macro DATECONV(VAR=);
	&VAR.=datepart(&VAR.);
	format &VAR. yymmdd10.;
%mend;

*�f�[�^�Z�b�g���\�[�g����;
proc sort data=raw.EX(where=(S_EXDOSE>0)) out=EX;
	by SUBJECT;
run;

*���񓊗^�����Z�o;
proc means data=EX noprint;
	var	S_EXSTDTC;
	by	SUBJECT ;
	output	out=EX_ST(drop=_type_ _freq_)
			min=RFSTDTC;
;
run;
*���񓊗^���̃t�H�[�}�b�g���C��;
data EX_ST2;
	set EX_ST;
	%DATECONV(VAR=RFSTDTC)
run;


*�f�[�^��CSV�ɃG�N�X�|�[�g�@���K�X�ύX���Ă�������;
PROC EXPORT DATA= work.EX_ST2
OUTFILE= "&OUT.\1.csv"
DBMS=CSV REPLACE ; PUTNAMES=YES;
RUN;
