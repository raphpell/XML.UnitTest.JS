<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" 
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />

  
<xsl:template match="truth">
<html>
<head>
	<title><xsl:value-of select="@name"/></title>
	<style>
DL { margin: 0; }

/* legend */
.legend {
	border: 1px solid #000;
	float: right;
	}
DD {
	margin: 0;
	padding: .2em .5em;
	}

/* test */
H2 {
	margin:0;
	padding: 0 .5em;
	}
.test {
	background: #FFE;
	border: 1px solid #000;
	float: left;
	margin: 0 0 1em 1em ;
	padding: 0.25em;
	}
.value {
	margin: .25em 0;
	border: 1px solid #aaa;
	padding: .25em 1em;
	}
.desc , .assertions {
	}
	
/* result */
DT {
	margin-top: 1px;
	padding: 0 .5em;
	}
.green { background: darkgreen; color:#FFF; }
.orange { background: orange; }
.red { background: red; }
	</style>
</head>
<body>
	<dl class="legend">
		<dd class="red">erreur</dd>
		<dd class="orange">raté</dd>
		<dd class="green">réussi</dd>
	</dl>
	
	<h1><xsl:value-of select="@name"/></h1>
	
	<script>var aUnitTest = []</script>
	
	<xsl:for-each select="test">
	<div class="test">
		<h2><xsl:value-of select="@name"/></h2>
		<xsl:for-each select="assertions">
		<div class="assertions">
		
		<pre class="value"><xsl:value-of select="value" /></pre>
		<script><xsl:value-of select="value"/></script>
		<dl>
			<xsl:for-each select="assert">
			<dt><xsl:value-of select="current()"/></dt>
			<script>
				try{
					aUnitTest.push([(<xsl:value-of select="current()"/>)?2:1,''])
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
	
	<script>
		function getDT_H2( eDT ){
			return eDT.parentNode.parentNode.parentNode.firstChild
			}
		var aDT = document.getElementsByTagName('DT')
		var aDD = document.getElementsByTagName('DD')
		var oColor = { 0:'red', 1:'orange', 2:'green' }
		for(var i=0; aDD[i]; i++ ) aDD[i].count = 0
		for(var i=0; aDT[i]; i++ ){
			var n = aUnitTest[i][0]
			aDD[n].count++
			aDT[i].className = oColor[n]
			aDT[i].title = aUnitTest[i][1]
			if( n==0 || n==1 )
				getDT_H2( aDT[i]).className = oColor[n]
			}
		for(var i=0; aDD[i]; i++ ) aDD[i].innerHTML += ' '+ aDD[i].count
	</script>

</body>
</html>
</xsl:template>
</xsl:transform>