%%
%%
%%

\ProvidesClass{asu-nateph}[2021/03/30 Version 0.1]
\RequirePackage{graphicx}
\RequirePackage{ifthen}
\RequirePackage{setspace}
% \RequirePackage{secsty}
% \RequirePackage{xparse}
% Required packages
% \RequirePackage{hyperref}
% \hypersetup{
%   linktocpage,
%   colorlinks,
%   citecolor=black,
%   filecolor=black,
%   linkcolor=black,
%   urlcolor=black,
% }

%-----------------------------------------------------------------------
% Names of environments
%-----------------------------------------------------------------------

\newcommand{\bachelordegree}[1]{\ifx\empty#1\else\gdef\@bachelordegree{#1}\fi}
\newcommand{\asudegree}[1]{\ifx\empty#1\else\gdef\@asudegree{#1}\fi}
\newcommand{\degreeabbrev}[1]{\ifx\empty#1\else\gdef\@degreeabbrev{#1}\fi}
\newcommand{\department}[1]{\ifx\empty#1\else\gdef\@department{#1}\fi}
\newcommand{\gradmonth}[1]{\ifx\empty#1\else\gdef\@gradmonth{#1}\fi}
\newcommand{\gradyear}[1]{\ifx\empty#1\else\gdef\@gradyear{#1}\fi}
\newcommand{\thesischair}[1]{\ifx\empty#1\else\gdef\@thesischair{#1}\fi}
\newcommand{\thesismemberone}[1]{\ifx\empty#1\else\gdef\@thesismemberone{#1}\fi}
\newcommand{\thesismembertwo}[1]{\ifx\empty#1\else\gdef\@thesismembertwo{#1}\fi}
\newcommand{\thesismemberthree}[1]{\ifx\empty#1\else\gdef\@thesismemberthree{#1}\fi}
\newcommand{\deptchair}[1]{\ifx\empty#1\else\gdef\@deptchair{#1}\fi}
\newcommand{\dean}[1]{\ifx\empty#1\else\gdef\@dean{#1}\fi}
\newcommand{\authorcaps}[1]{\ifx\empty#1\else\gdef\@authorcaps{#1}\fi}
\renewcommand{\author}[1]{\ifx\empty#1\else\gdef\@author{#1}\fi}
\renewcommand{\title}[1]{\ifx\empty#1\else\gdef\@title{#1}\fi}

%-----------------------------------------------------------------------
% Load original class
%-----------------------------------------------------------------------

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{./class/nateph}}
\ExecuteOptions{gradschool,MS,doublespace,newstyle,bind}
\ProcessOptions\relax
\LoadClass[12pt,letterpaper]{./class/nateph}


% -----------------------------------------------------------------------
% TITLE PAGES:
% a) make title page and copyright page
% b) if we're making g-school approved vers, make UMI abs page
% -----------------------------------------------------------------------

%-------------------------------------------------------------------------
% Prelminary - \preliminary
%-------------------------------------------------------------------------
\newenvironment{preliminary}
  {\pagestyle{plain}\pagenumbering{roman}\begin{spacing}{1}}
  {\end{spacing}\cleardoublepage\pagenumbering{arabic}}

%-------------------------------------------------------------------------
% Title - \maketitle
%-------------------------------------------------------------------------
\renewcommand{\maketitle}{
   \begin{titlepage}
   \vspace*{0.5in}
   \begin{center}
      {\@title} \\[25ex]
      A Thesis \\
      by \\
      {\@authorcaps} \\[6ex]
      Submitted to the Graduate School \\
      Appalachian State University \\
      in partial fulfillment of the requirements for the degree of \\
      {\@asudegree} \\[12ex]
      {\@gradmonth} {\@gradyear} \\
      Department of {\@department}
   \end{center}
   \setcounter{page}{1}
   \end{titlepage}
   \setcounter{page}{2}
}


%-------------------------------------------------------------------------
% Approval - \makeapproval
%-------------------------------------------------------------------------
% \NewDocumentCommand{\codeTextOptional}{ O{} }{\codeText{#1}}
\newcommand{\signatureWidth}{2.70in}
\newcommand{\signatureHeight}{3.6ex}
\newcommand{\makeapproval}{
   \thispagestyle{empty}
   % \vspace*{0.125in}
   \begin{center}
      {\@title} \\
      \vspace{0.50in}
      A Thesis \\
      by \\
      {\@authorcaps} \\
      {\@gradmonth} {\@gradyear}
   \end{center}
   \vspace{1.5cm}
   APPROVED BY: \\ [\signatureHeight]
   \underline{\hspace{\signatureWidth}} \\
   {\@thesischair} \\
   Chairperson, Thesis Committee \\[\signatureHeight]
   \underline{\hspace{\signatureWidth}} \\
   {\@thesismemberone} \\
   Member, Thesis Committee \\[\signatureHeight]
   \underline{\hspace{\signatureWidth}} \\
   {\@thesismembertwo} \\
   Member, Thesis Committee \\[\signatureHeight]
   \underline{\hspace{\signatureWidth}} \\
   {\@thesismemberthree} \\
   Member, Thesis Committee \\[\signatureHeight]
   \underline{\hspace{\signatureWidth}} \\
   {\@deptchair} \\
   Chairperson, Department of {\@department} \\[\signatureHeight]
   \underline{\hspace{\signatureWidth}} \\
   {\@dean} \\
   Dean, Cratis D. Williams School of Graduate Studies
   \newpage
}

%-------------------------------------------------------------------------
% Copyright - \makecopyright
%-------------------------------------------------------------------------
\providecommand{\makecopyright}{}
\renewcommand{\makecopyright}{
  \thispagestyle{empty}
  \vspace*{3.5in}
  \begin{center}
  Copyright{\copyright} {\@author} {\@gradyear}\\
  All Rights Reserved
  \end{center}
  \setcounter{page}{3}
  \newpage
}

%-------------------------------------------------------------------------
% Abstract - \abstract
%-------------------------------------------------------------------------
\renewenvironment{abstract}{
  % \vspace*{0.5in}
  % \addcontentsline{toc}{chapter}{Abstract}
  % {\bf Abstract} \\[2ex]
  \begin{spacing}{1}
    \titlespacing*{\chapter}{0pt}{*1}{*1}
    \nmchapter{\abstractname}
  \end{spacing}

    \begin{center}
      % {\bf Abstract} \\[2ex]
      \begin{spacing}{1}
        {\@title}
      \end{spacing}

      \vspace{\baselineskip}
      \begin{spacing}{1}
        {\@author}\\
        {\@bachelordegree}\\
        {\@degreeabbrev}, Appalachian State University
      \end{spacing}

      Chairperson:  {\@thesischair}
    \end{center}
   \setstretch{2}
}{\par\newpage}

%-------------------------------------------------------------------------
% Acknowledgment - \acknowledgments
%-------------------------------------------------------------------------
% \renewenvironment{acknowledgements}{
%    \vspace*{0.5in}
%    \begin{center}
%       ACKNOWLEDGEMENTS \\[2ex]
%    \end{center}
%    \setstretch{2}
% }{\par\newpage}

\renewenvironment{acknowledgements}{
   % \vspace*{0.5in}
   % \begin{center}
   %   {\bf Acknowledgments} \\[2ex]
   % \end{center}
  \begin{spacing}{1}
    \titlespacing*{\chapter}{0pt}{*1}{*1}
    \nmchapter{\ackname}
  \end{spacing}

   \setstretch{2}
}{\par\newpage}

%-------------------------------------------------------------------------
% Dedication - \dedication
%-------------------------------------------------------------------------
\renewenvironment{dedication}{
   \vspace*{0.5in}
   \setstretch{2}
}{\par\newpage}



\setlength{\parindent}{0.5in}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

%-------------------------------------------------------------------------
% Sections!
%-------------------------------------------------------------------------
% \renewcommand\section{\@startsection {section}{1}{\z@}%
%                                    {-3.5ex \@plus -1ex \@minus -.2ex}%
%                                    {2.3ex \@plus.2ex}%
%                               {\normalbaselines\normalfont\Large\bfseries}}


%
%  MARGINS
%
%  Sets margins to 1 1/2" left margin and 1" everywhere else.
%
\setlength{\voffset}{0in}
\setlength{\hoffset}{0.25in}

\setlength{\textheight}{\paperheight}
\setlength{\textwidth}{\paperwidth}

% Dr. Parry's settings:
\addtolength{\textheight}{-2in}
\setlength{\topmargin}{0in}
\setlength{\headsep}{0in}
\setlength{\footskip}{.5in}
\setlength{\headheight}{0in}

% Dr. Fenwick's Original Settings:
% \addtolength{\textheight}{-2in}
% \setlength{\topmargin}{1in}
% \setlength{\headsep}{.5in}
% \setlength{\footskip}{.5in}

\setlength{\textwidth}{6.25in}
\setlength{\oddsidemargin}{0in}
\setlength{\evensidemargin}{0in}
\setlength{\marginparwidth}{0in}
\setlength{\marginparsep}{0in}
\setlength{\marginparpush}{0in}
\flushbottom
