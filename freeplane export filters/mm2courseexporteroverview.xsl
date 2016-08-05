<?xml version='1.0'?>
<!--MINDMAPEXPORTFILTER tex  Latex Beamer Course outline exporter
License     : This code is released under the GPL. [http://www.gnu.org/copyleft/gpl.html]
Document    : mm2latexbeamer_richcontent.xsl based on mm2latexbeamer 
Description : Transforms freemind mm format to latex beamer presentations.

See: http://freemind.sourceforge.net/
-->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>  
<xsl:output omit-xml-declaration="yes" encoding="ISO-8859-1" use-character-maps="returns" /> 


<xsl:character-map name="returns">
  <xsl:output-character character="&#13;" string="&#xD;"/>
 </xsl:character-map> 



<xsl:template match="map">

<!-- ==== HEADER ==== -->
<xsl:text>

% !TEX encoding = latin1
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

</xsl:text>
<!--
<xsl:if test="node/attribute/@NAME = 'usepackage' ">
	<xsl:text>&#xD;\usepackage{</xsl:text>
	<xsl:value-of select="node/attribute[@NAME = 'usepackage']/@VALUE" disable-output-escaping="yes"/>
	<xsl:text>}</xsl:text>
</xsl:if>
-->

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Begin Document  %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\begin{document}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%% Content starts here %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


<!-- <xsl:apply-templates select="node"/> -->
<xsl:apply-templates/>

</xsl:template>


<!-- ======= Body ====== -->
<xsl:template match="richcontent">
</xsl:template> <!--Avoids to write notes contents at the end of the document-->

<xsl:template match="node">
	<xsl:if test="(count(ancestor::node())-2)=0">
		<xsl:apply-templates/>
		<xsl:text>\end{document}</xsl:text>
	</xsl:if>
	<xsl:if test="(count(ancestor::node())-2)=1">
		<xsl:text disable-output-escaping="yes">\section{</xsl:text>
		<xsl:value-of select="current()/@TEXT" disable-output-escaping="yes"/>
		<xsl:text>}</xsl:text>

		<xsl:if test="current()/attribute/@NAME = 'subtitle' ">
			<xsl:text>&#xA;subtitle: </xsl:text>
			<xsl:value-of select="current()/attribute[@NAME = 'subtitle']/@VALUE" disable-output-escaping="yes"/>
			<xsl:text>\\</xsl:text>
		</xsl:if>
		<xsl:if test="current()/attribute/@NAME = 'date' ">
			<xsl:text>&#xA;\hfill date: </xsl:text>
			<xsl:value-of select="current()/attribute[@NAME = 'date']/@VALUE" disable-output-escaping="yes"/>
			<xsl:text>\par</xsl:text>
		</xsl:if>

		<xsl:text>&#xA;\hfill </xsl:text>
		<xsl:value-of select="count(child::node)"/>
		<xsl:text> main topics -- </xsl:text>
		<xsl:value-of select="count(child::*/child::node)"/>
		<xsl:text> subtopics -- </xsl:text>
		<xsl:value-of select="count(child::*/child::*/child::node)"/>
		<xsl:text> content slides \\</xsl:text>

		<xsl:apply-templates/>

		<xsl:text>&#xA;\newpage</xsl:text>
	</xsl:if>
	<xsl:if test="(count(ancestor::node())-2)=2">
		<xsl:text>\noindent &#xA;</xsl:text>
		<xsl:value-of select="@TEXT" disable-output-escaping="yes"/>
		<xsl:text> (</xsl:text>
		<xsl:value-of select="count(child::*/child::node)"/>
		<xsl:text> slides)</xsl:text>
		<xsl:text>&#xA;{\footnotesize</xsl:text>
		<xsl:text>&#xA;\begin{multicols}{2}</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#xA;\end{multicols}</xsl:text>
		<xsl:text>&#xA;}&#xA;</xsl:text>
	</xsl:if>
	<xsl:if test="(count(ancestor::node())-2)=3">
		<xsl:text>\noindent &#xA;</xsl:text>
		<xsl:value-of select="@TEXT" disable-output-escaping="yes"/>
		<xsl:text> (</xsl:text>
		<xsl:value-of select="count(child::node)"/>
		<xsl:text> slides)</xsl:text>
	</xsl:if>
</xsl:template>

<!-- End of LaTeXChar template -->

</xsl:stylesheet>

