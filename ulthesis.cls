\let\oldshow\show

% Loosely based on https://github.com/joaomlourenco/unlthesis
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ulthesis}[2015/06/11 UL Thesis Template]

% Process the options
% -------------------

% Key-value packages to process class options
\RequirePackage{xkeyval}
\RequirePackage{xifthen}

% Document type
% This can be any of the following:
%   bsc           - BSc report
%   premsc        - MSc prelimiary report
%   msc           - MSc dissertation
%   prephd        - PhD proposal
%   qualification - PhD qualification
%   phd           - PhD thesis
\DeclareOptionX{doctype}{
    \def\ulthesis@doctype{#1}
}

\DeclareOption{draft}{
    \PassOptionsToClass{draft}{memoir}
}

% Main language
%   pt - makes Portuguese the main language
%   en - makes English the main language (default)
\DeclareOptionX{lang}[en]{
    \ifthenelse{\equal{#1}{en}}{
        % English selected. Save this in \ulthesis@lang and pass the correct
        % options to the babel package
        \def\ulthesis@lang{en}
        \PassOptionsToPackage{portuguese,english}{babel}
    }{
    \ifthenelse{\equal{#1}{pt}}{
        % Portuguese selected. Save this in \ulthesis@lang and pass the correct
        % options to the babel package
        \def\ulthesis@lang{pt}
        \PassOptionsToPackage{english,portuguese}{babel}
    }{
        % Not one of the possible options selected. Make this an error
       \PackageError{ulthesis}%
       {Wrong value for option 'lang'}%
       {Please see the documentation}\expandafter\endinput}
    }
}

% Style for the bibliography
\DeclareOptionX{bibstyle}[]{
    \def\ulthesis@bibstyle{#1}
}

% Process all options
% -------------------
\ProcessOptionsX\relax


% Load class and packages
% -----------------------
\LoadClass[a4paper,11pt]{memoir}

% File encoding
\RequirePackage[utf8]{inputenc}

% Fonts
\RequirePackage[T1]{fontenc} % Use new T1 fonts
\RequirePackage{lmodern}     % Use lmodern instead of the default font

% Fine tuning of typesetting
\RequirePackage{microtype}

% Configure multilingual language support
\RequirePackage{babel}  % Support for bilingual documents
\RequirePackage{memory} % To store strings for later use, according to language

% Configure Graphics
\RequirePackage{graphicx}
\DeclareGraphicsExtensions{.pdf, .png, .jpg, .tif}

% Configure page geometry
% Needs version equal or later to 2010/02/12, which support the
% "newgeometry" command
\RequirePackage[
    top=3cm,
    bottom=2.5cm,
    inner=2.5cm,
    outer=2.5cm
]{geometry}[2010/02/12]


\RequirePackage[%
    backend=biber,
    natbib=true,
    firstinits=true,
    maxcitenames=2,
    uniquelist=false,
    style=alphabetic
]{biblatex}
    \renewcommand*{\labelalphaothers}{}
    \AtBeginBibliography{\small}


% Multi-language support
% ----------------------
\def\@make@memory#1{
    \def#1[##1]=##2{
        \expandafter\def\csname ulthesis@\expandafter\@gobble\string#1@##1\endcsname{##2}
    }
}

\@make@memory\babellanguagename
\@make@memory\abstractorder
\@make@memory\abstractname
\@make@memory\keywords
\@make@memory\acknowledgements
\@make@memory\notdefined

% Input definitions for strings above in multiple languages
\InputIfFileExists{internal/lang-constants}{}{}

% Now pull back the settings for the chosen language back to the
% language-agnostic macro
\def\@make@default#1{
    \expandafter\expandafter
    \expandafter\let
    \expandafter\expandafter
    \csname ulthesis@\expandafter\@gobble\string#1@def\endcsname
    \csname ulthesis@\expandafter\@gobble\string#1@\ulthesis@lang\endcsname
}

\@make@default\babellanguagename
\@make@default\abstractorder
\@make@default\abstractname
\@make@default\keywords
\@make@default\acknowledgements
\@make@default\notdefined

% If section names this are in Portuguese, change the listings name
\ifthenelse{\equal{\ulthesis@lang}{pt}}{
    \def\lstlistlistingname{Listagens}
}{}

% Select the language
\edef\mylang@{\csname ulthesis@babellanguagename@\ulthesis@lang\endcsname}
\expandafter\selectlanguage\expandafter{\mylang@}

% Macro for the cover page
% ------------------------
\def\coverpage{
    \thispagestyle{empty}
    \newgeometry{
        tmargin=2.5cm,
        bmargin=2.5cm,
        lmargin=2.5cm,
        rmargin=2.5cm
    }
    \pdfbookmark{Cover page}{Cover page}
    \begin{center}
        \type@cover@start
        \type@logo
        \type@title     \vfill
        \type@programme \vspace{1cm}
        \type@authors
        \type@bottom
    \end{center}
    \restoregeometry
    \cleardoublepage
}

\def\type@cover@start{
    UNIVERSIDADE DE LISBOA\par
    FACULDADE DE CI\^ENCIAS\par
}

\def\type@logo{
    \vspace{1.7cm}
    \includegraphics[height=3.6cm]{internal/logo-ciencias.png}\par
    \vspace{1.7cm}
}

\def\type@title{
    {\LARGE{\textbf{\ulthesis@title}}\par}
    \vspace{0.35cm}
    \emph{Documento provis\'orio}\par
}

\def\type@programme{
    \MakeUppercase{\ulthesis@programme}\par
    \MakeUppercase{\ulthesis@branch}\par
}

\def\type@authors{
    {\Large\ulthesis@author\par}
    \vspace{1cm}
    Tese orientada por:\\
    \@for\next:=\the\ulthesis@advisors@toks\do{%
        \next\\
    }
}

\def\type@bottom{
    \vspace{2.5cm}
    Documento especialmente elaborado para a obten\c c\~ao do grau de doutor
    \par
    \vspace{0.5cm}
    \ulthesis@date
}

% User defined constants
% ----------------------
\def\@make@uservariable#1{
    \def#1##1{
        \expandafter\def\csname ulthesis@\expandafter\@gobble\string#1\endcsname{##1}
    }
}

\@make@uservariable\department
\@make@uservariable\title
\@make@uservariable\programme
\@make@uservariable\branch
\@make@uservariable\author
\@make@uservariable\date

\def\advisor#1{
    \ifx\ulthesis@advisors@toks\relax
        \newtoks\ulthesis@advisors@toks
        \ulthesis@advisors@toks={#1}
    \else
        \ulthesis@advisors@toks=\expandafter{\the\ulthesis@advisors@toks,#1}
    \fi
}
\let\ulthesis@advisors@toks\relax


% Macros for including content
% ----------------------------

% Abstracts
\def\startabstract{
    \@ifnextchar[{\start@abstract}{\start@abstract[\ulthesis@lang]}
}

\def\start@abstract[#1]{
    % As per the babel documentation, changing language in a local manner
    % must be done inside two (!) groups. I do not understand this but it
    % is documented as such.
    
    \bgroup\bgroup
    % We start the grouping with \bgroup because the end of the group will
    % be taken care of by the new \include command that we create in this
    % group
    
    % Select the appropriate language
    \def\abstract@lang{#1}
    \edef\mylang@{\csname ulthesis@babellanguagename@\abstract@lang\endcsname}
    \expandafter\selectlanguage\expandafter{\mylang@}
    
    \let\@old@include\include
    \def\include##1{
        \@old@include{##1}\egroup\egroup
    }
    % If the next token is not \include, add \include to the token stream
    \@ifnextchar\include{}{\include}
}



% Typesetting configurations
% --------------------------
\def\@mylinespace{1.3}
\setSpacing{\@mylinespace}
\setPagenoteSpacing{\@mylinespace}
\setFloatSpacing{\@mylinespace}
\ifthenelse{\equal{\ulthesis@lang}{pt}}{
    \frenchspacing
}{}

\brokenpenalty=10000

% Set the maximum depth on the Table of contents
\setcounter{tocdepth}{2}
\maxsecnumdepth{subsubsection}

\let\old@toc\tableofcontents
\def\tableofcontents{\pdfbookmark{\contentsname}{toc}\old@toc}
\renewcommand\partnumberlinebox[2]{}

% Redefine \cleardoublepage to use a really empty page
\let\origcleardoublepage=\cleardoublepage
\def\cleardoublepage{%
    \newpage{\pagestyle{empty}\origcleardoublepage}
}


% Macros for the content

% Abstract
\renewenvironment{abstract}{
    \chapter*{\csname ulthesis@abstractname@\abstract@lang\endcsname}
}{}

% Keywords
\renewenvironment{keywords}{
    \par\vskip\baselineskip
    \noindent\textbf{\csname ulthesis@keywords@\abstract@lang\endcsname}
}{}


% Chapter style
\makechapterstyle{chapterstyle}{
    \setlength\beforechapskip{30pt}
    \setlength\midchapskip{10pt}
    
    \def\chapterheadstart{\vspace*{\beforechapskip}}
    \def\printchaptername{\chapnamefont\@chapapp}
    \def\chapternamenum{\space}
    \def\printchapternum{\chapnumfont\thechapter}
    \def\afterchapternum{\par\nobreak\vskip\midchapskip}
    \def\printchapternonum{}
    \def\printchaptertitle##1{\chaptitlefont##1}
    \def\afterchaptertitle{%
        \par\nobreak\vskip 5pt
        \rule{6cm}{0.4pt}%
        \vskip 30pt
    }
    
    \def\chapnamefont{\normalfont\LARGE\scshape\centering}
    \def\chapnumfont{\normalfont\LARGE}
    \def\chaptitlefont{\normalfont\huge\bfseries\centering}
    
}
\chapterstyle{chapterstyle}

\copypagestyle{chapter}{plain}
\makeoddfoot{chapter}{}{}{\thepage}

% Part style
\def\beforepartskip{\null\vskip 2in\relax}
\def\partnamefont{\Large\scshape\centering\MakeLowercase}
\def\partnumfont{\Large\scshape\centering\MakeLowercase}
\def\midpartskip{\par\rule{2in}{0.5pt}\par}
\def\printparttitle{\normalfont\huge\bfseries\centering}

% Allow for epigraphs in the part pages
\let\oldpart\part
\def\part#1{%
    \@ifnextchar\epigraph{\part@epigraph{#1}}{\oldpart{#1}}%
}
\def\part@epigraph#1\epigraph#2#3{%
    \let\oldafterpartskip\afterpartskip
    \def\afterpartskip{%
        \vskip 90pt
        \noindent
        \hfil
        \vbox{%
            \hsize=0.5\linewidth
            {
            \rightskip=0pt plus 20pt
            \parfillskip=0pt plus 1fil
            \noindent
            \sffamily #2\par
            }
            \vskip 2ex
            \leftskip=0pt plus 1fil
            \rightskip=0pt
            \parfillskip=0pt
            --- {\scshape #3}%
        }\hskip2em\par
        \vskip -90pt
        \oldafterpartskip
    }
    \oldpart{#1}
    \let\afterpartskip\oldafterpartskip
}


% The page style (headers / footers)
\setlength{\headheight}{15pt}
\aliaspagestyle{part}{empty}