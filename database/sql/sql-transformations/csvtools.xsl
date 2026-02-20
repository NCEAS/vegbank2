<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<!-- this stylesheet should be imported by other stylesheets which want to write csv strings.  call the template csvIt with param text= text to make into a csv.  $LF is available as a line feed, too -->
   <xsl:param name="csv_txtdelim">"</xsl:param>
   <xsl:param name="LF1">|
|</xsl:param><!-- has line feed in string -->
   <xsl:param  name="LF" select="substring($LF1,2,1)" /><!-- get just LF -->
 <!-- specific search and replace for csv safe strings: -->
 <xsl:template name="csvIt">
   <xsl:param name="text" />
   <!-- a few steps: first replace all ' with '' -->
   <xsl:variable name="step1">
     <xsl:call-template name="replace-string"><xsl:with-param name="text" select="$text" /><xsl:with-param name="from"><xsl:value-of select="$csv_txtdelim" /></xsl:with-param><xsl:with-param name="to"><xsl:value-of select="$csv_txtdelim" /><xsl:value-of select="$csv_txtdelim" /></xsl:with-param></xsl:call-template>
   </xsl:variable>
   <!-- now, replace all \n with \n\n -->
   <xsl:variable name="step2">
     <xsl:call-template name="replace-string"><xsl:with-param name="text" select="$step1" /><xsl:with-param name="from">\n</xsl:with-param><xsl:with-param name="to">\n\n</xsl:with-param></xsl:call-template>
   </xsl:variable>
   <!-- ok, now replace LF with ' \n ' and enclose is single  quotes-->
   <xsl:variable name="step3"><xsl:value-of select="$csv_txtdelim" /><xsl:call-template name="replace-string"><xsl:with-param name="text" select="$step2" /><xsl:with-param name="from" select="$LF" /><xsl:with-param name="to"> \n </xsl:with-param></xsl:call-template><xsl:value-of select="$csv_txtdelim" /></xsl:variable>
  <xsl:variable name="empty"><xsl:value-of select="$csv_txtdelim" /><xsl:value-of select="$csv_txtdelim" /></xsl:variable>
   <xsl:choose>
    <xsl:when test="$step3=$empty">null</xsl:when>
    <xsl:otherwise><xsl:value-of select="$step3" /><!-- write restults --></xsl:otherwise>
  </xsl:choose>

 </xsl:template>
 
 <!-- reusable replace-string function -->
 <xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="from"/>
    <xsl:param name="to"/>

    <xsl:choose>
      <xsl:when test="contains($text, $from)">

	<xsl:variable name="before" select="substring-before($text, $from)"/>
	<xsl:variable name="after" select="substring-after($text, $from)"/>
	<xsl:variable name="prefix" select="concat($before, $to)"/>

	<xsl:value-of select="$before"/>
	<xsl:value-of select="$to"/>
        <xsl:call-template name="replace-string">
	  <xsl:with-param name="text" select="$after"/>
	  <xsl:with-param name="from" select="$from"/>
	  <xsl:with-param name="to" select="$to"/>
	</xsl:call-template>
      </xsl:when> 
      <xsl:otherwise>
        <xsl:value-of select="$text"/>  
      </xsl:otherwise>
    </xsl:choose>            
 </xsl:template>

<!-- reusable lower-case function -->
<xsl:template name="lower-case">
  <xsl:param name="text"/>
  <xsl:value-of select="translate($text,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
</xsl:template>
<xsl:template name="upper-case">
  <xsl:param name="text"/>
  <xsl:value-of select="translate($text,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
</xsl:template>

</xsl:stylesheet>
