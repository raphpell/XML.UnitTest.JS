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
	<!-- Import des fichiers requis -->
	<xsl:for-each select="link"><xsl:copy-of select="current()"/></xsl:for-each>
	<xsl:for-each select="script"><xsl:copy-of select="current()"/></xsl:for-each>
	<script>var aUnitTest = [], aEval = [], result</script>
</head>
<body>
	<a href="index.htm">Index</a>

	<h1><xsl:value-of select="@name"/></h1>
	
	<!-- Résultat des tests -->
	<dl class="legend">
		<dd class="red"><code>erreur</code></dd>
		<dd class="orange"><code>échec</code></dd>
		<dd class="green"><code>réussi</code></dd>
	</dl>
	<!-- Description du fichier test -->
	<xsl:if test="desc">
		<div class="desc"><xsl:copy-of select="desc"/></div>
	</xsl:if>
	<!-- Sommaire -->
	<div class="toc">
		<b>Sommaire</b>
		<ul>
		<xsl:for-each select="test">
			<xsl:if test="@name"><li class="{@class}"><a href="#{generate-id(current())}"><xsl:value-of select="@name"/></a></li></xsl:if>
		</xsl:for-each>
		</ul>
	</div>
	<!-- Fichiers requis -->
	<xsl:if test="script|link">
	<div class="required">
		<b>Requis</b>
		<ul>
			<xsl:for-each select="script"><li><xsl:value-of select="@src"/></li></xsl:for-each>
			<xsl:for-each select="link"><li><xsl:value-of select="@href"/></li></xsl:for-each>
		</ul>
	</div>
	</xsl:if>

	<hr style="clear:both;"/>
	
	<xsl:for-each select="test">
	<div class="test {@class}">
		<xsl:if test="@name">
			<a name="{generate-id(current())}"></a>
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
				<xsl:variable name="n"><xsl:number format="0" level="any" /></xsl:variable>
				<pre class="value" id="{$n}"><xsl:value-of select="value" /></pre>
				<script>
					aEval[<xsl:number format="0" level="any" />] = 0
					try{
						<xsl:value-of select="value"/>;
						aEval[<xsl:number format="0" level="any" />] = 1
					}catch(e){
						aEval[<xsl:number format="0" level="any" />] = e.message
					}
				</script>
			</xsl:if>
			<dl>
				<xsl:for-each select="assert">
				<dt><xsl:value-of select="current()"/></dt>
				<script>
					try{
						result =(<xsl:value-of select="current()"/>);
						aUnitTest[<xsl:number format="0" level="any" />] =
							[result?2:1,result.charAt ? result : JSON.stringify(result, null, '    ') || '' ];
					}catch(e){
						aUnitTest[<xsl:number format="0" level="any" />] = [0,e];
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
			var a = aUnitTest[i+1]
			if( a ){
				var n = a[0]
				aDD[n].count++
				aDT[i].className = oColor[n]
				aDT[i].title = a[1]
				}
			else{
				aDT[i].className += ' syntaxError'
				aDT[i].title = 'Erreur de syntaxe'
				}
			}
		for(var i=0; i<3; i++ ){
			if( aDD[i].count !== undefined )
				aDD[i].innerHTML += ' <b>'+ aDD[i].count +'</b>'
			}
		var aPRE = document.getElementsByTagName('PRE')
		for(var i=0; aPRE[i]; i++ ){
			if( aPRE[i].className=="value" ){
				var m = aEval[ aPRE[i].id ]
				switch( m ){
					case 1: break;
					default:
						aPRE[i].className += m ? ' red' : ' syntaxError'
						aPRE[i].title = m || 'Erreur de syntaxe'
					}
				}
			}
	]]></script>

</body>
</html>
</xsl:template>
</xsl:transform>