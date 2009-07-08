<?xml version="1.0" encoding="utf-8"?>

<!-- *********************************************************************
     * This program is free software. It comes without any warranty, to
     * the extent permitted by applicable law. You can redistribute it
     * and/or modify it under the terms of the Do What The Fuck You Want
     * To Public License, Version 2, as published by Sam Hocevar. See
     * COPYING file for more details. */ 
     ********************************************************************* -->

<!DOCTYPE stylesheet [
  <!ENTITY nbsp "&#x00A0;">
  <!ENTITY cr "&#x000A;">
  <!ENTITY lf "&#x000D;">
  <!ENTITY tab "&#x0009;">
  <!ENTITY ldash "&#x2014;">
  <!ENTITY laquo "&#x00AB;">
  <!ENTITY raquo "&#x00BB;">
  <!ENTITY mdots "&#x2026;">
]>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

  <xsl:param name="typograf.cfg.replace.mdots" select="'true'"/>
  <xsl:param name="typograf.cfg.tags.ignore"
             select="'|synopsis|cmdsynopsis|computeroutput|funcsynopsis|
             |lineannotation|literallayout|programlisting|screen|screenshot|
             |userinput|constant|envar|filename|lineannotation|literal|
             |markup|option|optional|parameter|prompt|replaceable|
             |tag|varname|command|'"/>
  <xsl:param name="typograf.cfg.debug" select="'false'"/>

  <xsl:variable name="cr">
    <xsl:text>&cr;</xsl:text>
  </xsl:variable>
  <xsl:variable name="lf">
    <xsl:text>&lf;</xsl:text>
  </xsl:variable>
  <xsl:variable name="tab">
    <xsl:text>&tab;</xsl:text>
  </xsl:variable>

  <!-- ROOT template -->
  <xsl:template match="text()">
    
    <xsl:if test="$typograf.cfg.debug='true'">
      [DEBUG {<xsl:value-of select="local-name(..)"/>},
             {<xsl:value-of select="contains($typograf.cfg.tags.ignore, local-name(..))"/>}]
    </xsl:if>

    <!-- ignoring tags with preformatted content -->
    <xsl:choose>
      <xsl:when test="contains($typograf.cfg.tags.ignore, concat('|', local-name(..), '|') )">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <!-- ok, let's process this -->

        <xsl:variable name="normalized_source">
          <xsl:if test="starts-with(., ' ') or
                        starts-with(., $cr) or
                        starts-with(., $lf) or
                        starts-with(., $tab)">
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:value-of select="normalize-space(.)"/>
          <!-- this following - just an implementation of the ends-with,
               which is absent in xpath spec. Arghhh... -->
          <xsl:variable name="lastchar"
                        select="substring(., string-length(.), 1)"/>
          <xsl:if test="$lastchar=' ' or
                        $lastchar=$cr or
                        $lastchar=$lf or
                        $lastchar=$tab">
            <xsl:if test="$typograf.cfg.debug='true'">
              [DEBUG {string '<xsl:value-of select="."/>' ends with space}]
            </xsl:if>
            <xsl:text> </xsl:text>
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="step1">
          <xsl:choose>
            <xsl:when test="$typograf.cfg.replace.mdots='true'">
              <xsl:call-template name="typograf.replace-mdots">
                <xsl:with-param name="source_str" select="$normalized_source"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="typograf.replace-dash">
          <xsl:with-param name="source_str">
            <xsl:call-template name="typograf.replace-quotes">
              <xsl:with-param name="source_str" select="$step1"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="typograf.replace-mdots">
    <xsl:param name="source_str" select="."/>
    <xsl:variable name="delim_str">...</xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($source_str, $delim_str)">
        <xsl:value-of select="substring-before($source_str, $delim_str)"/>
        <xsl:text>&mdots;</xsl:text>
        <xsl:call-template name="typograf.replace-mdots">
          <xsl:with-param name="source_str" select="substring-after($source_str, $delim_str)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$source_str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="typograf.replace-quotes">
    <xsl:param name="source_str" select="."/>
    <xsl:param name="opening_quot">
      <xsl:text>&quot;</xsl:text>
    </xsl:param>
    <xsl:param name="closing_quot">
      <xsl:text>&quot;</xsl:text>
    </xsl:param>
    <xsl:param name="opening_quot_repl">
      <xsl:text>&laquo;</xsl:text>
    </xsl:param>
    <xsl:param name="closing_quot_repl">
      <xsl:text>&raquo;</xsl:text>
    </xsl:param>
    <xsl:param name="opening_quot_int">
      <xsl:text>``</xsl:text>
    </xsl:param>
    <xsl:param name="closing_quot_int">
      <xsl:text>''</xsl:text>
    </xsl:param>

    <xsl:if test="$typograf.cfg.debug='true'">
      [CALL: {<xsl:value-of select="$source_str"/>} {oq: <xsl:value-of select="$opening_quot"/>} {cq: <xsl:value-of select="$closing_quot"/>} {oqr: <xsl:value-of select="$opening_quot_repl"/>} {cqr: <xsl:value-of select="$closing_quot_repl"/>} {oqi: <xsl:value-of select="$opening_quot_int"/>} {cqi: <xsl:value-of select="$closing_quot_int"/>}]
    </xsl:if>

    <xsl:choose>
      <!-- skipping all the typographical quotes, if they are already used by author -->
      <xsl:when test="contains($source_str, $opening_quot_repl)">
        <!-- remembering the substring after the opening quot -->
        <xsl:variable name="skip_tail" select="substring-after($source_str, $opening_quot_repl)"/>
        <xsl:choose>
          <!-- if closing quot is present - skipping everything before it... -->
          <xsl:when test="contains($skip_tail, $closing_quot_repl)">
            <xsl:variable name="skip_str" select="concat(substring-before($source_str, $closing_quot_repl), $closing_quot_repl)"/>
            <xsl:variable name="tail" select="substring-after($source_str, $closing_quot_repl)"/>
            <xsl:value-of select="$skip_str"/>

            <!-- ... & then processing everything after it -->
            <xsl:call-template name="typograf.replace-quotes">
              <xsl:with-param name="source_str"
                              select="$tail"/>
              <xsl:with-param name="opening_quot" select="$opening_quot"/>
              <xsl:with-param name="closing_quot" select="$closing_quot"/>
              <xsl:with-param name="opening_quot_repl" select="$opening_quot_repl"/>
              <xsl:with-param name="closing_quot_repl" select="$closing_quot_repl"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$source_str"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="contains($source_str, $opening_quot)">
        <xsl:variable name="head" select="substring-before($source_str, $opening_quot)"/>
        <xsl:variable name="tail" select="substring-after($source_str, $opening_quot)"/>
        <xsl:choose>
          <xsl:when test="contains($tail, $closing_quot)">
            <xsl:variable name="quoted_str" select="substring-before($tail, $closing_quot)"/>
            <xsl:variable name="rest_of_tail" select="substring-after($tail, $closing_quot)"/>
            <xsl:value-of select="$head"/>
            <xsl:value-of select="$opening_quot_repl"/>

            <!-- replacing internal quotes -->

            <xsl:call-template name="typograf.replace-quotes">
              <xsl:with-param name="source_str"
                              select="normalize-space($quoted_str)"/>
              <xsl:with-param name="opening_quot" select="$opening_quot_int"/>
              <xsl:with-param name="closing_quot" select="$closing_quot_int"/>
              <xsl:with-param name="opening_quot_repl" select="$opening_quot"/>
              <xsl:with-param name="closing_quot_repl" select="$closing_quot"/>
              <xsl:with-param name="opening_quot_int" select="$opening_quot_int"/>
              <xsl:with-param name="closing_quot_int" select="$closing_quot_int"/>
            </xsl:call-template>
            <!--<xsl:value-of select="normalize-space($quoted_str)"/>-->

            <!-- end of internal quotes replacement -->

            <xsl:value-of select="$closing_quot_repl"/>
            <xsl:call-template name="typograf.replace-quotes">
              <xsl:with-param name="source_str"
                              select="$rest_of_tail"/>
              <xsl:with-param name="opening_quot" select="$opening_quot"/>
              <xsl:with-param name="closing_quot" select="$closing_quot"/>
              <xsl:with-param name="opening_quot_repl" select="$opening_quot_repl"/>
              <xsl:with-param name="closing_quot_repl" select="$closing_quot_repl"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$source_str"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$source_str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="typograf.replace-dash">
    <xsl:param name="source_str" select="."/>
    <xsl:variable name="delim_str"> - </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($source_str, $delim_str)">
        <xsl:value-of select="substring-before($source_str, $delim_str)"/>
        <xsl:text>&nbsp;&ldash; </xsl:text>
        <xsl:call-template name="typograf.replace-dash">
          <xsl:with-param name="source_str"
                          select="substring-after($source_str, $delim_str)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$source_str"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

