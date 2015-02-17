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
	box-shadow: 0 0 1em #999;
	float: right;
	}
.legend DD {
	margin: 0;
	padding: .2em .5em;
	}

/* test */
H1,H2,H3 {
	margin: 0;
	padding: 0;
	}
.desc {
	margin: .5em;
	}
.test {
	background: #FFE;
	border: 1px solid #000;
	box-shadow: 0 0 1em #999;
	float: left;
	margin: 0 0 1em 1em ;
	padding: 0.25em;
	}
	.test > H2 { padding-left: .25em; }
	.test > .desc {}
	.assertions {
		background: #FFC;
		border: 1px solid #aaa;
		box-shadow: 0 0 .25em #999;
		margin: .25em;
		padding: .25em;
		}
		.assertions > H3 { padding-left: .25em; }
		.assertions > .desc {}
		.value {
			background: #FFF;
			box-shadow: inset 0 0 .25em #999;
			margin: 0 0 .25em 0;
			border: 1px solid #ccc;
			padding: 0 1em;
			}
		.assertions DT {
			border-radius: 1em;
			margin-top: 1px;
			padding: 0 1em;
			}
	
/* result */
.red { background: red; }
.orange { background: orange; }
.green { background: darkgreen; color:#FFF; }
	</style>
</head>
<body>
	<dl class="legend">
		<dd class="red">erreur</dd>
		<dd class="orange">raté</dd>
		<dd class="green">réussi</dd>
	</dl>
	
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
		for(var i=0; aDD[i]; i++ ) aDD[i].innerHTML += ' '+ aDD[i].count
	</script>

</body>
</html>
</xsl:template>
</xsl:transform>