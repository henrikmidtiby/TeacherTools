<?xml version='1.0'?>
<!--MINDMAPEXPORTFILTER tex  Latex book expoerter midtiby test script - latexbookexporter.xsl
License     : This code is released under the GPL. [http://www.gnu.org/copyleft/gpl.html]
Document    : latexbookexporter.xsl 
Description : Transforms freeplane mm format to a latex document.
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
		<xsl:call-template name="outputcontent"/>
	</xsl:for-each>
</xsl:template>


<xsl:template name="outputcontent">
	<xsl:text disable-output-escaping="yes">% node start (</xsl:text>
	<xsl:value-of select="current()/@ID" disable-output-escaping="yes"/>
	<xsl:text disable-output-escaping="yes">)&#xA;</xsl:text>
	<xsl:text disable-output-escaping="yes">% TEXT = </xsl:text>
	<xsl:value-of select="current()/@TEXT" disable-output-escaping="yes"/>
<!--	<xsl:text disable-output-escaping="yes">&#xA;</xsl:text> -->

	<xsl:if test = "contains(current()/richcontent/@TYPE,'NOTE') ">
		<xsl:call-template name="richtext"></xsl:call-template>
	</xsl:if>

	<xsl:text disable-output-escaping="yes">% node end (</xsl:text>
	<xsl:value-of select="current()/@ID" disable-output-escaping="yes"/>
	<xsl:text disable-output-escaping="yes">)&#xA;</xsl:text>

	<xsl:for-each select="node">
		<xsl:call-template name="outputcontent"/>
	</xsl:for-each>
</xsl:template>


<!-- template to parse and insert rich text (html, among <p> in Latex \item-s -->
<xsl:template name="richtext">
	<xsl:param name="i" select="current()/richcontent/html/body/p"/>
	<xsl:for-each select="$i">
		<xsl:text>&#xA;</xsl:text>
		<xsl:value-of select="normalize-space(.)" disable-output-escaping="yes"/>
		<xsl:text></xsl:text>
	</xsl:for-each>
	<xsl:text disable-output-escaping="yes">&#xA;</xsl:text>
</xsl:template>


</xsl:stylesheet>

