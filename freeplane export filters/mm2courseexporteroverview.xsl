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
</xsl:template>

<xsl:template name="showlectureinformation">
	<xsl:text disable-output-escaping="yes">&#xA;\section{</xsl:text>
	<xsl:value-of select="current()/@TEXT" disable-output-escaping="yes"/>
	<xsl:text>}</xsl:text>

	<xsl:call-template name="showlecturesubtitle"/>
	<xsl:call-template name="showlecturedate"/>

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

</xsl:stylesheet>

