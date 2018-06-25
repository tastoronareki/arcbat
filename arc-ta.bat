@ECHO OFF
REM --------------------------------------------------------------------
REM ��� �ਯ� ������ ���� DataDriven.
REM
REM * ࠡ�⠥� ⮫쪮 � 䠩���� ������묨 ��᫥ 31.05.2016
REM   ��ࠬ��� -ta
REM
REM �।����������:
REM 1. ����稥 ���७��� ��ࠡ�⪨ ������ DOS
REM 2. ����� RAR 3.62 (��� ��ࠬ��� -idc ������ ���� 3.42)
REM ��६����:
REM A - ������ ��� ��ୠ�� ࠡ��� �ਯ�
REM B - ������ ��� �������� ��⠫��� ��娢�樨
REM C - �᫮ ᮧ������, ��᫥ �맮�� :ROTATE, ��娢��
REM      ��⠭���������� 0 :ROTATE, +1 :ARC
REM D - ������ ��� ⥪�饣� �����⠫��� � ��樨
REM E - ��� ��᫥���� �訡�� = �����頥��� �ணࠬ��� ���祭��
REM F - 0 - ����� ��娢; 1 - �����
REM I - ����� ⥪�饣� �����⠫��� � ��樨
REM J - ����� ⥪�饩 ��娢�樨
REM L - ������ ��� ᯨ᪠ ��娢�樨
REM M - �᫮ �����⠫���� � ��樨
REM N - ����. �᫮ ��娢�権 � �����⠫���
REM P - ��� 䠩�� �ਯ�, �.�. �⮩ �ணࠬ��
REM R - ������� �맮�� ��娢���
REM S - ������ ��� inc-䠩��
REM X - ������ ��� ᯨ᪠ �᪫�祭�� ��娢�樨
REM Z - ������ ��� 䠩�� ��������� ��娢�
REM --------------------------------------------------------------------
SETLOCAL ENABLEDELAYEDEXPANSION
CD D:\Archive\arc2016
D:
SET B=D:\Archive\arc2016
SET A=%B%\arc.log
SET E=0
SET M=3
SET N=30
SET P=%0
ECHO -- %P% start %DATE% >>                                          %A%
:
CALL :ROTATE comp1
IF %ERRORLEVEL% EQU 0 (
 CALL :ARC c1 "\\COMP1\share1"
 CALL :ARC c2 "\\COMP1\share2"
 CALL :POST
)
:
CALL :ROTATE srv
IF %ERRORLEVEL% EQU 0 (
 CALL :ARC s1 "\\SERVER1\share1"
 CALL :ARC s2 "\\SERVER1\share2"
 CALL :POST
)
:
ECHO %TIME% exit %E% >>                                              %A%
EXIT /B %E%
REM ====================================================================
:
:POST
REM --------------------------------------------------------------------
REM ����-��ࠡ�⪠; �뭥ᥭ� ��� ����� ��뢠�饣� ����
REM ���� � ��ୠ� �᫮ ��娢�� ᮧ������ ��� ������� �맮�� :ROTATE
REM --------------------------------------------------------------------
IF %C% GTR 0 (
 CALL :CREATE_INC
 ECHO + %C% >>                                                       %A%
) ELSE (
 ECHO - %C% >>                                                       %A%
)
GOTO :EOF
REM ====================================================================

:ROTATE
REM --------------------------------------------------------------------
REM ���� �����⠫���� � ��娢���; %M% �����⠫���� �� %N% _��娢�権_
REM �맮�: CALL :ROTATE <dir>
REM  ��� <dir> - �᭮�� ����� �����⠫���� � ��樨 � inc-䠩��
REM ��⠭��������:
REM  %C% = 0
REM  %D% - ������ ��� ⥪�饣� �����⠫��� ��� ����� ��娢��
REM  %S% - ������ ��� inc-䠩��
REM  ���祭�� %I% � %J% ��⠭�������� �� �� �����뢠�� � inc-䠩�
REM   ������ �믮������ ��᫥ ��娢�樨 �᫨ �뫨 ᮧ���� ��娢� �
REM   �� �뫮 ����᪨� �訡��
REM �����頥� �� 0 �᫨ �ந��諠 ����᪠� �訡��
REM 
REM �ਬ�砭��:
REM  1. �訡�� 㤠����� ��娢�� �� �����⠫��� �� ��⠥��� ����᪮�.
REM     ���⢥��⢥���, �����頥��� 0.
REM  2. � ��砥 �訡��, ����稪� �ࠧ� �����뢠���� � inc-䠩�.
REM     �.�. ���� 蠭� �� ������� �� ��३�� � ��㣮� �����,
REM     � ���ன �������� �訡�� �� ��������
REM --------------------------------------------------------------------
IF "%1" EQU "" (
 SET E=101
 EXIT /B %E%
)
SET C=0
SET D=
SET I=%M%
SET J=%N%
SET S=%B%\%1.inc.bat
IF NOT EXIST "%S%" CALL :CREATE_INC
CALL "%S%"
REM ᯮᮡ 㤠���� �஡��� ����� �ᥫ, �८�ࠧ����� ��ப� � �᫠:
SET /A I=%I%
SET /A J=%J%
IF %I% LSS 1 SET I=1
IF %J% LSS 1 SET J=1
SET /A J+=1
REM �᫨ ����� ��娢�権 ���௠� - �믮����� ����
IF %J% GTR %N% (
 SET J=1
 SET /A I+=1
 IF !I! GTR %M% SET I=1
)
SET D=%B%\%1_%I%
REM �᫨ ����� ��� - ᮧ����
IF NOT EXIST "%D%" (
 SET J=1
 MD "%D%"
 IF ERRORLEVEL 1 (
  SET E=%ERRORLEVEL%
  ECHO MD "%D%" ERROR %E% >>                                         %A%
  CALL :CREATE_INC
  EXIT /B %E%
 )
)
ECHO - %1 %I%:%J% >>                                                 %A%
REM �ॡ���� ��⪠ �����
IF %J% EQU 1 IF EXIST "%D%\*.rar" (
 DEL /F /Q "%D%\*.rar"
 IF ERRORLEVEL 1 (
  SET E=%ERRORLEVEL%
  ECHO DEL /F /Q "%D%\*.rar" ERROR %E% >>                            %A%
 )
)
IF %J% EQU 1 CALL :CREATE_INC
EXIT /B 0
REM ====================================================================
:
:CREATE_INC
REM --------------------------------------------------------------------
REM �����뢠�� ���祭�� ���稪�� � "inc-䠩�" ��� �� ��࠭���� �����
REM  �맮���� �ணࠬ��
REM
REM �ਬ�砭��:
REM  ���࠭񭭮� ⠪�� ��ࠧ�� �᫮ ��᫥ CALL <inc-䠩�>
REM  �������� ��ப�� � ���楢� �஡����. ������ ⠪:
REM   SET /A I=%I%
REM --------------------------------------------------------------------
ECHO @ECHO OFF >                                                     %S%
ECHO REM Do not edit! Maintained by script %P% >>                    %S%
ECHO SET I=%I% >>                                                    %S%
ECHO SET J=%J% >>                                                    %S%
GOTO :EOF
REM ====================================================================
:
:ARC
REM --------------------------------------------------------------------
REM �맮�: CALL :ARC <���> <�⥢��_�����>
REM ��� <���> �᭮�� ����� ��娢�� <���>_1.rar ��� �஡����
REM
REM 㢥��稢��� ����稪 ᮧ������ ��娢�� %C%
REM --------------------------------------------------------------------
NET USE | FIND /I "T:" > NUL
IF %ERRORLEVEL% EQU 0 NET USE T: /DELETE
NET USE T: %2 /PERSISTENT:NO
IF ERRORLEVEL 1 (
 SET E=%ERRORLEVEL%
 ECHO NET USE T: %2 ERROR %E% >>                                     %A%
 GOTO :EOF
)
CALL :ENV_INIT %D%\%1_ %2
%R% >                                                                %O%
IF ERRORLEVEL 2 (
 SET E=%ERRORLEVEL%
 ECHO %R% %D%\%1_ @%L% ERROR %E% >>                                  %A%
REM �� �訡��: ��� 䠩���
) ELSE IF ERRORLEVEL 1 (
 REM �᫨ ᮧ������� ����� ��娢, ���-⠪� �訡��, 䠩�� ������ ����
 IF %F% EQU 1 SET E=%ERRORLEVEL%
 FIND /I "��� 䠩���" < %O%
 REM �� �����-� ��㣮� �।�०����� - ������� ��� � ��ୠ�
 IF ERRORLEVEL 1 (
  TYPE %O% >>                                                        %A%
  SET E=1
 ) ELSE (
  ECHO  ��� 䠩��� >>                                                %A%
 )
REM ��娢 ᮧ��� - 㢥����� ����稪
) ELSE (
 SET /A C+=1
 ECHO +1
)
NET USE T: /DELETE
GOTO :EOF
REM ====================================================================
:
:ENV_INIT
REM --------------------------------------------------------------------
REM ���樠������ ��६����� � 䠩��� � ��ࠬ��ࠬ�
REM 
REM �맮�:
REM  CALL :ENV_INIT <base>
REM  ECHO archive comments >>                            %Z%
REM  ECHO mask_to_arc >>                                 %L%
REM  ECHO mask_to_exclude >>                             %X%
REM  %R% >                                               %O%
REM      mask_to_arc - ���� ��� ����祭�� � ��娢
REM      ����� ���� ��᪮�쪮 ��ப ECHO, ��� �� ���� �����
REM      <base> - ����� ���� � ���� ���� ����� 䠩�� ��娢�
REM               ���ਬ��, D:\Arc\srv1\obmen_ ��� 䠩���:
REM               D:\Arc\srv1\obmen_20150224.rar
REM               D:\Arc\srv1\obmen_20150225.rar
REM
REM  ��ࠬ���� RAR:
REM  ac          ����� ��ਡ�� "��娢��" ��᫥ ��娢�樨 ��� �����祭��
REM  ao          �������� 䠩�� � ��⠭������� ��ਡ�⮬ "��娢��"
REM  ag[�ଠ�]  �������� � ����� ��娢� ⥪�騥 ���� � �६�
REM  idp         �� �⮡ࠦ��� ��業�� �������� 室� �믮������ ࠡ���
REM  idq         ��⨢������ "�娩" ०��, �� ���஬ �� �࠭
REM  m2          ��⮤ ᦠ�� - ������ (1 - ᪮��⭮�)
REM  md          ������ ᫮���� � �� (4096 - ���ᨬ����)
REM  ms          ����७�� 䠩��� ��� ��娢�஢���� ��� ᦠ��
REM  tl          ��⠭�������� �६� ��娢� �� �६��� �����襣� 䠩��
REM  rr          �������� ���ଠ�� ��� ����⠭�������
REM  sv          ������� ������ᨬ� �����뢭� ⮬�
REM  v4G         ��������� ⮬� ࠧ��஬ 4Gb
REM  x@<ᯨ᮪>  �� ��ࠡ��뢠�� 䠩��/蠡����, 㪠����� � 䠩��-ᯨ᪥
REM  y           ��⮬���᪨ �⢥��� "��" �� �� ������
REM  z<䠩�>     ������ �������਩ ��娢� �� 䠩��
REM --------------------------------------------------------------------
SET F=1
SET L=%TEMP%\LIST.TMP
SET O=%TEMP%\RAROUT.TMP
SET X=%TEMP%\EXCL.TMP
SET Z=%TEMP%\DESC.TMP
DEL %L% > NUL
DEL %O% > NUL
DEL %X% > NUL
DEL %Z% > NUL
SET R=rar a -ac 
REM �᫨ �� ��ࢠ� ��娢��� � ������ �����⠫��� - ᮧ���� ����� ��娢
IF %J% NEQ 1 IF EXIST %1*.rar SET F=0
IF %F% EQU 0 (
 SET R=%R% -ao
 ECHO partial archive #%J% >                                         %Z%
 ECHO %TIME% %2 changes >>                                           %A%
) ELSE (
 ECHO full archive #%J% >                                            %Z%
 ECHO %TIME% %2 full >>                                              %A%
)
ECHO T:\ >                                                           %L%
ECHO *.gid >                                                         %X%
ECHO *\Thumbs.db >>                                                  %X%
ECHO ~*.tmp >>                                                       %X%
ECHO ~$*.doc >>                                                      %X%
SET R=%R% -agYYYYMMDDHHMMSS -idc -idp -ilog%B%\rarerr.log -m2 -ms[7z;avi;gif;jpeg;jpg;mp3;mp4;png;rar;wmv;vob;zip] -md4096 -r -rr -sv -ta20160531 -tl -v4G -x@%X% -y -z%Z% %1 @%L%
REM ====================================================================
REM 20160314 nvvpost@yandex.ru