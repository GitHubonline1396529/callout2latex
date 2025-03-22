%
% This is file `uglyrep.cls',
% created for displaying the function of the pandoc lua filter 
% `callout2latex.lua'.
%
% Copyright (C) 2025 Githubonline1396529 <yyg249942899@163.com>
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License (LPPL),
% either version 1.3c of this license or (at your option)
% any later version. The latest version of this license is in:
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of
% LaTeX version 2005/12/01 or later.
%
% This work has the LPPL maintenance status "maintained".
%
\ProvidesClass{example}[
  2025/03/20 An example document class to display the function of pandoc
  lua filter `callout2latex.lua'.
]
\NeedsTeXFormat{LaTeX2e}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Passing options to the article class.

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{extarticle}%
}
\ProcessOptions\relax

% Load the class. This document class is based on `article'.
\LoadClass{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load packages.

% Packages to deal with colors, and for creating color boxes.
\RequirePackage{color}
\RequirePackage{xcolor}
\RequirePackage{colortbl}
\RequirePackage{tcolorbox}

% Package to create theorem environments.
\RequirePackage{amsthm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define colors for alart blocks.

\definecolor{notetypecolor}{HTML}{316dca}%
\definecolor{warningtypecolor}{HTML}{BB8009}%
\definecolor{tiptypecolor}{HTML}{2EA043}%
\definecolor{importanttypecolor}{HTML}{8256D0}%
\definecolor{cautiontypecolor}{HTML}{C83C39}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Titles of the alart blocks.

\newcommand{\notetypename}{Note}
\newcommand{\warningtypename}{Warning}
\newcommand{\tiptypename}{Tip}
\newcommand{\importanttypename}{Important}
\newcommand{\cautiontypename}{Caution}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define tcolorbox format.

\tcbuselibrary{skins, breakable}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define tcolorboxes for info, warning, tips, important and caution.

\newtcolorbox{note}[1][]{%
  enhanced,
  breakable,
  colback=white, % Background color.
  colframe=notetypecolor, % Frame color.
  coltitle=white, % Title color.
  fonttitle=\bfseries\small, % Bold small font for block title.
  fontupper=\bfseries, % Bold normal sized font for block text.
  boxrule=0.75mm, % Frame line width.
  % arc=2mm, % Corner radius.
  left=2.5pt, right=2.5pt, % Paddings.
  top=2.5pt, bottom=2.5pt,
  title={\notetypename~\thetcbcounter}, % Title format.
}

\newtcolorbox{warning}[1][]{%
  enhanced,
  breakable,
  colback=white, % Background color.
  colframe=warningtypecolor, % Frame color.
  coltitle=white, % Title color.
  fonttitle=\bfseries\small, % Bold small font for block title.
  fontupper=\bfseries, % Bold normal sized font for block text.
  boxrule=0.75mm, % Frame line width.
  % arc=2mm, % Corner radius.
  left=2.5pt, right=2.5pt, % Paddings.
  top=2.5pt, bottom=2.5pt,
  title={\warningtypename~\thetcbcounter}, % Title format.
}

\newtcolorbox{tip}[1][]{%
  enhanced,
  breakable,
  colback=white, % Background color.
  colframe=tiptypecolor, % Frame color.
  coltitle=white, % Title color.
  fonttitle=\bfseries\small, % Bold small font for block title.
  fontupper=\bfseries, % Bold normal sized font for block text.
  boxrule=0.75mm, % Frame line width.
  % arc=2mm, % Corner radius.
  left=2.5pt, right=2.5pt, % Paddings.
  top=2.5pt, bottom=2.5pt,
  title={\tiptypename~\thetcbcounter}, % Title format.
}

\newtcolorbox{important}[1][]{%
  enhanced,
  breakable,
  colback=white, % Background color.
  colframe=importanttypecolor, % Frame color.
  coltitle=white, % Title color.
  fonttitle=\bfseries\small, % Bold small font for block title.
  fontupper=\bfseries, % Bold normal sized font for block text.
  boxrule=0.75mm, % Frame line width.
  % arc=2mm, % Corner radius.
  left=2.5pt, right=2.5pt, % Paddings.
  top=2.5pt, bottom=2.5pt,
  title={\importanttypename~\thetcbcounter}, % Title format.
}

\newtcolorbox{caution}[1][]{%
  enhanced,
  breakable,
  colback=white, % Background color.
  colframe=cautiontypecolor, % Frame color.
  coltitle=white, % Title color.
  fonttitle=\bfseries\small, % Bold small font for block title.
  fontupper=\bfseries, % Bold normal sized font for block text.
  boxrule=0.75mm, % Frame line width.
  % arc=2mm, % Corner radius.
  left=2.5pt, right=2.5pt, % Paddings.
  top=2.5pt, bottom=2.5pt,
  title={\cautiontypename~\thetcbcounter}, % Title format.
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define theorem environments.

\theoremstyle{plain}% default
\newtheorem{theorem}{Theorem}[section] %

\theoremstyle{definition} %
\newtheorem{definition}{Definition}[section] %

\theoremstyle{remark} %
\newtheorem*{remark}{Remark} %

\let\openbox\relax
\newtheoremstyle{plain}{\topsep}{\topsep}{}{}{%
  \bfseries}{}{%
  0.5em}{%
  \thmname{#1}\thmnumber{ #2}\thmnote{ (#3)}}

\newtheoremstyle{definition}{\topsep}{\topsep}{}{}{%
  \bfseries}{}{%
  0.5em}{}

\newtheoremstyle{remark}{\topsep}{\topsep}{}{}{
 \bfseries}{}{
  0.5em}{}
