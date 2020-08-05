<?xml version='1.0'?>
<!--MINDMAPEXPORTFILTER tex  Assess reports (RMURV2) - mm2assessing_reports.xsl
License     : This code is released under the GPL. [http://www.gnu.org/copyleft/gpl.html]
Document    : mm2courseexporteroverview.xsl 
Description : Transforms freemind mm format to latex course outline.
Author      : Henrik Skov Midtiby henrikmidtiby@gmail.com

See: http://freemind.sourceforge.net/
-->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>  
<xsl:output omit-xml-declaration="yes" encoding="UTF8" use-character-maps="returns" /> 


<xsl:character-map name="returns">
  <xsl:output-character character="&#13;" string="&#xD;"/>
</xsl:character-map> 


<xsl:template match="map">
	<xsl:for-each select="node">
		<xsl:call-template name="showalllectures"/>
	</xsl:for-each>
	<xsl:text>\end{document}</xsl:text>
</xsl:template>


<xsl:template name="generate_preamble">
<xsl:text>% !TEX encoding = utf8
\documentclass[usepdftitle=false,professionalfonts,compress,a4paper]{article}

%Packages to be included
\usepackage[utf8]{inputenc}
\usepackage{multicol}
\usepackage{fancyhdr}
\usepackage{filecontents}
\usepackage[top=3cm]{geometry}
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\lhead[]{</xsl:text>
<xsl:value-of select="@TEXT" disable-output-escaping="yes"/>
<xsl:text>}
\chead[]{}
\rhead[]{\today}
\lfoot[]{}
\cfoot[]{}
\rfoot[]{}

\begin{document}
</xsl:text>
</xsl:template>


<xsl:template name="showalllectures">
	<xsl:call-template name="generate_preamble"/>
	<xsl:for-each select="node">
		<xsl:call-template name="showlecture"/>
	</xsl:for-each>
</xsl:template>


<xsl:template name="showlecture">
	<xsl:call-template name="showlectureinformation"/>
	<xsl:call-template name="itemization"/>
</xsl:template>


<xsl:template name="showlectureinformation">
	<xsl:text disable-output-escaping="yes">&#xA;\newpage</xsl:text>
	<xsl:text disable-output-escaping="yes">&#xA;\section*{</xsl:text>
	<xsl:value-of select="current()/@TEXT" disable-output-escaping="yes"/>
	<xsl:text>}</xsl:text>
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

