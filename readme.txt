NewMonthGadget - a new cool calendar gadget for WPSWizard
=========================================================

Table of contents:
^^^^^^^^^^^^^^^^^^
    -> Requirements
    -> What's NewMonthGadget?
    -> Why the optional requirements?
    -> Installation
    -> Upgrade
    -> I want to customize the gadget!!
    -> How did you achieve transparency?
    -> Changelog
    -> Links
    -> Thanks


Requirements
^^^^^^^^^^^^
- WPSWizard 0.5.1+
- (optional) Innotek Font Engine
- (optional) Arial Black font from the "MS Core Web Fonts" package


What's NewMonthGadget?
^^^^^^^^^^^^^^^^^^^^^^
NewMonthGadget is a gadget for WPSWizard 0.5.1+. A gadget is something used
to display information embedded in the desktop.

Compared to the default MonthGadget included in the WPSWizard distribution,
this one has a nicer look. You can have an idea of the look by opening one
of the screenshots in this package (newcalendar1.png and newcalendar2.png).

I got the inspiration to create this gadget by one of the gadgets used in
Object Desktop (you can see the original in the included odnt-july03.jpg
picture).


Why the optional requirements?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You can greatly improve the look of the gadget (and the look of your whole
OS/2 or eCS desktop) by installing the Innotek Font Engine. This provides
antialiased fonts to OS/2-eCS. I highly recommend it for improved font
readability (see below for a download link).

Please note that if you want your gadget to show smooth fonts you have to add
"PMSHELL.EXE" to the list of Font Engine enabled applications (see below for a
download link to the Feffer utility). This is NOT SUPPORTED by Innotek, and may
lead to instability (but I have had no problems with it).

I also recommend using the M$ Core Web Fonts for improved font rendering and
readability (see below for a download link). You will find that a lot of web
pages use these fonts, so you will have a better browsing experience.

If you don't want to use the Core Web Fonts you can substitute the "Arial
Black" font used in the gadget by "Arial Bold" (but you have to edit the
gadget code).


Installation
^^^^^^^^^^^^
Simply copy the following files to the WPSWizard gadgets directory (on my
system this is g:\WPSWizard\bin\gadgets):

- NewMonthGadget.cmd
- NewMonthGagdet.xl8
- gcalendar.gif
- (optional) CleanIni.cmd

Then create a program object for NewMonthGadget.cmd and place it in your
Startup folder.

The CleanIni.cmd file may come in handy if you want to customize your gadget
(see below). While customizing you may do something wrong that you want to
undo: CleanIni cleans the WPSWizard INI file so that the gadget will return to
is initial state. Note that WPSWizard's INI file is usually located under your
HOME directory.


Upgrade
^^^^^^^
Simply copy the new files over the old ones. You may have to run CleanIni.cmd
to use the new default font (see changelog of 2006-02-21 below).

You can now have the week start on Sunday instead of Monday: see the changelog
for 2006-03-13 below.

If you don't like the week number display column introduced on 2006-02-21, you
can use the "-noweek" version of the gadget (you have to copy the related .xl8
file too).


I want to customize the gadget!!
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
You can customize the gadget even without knowing rexx and/or gadgets, by
simply using drag and drop of fonts and colors.

First of all, you'll probably want to move the gadget on your desktop, but you
can't simply drag it because the gadget is embedded into the desktop. To move
it, CTRL+Click on it with your left mouse button. You'll see a square that you
can move around by dragging it with the mouse. Once you're satisfied with the
position, CTRL+Click again and it will return to its embedded state.

If you want to do other customizations, CTRL+Click on the gadget and then click
with your right mouse button. This will bring up a context menu with a few
entries:

- Close gadget: this will close the gadget (and save your customizations)
- Unlock children: (see below)
- No Border, Border, Sunken Border, Color Border: this will draw or remove the
  border around the gadget (you see a color border in the newcalendar1.png
  image)
- Previous, Current, Next: this will change the displayed month

Let's explore the "Unlock Children" entry: a gadget can be built around a few
sub-gadgets (or "children"), as is the case with the NewMonthGadget, which is
built around six children. We'll examine them starting from top-left:

   - the day number
   - the month name
   - the month name's shadow
   - the year
   - the year's shadow
   - the monthly calendar

Once you have unlocked the children, you CTRL-Click again on the gadget to
return it to its embedded state. If you now CTRL+Click on a child area you'll
be editing the single child, NOT the whole gadget.

You can now move or size each child, and you can drag and drop fonts or colors
onto the child. Once you're satisfied with the results, CTRL+Click on the child
to return it to the embedded state, then CTRL+Click on an area not occupied by
any of the children (the easiest spot is on the bottom-left) to edit the base
(container) gadget. You can now bring up the context menu and choose "lock
children" to return it to its initial state. At this point I recommend to close
and reopen the gadget to force the saving of your customizations.


How did you achieve transparency?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Short explanation: I did not achieve it ;-)

Long explanation: In the newcalendar2.png picture you can see a seemingly
transparent gadget. The gcalendar.gif picture actually has transparency
information, but the OS/2-eCS multimedia I/O procedures responsible for reading
and displaying GIF images (or any other image format supporting transparency)
aren't capable of using this information. The developer of the PNGIO I/O proc
(available on the eComStation BetaZone) says in the "readme" that he wants to
implement support for transparency in the next major release, so we may have
a transparent gadget in future.
The newcalendar2.png image is obtained by changing the base calendar image
(gcalendar.gif) to have the same background color as my desktop. You can do it
too, with an image editing program and a little fantasy.


Changelog
^^^^^^^^^
2006-05-15
- corrected a bug: the gadget would not update correctly upon month change
- added the "noweek" gadget for those who do not like the week number display
  column (requested feature)

2006-03-21
- added translation kit: all the language-dependent strings are held in the
  NewMonthGadget.xl8 file. If you want to add a language, simply follow the
  structure and add your strings.
- the gadget will automatically adapt to the language of the system, if
  available, by reading the LANG environment variable; it will fall-back to
  english otherwise
- added italian translation
- changed german translation for the new kit
- changed the "german" folder to "intl_docs" folder: it now contains the
  translated "readme" files
- moved the editable variables to the start of the gadget code to simplify
  editing

2006-03-13
- added option to change start of week (Sunday or Monday). You have to change
  the value of the WeekStart variable in the script (line 60).
- added BuildLevel information to the gadget
- added the "backgrounds" folder to host user-created backgrounds for the
  gadget. At present it only contains one new backgrounds from David Graser.
  If you want to use it, rename it to gcalendar.gif and overwrite the original.
- added the "german" folder to host german translation. It contains the
  german translation made by Rudolf H”ger. The translated gadget is the
  2006-02-21 version, but I don't think this is a problem, since German users
  should be comfortable with the week starting on monday ;-) In the future I'd
  like to provide a more comfortable way of translating the gadget by
  decoupling the code from the strings.

2006-02-21
- added week number to the calendar (requested feature)
- changed default calendar font to accommodate the new column
- updated screenshots to show new feature
- added 'Upgrade' section to the readme.txt file

2006-02-09
- changed popup menu to be more intuitive
- changed "childs" to "children" ;-)

2006-02-07
- first public release

2004-03-24
- first internal release


Links
^^^^^
Innotek Font Engine:
 http://download.innotek.de/ft2lib/InnoTek_FT2LIB_260_Beta1.exe

MS Core Web Fonts Downloader:
 http://www.ecomstation.org/vitalfiles/MSFONTPACK1_2-fixed.zip

Feffer (Front-End For Font Engine Registry):
 http://www.os2world.com/forum/Public/Uploads/Post-83-68-feffer_0_9_2.zip (base)
 http://www.os2world.com/forum/Public/Uploads/Post-83-94-FFR093.ZIP (update)


Thanks
^^^^^^
Thanks to Chris Wohlgemuth for his great WPSWizard, and for all his hard work
on extending OS/2 and making it better. This little gadget is a sign of
appreciation, and is intended as the first of a series of gadgets. I hope this
will inspire other people to do the same... WPSWizard holds a lot of potential.
Chris, you can obviously include this gadget in your next release of WPSWizard
if you like.

Thanks to David Graser for his work on a new background for the gadget.

Thanks to Rudolf H”ger for the german translation of the gadget.

Thanks to Serenity Systems for the great eComStation, and for keeping OS/2
alive and kicking.

Thanks to anyone who will use and like this little gadget. Please write me if
you use it, I'd like to know!

Enjoy!

              Cris

              (criguada _at_ libero .dot. it)
