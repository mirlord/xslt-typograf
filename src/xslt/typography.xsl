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
  <!ENTITY ldash "&#x2014;">
  <!ENTITY laquo "&#x00AB;">
  <!ENTITY raquo "&#x00BB;">
  <!ENTITY drapos "``">
  <!ENTITY dapos "''">
]>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

  <!-- typography -->

  <xsl:template match="text()">

    <xsl:call-template name="replace-dash">
      <xsl:with-param name="source_str">
        <xsl:call-template name="replace-quotes">
          <xsl:with-param name="source_str" select="normalize-space(.)"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="replace-quotes">
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

    <xsl:variable name="debug">
      [CALL: {<xsl:value-of select="$source_str"/>} {oq: <xsl:value-of select="$opening_quot"/>} {cq: <xsl:value-of select="$closing_quot"/>} {oqr: <xsl:value-of select="$opening_quot_repl"/>} {cqr: <xsl:value-of select="$closing_quot_repl"/>} {oqi: <xsl:value-of select="$opening_quot_int"/>} {cqi: <xsl:value-of select="$closing_quot_int"/>}]
    </xsl:variable>

    <!--<xsl:value-of select="$debug"/>-->

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
            <xsl:call-template name="replace-quotes">
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

            <xsl:call-template name="replace-quotes">
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
            <xsl:call-template name="replace-quotes">
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

  <xsl:template name="replace-dash">
    <xsl:param name="source_str" select="."/>
    <xsl:variable name="delim_str"> - </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($source_str, $delim_str)">
        <xsl:value-of select="substring-before($source_str, $delim_str)"/>
        <xsl:text>&nbsp;&ldash; </xsl:text>
        <xsl:call-template name="replace-dash">
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

