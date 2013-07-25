/*
 Rexx -  Calendar gadget showing the current month
*/

WeekStart = 0		/* Let's define the first day of the week: Monday = 0 (DEFAULT) ** Sunday = 1 */

/* ------------------------------------------------------------------------- */
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs

/* Check if the script was directly started */
if arg() = 0 then do
    /* Start the gadget */
    parse SOURCE . . theScript
    if arg(1)="" then
        call SysSetObjectdata "<WP_DESKTOP>", "WIZLAUNCHGADGET="theScript
        Exit(0)
end

numeric digits 15 /* We need this for calculating with hex numbers */

select
    when arg(1)="/GADGETSTARTED" then do
        theObject=arg(2)
        signal ON SYNTAX NAME errorHandler
        signal ON ERROR NAME errorHandler
        signal ON FAILURE NAME errorHandler

		INIFile=system.path.wpswizardini

	    parse SOURCE . . theScript
		scriptPath=filespec("d", theScript)||filespec("p", theScript)

        /* Info for storing data in WPS-wizard ini file */
        APPKEY="gcalendargadget"
		GROUPPOS="grouppos"
		GROUPBACKCOLOR="groupbackcolor"
		GROUPBORDER="groupborder"
		GROUPBORDERWIDTH="groupborderwidth"

        MONTHFONT="monthfont"
        MONTHCOLOR="monthcolor"

		MHEADFONT="mheadfont"
		MHEADCOLOR="mheadcolor"
		MHEADSCOLOR="mheadscolor"

		DAYFONT="dayfont"
		DAYCOLOR="daycolor"

		YEARFONT="yearfont"
		YEARCOLOR="yearcolor"
		YEARSCOLOR="yearscolor"

		/* Init standard values */
		childsLocked="YES"
		drawBorder=0
		NORMAL_BORDER=1
		SUNKEN_BORDER=2
		COLOR_BORDER=3

		/* Init language-dependent strings */
		rc=InitLanguage()

		/*** Let's start with the container ***/
		/* Default position after installation */
		defaultPos=system.screen.width-300||" 250 256 200"
		parse VAR defaultPos x y cx cy rest

		/* Default colors */
		backColor=X2D('8080ff')
		foreColor=X2D('dddddd')

		/* Get saved border info if any */
		ret=Sysini(INIFile, APPKEY, GROUPBORDER)
		if ret >< "ERROR:" then drawBorder=STRIP(ret)

		/* Create an image container gadget */
		stem._x=x		/* x  */
		stem._y=y		/* y  */
		stem._cx=cx		/* cx */
		stem._cy=cy		/* cy */

		stem._type=IMAGE_GADGET		/* Gadget type */
		stem._hwnd=arg(3)			/* hwnd */
		stem._flags=GSTYLE_POPUP + GSTYLE_NORESIZE	/* We want a popup menu and no resizing */
		select
			when drawBorder=COLOR_BORDER then
				stem._flags=stem._flags + GSTYLE_COLORBORDER
			when drawBorder=NORMAL_BORDER then
				stem._flags=stem._flags + GSTYLE_BORDER
			when drawBorder=SUNKEN_BORDER then
				stem._flags=stem._flags + GSTYLE_SUNKENBORDER
			otherwise
				nop
		end
		stem._font="10.Helv" /* font */

		/* Get (group) saved position if any */
		ret=Sysini(INIFile, APPKEY, GROUPPOS)
		if  ret >< "ERROR:" then do
			parse VAR ret stem._x stem._y stem._cx stem._cy rest
			x = stem._x
			y = stem._y
			cx = stem._cx
			cy = stem._cy
		end

		/* Create the gadget on the desktop */
		ret=WizCreateGadget("DESKTOP", "stem.", "groupGadget")
		call groupGadget.Image scriptPath||"gcalendar.gif"

		/* Get back color. This is the color of the border */
		ret=Sysini(INIFile, APPKEY, GROUPBACKCOLOR)
		if  ret >< "ERROR:" then
			call groupGadget.backcolor ret
		else
			call groupGadget.backcolor backcolor

		/*** Now we proceed with the first child: the calendar ***/
        /* Gadget create info */
        thestem._x=x+35                 /* x  */
        thestem._y=y                    /* y  */
        thestem._cx=cx-35               /* cx */
        thestem._cy=cy-53               /* cy */
        thestem._type=HTML_GADGET       /* Gadget type */
        thestem._hwnd=arg(3)            /* hwnd */
        thestem._flags=0				/* Nothing */
        thestem._font="6.System VIO"	/* font - must be monospaced */

        col1 = '<font color="#69708a">' /* Days (header) */
        col2 = '<font color="#ff308a">' /* Sunday (reddish) */
		col3 = '<font color="#6970ff">' /* Today (blueish) */
	    col8 = '<font color="#00bb00">' /* Week (greenish) */
        mon_str = xl8Strings.1

        /* Get saved font if any */
        ret=Sysini(INIFile, APPKEY, MONTHFONT)
        if  ret <> "ERROR:" then do
            thestem._font=ret
        end

        /* Create gadget */
        rc=WizCreateGadget("groupGadget", "thestem." , "monthGadget")

        /* Get saved color if any */
        ret=Sysini(INIFile, APPKEY, MONTHCOLOR)
        if  ret <> "ERROR:" then do
            call groupGadget.monthGadget.Color ret
        end

		/*** Second child: the month name ***/
        /* Gadget create info */
        thestem._x=x+63                 /* x  */
        thestem._y=y+130                /* y  */
        thestem._cx=150                 /* cx */
        thestem._cy=50                  /* cy */
        thestem._type=HTML_GADGET       /* Gadget type */
        thestem._hwnd=arg(3)            /* hwnd */
        thestem._flags=0				/* Nothing */
        thestem._font="10.Arial Black"	/* font */

        col4 = '<font color="#868d9f">' /* Big Month */

        /* Get saved font if any */
        ret=Sysini(INIFile, APPKEY, MHEADFONT)
        if  ret <> "ERROR:" then do
            thestem._font=ret
        end

        /* Create gadget */
        rc=WizCreateGadget("groupGadget", "thestem." , "monthHeadGadget")

        /* Get saved color if any */
        ret=Sysini(INIFile, APPKEY, MHEADCOLOR)
        if  ret <> "ERROR:" then do
            call groupGadget.monthHeadGadget.Color ret
        end

		/*** Third child: the month name's shadow ***/
        /* Gadget create info */
        thestem._x=x+70                 /* x  */
        thestem._y=y+125                /* y  */
        thestem._cx=150                 /* cx */
        thestem._cy=50                  /* cy */
        thestem._type=HTML_GADGET       /* Gadget type */
        thestem._hwnd=arg(3)            /* hwnd */
        thestem._flags=0				/* Nothing */
        thestem._font="10.Arial Black"	/* font */

        col5 = '<font color="#b6c1d5">' /* Big Month Shadow */

        /* Get saved font if any */
        ret=Sysini(INIFile, APPKEY, MHEADFONT)
        if  ret <> "ERROR:" then do
            thestem._font=ret
        end

        /* Create gadget */
        rc=WizCreateGadget("groupGadget", "thestem." , "monthShadeGadget")

        /* Get saved color if any */
        ret=Sysini(INIFile, APPKEY, MHEADSCOLOR)
        if  ret <> "ERROR:" then do
            call groupGadget.monthShadeGadget.Color ret
        end

		/*** Fourth child: the day number ***/
        /* Gadget create info */
        thestem._x=x+20                 /* x  */
        thestem._y=y+156                /* y  */
        thestem._cx=50                  /* cx */
        thestem._cy=30                  /* cy */
        thestem._type=HTML_GADGET       /* Gadget type */
        thestem._hwnd=arg(3)            /* hwnd */
        thestem._flags=0				/* Nothing */
        thestem._font="10.Arial Bold"	/* font */

        /* Get saved font if any */
        ret=Sysini(INIFile, APPKEY, DAYFONT)
        if  ret <> "ERROR:" then do
            thestem._font=ret
        end

        /* Create gadget */
  		rc=WizCreateGadget("groupGadget", "thestem." , "dayNumGadget")

        /* Get saved color if any */
        ret=Sysini(INIFile, APPKEY, DAYCOLOR)
        if  ret <> "ERROR:" then do
            call groupGadget.dayNumGadget.Color ret
        end

		/*** Fifth child ***/
        /* Gadget create info */
        thestem._x=x+182                /* x  */
        thestem._y=y+148                /* y  */
        thestem._cx=100                 /* cx */
        thestem._cy=30                  /* cy */
        thestem._type=HTML_GADGET       /* Gadget type */
        thestem._hwnd=arg(3)            /* hwnd */
        thestem._flags=0				/* Nothing */
        thestem._font="10.Courier Bold"	/* font - must be monospaced */

        /* Get saved font if any */
        ret=Sysini(INIFile, APPKEY, YEARFONT)
        if  ret <> "ERROR:" then do
            thestem._font=ret
        end

        col6 = '<font color="#ffffff">' /* Year */

        /* Create gadget */
        rc=WizCreateGadget("groupGadget", "thestem." , "yearNumGadget")

        /* Get saved color if any */
        ret=Sysini(INIFile, APPKEY, YEARCOLOR)
        if  ret <> "ERROR:" then do
            call groupGadget.yearNumGadget.Color ret
        end

		/*** Sixth child ***/
        /* Gadget create info */
        thestem._x=x+184                /* x  */
        thestem._y=y+146                /* y  */
        thestem._cx=100                 /* cx */
        thestem._cy=30                  /* cy */
        thestem._type=HTML_GADGET       /* Gadget type */
        thestem._hwnd=arg(3)            /* hwnd */
        thestem._flags=0				/* Nothing */
        thestem._font="10.Courier Bold"	/* font - must be monospaced */

        col7 = '<font color="#b6c1e5">' /* Year shadow */

        /* Get saved font if any */
        ret=Sysini(INIFile, APPKEY, YEARFONT)
        if  ret <> "ERROR:" then do
            thestem._font=ret
        end

        /* Create gadget */
        rc=WizCreateGadget("groupGadget", "thestem." , "yearShadeGadget")

        /* Get saved color if any */
        ret=Sysini(INIFile, APPKEY, YEARSCOLOR)
        if  ret <> "ERROR:" then do
            call groupGadget.yearShadeGadget.Color ret
        end

		/*** We proceed to initialize the whole gadget ***/
        /* Set gadget text - create calendar for current month */
		call monthCurrent

		/* Lock all childs */
		call groupGadget.monthGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
		call groupGadget.monthShadeGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
		call groupGadget.monthHeadGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
		call groupGadget.dayNumGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
		call groupGadget.yearNumGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
		call groupGadget.yearShadeGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE

        /* Start a timer sending a message every 1000ms  */
        ret=WPSWizCallWinFunc("winStartTimer", arg(3), 10, 1000)

        /* Gadget message loop */
        do forever
            ret=WizGetMessage(arg(3))
            if ret<>'' then
                interpret "call "ret
        end

        exit(0)
    end
    otherwise
        /* We shouldn't end here... */
        Exit(0)
end
exit(0)

groupGadget.onPopUp:
/*
	arg(1): hwnd of client area
	arg(2): x
	arg(3): y
*/
	menu.0=12
	if childsLocked="YES" then
		menu.1=xl8Strings.2
	else
		menu.1=xl8Strings.3

	menu.2="-" /* Separator */
	menu.3=xl8Strings.4
	menu.4=xl8Strings.5
	menu.5=xl8Strings.6
	menu.6=xl8Strings.7
    menu.7="-"
    menu.8=xl8Strings.8
    menu.9=xl8Strings.9
    menu.10=xl8Strings.10
	menu.11="-"
	menu.12=xl8Strings.11

	menu._x=arg(2)
	menu._y=arg(3)

	ret=WPSWizCallWinFunc("menuPopupMenu", arg(1), 'menu.')

	select
		when drawBorder=NORMAL_BORDER then
			ret=WPSWizCallWinFunc("menuCheckItem", ret, 4, 0, 1)
		when drawBorder=SUNKEN_BORDER then
			ret=WPSWizCallWinFunc("menuCheckItem", ret, 5, 0, 1)
		when drawBorder=COLOR_BORDER then
			ret=WPSWizCallWinFunc("menuCheckItem", ret, 6, 0, 1)
		otherwise
			ret=WPSWizCallWinFunc("menuCheckItem", ret, 3, 0, 1)
	end

return

groupGadget.onCommand:
/*
	arg(1): hwnd of client area
	arg(2): ID
	arg(3): source (menu or button)
*/
	parse SOURCE . . theScript

	select
	when arg(2)=1 then do
		if childsLocked="YES" then do
			/* Children are now unlocked */
			childsLocked="NO"
			call groupgadget.monthGadget.style 0, GSTYLE_NOACTIVATE
			call groupgadget.monthHeadGadget.style 0, GSTYLE_NOACTIVATE
			call groupgadget.monthShadeGadget.style 0, GSTYLE_NOACTIVATE
			call groupGadget.dayNumGadget.style 0, GSTYLE_NOACTIVATE
			call groupGadget.yearNumGadget.style 0, GSTYLE_NOACTIVATE
			call groupGadget.yearShadeGadget.style 0, GSTYLE_NOACTIVATE
		end
		else do
			childsLocked="YES"
			call groupgadget.monthGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
			call groupgadget.monthHeadGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
			call groupgadget.monthShadeGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
			call groupGadget.dayNumGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
			call groupGadget.yearNumGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
			call groupGadget.yearShadeGadget.style GSTYLE_NOACTIVATE, GSTYLE_NOACTIVATE
		end
	end
	when arg(2)=3 then do
		drawBorder=0
		call groupgadget.style 0, GSTYLE_SUNKENBORDER + GSTYLE_BORDER + GSTYLE_COLORBORDER
	end
	when arg(2)=4 then do
		/* User wants a border */
		drawBorder=1
		call groupgadget.style GSTYLE_BORDER, GSTYLE_SUNKENBORDER + GSTYLE_BORDER + GSTYLE_COLORBORDER
	end
	when arg(2)=5 then do
		/* Sunken border */
		drawBorder=2
		call groupgadget.style GSTYLE_SUNKENBORDER, GSTYLE_SUNKENBORDER + GSTYLE_BORDER + GSTYLE_COLORBORDER
	end
	when arg(2)=6 then do
		/* Color border */
		drawBorder=3
		call groupgadget.style GSTYLE_COLORBORDER, GSTYLE_SUNKENBORDER + GSTYLE_BORDER + GSTYLE_COLORBORDER
	end
    when arg(2) = 8 then do
        if mm > 1 then do
            mm = mm-1
            mm_days = word(mon_days,mm)
            base_1st = base_1st-mm_days
			dow_1st = weekDay(base_1st)+1
            day_dif = dow_1st-1
            call ShowMe
        end
    end
    when arg(2) = 9 then call monthCurrent
    when arg(2) = 10 then do
        if mm < 12 then do
            mm_dold = mm_days
            mm = mm+1
            mm_days = word(mon_days,mm)
            base_1st = base_1st+mm_dold
			dow_1st = weekDay(base_1st)+1
            day_dif = dow_1st-1
            call ShowMe
        end
    end
	when arg(2)=12 then do
		/* Gadget closes. Save configuration. */
		call SysIni iniFile, APPKEY, GROUPPOS, groupGadget.position()
		rc = Sysini(INIFile, APPKEY, GROUPBORDER, drawBorder)
		call SysIni iniFile, APPKEY, GROUPBACKCOLOR, groupGadget.Backcolor()
        call SysIni iniFile, APPKEY, MONTHFONT, groupGadget.monthGadget.font()
        call SysIni iniFile, APPKEY, MONTHCOLOR, groupGadget.monthGadget.Color()
        call SysIni iniFile, APPKEY, MHEADFONT, groupGadget.monthHeadGadget.font()
        call SysIni iniFile, APPKEY, MHEADCOLOR, groupGadget.monthHeadGadget.Color()
        call SysIni iniFile, APPKEY, MHEADSCOLOR, groupGadget.monthShadeGadget.Color()
        call SysIni iniFile, APPKEY, DAYFONT, groupGadget.dayNumGadget.font()
        call SysIni iniFile, APPKEY, DAYCOLOR, groupGadget.dayNumGadget.Color()
        call SysIni iniFile, APPKEY, YEARFONT, groupGadget.yearNumGadget.font()
        call SysIni iniFile, APPKEY, YEARCOLOR, groupGadget.yearNumGadget.Color()
        call SysIni iniFile, APPKEY, YEARSCOLOR, groupGadget.yearShadeGadget.Color()
        rc=wizDestroyGadget("groupGadget.yearShadeGadget")
        rc=wizDestroyGadget("groupGadget.yearNumGadget")
        rc=wizDestroyGadget("groupGadget.dayNumGadget")
        rc=wizDestroyGadget("groupGadget.monthShadeGadget")
        rc=wizDestroyGadget("groupGadget.monthHeadGadget")
		rc=wizDestroyGadget("groupGadget.monthGadget")
		rc=WizDestroyGadget("groupGadget")
		exit(0)
	end
	otherwise
		nop
	end
return

onTimer:
	if time('S')//60 = 0 then do
    	parse value date('S') WITH dy +4 dm +2 dd
	    select
    		when (dy = yy) & (dm = mm) then call ShowMe
	    	otherwise call monthCurrent
	    end
	end

return

monthCurrent:
	parse value date('S') WITH yy +4 mm +2 dd
	mm = mm/1
	dd = dd/1
	select
		when yy//400 = 0 then mon_days = '31 29 31 30 31 30 31 31 30 31 30 31'
	    when yy//100 = 0 then mon_days = '31 28 31 30 31 30 31 31 30 31 30 31'
    	when yy//4 = 0 then mon_days = '31 29 31 30 31 30 31 31 30 31 30 31'
	    otherwise mon_days = '31 28 31 30 31 30 31 31 30 31 30 31'
	end
	mm_days = word(mon_days,mm)
	base_now = date('B')+1
	base_1st = base_now-dd
	dow_1st = weekDay(base_1st)+1
	day_dif = dow_1st-1
	call ShowMe

return

/* weekDay returns 0 to 6, where 0=Monday, 6=Sunday (but see WeekStart param) */
weekDay: procedure expose WeekStart
	if arg()=0 then
		bDayNum = date('B')
	else
		bDayNum = arg(1)

	if WeekStart = 0 then				/* European: WeekStart is monday */
		wd = bDayNum//7
	else
		wd = ((bDayNum//7)+1)//7		/* American: WeekStart is sunday */
return wd

ShowMe:
	/* display calendar */
	if WeekStart = 0 then
		interpret 'myText='xl8Strings.12
	else
		interpret 'myText='xl8Strings.13
	do a = 1 TO mm_days+day_dif
    	d = a-day_dif
	    select
	        when d < 1 then myText = myText||copies(' ',4)
	        when d = dd then myText = myText||col3||right(d,4)||'</font>'
	        when (a//7 = 0) & (WeekStart = 0) then
				myText = myText||col2||right(d,4)||'</font>'
	        when (a//7 = 1) & (WeekStart = 1) then
				myText = myText||col2||right(d,4)||'</font>'
	        otherwise myText = myText||right(d,4)
	    end
	    if a//7 = 0 then do
	        myText = myText||'<br>'
	    end
	end
	select
	    when right(myText,4) = '<br>' then myText = myText
	    otherwise myText = myText||'<br>'
	end
	call groupGadget.monthGadget.text myText

	/* display month header */
	myText2='<h1>'||col4||word(mon_str,mm)||'</font></h1><br>'
	call groupGadget.monthHeadGadget.text myText2

	/* display month header shadow */
	myText3='<h1>'||col5||word(mon_str,mm)||'</font></h1><br>'
	call groupGadget.monthShadeGadget.text myText3

	/* display big day number */
	myText4 = '<h1>'||right(dd,2,'0')||'</1><br>'
	call groupGadget.dayNumGadget.text myText4

	/* display year number */
	myText5 = col6||yy||'</font><br>'
	call groupGadget.yearNumGadget.text myText5

	/* display year number shadow */
	myText6 = col7||yy||'</font><br>'
	call groupGadget.yearShadeGadget.text myText6

return

InitLanguage: procedure expose xl8Strings. theScript
	/* check args */
	if arg()=0 then
		Language = value("LANG",, "OS2ENVIRONMENT")
	else
		Language = arg(1)

	/* Init local vars */
	xl8Strings.0 = 0
	f = 0
	start = 0

	/* build the name of the strings file */
    lstfile = substr(theScript, 1, lastpos('.',theScript))||'xl8'

	/* extract the strings and store 'em in a stem :-) */
	if stream(lstfile,'C','QUERY EXISTS') <> '' then do
    	dummy = stream(lstfile,'C','OPEN READ')
    	do while lines(lstfile)
        	lstline = strip(linein(lstfile))
        	if lstline <> '' then
				if (left(lstline, 5)="LANG=") & (Pos(Language, lstline)<>0) then
					start = 1
				else if (start = 1) & (f < 13) then do
	           		f = f + 1
    	       		xl8Strings.f = lstline
	        	end
    	end
    	dummy = stream(lstfile,'C','CLOSE')
    	xl8Strings.0 = f
	end

	/* if the language is not found, fallback to english */
	if start = 0 then rc=InitLanguage("en_US")
return Language

quit:
exit(0)

errorHandler:
    parse SOURCE . . theScript

    ret=WPSWizGadgetFunc("cwDisplayRexxError", "")
    ret=WPSWizGadgetFunc("cwDisplayRexxError", theScript||": ")
    ret=WPSWizGadgetFunc("cwDisplayRexxError", "Error in line "||SIGL)

exit(0)

BuildLevel = "@#Cristiano Guadagnino:2006.05.15#@New Monthly Calendar Gadget (no_week version)"
