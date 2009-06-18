<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE stylesheet [
  <!ENTITY nbsp "&#x00A0;">
  <!ENTITY ldash "&#x2014;">
  <!ENTITY laquo "&#x00AB;">
  <!ENTITY raquo "&#x00BB;">
]>

<xsl:stylesheet
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns:fo="http://www.w3.org/1999/XSL/Format"
      version="1.0">

  <!-- typography -->

  <xsl:template match="text()">

    <xsl:call-template name="replace-double-dash">
      <xsl:with-param name="source_str">
        <xsl:call-template name="replace-dash">
          <xsl:with-param name="source_str">
            <xsl:call-template name="replace-quotes">
              <xsl:with-param name="source_str" select="normalize-space(.)"/>
              <xsl:with-param name="opening_quot"><xsl:text>&quot;</xsl:text></xsl:with-param>
              <xsl:with-param name="closing_quot"><xsl:text>&quot;</xsl:text></xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <xsl:template name="replace-quotes">
    <xsl:param name="source_str" select="."/>
    <xsl:param name="opening_quot" select="."/>
    <xsl:param name="closing_quot" select="."/>

    <xsl:choose>
      <xsl:when test="contains($source_str, $opening_quot)">
        <xsl:variable name="head" select="substring-before($source_str, $opening_quot)"/>
        <xsl:variable name="tail" select="substring-after($source_str, $opening_quot)"/>
        <xsl:choose>
          <xsl:when test="contains($tail, $closing_quot)">
            <xsl:variable name="quoted_str" select="substring-before($tail, $closing_quot)"/>
            <xsl:variable name="rest_of_tail" select="substring-after($tail, $closing_quot)"/>
            <xsl:value-of select="$head"/>
            &laquo;<xsl:value-of select="$quoted_str"/>&raquo;
            <xsl:call-template name="replace-quotes">
              <xsl:with-param name="source_str"
                              select="$rest_of_tail"/>
              <xsl:with-param name="opening_quot" select="$opening_quot"/>
              <xsl:with-param name="closing_quot" select="$closing_quot"/>
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

  <xsl:template name="replace-double-dash">
    <xsl:param name="source_str" select="."/>
    <xsl:variable name="delim_str">--</xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($source_str, $delim_str)">
        <xsl:value-of select="substring-before($source_str, $delim_str)"/>
        <xsl:text>&ldash;</xsl:text>
        <xsl:call-template name="replace-double-dash">
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

