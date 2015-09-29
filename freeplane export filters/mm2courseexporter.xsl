<?xml version='1.0'?>
<!--MINDMAPEXPORTFILTER tex  Latex Beamer Course exporter
License     : This code is released under the GPL. [http://www.gnu.org/copyleft/gpl.html]
Document    : mm2latexbeamer_richcontent.xsl based on mm2latexbeamer 
Description : Transforms freemind mm format to latex beamer presentations.

Orginal idea created by Joerg Feuerhake [joerg.feuerhake@free-penguin.org]
(original stylesheet) and Robert Ladstaetter [robert@ladstaetter.info] 
(small adaptions to fit into latex beamer scheme)
Bug fixing and features added by: Igor G. Olaizola [igor.go@gmail.com]
Richcontent adaptations made by: Igor G. Olaizola
Attribute feautres added by: Igor G. Olaizola
Image insertion (full slide and two columns) added by: Igor G. Olaizola

ChangeLog : 
Created on  : 01 February 2004
Updated    : 30 December 2006
Modified	: 29 November 2007 
Modified    : 30 April 2008: bug fixing, good idea but it didn't work (iolaizola)
Modified    : 21 October 2008 (iolaizola, some new modifications to 
		support images);
Modified    : 23 October 2008, cleanup
Modified    : 23 October 2008: Extension to more richcontent "notes" (iolaizola)
Modified    : 28 October: some minor format changes
Modified    : 07 December 2008: Including text in richcontent mode (v1.5)
Modified    : 09 December 2008: Bug fixing in richcontent mode (v1.6)
Modified    : 01 January 2009: Notes in the third level accepted as 
		main text for the slide (v.1.7) (iolaizola)
Modified    : 01 January 2009: Bug fixing: Notes were not fully compatible
		 with "items" richcontent, some html spacing issues solved (v.1.71) (iolaizola) 
Modified    : 07 January 2009: HTML code of images can be now directly 
		edited in freemind (<p> effect) (v.1.72) (iolaizola)
Modified   : 04 May 2009: Fixing some bugs detected in version 1.72 ( iolaizola)
Modified:  : 21 July 2009: One attribute can be read from 3d, level.  
		(allowframebreaks, shrink, plain) version 1.74 (iolaizola)
Modified   : 21 July 2009: More than one attribute can be read from 3d level. (v.1.75)(iolaizola)
Modified   : 21 July 2009: Coma correction with attributes. (v.1.76) (iolaizola)
Modified   : 28 April 2010: Figure captions added as attributes (v.1.77) (rodrigo.goya) and
first page established as "Plain".
Modified   : 5 May 2010: Variable width columns allowed in two column mode. (rodrigo.goya & iolaizola). (v1.80)
NOTE: . From now on, "allowframebreaks, plain and shrink" attributes will be the only attributes which don't require the  attribute name (due to backwards compatibility reasons).
Modified:  : 6 May 2010: Multiple attributes allowed. (iolaizola). Note, default frame format is "shrink", there are problems to place the comas with the XLS template. (v 1.81)
Modified    : 9 May 2010. Coma issues solved with format styles. Now there is no need for a defalut frame style like "shrink" (iolaizola) (v.1.83)
Modified    : 9 May 2010. "squeeze" format style included (iolaizola) (v.1.835)
Modified    : 11 May 2010. "width" option added as attribute for figures and improvements to allow multiple attributes (iolaizola) (v.1.84)
Modified    : 11 May 2010. "framestyle" attribute name featured (iolaizola) (v.1.85)
Modified    : 13 May 2010  "subtitle" "author" and "date" attributes in main node.  (iolaizola) (v.1.9)
Modified    : 13 May 2010  "Unescape encoding activated. (iolaizola) (v.1.95)
Modified    : 17 May 2010 "Appendix" option added (v.1.955) (rodrigo.goya & iolaizola)
Modified    : 19 May 2010Issues fixed: Author, date, options.... (v.1.958)(iolaizola) \begin{document} and \end{document} are included within the content.tex file. Ported to XSL 2.0. Fixed compatibility issues for Saxon9. Ready to be tested for v2.0
Modified    : 20 May 2010. "Institute option added in main node (v.1.96)
Modified: 1 October 2010: Minor bug correction: "heigth" -> "height"
Modified: 23 July 2010: Changes in strucutre. In order to avoid the dependance on the main doc. A main documente will be directly generated. It will call the "theme" as attribute in the main node. Default theme will be assigned. (iolaizola)
Modified: 3 October 2010: Frame background properties added through attributes (iolaizola 1.99)
Modified: 5 October 2010: Frame background color properties added. First 2.0 release candidate (iolaizola)
Modified: 22 September 2011: Clean up and other changes proposed by Guy Kloss. PDF metadata added. "{" substituted by "\begin{frame}" (iolaizola).
Modified: 7 February 2012: Error corrections from last version, (2 title pages, hpyersetup errors, etc. (iolaizola).
Modified: 7 February 2012: Cloud -> Block option added .(iolaizola )
Modified: 7 February 2012: Cloud -> Freeplane Latex Equation hook included .(iolaizola 2.02)
Modified: 8 February 2012: Latex compiler errors solved (empty itemize sections) .(iolaizola 2.03)
Modified; 14th February 2012: "figuresp" template extended to make compatible with width, height, scacle attributes (like figures) [iolaizola 2.04]
Modified_ 16th of June 2014: Compatibility issues with ##1.3.x## version of freeplane. 
	1- LaTeX equations are identified as  "FORMAT="latexPatternFormat" within the node info. We keep the "hook" option for backwards compatibility. Warning: LaTeX Format will be exclusivelly considered for formulas (it will create an "equation" environment). 
	2- Now there are more "hooks" because IMAGES can also be inserted as "hooks" therefore, the old equation filter "hook" has to be adjusted to the specific type "hook equation". Hooks with NAME=ExternalObject will be considered as images. 

Thanks to: Gorka Marcos and Myriam Alustiza for giving the xsl syntax support 			  


See: http://freemind.sourceforge.net/
-->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='2.0'>  
<xsl:output omit-xml-declaration="yes" encoding="ISO-8859-1" use-character-maps="returns" /> 


<xsl:character-map name="returns">
  <xsl:output-character character="&#13;" string="&#xD;"/>
 </xsl:character-map> 


<xsl:template match="map">

<!-- ==== HEADER ==== -->
<xsl:text disable-output-escaping="yes">%&amp; -jobname newfilenameialwayswanted</xsl:text>
<xsl:text>
% !TEX encoding = latin1
\documentclass[usepdftitle=false,professionalfonts,compress ]{beamer}

% Packages to be included
\usepackage[latin1]{inputenc}</xsl:text>
<xsl:if test="node/attribute/@NAME = 'usepackage' ">
	<xsl:text>
\usepackage{</xsl:text>
	<xsl:value-of select="node/attribute[@NAME = 'usepackage']/@VALUE" disable-output-escaping="yes"/>
	<xsl:text>}</xsl:text>
</xsl:if>

% Beamer Theme
<xsl:choose>
	<xsl:when test="node/attribute/@NAME = 'theme' ">
		<xsl:text>\usetheme[]{</xsl:text>
		<xsl:value-of select="node/attribute[@NAME = 'theme']/@VALUE" disable-output-escaping="yes"/>
		<xsl:text>}</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>\usetheme[]{Darmstadt}</xsl:text>
	</xsl:otherwise>
</xsl:choose>

<xsl:apply-templates/>

</xsl:template>


<!-- ======= Body ====== -->
<xsl:template match="richcontent">
</xsl:template> <!--Avoids to write notes contents at the end of the document-->

<xsl:template match="node">

	<xsl:if test="(count(ancestor::node())-2)=0">
		<xsl:apply-templates select="node[1]"/>
	</xsl:if>
	<xsl:if test="(count(ancestor::node())-2)=1">
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

		<xsl:apply-templates select="node"/>
		<xsl:text>\end{document}</xsl:text>
	</xsl:if>
		
	<xsl:if test="(count(ancestor::node())-2)=2">
		<xsl:text>\section{</xsl:text><xsl:value-of select="@TEXT" disable-output-escaping="yes"/><xsl:text>}&#xA;&#xA;</xsl:text>
<!--		<xsl:apply-templates/> -->
		<xsl:apply-templates select="node"/>
	</xsl:if>
	
	<xsl:if test="(count(ancestor::node())-2)=3">
		<xsl:text>\subsection{</xsl:text><xsl:value-of select="@TEXT" disable-output-escaping="yes"/><xsl:text>}&#xA;&#xA;</xsl:text>
<!--		<xsl:apply-templates/> -->
		<xsl:apply-templates select="node"/>
	</xsl:if>
	<xsl:if test="(count(ancestor::node())-2)=4"> <!-- We are starting a frame-->
		<xsl:text>{&#xA;</xsl:text>
		
		<xsl:text>\begin{frame}</xsl:text>

		<!-- Add possibility of setting options for individual slides frames -->
		<xsl:if test="(current()/attribute/@NAME = 'options')">
			<xsl:text>[</xsl:text>
			<xsl:value-of select="current()/attribute[@NAME = 'options']/@VALUE" disable-output-escaping="yes"/>
			<xsl:text>]</xsl:text>
		</xsl:if>

		<xsl:text>&#xA;\frametitle{</xsl:text><xsl:value-of select="(@TEXT)" disable-output-escaping="yes"/>
		<xsl:text>}</xsl:text>
		<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
			<xsl:call-template name="richtext"></xsl:call-template>
		</xsl:if>

		<xsl:if test="current()/node and current()/node/@TEXT != ''">
			<xsl:call-template name="itemization"></xsl:call-template>
		</xsl:if>
		<xsl:text>&#xA;\end{frame}&#xA;</xsl:text>
		<xsl:text>}&#xA;&#xA;</xsl:text>

<!--		<xsl:apply-templates/> -->
		<xsl:apply-templates select="node"/>
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

<xsl:template match="text">
   <Notes><xsl:value-of select="text" disable-output-escaping="yes"/></Notes>
</xsl:template>


<!-- End of LaTeXChar template -->

</xsl:stylesheet>

