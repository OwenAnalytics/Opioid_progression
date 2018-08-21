** Import MarketScan .csv files as WPD for creation of analysis datasets **;
** for Opioid Predictive Models                                          **;
** N. Ridenour 4.25.18                                                   **;

libname op wpd      '/data/mscan/opioid';
libname library wpd '/home/u0112740/opioid/library';

%let hedis_yr = 2017;

proc format;
  value bi 0  = '0'
           .  = 'MD'
        other = '1';
  value ten_pct  0-.10499 = '0-10%'
                .105-.20499 = '11-20%'
				.205-.30499 = '21-30%'
				.305-.40499 = '31-40%'
				.405-.50499 = '41-50%'
				.505-.60499 = '51-60%'
				.605-.70499 = '61-70%'
				.705-.80499 = '71-80%'
				.805-.90499 = '81-90%'
				.905-1.0499 = '91-100%'
				1.05-999 = '>100%';
  value days 1-3  = '1-3'
             4-7  = '4-7'
			 8-13 = '8-13'
			 14-300 = '14+';
  value vol 1-5 		 = '1-5'
            6-10 		 = '6-10'
            11-20 		 = '1-20'
			21-30 		 = '21-30'
			31-40 		 = '31-40'
			41-50 		 = '41-50'
			51-60 		 = '51-60'
			61-70 		 = '61-70'
			71-80 		 = '71-80'
			81-90 		 = '81-90'
			91-100 		 = '91-100'
			101-200      = '101-200'
            201-140000   = '201+';
  value ratio 0-0.05499     = '0-5%'
              0.055-0.09499 = '6-9%'
			  0.095-0.19499 = '10-19%'
			  0.195-0.29499 = '20-29%'
			  0.295-0.39499 = '30-39%'
			  0.395-0.49499 = '40-49%'
			  0.495-1       = '50-100%';
  value mpr_fmt 0-1.249 = '0-125%'
                1.25-60 = '>125%';
run;

*** Value Sets ***;
** ICD9 **;
* SUD - non-opioid *;
%let sud9 = ('2910' ,'2911' ,'2912', '2913' ,'2914' ,'2915' ,'29181','29182','29189','2919', '30300','30301','30302','30390',
			 '30391','30392','30410','30411','30412','30420','30421','30422','30430','30431','30432','30440','30441','30442',
			 '30450','30451','30452','30460','30461','30462','30480','30481','30482','30490','30491','30492','30500','30501',
			 '30502','30520','30521','30522','30530','30531','30532','30540','30541','30542','30550','30551','30552','30560',
			 '30561','30562','30570','30571','30572','30580','30581','30582','30590','30591','30592','53530','53531','5711');

* OUD *;
%let oud9 = ('30400','30401','30402','30470','30471','30472','30550','30551','30552');

* OUD-remission *;
%let oudr9 = ('30403','30473');

* Adverse affects *;
%let adv9 = ('E9352');

* Overdose *;
%let od9 = ('96500','96501','96509','E8500','E8501','E8502','E9500','E9620','E9800');

* Neonatal Abstinence Syndrome *;
%let nas9 = ('7795');
%let nas_mom9 = ('76072');

** ICD10 **;
* SUD - non-opioiod *;
%let sud10 = 
('F1010' ,'F10120','F10121','F10129','F1014' ,'F10150','F10151','F10159','F10180','F10181','F10182','F10188','F1019' ,
 'F1020' ,'F10220','10221' ,'F10229','F10230','F10231','F10232','F10239','F1024' ,'F10250','F10251','F10259','F1026' ,
 'F1027' ,'F10280','F10281','F10282','F10288','F1029' ,'F1120' ,'F1210' ,'F12120','F12121','F12122','F12129','F12150',
 'F12151','F12159','F12180','F12188','F1219' ,'F1220' ,'F12220','F12221','F12222','F12229','F12250','F12251','F12259',
 'F12280','F12288','F1229' ,'F1310' ,'F13120','F13121','F13129','F1314' ,'F13150','F13151','F13159','F13180','F13181',
 'F13182','F13188','F1319' ,'F1320' ,'F13220','F13221','F13229','F13230','F13231','F13232','F13239','F1324' ,'F13250',
 'F13251','F13259','F1326' ,'F1327' ,'F13280','F13281','F13282','F13288','F1329' ,'F1410' ,'F14120','F14121','F14122',
 'F14129','F1414' ,'F14150','F14151','F14159','F14180','F14181','F14182','F14188','F1419' ,'F1420' ,'F14220','F14221',
 'F14222','F14229','F1423' ,'F1424' ,'F14250','F14251','F14259','F14280','F14281','F14282','F14288','F1429' ,'F1510' ,
 'F15120','F15121','F15122','F15129','F1514' ,'F15150','F15151','F15159','F15180','F15181','F15182','F15188','F1519' ,
 'F1520' ,'F15220','F15221','F15222','F15229','F1523' ,'F1524' ,'F15250','F15251','F15259','F15280','F15281','F15282',
 'F15288','F1529' ,'F1610' ,'F16120','F16121','F16122','F16129','F1614' ,'F16150','F16151','F16159','F16180','F16183',
 'F16188','F1619' ,'F1620' ,'F16220','F16221','F16229','F1624' ,'F16250','F16251','F16259','F16280','F16283','F16288',
 'F1629' ,'F1810' ,'F18120','F18121','F18129','F1814' ,'F18150','F18151','F18159','F1817' ,'F18180','F18188','F1819' ,
 'F1820' ,'F18220','F18221','F18229','F1824' ,'F18250','F18251','F18259','F1827' ,'F18280','F18288','F1829' ,'F1910' ,
 'F19120','F19121','F19122','F19129','F1914' ,'F19150','F19151','F19159','F1916' ,'F1917' ,'F19180','F19181','F19182',
 'F19188','F1919' ,'F1920' ,'F19220','F19221','F19222','F19229','F19230','F19231','F19232','F19239','F1924' ,'F19250',
 'F19251','F19259','F1926' ,'F1927' ,'F19280','F19281','F19282','F19288','F1929');

* OUD *;
%let oud10 = 
('F1120' ,'F11220','F11221','F11222','F11229','F1123','F1124' ,'F11250','F11251','F11259','F11281','F11282','F11288',
 'F1129' ,'F1110' ,'F11120','F11121','F11122','F11129','F1114','F11150','F11151','F11159','F11181','F11182','F11188',
 'F1119' ,'F1190' ,'F11920','F11929','F11921','F11922','F1193','F1194' ,'F11950','F11951','F11959','F11981','F11982',
 'F11988','F1199' );

* Overdose *;
%let od10 = ('T400X1A','T400X1D','T400X1S','T400X2A','T400X2D','T400X2S','T400X3A','T400X3D','T400X3S','T400X4A','T400X4D',
			 'T400X4S','T401X1A','T401X1D','T401X1S','T401X2A','T401X2D','T401X2S','T401X3A','T401X3D','T401X3S','T401X4A',
			 'T401X4D','T401X4S','T402X1A','T402X1D','T402X1S','T402X2A','T402X2D','T402X2S','T402X3A','T402X3D','T402X3S',
			 'T402X4A','T402X4D','T402X4S');

* Remission *;
%let oudr10 = ('F1121');

* Adverse Effects *;
%let adv10 = ('T400X5A','T400X5D','T400X5S','T402X5A','T402X5D','T402X5S');

* Underdosing *;
%let ud10 = ('T400X6A','T400X6D','T400X6S','T402X6A','T402X6D','T402X6S');

* Neonatal Abstinence Syndrome *;
%let nas10 = ('P961','P962');
%let nas_mom10=('P0449');

** CPT/HCPCS **;
* Hospice *; 
%let excl_hospice_c = 
('99377','99378','G0182','G9473','G9474','G9475','G9476','G9477','G9478','G9479','Q5003','Q5004','Q5005',
 'Q5006','Q5007','Q5008','Q5010','S9126','T2042','T2043','T2044','T2045','T2046');

** Revenue **;
* Hospice *; 
%let excl_hospice_r = 
('0115','0125','0135','0145','0155','0235','0620','0651','0652','0655','0656','0657','0658','0659','0810',
 '0811','0812','0813','0814','0815','0817','0818','0891','081A','081B','081C','081D','081E','081F','081G',
 '081H','081I','081J','081K','081M','081O','081X','081Y','081Z','0820','0821','0822','0823','0824','0825',
 '0827','0828','0829','082A','082B','082C','082D','082E','082F','082G','082H','082I','082J','082K','082M',
 '082O','082X','082Y','082Z') ;

 ** Rx **;
 * Morphine *;
 %let morph = ('J2270','J2271','J2275','S0093','Q9974');

 * Treatment Rx *;
 %let trt_rx = ('J0571','J0592','J0570','J0572','J0573','J0574','J0575','J0592','J2310');

 * Treatment Px *;
 %let trt_px = ('HZ81ZZZ','HZ82ZZZ','HZ84ZZZ','HZ85ZZZ','HZ86ZZZ','HZ91ZZZ','HZ92ZZZ','HZ94ZZZ','HZ95ZZZ','HZ96ZZZ');

 ** DxCats **;
 * Cancer: malignant neoplasms *;
 %let ca_dxcat = ('CVS81','DEN05','DEN06','DEN07','DEN08','END14','END15','END81','ENT13','ENT14','ENT15','ENT16','ENT17','EYE25','EYE26','EYE81','GIS27',
   				  'GIS28','GIS29','GIS30','GIS83','GUS05','GUS06','GUS81','GYN19','GYN20','GYN21','GYN22','GYN23','GYN24','GYN25','GYN81','HEM13','HEM14',
				  'HEM15','HEM16','HEM17','HEM18','HEM19','HEM20','HEM21','HEM22','HEM23','HEM24','HEM25','HEM26','HEM27','HEM28','HEM29','HEM30','HEM31',
				  'HEM32','HEM33','HEM34','HEM35','HEM37','HEM82','HEM83','HEM84','HEP11','HEP82','MGS04','MGS05','MGS06','MGS07','MUS33','OTH90','OTH91',
				  'RES13','RES82','SKN06','SKN07','SKN08','SKN81');

%let mh_dxc = ('PSY01','PSY02','PSY03','PSY04','PSY13','PSY14','PSY15','PSY16','PSY80','PSY81','PSY82','PSY83');


%macro mcd(yr,ver);
  * Eligibility *;
  data op.medicaid_a_&yr._&ver;
    infile "/data/mscan/medicaid_a_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 33000;
    format mcasenum $16. boe $30.;
    input SEQNUM ENROLID MCASENUM $ DOBYR VERSION $ YEAR MEMDAYS STDRACE $ SEX $ ENRMON 
      ENRIND1 ENRIND2 ENRIND3 ENRIND4 ENRIND5 ENRIND6 ENRIND7 ENRIND8 ENRIND9 ENRIND10 ENRIND11 ENRIND12
      MEMDAY1 MEMDAY2 MEMDAY3 MEMDAY4 MEMDAY5 MEMDAY6 MEMDAY7 MEMDAY8 MEMDAY9 MEMDAY10 MEMDAY11 MEMDAY12
      PLNTYP1 PLNTYP2 PLNTYP3 PLNTYP4 PLNTYP5 PLNTYP6 PLNTYP7 PLNTYP8 PLNTYP9 PLNTYP10 PLNTYP11 PLNTYP12
      BOE $ CAP $ DRUGCOVG $ MAS $ MEDICARE $ MHSACOVG $;  
  run;
  * Pharmacy *;
  data op.medicaid_d_&yr._&ver;
    infile "/data/mscan/medicaid_d_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 33000;
    informat 'SVCDATE'n 'PDDATE'n MMDDYY10.;
    format mcasenum $16. boe pharm_id $30. 'SVCDATE'n 'PDDATE'n MMDDYY10.;
    input SEQNUM ENROLID MCASENUM $ DOBYR DRUGCOVG $ MHSACOVG $ PLANTYP BOE $ CAP MAS MEDICARE VERSION $
      YEAR AWP COB COINS COPAY DEDUCT DAWIND DISPFEE INGCOST QTY REFILL SVCDATE DAYSUPP GENERID METQTY
      NDCNUM NETPAY PAY PDDATE THERCLS STDRACE DEACLAS MAINTIN SEX THERGRP GENIND PHARM_ID;
   run;   
   %if &yr = 2015 %then %do;
     data op.medicaid_i_&yr._&ver;
       infile  "/data/mscan/medicaid_i_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 33000;
       informat 'DISDATE'n 'ADMDATE'n 'PDDATE'n MMDDYY10.;
       format mcasenum $16. boe $30. 'DISDATE'n 'ADMDATE'n 'PDDATE'n MMDDYY10.;
       input SEQNUM ENROLID MCASENUM $ DOBYR DRUGCOVG $ MHSACOVG $ PLANTYP BOE $ CAP $ MAS $ MEDICARE $ VERSION $ YEAR DISDATE
         TOTCOB TOTCOINS TOTCOPAY TOTDED ADMDATE CASEID DAYS DRG HOSPNET HOSPPAY PDDATE DXVER PDX $ PHYSNET PHYSPAY PPROC $ 
         TOTNET TOTPAY STDRACE ADMTYP $ MDC $ SEX DSTATUS $ DX1 $ DX2 $ DX3 $ DX4 $ DX5 $ DX6 $ DX7 $ DX8 $ DX9 $ DX10 $ DX11 $ 
         DX12 $ DX13 $ DX14 $ DX15 $ PROC1 $ PROC2 $ PROC3 $ PROC4 $ PROC5 $ PROC6 $ PROC7 $ PROC8 $ PROC9 $ PROC10 $ 
         PROC11 $ PROC12 $ PROC13 $ PROC14 $ PROC15 $ HOSP_ID $ PHYS_ID $;
    %end;
    %else %if &yr = 2016 %then %do;
     data op.medicaid_i_&yr._&ver;
       infile  "/data/mscan/medicaid_i_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 33000;
       informat 'DISDATE'n 'ADMDATE'n 'PDDATE'n MMDDYY10.;
       format mcasenum $16. boe $30. 'DISDATE'n 'ADMDATE'n 'PDDATE'n MMDDYY10.;
       input SEQNUM ENROLID MCASENUM $ DOBYR DRUGCOVG $ MHSACOVG $ PLANTYP BOE $ CAP $ MAS $ MEDICARE $ VERSION $ YEAR DISDATE
         TOTCOB TOTCOINS TOTCOPAY TOTDED ADMDATE CASEID DAYS DRG HOSPNET HOSPPAY PDDATE DXVER PDX $ PHYSNET PHYSPAY PPROC $
         TOTNET TOTPAY STDRACE ADMTYP $ MDC $ SEX DSTATUS $ DX1 $ DX2 $ DX3 $ DX4 $ DX5 $ DX6 $ DX7 $ DX8 $ DX9 $ DX10 $ DX11 $
         DX12 $ DX13 $ DX14 $ DX15 $ PROC1 $ PROC2 $ PROC3 $ PROC4 $ PROC5 $ PROC6 $ PROC7 $ PROC8 $ PROC9 $ PROC10  $
	     PROC11 $ PROC12 $ PROC13 $ PROC14 $ PROC15 $ HOSP_ID $ PHYS_ID $;
    %end;    
    %else %do;	  
	  data op.medicaid_i_&yr._&ver;
        infile  "/data/mscan/medicaid_i_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 33000;
        informat 'DISDATE'n 'ADMDATE'n 'PDDATE'n MMDDYY10.;
        format mcasenum $16. boe $30. 'DISDATE'n 'ADMDATE'n 'PDDATE'n MMDDYY10.;
        input SEQNUM ENROLID MCASENUM $ DOBYR DRUGCOVG $ MHSACOVG $ PLANTYP BOE $ CAP $ MAS $ MEDICARE $ VERSION $ YEAR DISDATE
          TOTCOB TOTCOINS TOTCOPAY TOTDED ADMDATE CASEID DAYS DRG HOSPNET HOSPPAY PDDATE PDX $ PHYSNET PHYSPAY PPROC $
          TOTNET TOTPAY STDRACE ADMTYP $ MDC $ SEX DSTATUS $ DX1 $ DX2 $ DX3 $ DX4 $ DX5 $ DX6 $ DX7 $ DX8 $ DX9 $ DX10 $ DX11 $
          DX12 $ DX13 $ DX14 $ DX15 $ PROC1 $ PROC2 $ PROC3 $ PROC4 $ PROC5 $ PROC6 $ PROC7 $ PROC8 $ PROC9 $ PROC10  $
	      PROC11 $ PROC12 $ PROC13 $ PROC14 $ PROC15 $ HOSP_ID $ PHYS_ID $;
	  run;
	%end; 
	%if &yr = 2013 or &yr = 2014 %then %do;
	  data op.medicaid_o_&yr._&ver;
          infile  "/data/mscan/medicaid_o_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 33000;
          informat 'SVCDATE'n 'PDDATE'n 'TSVCDAT'n MMDDYY10.;
          format mcasenum $16. boe $30. 'SVCDATE'n 'PDDATE'n 'TSVCDAT'n MMDDYY10.;
          input SEQNUM ENROLID MCASENUM $ DOBYR DRUGCOVG $ MHSACOVG $ PLANTYP BOE $ CAP $ MAS $ MEDICARE $ VERSION $ 
          YEAR COB COINS COPAY DEDUCT NETPAY PAY FACHDID FACPROF $ REVCODE $ DX1 $ DX2 $ PROC1 $ PROCTYP $ SEX SVCDATE
          DX3 $ DX4 $ PDDATE PROCGRP QTY SVCSCAT $ TSVCDAT STDRACE MDC $ STDPLAC STDPROV DENTAL $ STDSVC PROV_ID $;
	    run;
	 %end;
	 %else %do;
	   data op.medicaid_o_&yr._&ver;
          infile  "/data/mscan/medicaid_o_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 33000;
          informat 'SVCDATE'n 'PDDATE'n 'TSVCDAT'n MMDDYY10.;
          format mcasenum $16. boe $30. 'SVCDATE'n 'PDDATE'n 'TSVCDAT'n MMDDYY10.;
          input SEQNUM ENROLID MCASENUM $ DOBYR DRUGCOVG $ MHSACOVG $ PLANTYP BOE $ CAP $ MAS $ MEDICARE $ VERSION $ 
          YEAR COB COINS COPAY DEDUCT NETPAY PAY FACHDID FACPROF $ REVCODE $ DX1 $ DX2 $ DXVER $ PROC1 $ PROCTYP $ SEX SVCDATE
          DX3 $ DX4 $ PDDATE PROCGRP QTY SVCSCAT $ TSVCDAT STDRACE MDC $ STDPLAC STDPROV DENTAL $ PROV_ID $ MSCLMID NPI $ UNITS;
	    run;
	 %end;
	 
	 %if &yr = 2013 or &yr = 2014 %then %do;
	  data op.medicaid_s_&yr._&ver;
          infile  "/data/mscan/medicaid_s_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 32760;
          informat 'SVCDATE'n 'PDDATE'n 'TSVCDAT'n 'ADMDATE'n 'DISDATE'n MMDDYY10.;
          format mcasenum $16. boe $30. 'SVCDATE'n 'PDDATE'n 'TSVCDAT'n 'ADMDATE'n 'DISDATE'n MMDDYY10.;
          input SEQNUM DISDATE CASEID DRG PDX $ PPROC $ ADMTYP MDC $ ENROLID MCASENUM $ DOBYR DRUGCOVG $ MHSACOVG $
	            PLANTYP BOE $ CAP MAS MEDICARE VERSION YEAR COB COINS COPAY DEDUCT NETPAY PAY FACHDID FACPROF $
				REVCODE $ DX1 $ DX2 $ PROC1 $ PROCTYP $ SEX $ DX3 $ DX4 $ PDDATE QTY SVCSCAT $ SVCDATE TSVCDAT STDRACE
				ADMDATE DSTATUS STDPLAC STDPROV STDSVC PROV_ID $;
      run;
      %end;
	  %else %do;
	   data op.medicaid_s_&yr._&ver;
          infile  "/data/mscan/medicaid_s_&yr._&ver..csv" dlm = ',' missover dsd firstobs = 2 lrecl = 32760;
          informat 'SVCDATE'n 'PDDATE'n 'TSVCDAT'n 'DISDATE'n 'ADMDATE'n MMDDYY10.;
          format mcasenum $16. boe $30. 'SVCDATE'n 'PDDATE'n 'TSVCDAT'n 'DISDATE'n 'ADMDATE'n MMDDYY10.;
		  input SEQNUM DISDATE CASEID DRG PDX $ PPROC $ ADMTYP MDC $ ENROLID MCASENUM $ DOBYR DRUGCOVG $ MHSACOVG $
				PLANTYP BOE $ CAP MAS MEDICARE VERSION YEAR COB COINS COPAY DEDUCT NETPAY PAY FACHDID FACPROF $
				REVCODE $ DX1 $ DX2 $ DXVER $ PROC1 $ PROCTYP $ SEX $ DX3 $ DX4 $ PDDATE QTY SVCSCAT $ SVCDATE
				TSVCDAT STDRACE ADMDATE DSTATUS STDPLAC STDPROV PROV_ID $ MSCLMID NPI $ UNITS;
        run;
      %end;
	 
	    /*proc import datafile = '/data/mscan/medicaid_s_2015_v2.csv' out = op.medicaid_s_2015_v2 dbms = CSV; run;*/	    
%mend mcd;
*%mcd(2013,v4);
*%mcd(2014,v2);
*%mcd(2015,v2);
*%mcd(2016,v1);
 
* Value Sets from file *;
* Cancer, Mental Health dx, Rx *;
data library.opioid_vs_&hedis_yr;
  infile "/home/u0112740/opioid/data/opioid_value_sets_2017.csv" dlm = ',' missover dsd firstobs = 2;
  length msre_name $50 type_of_code short_name $20;
  input msre_name $ type_of_code $ Code $ short_name $;
  if type_of_code = 'generid' then fmtname = trim(short_name) || '_' || type_of_code;
    else                           fmtname = '$' || trim(short_name) || '_' || type_of_code;
  label = trim(short_name) || '_' || type_of_code;
  dx = code;
run;
proc freq data=library.opioid_vs_&hedis_yr; tables fmtname / missprint; run;
proc sort data=library.opioid_vs_&hedis_yr out = dx nodupkey; by fmtname dx; run;
proc format library=library cntlin=dx(where = (start ne '') rename=(dx=start)); run;
proc sort data=library.opioid_vs_&hedis_yr (where = (type_of_code = 'generid')) out = rx nodupkey; by fmtname code; run;
proc format library=library cntlin=rx(where = (start ne '') rename=(code=start)); run;

* Create eligibility files *;
* Restrict to at least 11 months of enrollment per year and age at MPSD of CY14 of 12 yrs old *;
data op.elig13_16_1;
  merge op.medicaid_a_2013_v4 (keep = client enrolid enrmon rename = (enrmon = enrmon13))
		op.medicaid_a_2014_v2 (keep = client enrolid enrmon age rename = (enrmon = enrmon14))
		op.medicaid_a_2015_v2 (keep = client enrolid enrmon rename = (enrmon = enrmon15))
		op.medicaid_a_2016_v1 (keep = client enrolid enrmon recipzip sex stdrace msa recipcty recipgeoloc rural 
          rename = (enrmon = enrmon16));
  by client enrolid;
  if age >= 12 & enrmon13 >= 11 & enrmon14 >= 11 & enrmon15 >= 11 & enrmon16 >= 11;
run;
proc freq data=op.elig13_16_1;
  title 'Elig 2013-2016';
  tables age sex stdrace recipgeoloc rural enrmon13-enrmon16 / missprint; 
run;

* Create concatenated dataset for eligibility *;
%macro elig(yr,ver);
  proc sql;
    create table op.elig&yr as
    select b.* 
    from op.elig13_16_1 as a inner join op.medicaid_a_20&yr._&ver as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
%mend elig;
* adding first 6 months of 2017 *; 
%elig(17,v0);
%elig(16,v1);
%elig(15,v2);
%elig(14,v2);
%elig(13,v4);
* Combine all elig datasets *;
data op.elig13_16;
  set op.elig13
      op.elig14
	  op.elig15
	  op.elig16;
  by client enrolid year;
run;

* Macro to create opioid datasets for each year for all file types *;
%macro opioid(yr,ver);
  ** Drugs **;
  ** Limit to members in Elig dataset **;
  proc sql;
    create table op.rx&yr as
    select b.* 
    from op.elig13_16_1 as a inner join mdcd&yr..medicaid_d_20&yr._&ver as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  data op.rx&yr;
    set op.rx&yr (where = (daysupp > 0));
	* Initialize *;
	opioid         = 0;
    naloxone       = 0;
    buprenorphine  = 0;
    methadone      = 0;
    short_acting   = 0;
    long_acting    = 0;
    fentanyl       = 0;
    benzodiazepine = 0;
    naltrexone     = 0;
	antidepressant = 0;
	antipsychotic  = 0;
	op_lax         = 0; 
	nat_opioid     = 0;
	semi_opioid    = 0;
	syn_opioid     = 0;
	barbiturate    = 0;
	good_pot       = 0;
	bad_pot        = 0;
	muscle         = 0;
    gt7d           = 0;
    le7d           = 0;
	bup_meth_nalt  = 0;
    morphine       = 0;
	* Set drug flags *;
	if put(generid,antidep_generid.      ) = 'antidep_generid'       then antidepressant = 1;
	if put(generid,antipsy_generid.      ) = 'antipsy_generid'       then antipsychotic  = 1;
	if put(generid,benzo_generid.        ) = 'benzo_generid'         then benzodiazepine = 1;
	if put(generid,op_lax_generid.       ) = 'op_lax_generid'        then op_lax         = 1;
    if put(generid,nat_opioid_generid.   ) = 'nat_opioid_generid'    then nat_opioid     = 1;
	if put(generid,semi_opioid_generid.  ) = 'semi_opioid_generid'   then semi_opioid    = 1;
	if put(generid,syn_opioid_generid.   ) = 'syn_opioid_generid'    then syn_opioid     = 1;
	if nat_opioid | semi_opioid | syn_opioid                         then opioid         = 1;
	if put(generid,barb_generid.         ) = 'barb_generid'          then barbiturate    = 1;
	if put(generid,good_pot_generid.     ) = 'good_pot_generid'      then good_pot       = 1;
	if put(generid,bad_pot_generid.      ) = 'bad_pot_generid'       then bad_pot        = 1;
	if put(generid,nalox_generid.        ) = 'nalox_generid'         then naloxone       = 1;
    if put(generid,bupren_generid.       ) = 'bupren_generid'        then buprenorphine  = 1;
	if put(generid,meth_generid.         )    = 'meth_generid'       then methadone      = 1;
	if put(generid,long_acting_generid.  ) = 'long_acting_generid'   then long_acting    = 1;
	if opioid = 1 and long_acting = 0                                then short_acting   = 1;
	if put(generid,fent_generid.         ) = 'fent_generid'          then fentanyl       = 1;
	if put(generid,naltrex_generid.      ) = 'naltrex_generid'       then naltrexone     = 1;
	if put(generid,muscle_generid.       ) = 'muscle_generid'        then muscle         = 1;
	if put(generid,bup_meth_nalt_generid.) = 'bup_meth_nalt_generid' then bup_meth_nalt  = 1;
    if put(generid,morphine_generid.     ) = 'morphine_generid'      then morphine       = 1;
         if      daysupp > 7 then gt7d = 1;
    else if 1 <= daysupp <=7 then le7d = 1;
  run;
  proc freq data=op.rx&yr;
    title "Rx &yr";
	tables opioid naloxone buprenorphine methadone short_acting long_acting fentanyl benzodiazepine naltrexone antidepressant 
      antipsychotic op_lax nat_opioid syn_opioid semi_opioid muscle bup_meth_nalt morphine deaclas 
      opioid * gt7d 
      opioid * le7d / missprint;
  run;
  * Summarize by member *;
  * Assumes sorted by svcdate, so age will be age at last Rx *;
  data op.rx&yr._1 (keep = client enrolid age sex opioid1 naloxone1 buprenorphine1 methadone1 short_acting1 long_acting1
      fentanyl1 benzodiazepine1 naltrexone1 antidepressant1 antipsychotic1 op_lax1 nat_opioid1 syn_opioid1 semi_opioid1
      op_benz op_dep op_psy op_lax opioid_days muscle1 good_pot1 bad_pot1 op_lax_c  barbiturate1 muscle1 bup_meth_nalt1 morphine1 trinity);
    set op.rx&yr (where = (daysupp ne 0));
	by client enrolid;
	* set flags by member *;
	retain opioid1 naloxone1 buprenorphine1 methadone1 short_acting1 long_acting1 fentanyl1 benzodiazepine1 naltrexone1 
      antidepressant1 antipsychotic1 op_lax1 nat_opioid1 syn_opioid1 semi_opioid1 op_benz op_dep op_psy op_lax_c opioid_days 
      bad_pot1 good_pot1 barbiturate1 muscle1 bup_meht_nalt1 morphine1 trinity 0;
	if first.enrolid then do;
	  opioid1         = 0;
      naloxone1       = 0;
      buprenorphine1  = 0;
      methadone1      = 0;
      short_acting1   = 0;
      long_acting1    = 0;
      fentanyl1       = 0;
      benzodiazepine1 = 0;
      naltrexone1     = 0;
      antidepressant1 = 0;
      antipsychotic1  = 0;
      op_lax1         = 0; 
      nat_opioid1     = 0;
      syn_opioid1     = 0;
      semi_opioid1    = 0;
      op_benz		  = 0;
	  op_dep		  = 0;
	  op_psy		  = 0;
	  op_lax_c   	  = 0;
	  opioid_days     = 0;
	  bad_pot1        = 0;
	  barbiturate1    = 0;
	  good_pot1       = 0;
	  muscle1         = 0;
	  bup_meth_nalt1  = 0;
      morphine1       = 0;
	  trinity         = 0;
	end;
	* Count number of Rx per member *;
	if opioid         = 1 then do;
      opioid1         = 1;
	  opioid_days = opioid_days + daysupp;
	end;
    if naloxone       = 1 then naloxone1       = 1;
    if buprenorphine  = 1 then buprenorphine1  = 1;
    if methadone      = 1 then methadone1      = 1;
    if short_acting   = 1 then short_acting1   = 1;
    if long_acting    = 1 then long_acting1    = 1; 
    if fentanyl       = 1 then fentanyl1       = 1;
    if benzodiazepine = 1 then benzodiazepine1 = 1;
    if naltrexone     = 1 then naltrexone1     = 1;
    if antidepressant = 1 then antidepressant1 = 1;
    if antipsychotic  = 1 then antipsychotic1  = 1;
    if op_lax         = 1 then op_lax1         = 1;
    if nat_opioid     = 1 then nat_opioid1     = 1;
    if syn_opioid     = 1 then syn_opioid1     = 1;
    if semi_opioid    = 1 then semi_opioid1    = 1;
	if bad_pot        = 1 then bad_pot1        = 1;
	if good_pot       = 1 then good_pot1       = 1;
	if barbiturate    = 1 then barbiturate1    = 1;
	if muscle         = 1 then muscle1         = 1;
	if bup_meth_nalt  = 1 then bup_meth_nalt1  = 1;
    if morphine       = 1 then morphine1       = 1;
	if last.enrolid then do;
	  if opioid1 > 0 then do; 
        if benzodiazepine1 > 0 then do;
          op_benz  = 1;
		  if muscle1 > 0 then trinity = 1;
		end;
	    if antidepressant1 > 0 then op_dep   = 1;
		if antipsychotic1  > 0 then op_psy   = 1;
		if op_lax1         > 0 then op_lax_c = 1;
	  end;
	  output;
	end;
  run;

  proc freq data=op.rx&yr._1;
    tables nat_opioid1  * semi_opioid1 * syn_opioid1
	       long_acting1  * short_acting1
      age sex opioid1 naloxone1 buprenorphine1 methadone1 short_acting1 long_acting1 fentanyl1 benzodiazepine1 
	  naltrexone1 antidepressant1 antipsychotic1 op_lax1 nat_opioid1 syn_opioid1 semi_opioid1 op_benz op_dep op_psy 
      op_lax_c good_pot1 bad_pot1 barbiturate1 muscle1 bup_meth_nalt1 morphine1 trinity / missprint; 
  run;
  proc freq data=op.rx&yr._1; 
    where opioid1 > 0; 
	tables opioid_days age sex / missprint; 
  run;

  ** Medical **;
  * How many members? *;
  proc sort data=mdcd&yr..medicaid_s_20&yr._&ver out = ip&yr (keep = client enrolid) nodupkey; by client enrolid; run;
  proc sort data=mdcd&yr..medicaid_o_20&yr._&ver out = op&yr (keep = client enrolid) nodupkey; by client enrolid; run;

  ** Limit to members in Elig dataset **;
  * OP *;
  proc sql;
    create table op&yr as
    select b.* 
    from op.elig13_16_1 as a inner join mdcd&yr..medicaid_o_20&yr._&ver as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  * IP *;
  proc sql;
    create table ip&yr as
    select b.* 
    from op.elig13_16_1 as a inner join mdcd&yr..medicaid_s_20&yr._&ver as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  data op.med&yr (drop = i);
    set ip&yr (in=sin)
        op&yr;
	* Set IP_OP flag *;
    if sin then ip_op = 'IP'; else ip_op = 'OP';
	* Diagnosis Array *;
	array diag{4} $ dx1-dx4;
	* Initialize *;
	sud      = 0;
	oud      = 0;
	nas      = 0;
    nas_mom  = 0;
	mh       = 0;
	oudr     = 0;
	adv      = 0;
	treat    = 0;
    treat_rx = 0;
	cancer   = 0;
	hospice  = 0;
	od       = 0;
	morphine_px = 0;
	death    = 0;
	mal_neo  = 0;
	oth_neo  = 0;
	hx_neo   = 0;
	cancer_dxcat = 0;
	mh_dxcat = 0;
	pcp      = 0;
	ed       = 0;
	if dxver = '' then dxver = '9';
	* Set dx flags *;
	do i = 1 to 4;
	  * ICD 9 *;
	  if dxver = '9' then do;
	    if diag{i} in &sud9     then sud      = 1;
	    if diag{i} in &oud9     then oud      = 1;
	    if diag{i} in &nas9     then nas      = 1;
		if diag{i} in &nas_mom9 then nas_mom  = 1;
	    if put(diag{i},$MH_DX_ICD9CM.)        = 'MH_Dx_ICD9CM'        then mh      = 1;
	    if put(diag{i},$MAL_NEO_ICD9CM.)      = 'Mal_Neo_ICD9CM'      then mal_neo = 1;
        if put(diag{i},$OTH_NEO_ICD9CM.)      = 'Oth_Neo_ICD9CM'      then oth_neo = 1;
        if put(diag{i},$HX_MALIG_NEO_ICD9CM.) = 'Hx_Malig_Neo_ICD9CM' then hx_neo  = 1;
        if diag{i} in &oudr9 then oudr    = 1;
		if diag{i} in &adv9  then adv     = 1;
		if diag{i} in &od9   then od      = 1;
	  end;
	  * ICD 10 *;
	  else if dxver = '0' then do;
	    if diag{i} in &sud10     then sud      = 1;
	    if diag{i} in &oud10     then oud      = 1;
	    if diag{i} in &nas10     then nas      = 1;
		if diag{i} in &nas_mom10 then nas_mom  = 1;
	    if put(diag{i},$MH_DX_ICD10CM.)        = 'MH_Dx_ICD10CM'        then mh      = 1;
	    if put(diag{i},$MAL_NEO_ICD10CM.)      = 'Mal_Neo_ICD10CM'      then mal_neo = 1;
        if put(diag{i},$OTH_NEO_ICD10CM.)      = 'Oth_Neo_ICD10CM'      then oth_neo = 1;
        if put(diag{i},$HX_MALIG_NEO_ICD10CM.) = 'Hx_Malig_Neo_ICD10CM' then hx_neo  = 1;
		if diag{i} in &oudr10 then oudr    = 1;
		if diag{i} in &adv10  then adv     = 1;
		if diag{i} in &od10   then od      = 1;
	  end;
	end;
	if mal_neo | oth_neo | hx_neo then cancer = 1;
	if dxcat in &ca_dxcat then cancer_dxcat = 1;
	if dxcat in &mh_dxc then mh_dxcat = 1;
	* Hospice_Morphine *;
	if proctyp in ('1','7') then do;
           if proc1 in &excl_hospice_c then hospice  = 1;
	  else if proc1 in &morph          then morphine_px = 1;
	  else if proc1 in &trt_rx then    treat_rx      = 1;
	end;
	else do;
	  if proc1 in &trt_px then treat    = 1;
	end;
	if revcode in &excl_hospice_r then hospice = 1;
	else if put(revcode,$ED_UBREV.) = 'ED_UBREV' then ed      = 1;
    if stdprov in (200, 202, 204, 206, 240, 245, 400, 410, 825, 845) then pcp = 1; 
	if dstatus = '20' then death = 1;
  run;
  proc sort data=op.med&yr; by client enrolid svcdate; run;
  proc freq data=op.med&yr;
    title "Med &yr claims";
	tables mh_dxcat cancer_dxcat dxcat mdc sud oud oudr adv od morphine_px treat treat_rx nas mh cancer hospice death mal_neo oth_neo 
           hx_neo nas nas_mom pcp ed / missprint;
  run;

proc freq data=op.med&yr; tables ed_cpt ed_rev ed pcp / missprint; 
  * Summarize by member *;
  * Sorted by svcdate, so age will be age at last claim *;
  proc sort data=op.med&yr; by client enrolid svcdate; run;
  data op.med&yr._1 (keep = client enrolid age sex sud1 oud1 oudr1 adv1 od1 hospice1 morphine_px1 treat1 treat_rx1 death1 
      cancer1 mh1 nas1 nas_mom1 cancer_dxcat1 mh_dxcat1 dxcat_psy11 dxcat_tra82 mdc20 mdc21 mdc19 pcp1 ed1 ip1);
    set op.med&yr (keep = client enrolid age sex sud oud oudr adv od hospice morphine_px treat treat_rx death cancer mh nas 
      nas_mom cancer_dxcat mh_dxcat mdc dxcat pcp ed ip_op);
	by client enrolid;
	* set flags by member *;
	retain sud1 oud1 oudr1 adv1 od1 morphine_px1 treat1 treat_rx1 hospice1 death1 cancer1 mh1 nas1 nas_mom1 cancer_dxcat1 mh_dxcat1 dxcat_psy11 dxcat_tra82
      mdc20 mdc19 mdc21 pcp1 ed1 ip1 0;
	if first.enrolid then do;
	  sud1      = 0;
      oud1      = 0;
      oudr1     = 0;
      adv1      = 0;
      od1       = 0;
      hospice1  = 0;
	  morphine_px1 = 0;
	  treat1    = 0;
	  treat_rx1 = 0;
	  death1    = 0;
	  cancer1   = 0;
	  mh1       = 0;
	  nas1      = 0;
	  nas_mom1  = 0;
	  mh_dxcat1 = 0;
	  mdc20     = 0;
      mdc19     = 0;
      mdc21     = 0;
	  pcp1      = 0;
	  ed1       = 0;
	  ip1       = 0;
	  dxcat_psy11   = 0;
      dxcat_tra82   = 0;
	  cancer_dxcat1 = 0;
	end;
	* Set flag if any claims met criteria *;
	if sud      then sud1      = 1;
	if oud      then oud1      = 1;
	if oudr     then oudr1     = 1;
	if adv      then adv1      = 1;
	if od       then od1       = 1;
	if hospice  then hospice1  = 1;
	if morphine_px then morphine_px1 = 1;
	if treat    then treat1    = 1;
	if treat_rx then treat_rx1 = 1;
	if death    then death1    = 1;
	if cancer   then cancer1   = 1;
	if mh       then mh1       = 1;
	if nas      then nas1      = 1;
	if nas_mom  then nas_mom1  = 1;
	if mh_dxcat then mh_dxcat1 = 1;
	if mdc = '20'   then mdc20 = 1;
    if mdc = '19'   then mdc19 = 1;
    if mdc = '21'   then mdc21 = 1;
	if pcp = 1      then pcp1  = 1;
	if ed  = 1      then ed1   = 1;
	if ip_op = 'IP' then ip1   = 1;
	if dxcat = 'PSY11' then dxcat_psy11   = 1;
    if dxcat = 'TRA82' then dxcat_tra82   = 1;
	if cancer_dxcat    then cancer_dxcat1 = 1;
	if last.enrolid;
  run;

 proc freq data=op.med&yr._1;
    title "med person";
    tables age sex sud1 oud1 oudr1 adv1 od1 hospice1 morphine_px1 treat1 treat_rx1 death1 cancer1 mh1 nas1 nas_mom1
	       pcp1 ed1 ip1 
	       oud1  * cancer1
		   oud1  * mh1
           oud1  * sud1 
		   oud1  * oudr1 
		   oud1  * adv1 
		   oud1  * od1 
		   oud1  * morphine_px1
		   oud1  * treat1
		   oud1  * treat_rx1
		   oud1  * nas_mom1
		   oud1  * hospice1
		   oudr1 * treat1
		   oudr1 * treat_rx1
		   od1   * mh1
		   od1   * treat1
		   od1   * treat_rx1
		   od1   * morphine_px1
		   od1   * death1
		   od1   * nas_mom1
		   dxcat_psy11 
		   dxcat_tra82 
		   cancer_dxcat1
		   mh_dxcat1
		   mdc20
		   mdc19 
		   mdc21
           cancer_dxcat1 * cancer1 
           oud1 * dxcat_psy11
           od1  * dxcat_tra82 
           oud1 * mdc20
           od1  * mdc21
           mh_dxcat1 * mdc19
           mh1 * mdc19
           mh1 * mh_dxcat1 
           mh1 * mh_dxcat1 * mdc19 / missprint; 
  run;
  * Admissions - only place to get ub_surg px *;
  proc sort data=mdcd&yr..medicaid_i_20&yr._&ver out = adm&yr (keep = client enrolid) nodupkey; by client enrolid; run;
  proc sql;
    create table op.adm&yr as
    select b.* 
    from op.elig13_16_1 as a inner join mdcd&yr..medicaid_i_20&yr._&ver as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  data op.adm&yr (drop = i);
    set op.adm&yr;
	* Procedure Array *;
	array px{15} $ proc1-proc15;
	* Initialize *;
	treat  = 0;
	if dxver = '' then dxver = '9';
	* Set px flag *;
	do i = 1 to 15;
	  * ICD 10 *;
	  if dxver = '0' then do;
	    if px{i} in &trt_px  then treat = 1;
	  end;
	end;
  run;
  proc freq data=op.adm&yr;
    title "Admissions &yr";
	tables treat / missprint;
  run;*/
  * Summarize by member *;
  * Assumes sorted by svcdate, so age will be age at last claim *;
  proc sort data=op.adm&yr; by client enrolid; run;
  data op.adm&yr._1 (keep = client enrolid age sex treat1);
    set op.adm&yr (keep = client enrolid age sex treat);
	by client enrolid;
	* set flags by member *;
	retain treat1 0;
	if first.enrolid then do;
	  treat1    = 0;
	end;
	* Set flag if any claims met criteria *;
	if treat    then treat1    = 1;
	if last.enrolid;
  run;
 proc freq data=op.adm&yr._1;
    tables age sex treat1 / missprint; 
  run;

  * Combine rx, med, and adm at member level *;
  data op.rx_med&yr._1;
    merge op.rx&yr._1
	      op.med&yr._1 (drop = treat1)
          op.adm&yr._1;
	by client enrolid;
  run;
  proc freq data=op.rx_med&yr._1;
    title "Rx & Med 20&yr";
	format opioid1 bi.;
	tables opioid1 * cancer1
           opioid1 * mh1 
           opioid1 * sud1
	       opioid1 * oud1
		   opioid1 * oudr1
		   opioid1 * adv1
		   opioid1 * od1 
           opioid1 * morphine_px1 
		   opioid1 * treat1
		   opioid1 * treat_rx1
           opioid1 * nas_mom1 / missprint; 
  run;
%mend opioid;
%opioid(17,v0);
%opioid(16,v1);
%opioid(15,v2);
%opioid(14,v2);
%opioid(13,v4);

/* Combine all years *;
* Rx *;
proc sort data=op.rx13; by client enrolid svcdate; run;
proc sort data=op.rx14; by client enrolid svcdate; run;
proc sort data=op.rx15; by client enrolid svcdate; run;
proc sort data=op.rx16; by client enrolid svcdate; run;
data op.rx13_16;
  set op.rx13
      op.rx14
	  op.rx15
	  op.rx16;
  by client enrolid svcdate; 
run;
* Med *;
proc sort data=op.med13; by client enrolid svcdate; run;
proc sort data=op.med14; by client enrolid svcdate; run;
proc sort data=op.med15; by client enrolid svcdate; run;
proc sort data=op.med16; by client enrolid svcdate; run;
data op.med13_16;
  set op.med13
      op.med14
	  op.med15
	  op.med16;
  by client enrolid svcdate; 
run;
* Adm *;
proc sort data=op.adm13; by client enrolid admdate; run;
proc sort data=op.adm14; by client enrolid admdate; run;
proc sort data=op.adm15; by client enrolid admdate; run;
proc sort data=op.adm16; by client enrolid admdate; run;
data op.adm13_16;
  set op.adm13
      op.adm14
	  op.adm15
	  op.adm16;
  by client enrolid admdate; 
run;
proc contents data=op.elig13_16; run;
proc contents data=op.rx13_16  ; run;
proc contents data=op.med13_16 ; run;
proc contents data=op.adm13_16 ; run;
*/
** Export .csv files **;
%macro exp(dset);
  proc export data=op.&dset
    outfile = "/home/u0112740/opioid/data/&dset..csv"
    dbms = dlm replace;
    delimiter = ',';
    putnames = yes;
  run;
%mend exp;
* All years *;
%exp(elig13_16);
%exp(rx13_16  );
%exp(med13_16 );
%exp(adm13_16 );

* Just 2014 *;
%exp(elig14);
%exp(rx14  );
%exp(med14 );
%exp(adm14 );

%macro new (by,py);
  ** Find first opioid rx **;
  data rx&by._first (drop = gt7d le7d semi_opioid syn_opioid nat_opioid);
    set op.rx&by (keep = client enrolid generid svcdate opioid gt7d le7d semi_opioid syn_opioid nat_opioid);
    if opioid = 1;
	nat_gt7d = 0;
	syn_gt7d = 0;
	nat_le7d = 0;
	syn_le7d = 0;
	if gt7d then do;
	  if nat_opioid = 1 or semi_opioid = 1 then nat_gt7d = 1;
	  if syn_opioid = 1                    then syn_gt7d = 1;
	end;
	else if le7d = 1 then do;
	  if nat_opioid = 1 or semi_opioid = 1 then nat_le7d = 1;
	  if syn_opioid = 1                    then syn_le7d = 1;
	end;
  run;
  proc freq data=rx&by._first; tables nat_gt7d syn_gt7d nat_le7d syn_le7d / missprint; run;
  proc sort data=rx&by._first; by client enrolid svcdate; run;
  data rx&by._first;
    set rx&by._first (drop = opioid);
    by client enrolid svcdate;
    if first.enrolid;
  run;
  ** Check prior opioid rx dates **;
  data rx&py._last(keep = client enrolid svcdate);
    set op.rx&py (where = (opioid = 1));
  run;
  proc sort data=rx&py._last; by client enrolid svcdate; run;
  data rx&py._last;
    set rx&py._last;
    by client enrolid svcdate;
    if last.enrolid;
  run;
  proc sql;
    create table op.new_users&by as
    select a.*, b.svcdate as prior_rx
    from rx&by._first as a left join rx&py._last as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  data op.new_users&by;
    set op.new_users&by;
    lag = svcdate - prior_rx;
  run;
  proc print data=op.new_users&by (obs = 5); title "new users 20&by"; run;
  proc means data=op.new_users&by; title "opioid lags 20&by"; var lag; run; 
  
  * Use 6 month (>180 days) threshold *;
  data op.new_users6_&by (keep = client enrolid svcdate nat_gt7d syn_gt7d nat_le7d syn_le7d);
    set op.new_users&by (where = (lag = . or lag > 180));
  run; 

  ** Remove cancer & hospice - 6 month clean for Rx **;
  data op.new_users_ex&by;
    merge op.new_users6_&by (in=nin)
          op.med16_1 (in=xinp2 keep = client enrolid cancer1 hospice1 rename = (cancer1 = cancerp2 hospice1 = hospicep2))
          op.med15_1 (in=xinp1 keep = client enrolid cancer1 hospice1 rename = (cancer1 = cancerp1 hospice1 = hospicep1))
          op.med14_1 (in=xin0  keep = client enrolid cancer1 hospice1 rename = (cancer1 = cancer0  hospice1 = hospice0 ))
		  op.med13_1 (in=xin1  keep = client enrolid cancer1 hospice1);
    by client enrolid;
    if nin;
    if cancer1  = 1 or cancer0  = 1 or cancerp1  = 1 or cancerp2  = 1 then cancer  = 1; else cancer  = 0;
    if hospice1 = 1 or hospice0 = 1 or hospicep1 = 1 or hospicep2 = 1 then hospice = 1; else hospice = 0;
    if cancer or hospice then drp = 1; else drp = 0;
  run;
  proc print data=op.new_users_ex&by (obs = 10); where hospice1 = 1 and hospicep2 ne 1; run;

  * Remove exclusions *;
  data op.new_users_ex1_&by (keep = client enrolid first_op nat_gt7d syn_gt7d nat_le7d syn_le7d);
    set op.new_users_ex&by (where = (cancer = 0 & hospice = 0) rename = (svcdate = first_op));
  run;
  proc print data=op.new_users_ex1_&by (obs = 5); title "Exclusions Removed 20&by"; run;
  * check only 1 rx *;
  data only_one&by;
    set op.rx&py (keep = client enrolid opioid where = (opioid = 1)); 
	by client enrolid;
	retain count 0;
	if first.enrolid then count = 0;
	count + 1;
	if last.enrolid & count = 1;
  run;
  data only1_&by;
    merge op.new_users_ex1_&by (in=din)
	      only_one&by (in=oin);
	by client enrolid;
	if din & oin;
  run; 
%mend new;
%new(14,13);
%new(15,14);
%new(16,15);
%new(17,16);
%exp(new_users_ex1_14);

/* Checking in and out of hospice *;
data hospice;
   set op.med13 (where = (client = 19 & enrolid in (20038989120,20039151114) & hospice = 1));
run;
proc print data=hospice; title 'hospice starts then stops'; var client enrolid svcdate revcode proc1 hospice; run;
proc freq data=op.new_users_ex_14; title 'New users without exclusions'; tables cancer1 * cancerp2 hospice1 * hospicep2 cancer * hospice 
  cancer1 cancer0 cancerp1 cancerp2 hospice1 hospice0 hospicep1 hospicep2 drp / missprint; run;


** Check new users for high usage/dosage **;
data op.rx_hi (keep = client enrolid first_op op_days op_pdc);
  merge op.new_users_ex1_14 (in=nin)
        op.rx14 (keep = client enrolid svcdate daysupp opioid where = (opioid = 1));
  by client enrolid;
  if nin;
  retain op_days 0;
  if first.enrolid then op_days = 0;
  op_days + daysupp;
  format op_pdc 10.4;
  op_pdc = op_days / ('31DEC2014'd - first_op + 1);
  if last.enrolid;
run;
proc print data=op.rx_hi (obs = 5); title 'Opioid Usage BY'; run;
proc freq data=op.rx_hi; format op_pdc ten_pct.; tables op_days op_pdc / missprint; run;
proc means data=op.rx_hi; var op_pdc; run;

** Trends for population of interest - new users with exclusions removed **;
data op.trends (keep = client enrolid first_op oud0 oud1 oud2 oud3 od0 od1 od2 od3 death0 death1 death2 death3 opioid3);
  merge op.new_users_ex1_14 (in=din)
        op.med14_1 (keep = client enrolid oud1 od1 death1 rename = (oud1 = oud0 od1 = od0 death1 = death0))
		op.med15_1 (keep = client enrolid oud1 od1 death1)
		op.med16_1 (keep = client enrolid oud1 od1 death1 rename = (oud1 = oud2 od1 = od2 death1 = death2))
        op.med17_1 (keep = client enrolid oud1 od1 death1 rename = (oud1 = oud3 od1 = od3 death1 = death3))
        op.rx17_1  (keep = client enrolid opioid1 rename = (opioid1 = opioid3));
  by client enrolid;
  if din;
run;
proc freq data=op.trends; 
  title 'New User trends'; 
  tables oud0 od0 death0 oud1 od1 death1 oud2 od2 death2 oud3 od3 death3 opioid3 / missprint; 
run;

** Trends in still using Opioids **;
data op.rx_still(keep = client enrolid opioid1 first_op opioid2);
  merge op.new_users_ex1_14 (in=din)
        op.rx15_1 (keep = client enrolid opioid1                              where = (opioid1 = 1))
		op.rx16_1 (keep = client enrolid opioid1 rename = (opioid1 = opioid2) where = (opioid2 = 1));
  by client enrolid;
  if din;
run;
proc print data=op.rx_still (obs = 5); title 'Still using opioids'; run;
proc freq data=op.rx_still; tables opioid1 * opioid2 / missprint; run;

*/
*** WEI ***;
** Checking for Wei outcomes - do not know how addiction treatment is defined so just use Rx use **;
* Combine 14 and 16 *;
data wei (keep = client enrolid first_op class_1 nat_gt7d syn_gt7d nat_le7d syn_le7d);
  merge op.new_users_ex1_14 (in=nin keep = client enrolid first_op nat_gt7d syn_gt7d nat_le7d syn_le7d)
        op.rx16_1 (in=sin keep = client enrolid opioid1 where = (opioid1 = 1));
  by client enrolid;
  if nin;
  if sin then class_1 = 1; else class_1 = 0;
run;
* Combine 14/16 with 15 dates to check within 1 year *;
data wei;
  merge wei (in=din)
        op.rx15 (keep = client enrolid opioid svcdate where = (opioid = 1));
  by client enrolid;
  if din;
  lag = svcdate - first_op;
  if 1 <= lag <= 365 then class_2 = 1; else class_2 = 0;
  if      lag >  365 then class_1 = 1; 
run;
data op.wei (keep = client enrolid classN type_first_op);
  set wei;
  by client enrolid;
  retain class1 class2 0;
  if first.enrolid then do;
    class1 = 0;
	class2 = 0;
  end;
  * Summarize flags *;
  if class_1 = 1 then class1 = 1;
  if class_2 = 1 then class2 = 1;
  if last.enrolid then do;
    * If at least 1 long term Rx, then set class I as 1 *;
    if class1 = 1 then class2 = 0;
	if class1 = 0 and class2 = 0 then class2 = 1;
	     if class1 = 1 then classN = 1; 
    else if class2 = 1 then classN = 2;
	     if nat_le7d = 1 then type_first_op = 1;
    else if syn_le7d = 1 then type_first_op = 2;
    else if nat_gt7d = 1 then type_first_op = 3;
    else if syn_gt7d = 1 then type_first_op = 4;
    output;
  end;
run;

proc freq data=op.wei; tables type_first_op * classN / missprint; run;

* Logistic *;
proc logistic data=op.wei;
   * class is categorical vars *;
   * predict long-term use, so class = 1 *;
   class type_first_op;
   model classN = type_first_op 
     / selection = forward expb;
run;
%exp(wei);

/** Checking HCPCS in correlation with Rx - morphine **;
data morphine_px;
  set op.med14 (keep = client enrolid svcdate morphine_px rename = (svcdate = px_svcdate) where = (morphine_px = 1));
run;
data morphine_rx;
  set op.rx14 (keep = client enrolid svcdate opioid generid rename = (svcdate = rx_svcdate) where = (opioid = 1));
run;
proc sql;
  create table op.morphine as
  select a.*,b.rx_svcdate, b.generid
  from morphine_px as a left join morphine_rx as b
  on a.client = b.client & a.enrolid = b.enrolid;
quit;
data op.morphine (drop = morphine_px);
  set op.morphine;
  lag = rx_svcdate - px_svcdate;
run;
proc sort data=op.morphine nodupkey; by client enrolid px_svcdate rx_svcdate generid; run;

proc print data=op.morphine (obs = 50); title 'Morphine rx and px'; where rx_svcdate = .; run;

data op.morphine1 (keep = client enrolid px_svcdate wind30d wind0d);
  set op.morphine;
  by client enrolid px_svcdate;
  retain wind30d wind0d 0;
  if first.px_svcdate then do; wind30d = 0; wind0d = 0; end;
  if -30 le lag le 30 then wind30d = 1;
  if lag = 0 then wind0d = 1;
  if last.px_svcdate;
run;
proc freq data=op.morphine1; tables wind30d wind0d / missprint; run;

proc print data=op.morphine1 (obs = 10); run;

* Check ce - all claims *;
data op.morphine_ce;
  merge op.morphine (in=din)
        op.elig13_16 (keep = client enrolid year memdays enrmon dualelig mhsacovg med_covg drugcovg where = (year = 2014));
  by client enrolid;
  if din;
run;

proc print data=op.morphine_ce (obs = 50); 
  title 'morphine ce claims';
  where drugcovg = '1'; 
run;

* Check ce *;
data op.morphine_ce1;
  merge op.morphine1 (in=din)
        op.elig13_16 (keep = client enrolid year memdays enrmon dualelig mhsacovg med_covg drugcovg where = (year = 2014));
  by client enrolid;
  if din;
run;
proc print data=op.morphine_ce1 (obs = 50); 
  title 'morphine ce1';
  where drugcovg = '1' and month(px_svcdate) ne 12 and wind30d = 0; 
run;
proc freq data=op.morphine_ce1;  
  tables wind30d * (enrmon dualelig mhsacovg med_covg drugcovg)
         wind0d  * (enrmon dualelig mhsacovg med_covg drugcovg)/ missprint; 
run;

** Checking HCPCS in correlation with Rx - buprenorphine/naloxone **;
data treat_px;
  set op.med14 (keep = client enrolid svcdate treat_rx rename = (svcdate = px_svcdate) where = (treat_rx = 1));
run;
data treat_rx;
  set op.rx14 (keep = client enrolid svcdate naloxone buprenorphine generid rename = (svcdate = rx_svcdate) 
    where = (naloxone = 1 or buprenorphine = 1));
run;
proc sql;
  create table op.treat_rx as
  select a.*,b.rx_svcdate, b.generid, b.buprenorphine, b.naloxone
  from treat_px as a left join treat_rx as b
  on a.client = b.client & a.enrolid = b.enrolid;
quit;
data op.treat_rx (drop = naloxone buprenorphine);
  set op.treat_rx;
  lag = rx_svcdate - px_svcdate;
run;
proc sort data=op.treat_rx nodupkey; by client enrolid px_svcdate rx_svcdate generid; run;

proc print data=op.treat_rx (obs = 50); title 'Buprenorphine/Naloxone rx and px'; where rx_svcdate = .; run;

data op.treat_rx1 (keep = client enrolid px_svcdate wind30d wind0d);
  set op.treat_rx;
  by client enrolid px_svcdate;
  retain wind30d wind0d 0;
  if first.px_svcdate then do; wind30d = 0; wind0d = 0; end;
  if -30 le lag le 30 then wind30d = 1;
  if lag = 0 then wind0d = 1;
  if last.px_svcdate;
run;
proc freq data=op.treat_rx1; tables wind30d wind0d / missprint; run;

proc print data=op.treat_rx1 (obs = 10); run;

* Compare each year *;
data treat_med (keep = client enrolid treat_rx1);
  set op.med14_1 (where = (treat_rx1 = 1));
run;
data treat_rx (keep = client enrolid rx naloxone1 buprenorphine1);
  set op.rx14_1 (where = (naloxone1 = 1 or buprenorphine1 = 1));
  rx = 1;
run;
data treat;
  merge treat_med
        treat_rx;
  by client enrolid;
run;
proc freq data=treat; title 'J code and Rx for Bup/Nal during 2014'; tables rx * treat_rx1 / missprint; run;

** Check duals **;
proc freq data=op.elig13_16;
  title 'checking elig';
  tables year * dualelig / missprint; 
run;
* Do duals have fewer rx/dx claims? *;
%macro duals(yr);
  * Rx *;
  data op.duals_rx&yr (keep = client enrolid count duals);
    merge op.elig13_16 (keep = client enrolid year dualelig where = (year = 20&yr))
	      op.rx&yr (keep = client enrolid svcdate);
    by client enrolid;
	retain count 0;
	if first.enrolid then count = 0;
	count + 1;
	if dualelig in ('1','2','3') then duals = 1; else duals = 0;
	if last.enrolid;
  run;
  proc print data=op.duals_rx&yr (obs = 5); title "duals rx &yr"; run;
  proc sort data=op.duals_rx&yr; by duals; run;
  proc means data=op.duals_rx&yr; by duals; var count; run;
  * Med *;
  data op.duals_med&yr (keep = client enrolid count duals);
    merge op.elig13_16 (keep = client enrolid year dualelig where = (year = 20&yr))
	      op.med&yr (keep = client enrolid svcdate);
    by client enrolid;
	retain count 0;
	if first.enrolid then count = 0;
	count + 1;
	if dualelig in ('1','2','3') then duals = 1; else duals = 0;
	if last.enrolid;
  run;
  proc print data=op.duals_med&yr (obs = 5); title "duals med&yr"; run;
  proc sort  data=op.duals_med&yr; by duals; run;
  proc means data=op.duals_med&yr; by duals; var count; run;
  
%mend duals;
%duals(15);
%duals(16);
*/
** Check pdx prior to 1st opioid rx **;
%macro dx_op (yr);
  proc sql;
    create table op.dx_op&yr as
    select a.*,b.svcdate, b.pdx, b.dx1 
    from op.new_users_ex1_&yr as a left join op.med&yr as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  proc sort data=op.dx_op&yr; by client enrolid descending svcdate; run;
  data op.dx_op&yr;
    set op.dx_op&yr;
	by client enrolid descending svcdate;
	if svcdate le first_op then kp = 1;
	lag = first_op - svcdate;
	if pdx ne '' then diag = pdx;
	else diag = dx1;
	if kp then output;
  run;
  proc sort data=op.dx_op&yr; by client enrolid descending svcdate pdx dx1; run;
  data op.dx_op&yr (keep = client enrolid svcdate first_op lag diag);
    set op.dx_op&yr;
	by client enrolid descending svcdate pdx dx1;
	if first.enrolid;
  run;
  ods output OneWayFreqs = frq; 
  proc freq data=op.dx_op&yr; tables diag; run;
  data frq;
    set frq (keep = diag frequency);
    dx = substr(diag,1,3);
  run;
  proc sort data=frq; by dx; run;
  data frq;
    set frq;
	by dx;
	retain sm 0;
	if first.dx then sm = frequency;
	sm + frequency;
	if last.dx;
  run;
  proc print data=frq; var dx sm; run;
%mend dx_op;
*%dx_op(14);

** Check new user pop for sud, oud, od, mh dx **;
%macro dx(yr);
  proc sql;
    create table op.new_dx&yr as
    select a.*,b.sud1, b.oud1, b.od1, b.mh1 
    from op.new_users_ex1_14 as a left join op.med&yr._1 as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  proc freq data=op.new_dx&yr; title "new users dx 20&yr"; tables sud1 oud1 od1 mh1 / missprint; run;
%mend dx;
%dx(14);
%dx(15);
%dx(16);
* Overlap by year *;
data op.new_dx_all;
  merge op.new_dx14 (rename = (sud1 = sud14 oud1 = oud14 od1 = od14 mh1 = mh14))
        op.new_dx15 (rename = (sud1 = sud15 oud1 = oud15 od1 = od15 mh1 = mh15))
		op.new_dx16 (rename = (sud1 = sud16 oud1 = oud16 od1 = od16 mh1 = mh16));
  by client enrolid;
  if sud14 = . then sud14 = 0;
  if sud15 = . then sud15 = 0;
  if sud16 = . then sud16 = 0;
  if oud14 = . then oud14 = 0;
  if oud15 = . then oud15 = 0;
  if oud16 = . then oud16 = 0;
  if od14  = . then od14  = 0;
  if od15  = . then od15  = 0;
  if od16  = . then od16  = 0;
  if mh14  = . then mh14  = 0;
  if mh15  = . then mh15  = 0;
  if mh16  = . then mh16  = 0;
run;
proc freq data=op.new_dx_all; 
  title "overlap over time"; 
  tables sud14 * sud15 * sud16 
         oud14 * oud15 * oud16
         od14 * od15 * od16
         mh14 * mh15 * mh16
         oud14 * od14 / missprint; 
run;

*** BREE metrics ***;
data library.ohd_2017;
  infile "/home/u0112740/opioid/data/ohd_2017.csv" dlm = ',' missover dsd firstobs = 2;
  length ndcnum $11;
  input ndcnum $ strength ratio;
run;
proc print data=library.ohd_2017 (obs = 5); title 'OHD-A 2017'; run;

%macro bree(yr,q_start,q_end,q_prior);
  * 1. Percent of pop w opioid rx *;
  proc sort data= op.rx&yr (where = ("&q_start"d <= svcdate <= "&q_end"d & opioid = 1)) out = opioid (keep = client enrolid) nodupkey; 
    by client enrolid; 
  run;
  * Quarterly Rx dset - require days supply *;
  data drug_&q_start;
    set op.rx&yr (where = ("&q_start"d <= svcdate <= "&q_end"d & opioid = 1 & daysupp ne 0)); 
  run;
  proc sort data=drug_&q_start; by client enrolid svcdate; run;
  * 2. Chronic >= 60 days *;
  data chronic_&q_start (keep = client enrolid tot_supp ge60);
    set drug_&q_start;
	by client enrolid;
	retain tot_supp 0;
	if first.enrolid then tot_supp = 0;
	tot_supp + daysupp;
	if last.enrolid then do;
	  if tot_supp >= 60 then ge60 = 1;
	  else ge60 = 0;
	  output;
	end;
  run;
  proc freq data=chronic_&q_start; title "2. Chronic &q_start"; tables ge60 / missprint; run;
  * 3. High-dose *;
  proc sql;
    create table high_&q_start as
    select a.*, b.client, b.enrolid, b.metqty, b.daysupp 
    from library.ohd_2017 as a right join drug_&q_start as b
    on a.ndcnum = b.ndcnum;
  quit;
  proc sort data=high_&q_start (where = (daysupp >= 1)); by client enrolid; run;
  data high_&q_start (keep = client enrolid med50 med90);
    set high_&q_start;
	by client enrolid;
	retain days50 days90 med50 med90 0;
	if first.enrolid then do;
      days50 = 0;
	  days90 = 0;
	  med50  = 0;
	  med90  = 0;
	end;
	med = strength * (metqty / daysupp) * ratio;
	if med >= 50 then days50 = days50 + daysupp;
	if med >= 90 then days90 = days90 + daysupp;
	if days50 >= 60 then med50 = 1; 
	if days90 >= 60 then med90 = 1; 
	if last.enrolid;
  run;
  proc freq data=high_&q_start; title "3. High dose &q_start"; tables med50 med90 / missprint; run;
  * 4. Sedatives *;
  data sed_&q_start;
    set op.rx&yr (where = ("&q_start"d <= svcdate <= "&q_end"d & barbiturate = 1)); 
  run;
  * Chronic >= 60 days *;
  data sed_&q_start (keep = client enrolid tot_supp ge60);
    set sed_&q_start;
	by client enrolid;
	retain tot_supp 0;
	if first.enrolid then tot_supp = 0;
	tot_supp + daysupp;
	if last.enrolid then do;
	  if tot_supp >= 60 then ge60 = 1;
	  else ge60 = 0;
	  output;
	end;
  run;
  * Combine Op/Sed *;
  data sed_&q_start;
    merge chronic_&q_start
	      sed_&q_start (rename = (ge60 = sed_ge60));
    by client enrolid;
	if ge60 = 1 and sed_ge60 = 1 then both = 1; else both = 0;
  run;
  proc freq data=sed_&q_start; title "4. Sed/Opioid &q_start"; tables both / missprint; run;
  * 5. Days Supply of First Opioid *;
  * First Rx *;
  data first_&q_start (keep = client enrolid svcdate daysupp);
    set drug_&q_start;
	by client enrolid svcdate;
	if first.enrolid;
  run;
  * No prior *;
  data clean_&q_start;
    merge first_&q_start (in=din)
	      first_&q_prior (in=xin keep = client enrolid);
	by client enrolid;
    if din & ^xin;
  run;
  proc freq data=clean_&q_start; title "First days supply &q_start"; format daysupp days.; tables daysupp / missprint; run;
  * 9. OUD per Q *;
  data oud_&q_start (keep = client enrolid oud);
    set op.med&yr (where = ("&q_start"d <= svcdate <= "&q_end"d & oud = 1));
  run;
  proc sort data=oud_&q_start nodupkey; by client enrolid; run;
  * 6/7. Overdose deaths - per person *;
  data od_&q_start (keep = client enrolid svcdate death od ed ip_op);
    set op.med&yr (where = ("&q_start"d <= svcdate <= "&q_end"d & od = 1));
  run;
  proc sort data=od_&q_start; by client enrolid svcdate descending ed ip_op; run;
  proc print data=od_&q_start (obs = 20); where death = 1; title 'all'; run;
  * Keep first overdose *;
  data od_&q_start;
    set od_&q_start;
	by client enrolid svcdate descending ed ip_op;
	if first.enrolid then do;
	  * if ED and IP, then ED resulted in IP, so change ED to 0 *;
	  if ed = 1 & ip_op = 'IP' then ed = 0;
	  output;
    end;
  run;
  proc print data=od_&q_start (obs = 20); where death = 1 and ed = 1 and ip_op = 'IP'; title 'one'; run;
  proc freq data= od_&q_start;
    title "6/7. Overdose deaths &q_start";
    tables death * (ed ip_op) / missprint; 
  run;
%mend bree;

data drug_01OCT2013;
  set op.rx13 (where = ("01OCT2013"d <= svcdate <= "31DEC2013"d & opioid = 1 & daysupp ne 0)); 
run;
proc sort data=drug_01OCT2013; by client enrolid svcdate; run;
data first_01OCT2013 (keep = client enrolid svcdate daysupp);
  set drug_01OCT2013;
  by client enrolid svcdate;
  if first.enrolid;
run;
%bree(14,01JAN2014,31MAR2014,01OCT2013);
%bree(14,01APR2014,30JUN2014,01JAN2014);
%bree(14,01JUL2014,30SEP2014,01APR2014);
%bree(14,01OCT2014,31DEC2014,01JUL2014);

%bree(15,01JAN2015,31MAR2015,01OCT2014);
%bree(15,01APR2015,30JUN2015,01JAN2015);
%bree(15,01JUL2015,30SEP2015,01APR2015);
%bree(15,01OCT2015,31DEC2015,01JUL2015);

%bree(16,01JAN2016,31MAR2016,01OCT2015);
%bree(16,01APR2016,30JUN2016,01JAN2016);
%bree(16,01JUL2016,30SEP2016,01APR2016);
%bree(16,01OCT2016,31DEC2016,01JUL2016);

%bree(17,01JAN2017,31MAR2017,01OCT2016);
%bree(17,01APR2017,30JUN2017,01JAN2016);

* Bree looking forward, so need Bree macro run first *;
%macro bree_next(q_start,q_prior,q_next);
  data next&q_start;
    merge clean_&q_start  (in=din keep = client enrolid)
	      chronic_&q_next (in=nin);
    by client enrolid;
	if din & nin;
  run;
  proc freq data=next&q_start; title "New Users Chronic &q_start"; tables ge60 / missprint; run;
%mend bree_next;

%bree_next(01JAN2014,01OCT2013,01APR2014);
%bree_next(01APR2014,01JAN2014,01JUL2014);
%bree_next(01JUL2014,01APR2014,01OCT2014);
%bree_next(01OCT2014,01JUL2014,01JAN2015);

%bree_next(01JAN2015,01OCT2014,01APR2015);
%bree_next(01APR2015,01JAN2015,01JUL2015);
%bree_next(01JUL2015,01APR2015,01OCT2015);
%bree_next(01OCT2015,01JUL2015,01JAN2016);

%bree_next(01JAN2016,01OCT2015,01APR2016);
%bree_next(01APR2016,01JAN2016,01JUL2016);
%bree_next(01JUL2016,01APR2016,01OCT2016);
%bree_next(01OCT2016,01JUL2016,01JAN2017);

%bree_next(01JAN2017,01OCT2016,01APR2017);
%bree_next(01APR2017,01JAN2017,01JUL2017);

* 9. Chronic use and OUD in 3/4 quarters per year *;
%macro bree_yr(q1,q2,q3,q4,yr);
  data op.chronic_&yr (keep = client enrolid n_chronic n_oud);
    merge chronic_&q1 (in=q1in) oud_&q1 (in=oud1)
	      chronic_&q2 (in=q2in) oud_&q2 (in=oud2)
	      chronic_&q3 (in=q3in) oud_&q3 (in=oud3)
	      chronic_&q4 (in=q4in) oud_&q4 (in=oud4);
    by client enrolid;
    n_chronic = q1in + q2in + q3in + q4in;
	n_oud     = oud1 + oud2 + oud3 + oud4;
  run;
  proc freq data=op.chronic_&yr; title "Chronic # Qs 20&yr"; tables n_chronic * n_oud / missprint; run;
%mend bree_yr;
%bree_yr(01JAN2014,01APR2014,01JUL2014,01OCT2014,14);
*%bree_yr(01JAN2015,01APR2015,01JUL2015,01OCT2015,15);
*%bree_yr(01JAN2016,01APR2016,01JUL2016,01OCT2016,16);
*%bree_yr(01JAN2017,01APR2017,01JUL2017,01OCT2017,17);

* Combine with my new users to find chronic users in 2016 *;
** ?? does this need to be n_chronic >= 3? **;
data op.chronic_new16;
    merge op.new_users_ex1_14 (in=nin)
          chronic_16 (in=bin)
          op.med16_1;
  by client enrolid;
  if nin & bin;
run;
proc print data=op.chronic_new16 (obs = 5); run;
proc freq data=op.chronic_new16; tables oud1 od1 death1 / missprint; run;

** Logistic Regression **;
* Create combined rx/med for new users *;
%macro combo(yr);
  data op.combo&yr;
    merge op.new_users_ex1_&yr (in=nin)
	      op.elig13_16_1
	      op.rx&yr._1
		  op.med&yr._1;
    by client enrolid;
	if nin;
	* Set Rx treatment flag *;
	if buprenorphine1 = 1 or naltrexone1 = 1 or methadone1 = 1 then rx_trmt = 1; else rx_trmt = 0;
  run;
%mend combo;
*%combo(14);

* Note: naltrexone1 and treat1 are all 0, too many cat in msa *;
*       descending predictss oud1 = 1 *;

* OUD *;
proc logistic data=op.combo14 descending;
   * class is categorical vars *;
   class sud1 mh1 short_acting1 long_acting1 sex stdrace rural enrmon13 enrmon14 enrmon15 enrmon16
         naloxone1 buprenorphine1 methadone1 fentanyl1 benzodiazepine1 antidepressant1 antipsychotic1 op_lax1 
	 	 nat_opioid1 syn_opioid1 semi_opioid1 op_dep op_psy op_lax treat_rx1 od1 rx_trmt good_pot1 bad_pot1;
   model oud1 = sud1 mh1 short_acting1 long_acting1 age sex stdrace rural enrmon13 enrmon14 enrmon15 enrmon16
                naloxone1 buprenorphine1 methadone1 fentanyl1 benzodiazepine1 antidepressant1 antipsychotic1 op_lax1 
			    nat_opioid1 syn_opioid1 semi_opioid1 op_dep op_psy op_lax_c opioid_days treat_rx1 od1 rx_trmt good_pot1 bad_pot1 
     / selection = forward expb;
run;

* Overdose *;
proc logistic data=op.combo14 descending;
   * class is categorical vars *;
   class sud1 mh1 short_acting1 long_acting1 sex stdrace rural enrmon13 enrmon14 enrmon15 enrmon16
         naloxone1 buprenorphine1 methadone1 fentanyl1 benzodiazepine1 antidepressant1 antipsychotic1 op_lax1 
	 	 nat_opioid1 syn_opioid1 semi_opioid1 op_dep op_psy op_lax_c treat_rx1 oud1 rx_trmt good_pot1 bad_pot1;
   model od1 = sud1 mh1 short_acting1 long_acting1 age sex stdrace rural enrmon13 enrmon14 enrmon15 enrmon16
               naloxone1 buprenorphine1 methadone1 fentanyl1 benzodiazepine1 antidepressant1 antipsychotic1 op_lax1 
		    nat_opioid1 syn_opioid1 semi_opioid1 op_dep op_psy op_lax_c opioid_days treat_rx1 oud1 rx_trmt good_pot1 bad_pot1 
     / selection = forward expb;
run;

%macro by_yr(yr);
  proc sql;
    create table adm&yr as
    select a.* 
    from op.adm&yr as a inner join op.new_users_ex1 as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  proc sort data=adm&yr nodupkey; by client enrolid admdate; run;
  proc freq data=adm&yr; title "How many admissions 20&yr"; tables xxx; run;
%mend by_yr;
%by_yr(14);

** Prescriber/Provider Metrics **;
%macro prov(yr);
  * No stdprov on Rx claims, so get from Med - might be multiple stdprov per person, but ignore that *;
  proc sort data=op.med&yr out=op.stdp&yr(keep = provid stdprov) nodupkey; by provid; run;
  * Ordering Provider - all Rx *;
  proc sort data=op.rx&yr (where = (daysupp ne 0)) out = op.prov&yr; by ord_prov client enrolid; run;
  data op.prov&yr (keep = ord_prov count_mbr count_rx count_days stdprov);
    merge op.prov&yr (in=pin keep = client enrolid ord_prov daysupp)
          op.stdp&yr (rename = (provid = ord_prov));
	by ord_prov;
	if pin;
	retain count_mbr count_rx count_days 0 prior_mbr '           ';
	if first.ord_prov then do;
      count_mbr  = 0;
	  count_rx   = 0;
	  count_days = 0;
	  prior_mbr  = '           ';
	end;
	* Count all rx *;
	if enrolid ne prior_mbr then count_mbr + 1;
	count_rx + 1;
	count_days + daysupp;
	* Reset prior_mbr *;
    prior_mbr = enrolid;
	if last.ord_prov;
  run;
  proc means data=op.prov&yr; title "Ordering Provider - all Rx"; var count_mbr count_rx count_days; run;
  proc freq data=op.prov&yr; format count_rx vol.; tables stdprov count_rx  / missprint; run;

proc sort data=op.rx&yr (where = (daysupp ne 0 & opioid = 1)) out = op.prov_op&yr; by ord_prov client enrolid; run;
  data op.prov_op&yr (keep = ord_prov stdprov op_mbr op_rx op_days);
    merge op.prov_op&yr (in=pin keep = client enrolid ord_prov daysupp)
          op.stdp&yr (rename = (provid = ord_prov));
	by ord_prov;
	if pin;
	retain op_mbr op_rx op_days 0 prior_mbr '           ';
	if first.ord_prov then do;
	  op_mbr     = 0;
      op_rx      = 0;
      op_days    = 0;
	  prior_mbr  = '           ';
	end;
	* Count all rx *;
	if enrolid ne prior_mbr then op_mbr + 1;
	op_rx + 1;
	op_days + daysupp;
	* Reset prior_mbr *;
    prior_mbr = enrolid;
	if last.ord_prov;
  run;
  
  data prov;
    merge op.prov&yr
	      op.prov_op&yr;
    by ord_prov;
	op_ratio = op_rx / count_rx; 
	format op_ratio 6.4;
  run;
  proc print data=prov(obs = 5); title 'prov'; run;
  proc means data=prov; title "Ordering Provider - Opioids"; var op_mbr op_rx op_days count_mbr count_rx count_days; run;
  proc freq data=prov; format op_rx count_rx vol. op_ratio ratio.; tables stdprov op_ratio / missprint; run;
  * Pharmacy *;
  proc sort data=op.rx&yr (where = (opioid = 1 and daysupp ne 0)) out = op.pharm&yr; by pharmid client enrolid; run;
  data op.pharm&yr (keep = ord_prov count_mbr count_op count_days);
    set op.pharm&yr (keep = client enrolid pharmid daysupp);
	by pharmid;
	retain count_mbr count_op count_days 0 prior_mbr '           ';
	if first.pharmid then do;
      count_mbr  = 0;
	  count_op   = 0;
	  count_days = 0;
	  prior_mbr = '           ';
	end;
	if enrolid ne prior_mbr then count_mbr + 1;
	prior_mbr = enrolid;
	count_op + 1;
	count_days + daysupp;
	if last.pharmid;
  run;
  proc means data=op.pharm&yr; title "Dispensing Pharmacy"; var count_mbr count_op count_days; run;

  ** Rate of OUD by provider **;
  proc sort data=op.med&yr. (keep = provid client enrolid oud) out = prov_oud&yr; by provid client enrolid descending oud; run;
  * Limit to 1 record per provider w/ OUD flag *;
  data prov_oud&yr;
    set prov_oud&yr;
	by provid client enrolid descending oud;
    if first.provid;
  run;
  * Sum num/den by provider *;
  data op.prov_oud&yr (keep = provid num den oud_rate _type_);
    set prov_oud&yr;
	by provid client enrolid;
	retain num den 0 prior_mbr .;
	if first.provid then do;
	  num = 0;
	  den = 1;
	  prior_mbr = enrolid;
	end;
    if prior_mbr ne enrolid then den + 1;
    if oud then num + 1;
	prior_mbr = enrolid;
	if last.provid then do;
	  format oud_rate 9.4;
	  oud_rate = num / den;
	  _type_ = 0;
	  output;
	end;
  run;

  proc means data=op.prov_oud&yr; output out = prov_oud&yr; title "Provider: OUD% 20&yr"; var oud_rate; run;
  data mean&yr  (keep = _type_ oud_rate)
       stdev&yr (keep = _type_ oud_rate);
    set prov_oud&yr;
	     if _stat_ = 'MEAN' then output mean&yr; 
	else if _stat_ = 'STD'  then output stdev&yr;
  run;
  data op.prov_oud&yr (drop = _type_);
    merge op.prov_oud&yr
	         mean&yr  (rename = (oud_rate = mn)) 
             stdev&yr (rename = (oud_rate = stdev));
	by _type_;
	if oud_rate > mn + (2 * stdev) then high = 1; else high = 0;
  run;
  proc freq  data=op.prov_oud&yr; tables high / missprint; run;

  *** DEAclass by Provider - all Rx **;
  proc sort data=op.rx&yr. (keep = ord_prov deaclas) out = class&yr; by ord_prov; run;
  data class&yr (keep = ord_prov class2_3 class4_7 class_rate _type_);
    set class&yr;
    by ord_prov;
    retain class2_3 class4_7 0;
    if first.ord_prov then do;
      class2_3 = 0;
      class4_7 = 0;
    end;
         if deaclas in (2,3  ) then class2_3 + 1;
		 * Need to add in class 7 and missing *;
    else class4_7 + 1;
    if last.ord_prov then do;
      * Ignores missing DEA class in denominator *;
      class_rate = class2_3 / (class2_3 + class4_7);
	  _type_ = 0;
      output;
    end;
  run;
  proc means data=class&yr; output out = class&yr.m; title "Provider: Class1-2% all rx 20&yr"; var class_rate; run;
  data mean&yr  (keep = _type_ class_rate)
       stdev&yr (keep = _type_ class_rate);
    set class&yr.m;
	     if _stat_ = 'MEAN' then output mean&yr; 
	else if _stat_ = 'STD'  then output stdev&yr;
  run;
  data class&yr (drop = _type_);
    merge class&yr
	         mean&yr  (rename = (class_rate = mn)) 
             stdev&yr (rename = (class_rate = stdev));
	by _type_;
	if class_rate > mn + (2 * stdev) then high = 1; else high = 0;
  run;
  proc freq data=class&yr; tables high / missprint; run;
 
 *** DEAclass by Provider - only opioids **;
  proc sort data=op.rx&yr. (keep = ord_prov deaclas opioid where = (opioid = 1)) out = class&yr; by ord_prov; run;
  data class&yr (keep = ord_prov class2_3 class4_7 class_rate _type_);
    set class&yr;
    by ord_prov;
    retain class2_3 class4_7 0;
    if first.ord_prov then do;
      class2_3 = 0;
      class4_7 = 0;
    end;
         if deaclas in (2,3  ) then class2_3 + 1;
		 * Need to add in class 7 and missing *;
    else class4_7 + 1;
    if last.ord_prov then do;
      * Ignores missing DEA class in denominator *;
      class_rate = class2_3 / (class2_3 + class4_7);
	  _type_ = 0;
      output;
    end;
  run;
  proc means data=class&yr; output out = class&yr.m; title "Provider: Class1-2% opioids 20&yr"; var class_rate; run;
  data mean&yr  (keep = _type_ class_rate)
       stdev&yr (keep = _type_ class_rate);
    set class&yr.m;
	     if _stat_ = 'MEAN' then output mean&yr; 
	else if _stat_ = 'STD'  then output stdev&yr;
  run;
  data class&yr (drop = _type_);
    merge class&yr
	      mean&yr  (rename = (class_rate = mn)) 
          stdev&yr (rename = (class_rate = stdev));
	by _type_;
	if class_rate > mn + (2 * stdev) then high = 1; else high = 0;
  run;
  proc freq data=class&yr; tables high / missprint; run;
 
  ** High-dose **;
  * Rx + MME *;
  proc sql;
    create table high&yr as
    select a.*, b.client, b.enrolid, b.metqty, b.daysupp, b.ord_prov, b.opioid 
    from library.ohd_2017 as a right join op.rx&yr as b
    on a.ndcnum = b.ndcnum;
  quit;
  * Summarize by provider - people w 1+ high-dose *;
  proc sort data=high&yr (where = (daysupp >= 1 & opioid = 1)); by ord_prov client enrolid; run;
  data high&yr (keep = ord_prov op_med50_rate op_med90_rate _type_);
    set high&yr;
	by ord_prov client enrolid;
	retain mbr50 mbr90 med50 med90 mbr 0 prior_mbr '           ';
	if first.ord_prov then do;
	  med50  = 0;
	  med90  = 0;
      mbr = 0;
      prior_mbr = '           ';
	end;
    if first.enrolid then do;
      mbr50 = 0;
      mbr90 = 0;
    end;
    med = strength * (metqty / daysupp) * ratio;
    if enrolid ne prior_mbr then mbr + 1;
    if med >= 50 then mbr50 = 1;
	if med >= 90 then mbr90 = 1;
    if last.enrolid then do;
      if mbr50 = 1 then med50 + 1;
      if mbr90 = 1 then med90 + 1;
    end;
    prior_mbr = enrolid;
	if last.ord_prov then do;
	  op_med50_rate = med50 / mbr;
	  op_med90_rate = med90 / mbr;
	  _type_ = 0;
	  output;
	end;
  run;
  proc means data=high&yr; output out = high&yr.m; title "High dose among opioid rx&yr"; var op_med50_rate op_med90_rate; run;
  data mean&yr  (keep = _type_ op_med90_rate op_med50_rate)
       stdev&yr (keep = _type_ op_med90_rate op_med50_rate);
    set high&yr.m;
	     if _stat_ = 'MEAN' then output mean&yr; 
	else if _stat_ = 'STD'  then output stdev&yr;
  run;
  data high&yr (drop = _type_);
    merge high&yr
	         mean&yr  (rename = (op_med50_rate = mn50    op_med90_rate = mn90   )) 
             stdev&yr (rename = (op_med50_rate = stdev50 op_med90_rate = stdev90));
	by _type_;
	if op_med50_rate > mn50 + (2 * stdev50) then high50 = 1; else high50 = 0;
    if op_med90_rate > mn90 + (2 * stdev90) then high90 = 1; else high90 = 0;
  run;
  proc freq data=high&yr; tables high50 high90 / missprint; run;
%mend prov;
%prov(14);
%prov(15); 
%prov(16); 
%prov(17); 

** Combine med/rx: Checking treatment Rx **;
data op.med_rx14;
  merge op.med14_1
        op.rx14_1;
  by client enrolid;
run;

proc freq data=op.med_rx14; 
  title '2014';
  tables oud1 * (bup_meth_nalt1 naloxone1) opioid1 * (bup_meth_nalt1 naloxone1)
         (oud1 opioid1) * (ed1 pcp1 ip1 mh1) / missprint; run;
run;

*** Read in Redbook ***;
data op.redbook;
  infile "/home/u0112740/opioid/data/redbook.csv" dlm = ',' missover dsd firstobs = 2;
  length gennme roads $50.;
  input NDCNUM $ DEACLAS	GENERID $ MAINTIN	ORGBKCD	$ PRODCAT SIGLSRC $ GENIND ORGBKFG $ DESIDRG $ MASTFRM $ PKQTYCD $ 
		THERCLS	EXCLDRG	THERGRP	PKSIZE THERDTL GNINDDS $ METSIZE $ MAINTDS $ STRNGTH $ PRDCTDS $ EXCDGDS $ ORGBKDS $ 
		THRDTDS $ MSTFMDS $ THRCLDS $ THRGRDS $ DEACLDS $ PRODNME $ MANFNME $ GENNME $ ROACD $ ROADS $;
run;

proc freq data=op.redbook; tables roacd * roads / missprint; run;

* Combine Megans list with Redbook *;
proc sort data=library.opioid_vs_&hedis_yr; by code;    run;
proc sort data=op.redbook;                  by generid; run;
data op.rx_doty;
  merge op.redbook (keep = generid thercls roacd deaclas gennme)
        library.opioid_vs_&hedis_yr (in=din keep = code short_name rename = (code = generid) 
          where = (short_name in ('semi_opioid','syn_opioid','nat_opioid','bupren','bup_meth_nalt','meth','naltrex')));
  by generid;
  if din;
run;
proc sort data=op.rx_doty nodupkey; by generid thercls roacd deaclas short_name; run;
proc print data=op.rx_doty; where deaclas = 5; run;

proc freq data=op.rx_doty;
  title 'Doty w/ Redbook'; 
  tables short_name * (thercls deaclas roacd) / missprint;
run;

** OUD with Opioids **;
%macro oud(yr);
  proc sql;
    create table oud&yr as
    select a.*,b.* 
    from op.med&yr._1 as a left join op.rx&yr._1 as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  proc freq data=oud&yr;
    title "OUD with Opioid 20&yr"; 
    where oud1 = 1;
    tables opioid1 / missprint;
  run;
%mend oud;
*%oud(14);
%oud(15);
%oud(16);
%oud(17);

** MPR **;
%macro mpr(yr,mped);
  proc sort data=op.rx&yr out = rx&yr; by client enrolid svcdate; run;
  data mpr&yr (keep = client enrolid mpr);
    set rx&yr;
	by client enrolid svcdate;
	retain op_days 0 first_op .;
	format first_op mmddyy10. mpr 5.3;
	if first.enrolid then do;
      op_days = 0;
	  first_op = .;
	end;
	if opioid = 1 then do;
      if first_op = . then first_op = svcdate;
	  op_days + daysupp;
	end;
	if last.enrolid then do;
	  days = "&mped"d - first_op + 1;
	  mpr = op_days / days;
	  output;
	end;
  run;
  proc freq data=mpr&yr;
    title "MPR 20&yr"; 
	format mpr mpr_fmt.;
    tables mpr / missprint;
  run;
%mend mpr;
%mpr(14,31DEC2014);
%mpr(15,31DEC2015);
%mpr(16,31DEC2016);
%mpr(17,30JUN2017); * 2017 is half year *;

** Opioids from Multiple Pharmacies/Providers **;
%macro mult(yr,prov);
  proc sort data=op.rx&yr (where = (opioid = 1)) out = rx&yr; by client enrolid &prov; run;
  data op.mult_&prov.&yr (keep = client enrolid num_prov);
    set rx&yr;
	by client enrolid &prov;
	retain num_prov 0 prov '            ';
	if first.enrolid then do;
      num_prov = 1;
	  prov = &prov;
	end;
	if prov ne &prov then num_prov + 1;
    prov = &prov;
	if last.enrolid;
  run;
  proc freq data=op.mult_&prov.&yr;
    title "Opioids from Multiple &prov 20&yr"; 
    tables num_prov / missprint;
  run;
%mend mult_prov;
%mult(14,pharmid);	%mult(14,ord_prov);
%mult(15,pharmid);	%mult(15,ord_prov);
%mult(16,pharmid);	%mult(16,ord_prov);
%mult(17,pharmid);	%mult(17,ord_prov);

** Concurrent Rx **;
%macro conc(yr);
  * Find opioid, benzos, bad potentiators, and muscle relaxants *;
  data opioid&yr   (keep = client enrolid svcdate daysupp)
       ben_bad&yr  (keep = client enrolid svcdate daysupp benzodiazepine bad_pot)
       muscle&yr   (keep = client enrolid svcdate daysupp muscle);
    set op.rx&yr (keep = client enrolid opioid benzodiazepine bad_pot muscle svcdate daysupp 
      where = (opioid = 1 or benzodiazepine = 1 or bad_pot = 1 or muscle = 1));
	     if opioid = 1 then output opioid&yr;
	else if muscle = 1 then output muscle&yr;
    else                    output ben_bad&yr;
  run;
  * Compare dates to see if concurrent *;
  proc sql;
    create table conc&yr as
    select a.*, b.svcdate as bdate, b.daysupp as bdays, b.benzodiazepine, b.bad_pot 
    from opioid&yr as a left join ben_bad&yr as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  data op.conc&yr (keep = client enrolid op_benz op_bad svcdate daysupp bdate);
    set conc&yr;
	by client enrolid;
	retain op_benz op_bad 0;
	if first.enrolid then do;
      op_benz = 0;
	  op_bad  = 0;
	end;
	if benzodiazepine = 1 then do;
      if svcdate <= bdate             <= svcdate + daysupp or
         svcdate <= bdate + bdays     <= svcdate + daysupp or
         bdate   <= svcdate           <= bdate   + bdays   or
         bdate   <= svcdate + daysupp <= bdate   + bdays then op_benz = 1;
    end;
	else if bad_pot = 1 then do;
       if svcdate <= bdate             <= svcdate + daysupp or
          svcdate <= bdate + bdays     <= svcdate + daysupp or
          bdate   <= svcdate           <= bdate   + bdays   or
          bdate   <= svcdate + daysupp <= bdate   + bdays then op_bad = 1;
	end;
	if last.enrolid;
  run;
  ** Check opioid/benzo data with muscle dates to see if concurrent **;
  proc sql;
    create table trinity&yr as
    select a.*, b.svcdate as mdate, b.daysupp as mdays 
    from op.conc&yr as a left join muscle&yr as b
    on a.client = b.client & a.enrolid = b.enrolid;
  quit;
  data op.conc&yr (keep = client enrolid op_benz op_bad trinity3);
    set trinity&yr;
	by client enrolid;
	retain trinity3 0;
	if first.enrolid then trinity3 = 0;
	if op_benz = 1 then do; * must have concurrent opioid and benzo, then check for muscle dates *;
      if svcdate <= mdate             <= svcdate + daysupp or
         svcdate <= mdate + mdays     <= svcdate + daysupp or
         mdate   <= svcdate           <= mdate   + mdays   or
         mdate   <= svcdate + daysupp <= mdate   + mdays then trinity3 = 1;
    end;
	if last.enrolid;
  run;
  proc freq data=op.conc&yr; title 'opioid concurrents'; tables op_benz * trinity3 op_bad / missprint; run;
%mend conc;
%conc(14);
%conc(15);
%conc(16);
%conc(17); 

** Check overlap of various risk pops: 2014 **;
data op.overlap14;
  merge op.rx_med14_1       (keep = client enrolid opioid1 oud1 sud1)
        op.new_users_ex1_14 (keep = client enrolid in = new_in)
        op.chronic_14       (keep = client enrolid n_chronic)
        op.conc14           (keep = client enrolid op_benz op_bad trinity3)
        op.mult_pharmid14   (keep = client enrolid num_prov rename = (num_prov = num_pharm))
        op.mult_ord_prov14  (keep = client enrolid num_prov);
  by client enrolid;
  if new_in         then new_user   = 1; else new_user   = 0;
  if n_chronic ge 3 then chronic    = 1; else chronic    = 0;
  if num_prov  >=2  then num_prov1  = 1; else num_prov1  = 0;
  if num_prov  >=3  then num_prov3  = 1; else num_prov3  = 0;
  if num_pharm >=2  then num_pharm1 = 1; else num_pharm1 = 0;
  if num_pharm >=3  then num_pharm3 = 1; else num_pharm3 = 0;
  if oud1       = . then oud1       = 0;
  if opioid1    = . then opioid1    = 0;
  if new_user   = . then new_user   = 0;
  if chronic    = . then chronic    = 0;
  if op_benz    = . then op_benz    = 0;
  if op_bad     = . then op_bad     = 0;
  if trinity3   = . then trinity3   = 0;
  if num_pharm1 = . then num_pharm1 = 0;
  if num_prov1  = . then num_prov1  = 0;
  if oud1 or sud1 then oud_sud1 = 1; else oud_sud1 = 0;
run;
proc freq data=op.overlap14;
  title 'Risk pop overlaps 2014';
  tables oud1 * new_user 
  	     oud_sud1 * new_user
		 opioid1 * oud1
		 opioid1 * oud_sud1
         opioid1 * new_user
         chronic * oud1
		 chronic * oud_sud1
         chronic * opioid1
         chronic * new_user
         op_benz * oud1
		 op_benz * oud_sud1
         op_benz * opioid1
         op_benz * new_user
         op_benz * chronic
         op_bad * oud1
		 op_bad * oud_sud1
		 op_bad * opioid1
         op_bad * new_user
         op_bad * chronic
         op_bad * op_benz
         trinity3 * oud1
		 trinity3 * oud_sud1
         trinity3 * opioid1
		 trinity3 * new_user
		 trinity3 * chronic
         trinity3 * op_benz
         trinity3 * op_bad
	  	 num_pharm1 * oud1
		 num_pharm1 * oud_sud1
         num_pharm1 * opioid1
   	 	 num_pharm1 * new_user
         num_pharm1 * chronic
         num_pharm1 * op_benz
         num_pharm1 * op_bad
 		 num_pharm1 * trinity3
         num_prov1 * oud1
		 num_prov1 * oud_sud1
         num_prov1 * opioid1
         num_prov1 * new_user
         num_prov1 * chronic
         num_prov1 * op_benz
         num_prov1 * op_bad
         num_prov1 * trinity3
         num_prov1 * num_pharm1 

         num_pharm3 * oud1
		 num_pharm3 * oud_sud1
         num_pharm3 * opioid1
   	 	 num_pharm3 * new_user
         num_pharm3 * chronic
         num_pharm3 * op_benz
         num_pharm3 * op_bad
 		 num_pharm3 * trinity3
         num_prov3 * oud1
		 num_prov3 * oud_sud1
         num_prov3 * opioid1
         num_prov3 * new_user
         num_prov3 * chronic
         num_prov3 * op_benz
         num_prov3 * op_bad
         num_prov3 * trinity3
         num_prov3 * num_pharm1/ missprint;
run;

* Checking initial vs. subsequent overdoses *;
proc freq data=op.med16; 
  title '2016:A is initial, D is subsequent';
  where dx1 in ('T400X1A','T400X2A','T400X3A','T400X4A','T401X1A','T401X2A','T401X4A','T402X1A','T402X2A','T402X3A','T402X4A',
                 'T400X5A','T402X5A',
                'T400X1D','T400X2D','T400X3D','T400X4D','T401X1D','T401X2D','T401X4D','T402X1D','T402X2D','T402X3D','T402X4D',
				'T400X5D','T402X5D');
  tables dx1;
run; 
* Was treatment successful? Was there opioid rx after opioid treatment? *;
* rx14 members on treatment *;
* rx15/16 members with/without opioid rx *;
* does not look at timing within rx14 *;
data trmt_op;
  merge op.rx14_1 (keep = client enrolid bup_meth_nalt1 where = (bup_meth_nalt1 = 1) in = din)
        op.rx15_1 (keep = client enrolid opioid1)
        op.rx16_1 (keep = client enrolid opioid1 rename = (opioid1 = opioid2));
  by client enrolid;
  if opioid1 = 1 or opioid2 = 1 then opioid = 1; else opioid = 0;
  if din;
run;
proc freq data=trmt_op;
  title 'Is opioid treatment in 2014 followed by opioid use in 2015/16';
  tables opioid1 opioid2 opioid / missprint;
run;
* Opioid after OUD *;
data oud_op;
  merge op.med14_1 (keep = client enrolid oud1 where = (oud1 = 1) in = din)
        op.rx15_1 (keep = client enrolid opioid1)
        op.rx16_1 (keep = client enrolid opioid1 rename = (opioid1 = opioid2));
  by client enrolid;
  if opioid1 = 1 or opioid2 = 1 then opioid = 1; else opioid = 0;
  if din;
run;
proc freq data=oud_op;
  title 'Is OUD dx in 2014 followed by opioid use in 2015/16';
  tables opioid1 opioid2 opioid / missprint;
run;

* Lag between new users and od *;
data new_od;
  merge op.new_users_ex1_14 (in=din keep = client enrolid)
        op.med14_1 (keep = client enrolid od1 rename = (od1 = od14))
		op.med15_1 (keep = client enrolid od1 rename = (od1 = od15))
		op.med16_1 (keep = client enrolid od1 rename = (od1 = od16));
  by client enrolid;
  if din;
run;
proc freq data=new_od;
  title 'New users in 2014 who OD later';
  tables od14 od15 od16 / missprint; 
run;
* Area Deprivation Index - hipxchange.org/ADI *;
PROC IMPORT
  DATAFILE="/home/u0112740/opioid/data/zip4_dep_index.csv"
  DBMS=CSV
  OUT=op.adi
  REPLACE;
  GUESSINGROWS=100000;
RUN;
proc print data=op.adi (obs = 5); title 'Area Deprivation Index'; run;
/*data op.adi1;
  set op.adi;
  recipzip = substr(zip_code_plus4_txt,1,3);
run; 
proc sort data=op.adi1; by recipzip; run;  */
proc means data=op.adi1; 
  output out = adi;
  by recipzip;
  var dep_2000_90coeff_index;
run;
data adi (drop = _stat_);
  set adi (keep = recipzip dep_2000_90coeff_index _stat_ rename = (dep_2000_90coeff_index = adi) where = (_stat_ = 'MEAN'));
run;
proc print data=adi (obs = 10); title 'Area Deprivation Index'; run;
** Need to add to op.elig13_16_1 and new_user_ex1_14 **;












 
  



