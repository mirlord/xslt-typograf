<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:db="http://docbook.org/ns/docbook"
    version="1.0">

  <xsl:import href="../../src/xslt/typography.xsl"/>

  <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/db:article">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>xslt-typograf test page</title>
        <meta content="xslt-typograf" name="generator"/>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="db:coloured-nbsp">
    <span style="background-color: #000000">&#x00a0;</span>
  </xsl:template>

  <xsl:template match="db:command">
    <tt><xsl:apply-templates/></tt>
  </xsl:template>

  <xsl:template match="db:screen">
    <pre><xsl:apply-templates/></pre>
  </xsl:template>

  <xsl:template match="db:synopsis">
    <pre><xsl:apply-templates/></pre>
  </xsl:template>

  <xsl:template match="db:para">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="db:sect1/db:title">
    <h1><xsl:apply-templates/></h1>
  </xsl:template>

</xsl:stylesheet>


