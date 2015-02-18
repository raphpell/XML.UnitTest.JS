<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" 
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />

  
<xsl:template match="truth">
<html>
<head>
	<title><xsl:value-of select="@name"/></title>
	<link rel="stylesheet" type="text/css" href="UnitTest.css" />
	<xsl:for-each select="link"><xsl:copy-of select="current()"/></xsl:for-each>
	<xsl:for-each select="script"><xsl:copy-of select="current()"/></xsl:for-each>
</head>
<body>
	<dl class="legend">
		<dd class="red">Erreur</dd>
		<dd class="orange">Echec</dd>
		<dd class="green">Réussi</dd>
	</dl>
	
	<xsl:if test="script|link">
	<dl class="required">
		<dd><b>Requis</b></dd>
		<xsl:for-each select="script"><dd><xsl:value-of select="@src"/></dd></xsl:for-each>
		<xsl:for-each select="link"><dd><xsl:value-of select="@href"/></dd></xsl:for-each>
	</dl>
	</xsl:if>
	
	<h1><xsl:value-of select="@name"/></h1>
	<xsl:if test="desc">
		<div class="desc"><xsl:copy-of select="desc"/></div>
	</xsl:if>
	
	<script>var aUnitTest = []</script>
	
	<xsl:for-each select="test">
	<div class="test">
		<xsl:if test="@name">
			<h2><xsl:value-of select="@name"/></h2>
		</xsl:if>
		<xsl:if test="desc">
			<div class="desc"><xsl:copy-of select="desc"/></div>
		</xsl:if>
		
		<xsl:for-each select="assertions">
		<div class="assertions">
			<xsl:if test="@name">
				<h3><xsl:value-of select="@name"/></h3>
			</xsl:if>
			<xsl:if test="desc">
				<div class="desc"><xsl:copy-of select="desc"/></div>
			</xsl:if>
			<xsl:if test="value">
				<pre class="value"><xsl:value-of select="value" /></pre>
				<script><xsl:value-of select="value"/></script>
			</xsl:if>
			<dl>
				<xsl:for-each select="assert">
				<dt><xsl:value-of select="current()"/></dt>
				<script>
					try{
						var result = (<xsl:value-of select="current()"/>)
						aUnitTest.push([result?2:1,JSON.stringify(result)])
					}catch(e){
						aUnitTest.push([0,e.message])
						}
				</script>
				</xsl:for-each>
			</dl>
		</div>
		</xsl:for-each>
	</div>
	</xsl:for-each>
	
	<script><![CDATA[
		var aDT = document.getElementsByTagName('DT')
		var aDD = document.getElementsByTagName('DD')
		var oColor = { 0:'red', 1:'orange', 2:'green' }
		for(var i=0; aDD[i]; i++ ) aDD[i].count = 0
		for(var i=0; aDT[i]; i++ ){
			var n = aUnitTest[i][0]
			aDD[n].count++
			aDT[i].className = oColor[n]
			aDT[i].title = aUnitTest[i][1]
			}
		for(var i=0; i<3; i++ ){
			if( aDD[i].count !== undefined )
				aDD[i].innerHTML += ' '+ aDD[i].count
			}
	]]></script>

</body>
</html>
</xsl:template>
</xsl:transform>