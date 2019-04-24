<?xml version='1.0'?>
<!--MINDMAPEXPORTFILTER tex  Latex Beamer Course outline exporter
License     : This code is released under the GPL. [http://www.gnu.org/copyleft/gpl.html]
Document    : mm2courseexporteroverview.xsl 
Description : Transforms freemind mm format to latex course outline.
Author      : Henrik Skov Midtiby henrikmidtiby@gmail.com

See: http://freemind.sourceforge.net/
-->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>  
<xsl:output omit-xml-declaration="yes" encoding="ISO-8859-1" use-character-maps="returns" /> 


<xsl:character-map name="returns">
  <xsl:output-character character="&#13;" string="&#xD;"/>
</xsl:character-map> 


<xsl:template match="map">
	<xsl:call-template name="generate_preamble"/>
	<xsl:for-each select="node">
		<xsl:call-template name="showalllectures"/>
	</xsl:for-each>
	<xsl:text>\end{document}</xsl:text>
</xsl:template>


<xsl:template name="generate_preamble">
<xsl:text>% !TEX encoding = latin1
\documentclass[usepdftitle=false,professionalfonts,compress ]{article}

%Packages to be included
\usepackage[latin1]{inputenc}
\usepackage{multicol}
\usepackage{fancyhdr}
\usepackage{filecontents}
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0.1pt}
\lhead[]{}
\chead[]{}
\rhead[]{}
\lfoot[]{\today}
\cfoot[]{}
\rfoot[]{\thepage}

\begin{document}
</xsl:text>
</xsl:template>


<xsl:template name="showalllectures">
	<xsl:for-each select="node">
		<xsl:call-template name="showlecture"/>
	</xsl:for-each>
</xsl:template>


<xsl:template name="showlecture">
	<xsl:call-template name="showlectureinformation"/>
	<xsl:call-template name="showlecturecontent"/>

	<xsl:call-template name="export_lecture"/>
</xsl:template>


<xsl:template name="showlectureinformation">
	<xsl:text disable-output-escaping="yes">&#xA;\section{</xsl:text>
	<xsl:value-of select="current()/@TEXT" disable-output-escaping="yes"/>
	<xsl:text>}</xsl:text>

	<xsl:call-template name="showlecturesubtitle"/>
	<xsl:call-template name="showlecturedate"/>
	<xsl:call-template name="showlecturefilename"/>

	<xsl:text>&#xA;\hfill </xsl:text>
	<xsl:value-of select="count(child::node)"/>
	<xsl:text> main topics -- </xsl:text>
	<xsl:value-of select="count(child::*/child::node)"/>
	<xsl:text> subtopics -- </xsl:text>
	<xsl:value-of select="count(child::*/child::*/child::node)"/>
	<xsl:text> content slides \\</xsl:text>
</xsl:template> 


<xsl:template name="showlecturesubtitle">
	<xsl:if test="current()/attribute/@NAME = 'subtitle' ">
		<xsl:text>&#xA;subtitle: </xsl:text>
		<xsl:value-of select="current()/attribute[@NAME = 'subtitle']/@VALUE" disable-output-escaping="yes"/>
		<xsl:text>\\</xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template name="showlecturedate">
	<xsl:if test="current()/attribute/@NAME = 'date' ">
		<xsl:text>&#xA;\hfill date: </xsl:text>
		<xsl:value-of select="current()/attribute[@NAME = 'date']/@VALUE" disable-output-escaping="yes"/>
		<xsl:text>\par</xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template name="showlecturefilename">
	<xsl:variable name="count">
		<xsl:number/>
	</xsl:variable>
	<xsl:text>&#xA;\hfill filename: lecture</xsl:text>
	<xsl:value-of select='format-number($count, "000")'/>
	<xsl:text>.tex</xsl:text>
	<xsl:text>\par</xsl:text>
</xsl:template>


<xsl:template name="showlecturecontent">
	<xsl:for-each select="node">
		<xsl:call-template name="showtopic"/>
	</xsl:for-each>

	<xsl:text>&#xA;\newpage</xsl:text>
</xsl:template>


<xsl:template name="showtopic">
	<xsl:call-template name="showtopicinformation"/>
	<xsl:call-template name="showtopiccontent"/>
</xsl:template>


<xsl:template name="showtopicinformation">
	<xsl:text>\noindent &#xA;</xsl:text>
	<xsl:value-of select="@TEXT" disable-output-escaping="yes"/>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="count(child::*/child::node)"/>
	<xsl:text> slides)</xsl:text>
</xsl:template> 


<xsl:template name="showtopiccontent">
	<xsl:text>&#xA;{\footnotesize</xsl:text>
	<xsl:text>&#xA;\begin{multicols}{2}</xsl:text>
	<xsl:for-each select="node">
		<xsl:call-template name="showsubtopic"/>
	</xsl:for-each>
	<xsl:text>&#xA;\end{multicols}</xsl:text>
	<xsl:text>&#xA;}&#xA;</xsl:text>
</xsl:template>


<xsl:template name="showsubtopic">
	<xsl:text>&#xA;\noindent </xsl:text>
	<xsl:value-of select="@TEXT" disable-output-escaping="yes"/>
	<xsl:text> (</xsl:text>
	<xsl:value-of select="count(child::node)"/>
	<xsl:text> slides) &#xA;</xsl:text>
</xsl:template> 


<xsl:template name="export_lecture">
	<xsl:text>&#xA;</xsl:text>
	<xsl:call-template name="generate_lecture_compilation_script_file"/>
	<xsl:call-template name="generate_lecture_file"/>
</xsl:template>


<xsl:template name="generate_lecture_compilation_script_file">
	<xsl:variable name="count">
		<xsl:number/>
	</xsl:variable>
	<xsl:text>\begin{filecontents*}{lecture</xsl:text>
	<xsl:value-of select='format-number($count, "000")'/>
	<xsl:text>.sh}</xsl:text>
	<xsl:text>&#xA;</xsl:text>
	<xsl:text>#!/bin/sh

 
latexmk -pdf -pvc lecture</xsl:text>
	<xsl:value-of select='format-number($count, "000")'/>
	<xsl:text>.tex</xsl:text>
	<xsl:text>&#xA;</xsl:text>
	<xsl:text>\end{filecontents*}</xsl:text>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="generate_lecture_file">
	<xsl:variable name="count">
		<xsl:number/>
	</xsl:variable>
	<xsl:text>\begin{filecontents*}{lecture</xsl:text>
	<xsl:value-of select='format-number($count, "000")'/>
	<xsl:text>.tex}</xsl:text>

	<xsl:call-template name="latexheader"></xsl:call-template>

	<xsl:for-each select="node">
		<xsl:call-template name="generate_section"/>
	</xsl:for-each>
	<xsl:text>\end{document}</xsl:text>
	<xsl:text>&#xA;</xsl:text>
	<xsl:text>\end{filecontents*}</xsl:text>
	<xsl:text>&#xA;</xsl:text>
</xsl:template>


<xsl:template name="generate_section">
	<xsl:text>\section{</xsl:text>
	<xsl:value-of select="@TEXT" disable-output-escaping="yes"/>
	<xsl:text>}&#xA;&#xA;</xsl:text>
	<xsl:for-each select="node">
		<xsl:call-template name="generate_subsection"/>
	</xsl:for-each>
</xsl:template>


<xsl:template name="generate_subsection">
	<xsl:text>\subsection{</xsl:text>
	<xsl:value-of select="@TEXT" disable-output-escaping="yes"/>
	<xsl:text>}&#xA;&#xA;</xsl:text>
	<xsl:for-each select="node">
		<xsl:call-template name="generate_frame"/>
	</xsl:for-each>
</xsl:template>


<xsl:template name="generate_frame">
	<xsl:text>{&#xA;</xsl:text>
		
	<xsl:text>\begin{frame}</xsl:text>

	<xsl:call-template name="setoptionsforframe"></xsl:call-template>

	<xsl:text>&#xA;\frametitle{</xsl:text>
	<xsl:value-of select="(@TEXT)" disable-output-escaping="yes"/>
	<xsl:text>}</xsl:text>
	<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
		<xsl:call-template name="richtext"></xsl:call-template>
	</xsl:if>

	<xsl:if test="current()/node and current()/node/@TEXT != ''">
		<xsl:call-template name="itemization"></xsl:call-template>
	</xsl:if>
	<xsl:text>&#xA;\end{frame}&#xA;</xsl:text>
	<xsl:text>}&#xA;&#xA;</xsl:text>
</xsl:template>


<xsl:template name="latexheader">
<xsl:text>
% !TEX encoding = latin1
\documentclass[usepdftitle=false,professionalfonts,compress]{beamer}

% Packages to be included
\usepackage[latin1]{inputenc}
\usepackage{hsmpresentation}</xsl:text>
<!-- Currently loading packages from options fails... -->
<!-- Currently loading packages from options fails... -->
<!-- Currently loading packages from options fails... -->
<!-- Currently loading packages from options fails... -->
<xsl:if test="current()/attribute/@NAME = 'usepackage' ">
	<xsl:text>
\usepackage{</xsl:text>
	<xsl:value-of select="current()/attribute[@NAME = 'usepackage']/@VALUE" disable-output-escaping="yes"/>
	<xsl:text>}</xsl:text>
</xsl:if>

<xsl:if test="current()/attribute/@NAME = 'theme' ">
	<xsl:text>

% Beamer Theme
\usetheme[]{</xsl:text>
	<xsl:value-of select="node/attribute[@NAME = 'theme']/@VALUE" disable-output-escaping="yes"/>
	<xsl:text>}</xsl:text>
</xsl:if>

		<xsl:text>&#xA;</xsl:text>
<xsl:text>% PDF meta data inserted here 
\hypersetup{
	pdftitle={</xsl:text><xsl:value-of select="current()/@TEXT" disable-output-escaping="yes"/><xsl:text>},
	pdfauthor={</xsl:text><xsl:if test="current()/attribute/@NAME = 'author' "><xsl:value-of select="current()/attribute[@NAME = 'author']/@VALUE" disable-output-escaping="yes"/></xsl:if><xsl:text>}
}
</xsl:text>


<xsl:text disable-output-escaping="yes">
\title{</xsl:text><xsl:value-of select="current()/@TEXT" disable-output-escaping="yes"/><xsl:text>}
</xsl:text>

<xsl:if test="current()/attribute/@NAME = 'subtitle' ">
	<xsl:text>\subtitle{</xsl:text>
	<xsl:value-of select="current()/attribute[@NAME = 'subtitle']/@VALUE" disable-output-escaping="yes"/>
	<xsl:text>}
</xsl:text>
</xsl:if>
<xsl:if test="current()/attribute/@NAME = 'author' ">
	<xsl:text>\author{</xsl:text>
	<xsl:value-of select="current()/attribute[@NAME = 'author']/@VALUE" disable-output-escaping="yes"/>
	<xsl:text>}
</xsl:text>
</xsl:if>
<xsl:if test="current()/attribute/@NAME = 'institute' ">
	<xsl:text>\institute{</xsl:text>
	<xsl:value-of select="current()/attribute[@NAME = 'institute']/@VALUE" disable-output-escaping="yes"/>
	<xsl:text>}
</xsl:text>
</xsl:if>
<xsl:if test="current()/attribute/@NAME = 'date' ">
	<xsl:text>\date{</xsl:text>
	<xsl:value-of select="current()/attribute[@NAME = 'date']/@VALUE" disable-output-escaping="yes"/>
	<xsl:text>}
</xsl:text>
</xsl:if>

<xsl:text>
\begin{document}
\frame[plain]{
	\frametitle{}
	\titlepage
	\vspace{-0.5cm}
}

</xsl:text>

</xsl:template>


<xsl:template name="setoptionsforframe">
	<!-- Add possibility of setting options for individual slides frames -->
	<xsl:if test="(current()/attribute/@NAME = 'options')">
		<xsl:text>[</xsl:text>
		<xsl:value-of select="current()/attribute[@NAME = 'options']/@VALUE" disable-output-escaping="yes"/>
		<xsl:text>]</xsl:text>
	</xsl:if>
</xsl:template>


<xsl:template name="itemization">
	<xsl:param name="i" select="current()/node"/>
	<xsl:text>&#xA;\begin{itemize}</xsl:text>
	<xsl:for-each select="$i">
		<xsl:text>&#xA;</xsl:text>
		<xsl:text>\item </xsl:text>
		<xsl:value-of select="@TEXT" disable-output-escaping="yes"/>
		
		<xsl:if test="current()/node">
			<xsl:call-template name="itemization"></xsl:call-template>
		</xsl:if>
		<xsl:text> </xsl:text>	
	</xsl:for-each>

	<xsl:text>&#xA;\end{itemize}</xsl:text>
</xsl:template>


<!-- template to parse and insert rich text (html, among <p> in Latex \item-s -->
<xsl:template name="richtext">
	<xsl:param name="i" select="current()/richcontent/html/body/p"/>
	<xsl:for-each select="$i">
		<xsl:text>&#xA;</xsl:text>
		<xsl:value-of select="normalize-space(.)" disable-output-escaping="yes"/>
		<xsl:text> </xsl:text>
	</xsl:for-each>
</xsl:template>


</xsl:stylesheet>

