<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oai="http://www.openarchives.org/OAI/2.0/" xmlns="http://www.loc.gov/MARC21/slim"
	xmlns:doc="http://www.lyncode.com/xoai" xmlns:exsl="http://exslt.org/common"
	xmlns:SimpleDateFormat="java.text.SimpleDateFormat" xmlns:Date="java.util.Date"
	exclude-result-prefixes="SimpleDateFormat Date" extension-element-prefixes="exsl" version="1.0">


	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes"/>
	<xsl:preserve-space elements="*"/>

	<xsl:variable name="UdeM" select="doc:metadata/doc:element[@name = 'UdeM']"/>
	<xsl:variable name="dc" select="doc:metadata/doc:element[@name = 'dc']"/>
	<xsl:variable name="dcterms" select="doc:metadata/doc:element[@name = 'dcterms']"/>
	<xsl:variable name="etdms"
		select="doc:metadata/doc:element[@name = 'etd']/doc:element[@name = 'degree']"/>
	<xsl:variable name="bundles" select="doc:metadata/doc:element[@name = 'bundles']"/>
	<xsl:variable name="oaire" select="doc:metadata/doc:element[@name = 'oaire']"/>
	<xsl:variable name="others" select="doc:metadata/doc:element[@name = 'others']"/>


	<!--// MHV Rappel: ce XSLT s'applique depuis le schema XOAI. Ex: https://papyrus.bib.umontreal.ca/oai/request?verb=GetRecord&metadataPrefix=xoai&identifier=oai:papyrus.bib.umontreal.ca:1866/11295 -->
	<!--// MHV Rappel:Pour modifier ce fichier sans recompiler les sources; faire les modifs dans 
	installation/config/crosswalk/oai/metadataformat/*.xsl puis repartir tomcat puis faire un oai clean-cache. -->
	<!--// MHV Rappel:Please, keep in mind that the OAI provider caches the transformed output,
	so you have to run [dspace]/bin/dspace oai clean-cache after any .xsl modification and reload the OAI page for the changes to take effect.
	When adding/removing metadata formats, making changes in [dspace]/config/crosswalks/oai/xoai.xml requires reloading/restarting the servlet container. -->



	<!--// MHV Rappel:  "descendant::text()[normalize-space()]" teste chaine de caractère non vide une fois les espace trimés -->

	<!-- // MHV Je créé une variable par type de document -->

	<xsl:variable name="estUnActesDeCongres">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Actes de congrès')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUnArticle">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Article')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUneRevue">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Revue')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUnLivre">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if
				test="contains(normalize-space(.), 'Livre') and not(contains(normalize-space(.), 'Chapitre'))">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>


	<xsl:variable name="estUnChapitredeLivre">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Chapitre de livre')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>


	<xsl:variable name="estUnEnregistrementMusical">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Enregistrement musical')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUnePartition">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Partition')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUnFilmOuVidéo">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Film ou vidéo')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUnEnsembleDeDonnées">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Ensemble de données')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUnLogiciel">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Logiciel')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUneCarteGéographique">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Carte géographique')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>


	<xsl:variable name="estUnRapport">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Rapport')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>


	<xsl:variable name="estUnePrésentationHorsCongrès">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Présentation hors congrès')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUneContributionÀunCongrès">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Contribution à un congrès')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>


	<xsl:variable name="estUneTME">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Thèse ou mémoire')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<!-- 
		
		// [MHV] Je veux pouvoir vérifier si c'est une TME UdeM. Pour ce, 2 conditions:
		// un etd.degree.grantor qui contient la chaîne "Université de Montréal"
		// *ET* au moins un type de document = "Thèse ou mémoire"
						
	-->

	<xsl:variable name="estUneTME_UdeM">
		<xsl:for-each
			select="$etdms/doc:element[@name = 'grantor']/doc:element/doc:field[@name = 'value']">
			<xsl:if
				test="contains(normalize-space(.), 'Université de Montréal') and $estUneTME = 'true'">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estUnTravailÉtudiant">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Travail étudiant')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<!-- 
		// 20-09-2018 MHV À revoir, il n'y a plus de grantor pour les travaux étudiants....
	
		// [MHV] Je veux pouvoir vérifier si c'est un travail dirigé UdeM. Pour ce, 2 conditions:
		// un etd.degree.grantor qui contient la chaîne "Université de Montréal"
		// *ET* au moins un type de document = "Graduate student work"
		// MAJ 8 dec 2017: En fonction de la nouvelle liste normalisée de types
		"Travail aux cycles supérieurs / Graduate student work"	et
    "Travail de 1er cycle / Undergraduate work"	
    sont tous regroupés sous:
     "Travail étudiant / Student work"		
	-->

	<xsl:variable name="estUnTravailÉtudiant_UdeM">
		<!-- MHV mars 2019. Anciennement on regardait pour voir si grantor ne contenait pas aussi la chaine "Université de Montréal"; mais cet élément n,est plus colligé pour les travaux et on peut supposer que si c'est un travail déposé dans le déPôt Papyrus alors c'est un travail UdeM -->
		<xsl:if test="$estUnTravailÉtudiant = 'true'">
			<xsl:value-of select="'true'"/>
		</xsl:if>
	</xsl:variable>


	<xsl:variable name="estUnDocumentAutre">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Autre')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>


	<xsl:variable name="estUnMatérielDidactique">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Matériel didactique')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>



	<xsl:variable name="estProgramme_Musique">
		<xsl:for-each
			select="$etdms/doc:element[@name = 'discipline']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Musique')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="estTME_Musique">
		<xsl:if test="$estUneTME_UdeM = 'true' and $estProgramme_Musique = 'true'">
			<xsl:value-of select="'true'"/>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="aUnLienVersVersionCompleteTME_Musique">
		<xsl:if test="$estTME_Musique = 'true'">
			<xsl:for-each
				select="$dc/doc:element[@name = 'identifier']/doc:element/doc:element/doc:field[@name = 'value']">
				<xsl:if test="contains(normalize-space(.), 'docs.bib.umontreal.ca/musique')">
					<xsl:value-of select="'true'"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:variable>


	<xsl:variable name="estUnPublisherUdeM">
		<xsl:for-each
			select="$dc/doc:element[@name = 'publisher']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'Université de Montréal')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="dateSoumission"
		select="$dc/doc:element[@name = 'date']/doc:element[@name = 'submitted'][position() = 1]/doc:element/doc:field[@name = 'value']"/>
	<xsl:variable name="datePublication"
		select="$dc/doc:element[@name = 'date']/doc:element[@name = 'issued'][position() = 1]/doc:element/doc:field[@name = 'value']"/>
	<xsl:variable name="dateDiffusionDspace"
		select="$dc/doc:element[@name = 'date']/doc:element[@name = 'accessioned'][position() = 1]/doc:element/doc:field[@name = 'value']"/>

	<!-- nombre de langue rééelle i.e. pas 'zxx' -->
	<xsl:variable name="nombreLangues"
		select="count($dcterms/doc:element[@name = 'language']/doc:element/doc:field[@name = 'value'][not(contains(., 'zxx'))])"/>


	<!-- fonction remplacement de chaînes de caractères -->
	<xsl:template name="remplaceTout">
		<xsl:param name="texte"/>
		<xsl:param name="replace"/>
		<xsl:param name="par"/>
		<xsl:choose>
			<xsl:when test="contains($texte, $replace)">
				<xsl:value-of select="substring-before($texte, $replace)"/>
				<xsl:value-of select="$par"/>
				<xsl:call-template name="remplaceTout">
					<xsl:with-param name="texte" select="substring-after($texte, $replace)"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="par" select="$par"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$texte"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<xsl:template name="AjouterMoisAUneDate">
    <xsl:param name="dateTime"/>
    <xsl:param name="months-to-add"/>
    <!-- extract components -->
    <xsl:variable name="year" select="substring($dateTime, 1, 4)"/>
    <xsl:variable name="month" select="substring($dateTime, 6, 2)"/>
<!--    <xsl:variable name="day" select="substring($dateTime, 9, 2)"/> -->
    <xsl:variable name="time" select="substring-after($dateTime, 'T')"/>

<xsl:variable name="day">
<xsl:choose>
			<xsl:when test="string(number(substring($dateTime, 9, 2))) != 'NaN'">
				<xsl:value-of select="substring($dateTime, 9, 2)"/>
			</xsl:when>
			<xsl:otherwise><!-- si il n'y a pas de jour de spécifier je pousse "01" -->
				<xsl:value-of select="01"/>
			</xsl:otherwise>
</xsl:choose>
</xsl:variable>


    <!-- calculate target year and month (using Knuth's corrected mod) -->
    <xsl:variable name="m11" select="$month + $months-to-add - 1"/>
    <xsl:variable name="y" select="$year + floor($m11 div 12)"/>
    <xsl:variable name="m" select="$m11 - 12 * floor($m11 div 12) + 1"/>
    <!-- calculate target day (clipped to last day of target month, excess days do not overflow) -->
    <xsl:variable name="cal" select="'312831303130313130313031'"/>
    <xsl:variable name="leap" select="not($y mod 4) and $y mod 100 or not($y mod 400)"/>
    <xsl:variable name="month-length" select="substring($cal, 2 * ($m - 1) + 1, 2) + ($m = 2 and $leap)" /> 
    <xsl:variable name="d">
        <xsl:choose>
            <xsl:when test="$day > $month-length">
                <xsl:value-of select="$month-length"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$day"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- output -->
    <xsl:value-of select="$y"/>
    <xsl:value-of select="format-number($m, '00')"/>
    <xsl:value-of select="format-number($d, '00')"/>
<!-- MHV Je ne veux pas outputer l'heure -->
<!-- <xsl:text>T</xsl:text> -->
<!-- <xsl:value-of select="$time"/> -->
</xsl:template>













	<!--############################################################-->
	<!--## Template to tokenize strings                           ##-->
	<!--############################################################-->
	<xsl:template name="tokenizeString">
		<!--passed template parameter -->
		<xsl:param name="list"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($list, $delimiter)">

				<xsl:variable name="dollarA">
					<!-- get everything in front of the first delimiter -->
					<xsl:value-of select="substring-before($list, $delimiter)"/>
				</xsl:variable>


				<!--
				<xsl:call-template name="tokenizeString">
-->
				<!-- store anything left in another variable -->
				<!--
					<xsl:with-param name="list" select="substring-after($list,$delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
	-->
			</xsl:when>
			<xsl:otherwise> $a <xsl:choose>
					<xsl:when test="$list = ''">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise> 2 <xsl:value-of select="$list"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="ConvertirCodeLangueEnMARC">
		<xsl:param name="cettelangue"/>
		<!--  
			// MHV on emploie maintenant ISO 639-3 pour dcterms.language
			
			// MARC uses its own set that seems to intersect ISO 639-2
			// but two letter codes from 639-1 don't seem to be in MARC
		-->
		<xsl:choose>
			<xsl:when test="$cettelangue">
				<xsl:choose>
					<xsl:when test="$cettelangue = 'fra'">fre</xsl:when>
					<xsl:when test="$cettelangue = 'eng'">eng</xsl:when>
					<xsl:when test="$cettelangue = 'spa'">spa</xsl:when>
					<xsl:when test="$cettelangue = 'por'">por</xsl:when>
					<xsl:when test="$cettelangue = 'deu'">ger</xsl:when>
					<xsl:when test="$cettelangue = 'ita'">ita</xsl:when>
					<xsl:when test="$cettelangue = 'ell'">gre</xsl:when>
					<xsl:when test="$cettelangue = 'lat'">lat</xsl:when>
					<xsl:when test="$cettelangue = 'zxx'">zxx</xsl:when>
					<xsl:otherwise>und</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>und</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ConvertirCodeLangueEnTexteFrançais">
		<xsl:param name="cettelangue"/>
		<!--  
			// MHV on emploie maintenant ISO 639-3 pour dcterms.language
			
			// MARC uses its own set that seems to intersect ISO 639-2
			// but two letter codes from 639-1 don't seem to be in MARC
		-->
		<xsl:choose>
			<xsl:when test="$cettelangue">
				<xsl:choose>
					<xsl:when test="$cettelangue = 'fra'">français</xsl:when>
					<xsl:when test="$cettelangue = 'eng'">anglais</xsl:when>
					<xsl:when test="$cettelangue = 'spa'">espagnol</xsl:when>
					<xsl:when test="$cettelangue = 'por'">portugais</xsl:when>
					<xsl:when test="$cettelangue = 'deu'">allemand</xsl:when>
					<xsl:when test="$cettelangue = 'ita'">italien</xsl:when>
					<xsl:when test="$cettelangue = 'ell'">grec</xsl:when>
					<xsl:when test="$cettelangue = 'lat'">latin</xsl:when>
					<xsl:when test="$cettelangue = 'zxx'">zxx</xsl:when>
					<xsl:otherwise>langue non déterminée</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>langue non déterminée</xsl:otherwise>
		</xsl:choose>
	</xsl:template>





	<!-- j'en prend juste un..... le premier (en principe le principal?) -->
	<xsl:variable name="langue008">
		<xsl:call-template name="ConvertirCodeLangueEnMARC">
			<xsl:with-param name="cettelangue">
				<xsl:value-of
					select="$dcterms/doc:element[@name = 'language'][1]/doc:element/doc:field[@name = 'value']"
				/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>


	<!-- nombreAuteurs : pour voir si on a une zone 100 vs 700 et aussi pour setting 1er indicateur dans le 245 -->
	<xsl:variable name="nombreAuteurs"
		select="count($dc/doc:element[@name = 'contributor']/doc:element[@name = 'author']/doc:element/doc:field)"/>


	<!-- to lower case -->
	<xsl:variable name="lc" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uc" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="apostrophe">'</xsl:variable>
	<xsl:variable name="apostrophe2">’</xsl:variable>
	<xsl:variable name="guillemet">"</xsl:variable>


	<xsl:template match="/doc:metadata">

		<record xmlns="http://www.loc.gov/MARC21/slim" xmlns:dcterms="http://purl.org/dc/terms/"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
			type="Bibliographic">

			<!-- <xsl:call-template name="debogage"/> -->
			<xsl:call-template name="createLeader"/>
			<xsl:call-template name="createControlField005"/>
			<xsl:call-template name="createControlField006new"/>
			<xsl:call-template name="createControlField007"/>
			<xsl:call-template name="createControlField008new"/>

			<xsl:call-template name="createDataField020"/>
			<xsl:call-template name="createDataField024"/>
			<xsl:call-template name="createDataField035"/>
			<xsl:call-template name="createDataField040"/>
			<xsl:call-template name="createDataField041"/>
			<xsl:call-template name="createDataField100_700"/>
			<xsl:call-template name="createDataField710"/>



			<xsl:call-template name="createDataField720Contributor"/>
			<xsl:call-template name="createDataField720DirecteurRecherche"/>
			<xsl:call-template name="createDataField245"/>
			<xsl:call-template name="createDataField246"/>
			<xsl:call-template name="createDataField251"/>
			<xsl:call-template name="createDataField264"/>
			<xsl:call-template name="createDataField300"/>
			<xsl:call-template name="createDataField336_337_338"/>
			<xsl:call-template name="createDataField490"/>

			<xsl:call-template name="createDataField500"/>
			<xsl:call-template name="createDataField502"/>
			<xsl:call-template name="createDataField505"/>
			<xsl:call-template name="createDataField506"/>
			<xsl:call-template name="createDataField516"/>
			<xsl:call-template name="createDataField520"/>
			<!-- <xsl:call-template name="createDataField524"/> -->
			<xsl:call-template name="createDataField542"/>
			<xsl:call-template name="createDataField546"/>

			<xsl:call-template name="createDataField653BB"/>
			<xsl:call-template name="createDataField653B6"/>
			<xsl:call-template name="createDataField655"/>
			<!--	<xsl:call-template name="createDataField730"/> -->
			<!--	<xsl:call-template name="createDataField740"/> -->
			<xsl:call-template name="createDataField767"/>
			<xsl:call-template name="createDataField787"/>
			<xsl:call-template name="createDataField773new"/>

			<xsl:call-template name="createDataField793"/>
			<xsl:call-template name="createDataField799"/>
			<xsl:call-template name="createDataField856"/>
		</record>
	</xsl:template>



	<xsl:template name="createLeader">
		<!-- 
  			
			// [MHV] ******************************************************************************
			// Notes sur le GUIDE (LEADER)
			//  
			// 00-04 Longeur de l'enregistrement : 00000
			// 05 Statut de la notice : n (nouvelle notice) 
			// 06 Type de notice : selon le type de document  
			// •        Actes de congrès : a
			// •        Articles : a
			// •        Revue : a
			// •        Livre : a
			// •        Rapport : a 
			// •        Chapitre de livre : a 
			// •        Enregistrement musical : j
			// •        Partition : c
			// •        Film, vidéo : g
			// •        Ensemble de données : m
			// •        Logiciel : m
			// •        Carte géographique : e
			// •        Présentation hors congrès : m
			// •        Contribution à un congrès : m
			// •        Thèse ou mémoire : a
			// •        Travail étudiant : m
			// •        Matériel didactique : m
			// •        Autre : m
			// 07 Niveau bibliographique : selon le type de document
			// •        • Actes de congrès : m (et non « s » réservé aux actes de « vrais » congrès) 
			// •        • Article : a 
			// •        • Revue : m (changé le 15 juillet 2020)
			// •        • Livre : m 
			// •        • Rapport : m 
			// •        • Chapitre de livre : a 
			// •        • Enregistrement musical : m 
			// •        • Partition : m 
			// •        • Film, vidéo : m 
			// •        • Ensemble de données : m 
			// •        • Logiciel : m 
			// •        • Carte géographique : m 
			// •        • Présentation hors congrès : m 
			// •        • Contribution à un congrès : a 
			// •        • Thèse ou mémoire :m 
			// •        • Travail étudiant : m 
			// •        • Matériel didactique : m 
			// •        • Autre : m 
			
			
			
			
			
			// 08 Genre de méthode : # (aucune méthode spécifique)
			// 09 Système de codage des caractères : a (jeu de caractères universel ou Unicode)
			// 10 Compte des indicateurs : 2 (nombre de positions de caractère utilisées pour les indicateurs)
			// 11 Compte des codes de sous-zones : 2 (nombre de positions de caractère utilisées pour un code de sous-zone)
			// 12-16 Adresse de base de données : 00000
			// 17 Niveau d'enregistrement : 3 (partiel)
			// 18 Forme de catalogage descriptif : u (inconnu)
			// 19 Niveau de la notice d'une ressource en plusieurs parties : # (non spécifié ou sans objet) SAUF Chapitre de livre : b et Article : b
			// 20  Longueur du segment longueur de zone ; Nbre de caractères du segment de la longueur de zone d'une entrée au Répertoire : 4
			//  21 Longueur du segment position de caractères de départ : 5 
			// 22 Longueur de la partie dépendante de l'application : 0 
			// 23 Non définie : 0
			
			
		-->

		<!-- Constante -->
		<xsl:variable name="p00-p05Guide" select="'00000n'"/>
		<xsl:variable name="p08-p18Guide" select="' a22000003u'"/>
		<xsl:variable name="p20-p23Guide" select="'4500'"/>

		<!-- MHV hum.... ceci assume qu'il n'y a qu'un seul type donc une seule forme de leader....-->
		<xsl:choose>

			<xsl:when test="
					$estUnActesDeCongres = 'true'
					">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'am', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>


			<xsl:when test="
					$estUnArticle = 'true'
					">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'aa', $p08-p18Guide, 'b', $p20-p23Guide)"/>
				</leader>
			</xsl:when>


			<xsl:when test="
					$estUneRevue = 'true'
					">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'am', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>


			<xsl:when test="$estUnChapitredeLivre = 'true'">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'aa', $p08-p18Guide, 'b', $p20-p23Guide)"/>
				</leader>
			</xsl:when>

			<xsl:when test="$estUnRapport = 'true'">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'am', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>


			<xsl:when test="$estUnLivre = 'true'">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'am', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>

			<xsl:when test="$estUnEnregistrementMusical = 'true'">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'jm', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>

			<xsl:when test="$estUnePartition = 'true'">

				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'cm', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>

			<xsl:when test="$estUnFilmOuVidéo = 'true'">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'gm', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>


			<xsl:when test="$estUneCarteGéographique = 'true'">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'em', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>


			<xsl:when test="$estUneTME = 'true'">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'am', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>


			<xsl:when
				test="
					$estUnEnsembleDeDonnées = 'true'
					or $estUnLogiciel = 'true'
					or $estUnePrésentationHorsCongrès = 'true'
					or $estUneContributionÀunCongrès = 'true'
					or $estUnTravailÉtudiant = 'true'
					or $estUnMatérielDidactique = 'true'
					or $estUnDocumentAutre = 'true'
					">
				<leader>
					<xsl:value-of
						select="concat($p00-p05Guide, 'mm', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:when>


			<!-- MHV fallback si aucune variable de type de définie....-->

			<xsl:otherwise>
				<leader>
				<xsl:value-of
					select="concat($p00-p05Guide, 'mm', $p08-p18Guide, ' ', $p20-p23Guide)"/>
				</leader>
			</xsl:otherwise>

		</xsl:choose>
	</xsl:template>


	<!--   CONTROL FIELDS  -->

	<!-- 
			// [MHV] ******************************************************************************
			// Notes sur Zone 005  Date et heure de la dernière transaction 
			//Format à respecter : aaaammjjhhmmss.f
		
		-->

	<xsl:template name="createControlField005">
		<xsl:variable name="lastModifyDate" select="$others/doc:field[@name = 'lastModifyDate']"/>
		<xsl:variable name="year" select="substring-before($lastModifyDate, '-')"/>
		<xsl:variable name="withoutyear" select="substring-after($lastModifyDate, '-')"/>
		<xsl:variable name="month" select="substring-before($withoutyear, '-')"/>
		<xsl:variable name="withoutmonth" select="substring-after($withoutyear, '-')"/>
		<xsl:variable name="day" select="substring-before($withoutmonth, ' ')"/>
		<xsl:variable name="withoutday" select="substring-after($withoutmonth, ' ')"/>
		<xsl:variable name="hour" select="substring-before($withoutday, ':')"/>
		<xsl:variable name="withouthour" select="substring-after($withoutday, ':')"/>
		<xsl:variable name="minute" select="substring-before($withouthour, ':')"/>
		<xsl:variable name="withoutminute" select="substring-after($withouthour, ':')"/>
		<xsl:variable name="second" select="substring-before($withoutminute, '.')"/>
		<xsl:variable name="datef" select="concat($year, $month, $day)"/>
		<xsl:variable name="timef" select="concat($hour, $minute, $second)"/>
		<controlfield tag="005">
			<xsl:value-of select="concat($datef, $timef, '.0')"/>
		</controlfield>
	</xsl:template>

	<xsl:template name="createControlField006">
		<!-- 
			// [MHV] ******************************************************************************
			// Notes sur le 006 - Éléments de données de longueur fixe - Caractéristiques matérielles additionnelles
		-->

		<xsl:variable name="p006_0">
			<xsl:choose>
				<xsl:when
					test="
						$estUnActesDeCongres = 'true'
						or $estUnArticle = 'true'
						or $estUneRevue = 'true'
						or $estUnLivre = 'true'
						or $estUnRapport = 'true'
						or $estUnChapitredeLivre = 'true'
						or $estUneTME = 'true'
						">
					<xsl:value-of select="'a'"/>
				</xsl:when>

				<xsl:when
					test="
						$estUnEnsembleDeDonnées = 'true'
						or $estUnLogiciel = 'true'
						or $estUnePrésentationHorsCongrès = 'true'
						or $estUneContributionÀunCongrès = 'true'
						or $estUnTravailÉtudiant = 'true'
						or $estUnMatérielDidactique = 'true'
						or $estUnDocumentAutre = 'true'
						">
					<xsl:value-of select="'m'"/>
				</xsl:when>

				<xsl:when test="$estUnEnregistrementMusical = 'true'">
					<xsl:value-of select="'j'"/>
				</xsl:when>

				<xsl:when test="$estUnePartition = 'true'">
					<xsl:value-of select="'c'"/>
				</xsl:when>

				<xsl:when test="$estUnFilmOuVidéo = 'true'">
					<xsl:value-of select="'g'"/>
				</xsl:when>

				<xsl:when test="$estUneCarteGéographique = 'true'">
					<xsl:value-of select="'e'"/>
				</xsl:when>
				<!-- MHV fallback si aucune variable de type de définie....-->
				<xsl:otherwise>
					<xsl:value-of select="'m'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p006_6">
			<xsl:choose>
				<xsl:when
					test="
						$estUnFilmOuVidéo = 'true'
						or $estUneCarteGéographique = 'true'
						">
					<xsl:value-of select="'|'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'s'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p006_7">
			<xsl:choose>
				<xsl:when test="
						$estUneTME = 'true'
						">
					<xsl:value-of select="'m'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'|'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p006_9">
			<xsl:choose>
				<xsl:when
					test="
						$estUnEnsembleDeDonnées = 'true'
						or $estUnLogiciel = 'true'
						or $estUnePrésentationHorsCongrès = 'true'
						or $estUneContributionÀunCongrès = 'true'
						or $estUnTravailÉtudiant = 'true'
						or $estUnMatérielDidactique = 'true'
						or $estUnDocumentAutre = 'true'
						">
					<xsl:value-of select="'d'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'|'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p006_12">
			<xsl:choose>
				<xsl:when
					test="
						$estUnFilmOuVidéo = 'true'
						or $estUneCarteGéographique = 'true'
						">
					<xsl:value-of select="'s'"/>
				</xsl:when>
				<xsl:when test="
						$estUnActesDeCongres = 'true'
						">
					<xsl:value-of select="'1'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'|'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="p006_16">
			<xsl:choose>
				<xsl:when test="
						$estUnFilmOuVidéo = 'true'
						">
					<xsl:value-of select="'v'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'|'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<controlfield tag="006">
			<xsl:value-of
				select="concat($p006_0, '|||||', $p006_6, $p006_7, '|', $p006_9, '||', $p006_12, '|||', $p006_16, '|')"
			/>
		</controlfield>
	</xsl:template>

	<xsl:template name="createControlField006new">
		<!-- 
			// [MHV] ******************************************************************************
			// Notes sur le 006 - Éléments de données de longueur fixe - Caractéristiques matérielles additionnelles
		-->

			<xsl:choose>
				<xsl:when
					test="
						$estUnActesDeCongres = 'true'
						or $estUnArticle = 'true'
						or $estUneRevue = 'true'
						or $estUnLivre = 'true'
						or $estUnRapport = 'true'
						or $estUnChapitredeLivre = 'true'
						or $estUneTME = 'true'
						">

					<xsl:variable name="p006_0">
								<xsl:value-of select="'a'"/>
					</xsl:variable>

					<xsl:variable name="p006_7-10">
					<xsl:choose>
						<xsl:when
							test="$estUneTME = 'true'">
									<xsl:value-of select="'m   '"/>
						</xsl:when>
						<xsl:otherwise>
									<xsl:value-of select="'||||'"/>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:variable>
				
					<xsl:variable name="p006_12">
					<xsl:choose>
						<xsl:when
							test="$estUnActesDeCongres = 'true'">
									<xsl:value-of select="'1'"/>
						</xsl:when>
						<xsl:otherwise>
									<xsl:value-of select="'0'"/>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:variable>

					<controlfield tag="006">
						<xsl:value-of
						select="concat($p006_0, '||||',' ','o',$p006_7-10,'u',$p006_12,'0','0','|','0',' ')" />
					</controlfield>

				</xsl:when>

				<xsl:when
					test="
						$estUnEnsembleDeDonnées = 'true'
						or $estUnLogiciel = 'true'
						or $estUnePrésentationHorsCongrès = 'true'
						or $estUneContributionÀunCongrès = 'true'
						or $estUnTravailÉtudiant = 'true'
						or $estUnMatérielDidactique = 'true'
						or $estUnDocumentAutre = 'true'
						">

					<xsl:variable name="p006_0">
								<xsl:value-of select="'m'"/>
					</xsl:variable>

					<controlfield tag="006">
						<xsl:value-of
						select="concat($p006_0, '|||| o||u|u||||||')" />
					</controlfield>

				</xsl:when>

				<xsl:when test="$estUnEnregistrementMusical = 'true'">
					<xsl:variable name="p006_0">
								<xsl:value-of select="'j'"/>
					</xsl:variable>

					<controlfield tag="006">
						<xsl:value-of
						select="concat($p006_0, 'uunn o||||||  |n|')" />
					</controlfield>
				</xsl:when>

				<xsl:when test="$estUnePartition = 'true'">
					<xsl:variable name="p006_0">
								<xsl:value-of select="'c'"/>
					</xsl:variable>

					<controlfield tag="006">
						<xsl:value-of
						select="concat($p006_0, 'uuu| o||||||n |||')" />
					</controlfield>
				</xsl:when>

				<xsl:when test="$estUnFilmOuVidéo = 'true'">
					<xsl:variable name="p006_0">
								<xsl:value-of select="'g'"/>
					</xsl:variable>

					<controlfield tag="006">
						<xsl:value-of
						select="concat($p006_0, '|||| |||||uo|||vu')" />
					</controlfield>
				</xsl:when>

				<xsl:when test="$estUneCarteGéographique = 'true'">
					<xsl:variable name="p006_0">
								<xsl:value-of select="'e'"/>
					</xsl:variable>

					<controlfield tag="006">
						<xsl:value-of
						select="concat($p006_0, '|||||||u||uo|0|||')" />
					</controlfield>
				</xsl:when>
				<!-- MHV fallback si aucune variable de type de définie....-->
				<xsl:otherwise>

					<xsl:variable name="p006_0">
								<xsl:value-of select="'m'"/>
					</xsl:variable>

					<controlfield tag="006">
						<xsl:value-of
						select="concat($p006_0, '|||| o||u|u||||||')" />
					</controlfield>
				</xsl:otherwise>

			</xsl:choose>

	</xsl:template>


	<xsl:template name="createControlField007">
		<!-- 
			// [MHV] ******************************************************************************
			// 007 Zone fixe de description matérielle 
		-->
		<controlfield tag="007">cr unu</controlfield>
	</xsl:template>


	<xsl:template name="createControlField008">
		<!-- 
			// [MHV] ******************************************************************************
			// 008 - Éléments de longueur fixe  
			// 00-05 Date d'enregistrement au fichier : selon le format : aaaammjj
			// 06 -Type de date ou de statut de publication : s (date unique de publication connue ou probable) 
			// 07-10 Date 1 : année du document (élément dc.date.issued)
			// 11-14 Date 2 : #
			// 15-17 Lieu de publication, production ou d'exécution : 
			// Pour le type « Thèse ou mémoire » : quc
			// Si l’élément dc.publisher « Université de Montréal » : quc 
			// Dans tous les autres cas : xx# (Aucun lieu, lieu inconnu ou indéterminé)
			
			// 18-21 Illustations : | (aucune tentative de coder)
			// 22 Public cible : # (Inconnu ou non précisé)
			// 23 Support matériel du document : o (en ligne)
			// 24-27 Nature du contenu
			// Si le type de document « Thèse ou mémoire » : m 
			// Dans tous les autres cas, # (non précisée)
			// 28 Publication officielle : # (pas une publication officielle)
			// 29 Publication de congrès : 
			// Si le type de document « Actés de congrès » ou « Contribution à un congrès » : 1 (publication de congrès) 
			// Dans tous les autres cas : 0 (ouvrage n'est pas une publication de congrès)
			// 30- 34 : | (aucune tentative de coder)
			
			// 35-37 Langue
			// Valeurs conformes à ISO 639-2, (MARC Language Code) ex.  français : fre 
			// Si le type « Ensemble de données » : zxx (aucun élément linguistique)
			// 38 Notice modifiée : | (aucune tentative de coder)
			// 39 Source de catalogage : | (aucune tentative de coder)
			// 
			
		-->


		<!--  position 00-05 : date d'enregistrement au fichier de la notice MARC, format aammjj de la date de diffusion dans Dspace -->
		<xsl:variable name="dateEnregistrement">
			<xsl:choose>
				<xsl:when test="string-length($dateDiffusionDspace) > 0">
					<xsl:call-template name="formatAnneeAPartirDeLaDate">
						<xsl:with-param name="datestring" select="$dateDiffusionDspace"/>
					</xsl:call-template>
				</xsl:when>
				<!-- 6 espaces -->
				<xsl:otherwise>000000</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- position 07-10 : MHV 20 Déc. 2018 Nous allons garder, pour les thèses et mémoires uniquement, la date de publication (format AAAA) du 008 et du 264 comme étant dc.date.submitted.
À revoir si l'on retouche à la problématique de la date dans Dspace pour les TME.-->

		<xsl:variable name="z008date1">
			<xsl:choose>
				<xsl:when test="$dateSoumission and string-length($dateSoumission) > 0">
					<!-- seules les TME ont des date de soumission -->
					<xsl:value-of select="substring($dateSoumission, 1, 4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when
							test="string-length($datePublication) > 0 and string-length($dateSoumission) = 0">
							<xsl:value-of select="substring($datePublication, 1, 4)"/>
						</xsl:when>
						<!-- 4 espaces -->
						<xsl:otherwise>
							<xsl:text>    </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- 4 espaces -->
		<xsl:variable name="z008date2" select="'    '"/>


		<xsl:variable name="placeOfPublication">
			<xsl:choose>
				<xsl:when
					test="$estUneTME_UdeM = 'true' or $estUnTravailÉtudiant_UdeM = 'true' or $estUnPublisherUdeM = 'true'"
					>quc</xsl:when>
				<xsl:otherwise>xx </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p23">
			<xsl:choose>
				<xsl:when
					test="
						$estUnFilmOuVidéo = 'true'
						or $estUneCarteGéographique = 'true'
						">
					<xsl:value-of select="'|'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'s'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p24">
			<xsl:choose>
				<xsl:when test="
						$estUneTME = 'true'
						">
					<xsl:value-of select="'m'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'|'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p26">
			<xsl:choose>
				<xsl:when
					test="
						$estUnEnsembleDeDonnées = 'true'
						or $estUnLogiciel = 'true'
						or $estUnePrésentationHorsCongrès = 'true'
						or $estUneContributionÀunCongrès = 'true'
						or $estUnTravailÉtudiant = 'true'
						or $estUnMatérielDidactique = 'true'
						or $estUnDocumentAutre = 'true'
						">
					<xsl:value-of select="'d'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'|'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p29">
			<xsl:choose>
				<xsl:when
					test="
						$estUnFilmOuVidéo = 'true'
						or $estUneCarteGéographique = 'true'
						">
					<xsl:value-of select="'s'"/>
				</xsl:when>
				<xsl:when test="
						$estUnActesDeCongres = 'true'
						">
					<xsl:value-of select="'1'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'|'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="p33">
			<xsl:choose>
				<xsl:when test="
						$estUnFilmOuVidéo = 'true'">
					<xsl:value-of select="'v'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'|'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<controlfield tag="008">
			<xsl:value-of
				select="concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, '|||||', $p23, $p24, '|', $p26, '||', $p29, '|||', $p33, '|', $langue008, '|d')"
			/>
		</controlfield>
		<!-- débogage - la taille de ce champ doit être 40
			<xsl:value-of select="string-length(concat($createDate,'s',$leaderDate1,$leaderDate2,$placeOfPublication,$positions18a34,$langue,' d'))"/>
		-->

	</xsl:template>

	<xsl:template name="createControlField008new">
		<!-- 
			// [MHV] ******************************************************************************
			// 008 - Éléments de longueur fixe  
			// 00-05 Date d'enregistrement au fichier : selon le format : aaaammjj
			// 06 -Type de date ou de statut de publication : s (date unique de publication connue ou probable) 
			// 07-10 Date 1 : année du document (élément dc.date.issued)
			// 11-14 Date 2 : #
			// 15-17 Lieu de publication, production ou d'exécution : 
			// Pour le type « Thèse ou mémoire » : quc
			// Si l’élément dc.publisher « Université de Montréal » : quc 
			// Dans tous les autres cas : xx# (Aucun lieu, lieu inconnu ou indéterminé)
			
			// 18-21 Illustations : | (aucune tentative de coder)
			// 22 Public cible : # (Inconnu ou non précisé)
			// 23 Support matériel du document : o (en ligne)
			// 24-27 Nature du contenu
			// Si le type de document « Thèse ou mémoire » : m 
			// Dans tous les autres cas, # (non précisée)
			// 28 Publication officielle : # (pas une publication officielle)
			// 29 Publication de congrès : 
			// Si le type de document « Actés de congrès » ou « Contribution à un congrès » : 1 (publication de congrès) 
			// Dans tous les autres cas : 0 (ouvrage n'est pas une publication de congrès)
			// 30- 34 : | (aucune tentative de coder)
			
			// 35-37 Langue
			// Valeurs conformes à ISO 639-2, (MARC Language Code) ex.  français : fre 
			// Si le type « Ensemble de données » : zxx (aucun élément linguistique)
			// 38 Notice modifiée : | (aucune tentative de coder)
			// 39 Source de catalogage : | (aucune tentative de coder)
			// 
			
		-->


		<!--  position 00-05 : date d'enregistrement au fichier de la notice MARC, format aammjj de la date de diffusion dans Dspace -->
		<xsl:variable name="dateEnregistrement">
			<xsl:choose>
				<xsl:when test="string-length($dateDiffusionDspace) > 0">
					<xsl:call-template name="formatAnneeAPartirDeLaDate">
						<xsl:with-param name="datestring" select="$dateDiffusionDspace"/>
					</xsl:call-template>
				</xsl:when>
				<!-- 6 espaces -->
				<xsl:otherwise>000000</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- position 07-10 : MHV 20 Déc. 2018 Nous allons garder, pour les thèses et mémoires uniquement, la date de publication (format AAAA) du 008 et du 264 comme étant dc.date.submitted.
À revoir si l'on retouche à la problématique de la date dans Dspace pour les TME.-->

		<xsl:variable name="z008date1">
			<xsl:choose>
				<xsl:when test="$dateSoumission and string-length($dateSoumission) > 0">
					<!-- seules les TME ont des date de soumission -->
					<xsl:value-of select="substring($dateSoumission, 1, 4)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when
							test="string-length($datePublication) > 0 and string-length($dateSoumission) = 0">
							<xsl:value-of select="substring($datePublication, 1, 4)"/>
						</xsl:when>
						<!-- 4 espaces -->
						<xsl:otherwise>
							<xsl:text>    </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- 4 espaces -->
		<!-- <xsl:variable name="z008date2" select="'    '"/> -->
		<xsl:variable name="z008date2" select="'    '"/> 

		<xsl:variable name="placeOfPublication">
			<xsl:choose>
				<xsl:when
					test="$estUneTME_UdeM = 'true' or $estUnTravailÉtudiant_UdeM = 'true' or $estUnPublisherUdeM = 'true'"
					>quc</xsl:when>
				<xsl:otherwise>xx </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

			<xsl:choose>
				<xsl:when
					test="
						$estUnActesDeCongres = 'true'
						or $estUnArticle = 'true'
						or $estUneRevue = 'true'
						or $estUnLivre = 'true'
						or $estUnRapport = 'true'
						or $estUnChapitredeLivre = 'true'
						or $estUneTME = 'true'
						">

					<xsl:variable name="p008_18-23">
								<xsl:value-of select="'|||| o'"/>
					</xsl:variable>

					<xsl:variable name="p008_24-27">
					<xsl:choose>
						<xsl:when
							test="$estUneTME = 'true'">
									<xsl:value-of select="'m   '"/>
						</xsl:when>
						<xsl:otherwise>
									<xsl:value-of select="'||||'"/>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:variable>

					<xsl:variable name="p008_28">
								<xsl:value-of select="'u'"/>
					</xsl:variable>

				
					<xsl:variable name="p008_29">
					<xsl:choose>
						<xsl:when
							test="$estUnActesDeCongres = 'true'">
									<xsl:value-of select="'1'"/>
						</xsl:when>
						<xsl:otherwise>
									<xsl:value-of select="'0'"/>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:variable>

					<xsl:variable name="p008_30-34">
								<xsl:value-of select="'00|0 '"/>
					</xsl:variable>

					<xsl:variable name="p008_18-34">
								<xsl:value-of select="concat($p008_18-23,$p008_24-27,$p008_28,$p008_29,$p008_30-34)"/>
					</xsl:variable>

					<controlfield tag="008">
						<xsl:value-of
							select="concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, $p008_18-34, $langue008, ' d')"/>
					</controlfield>

				</xsl:when>

				<xsl:when
					test="
						$estUnEnsembleDeDonnées = 'true'
						or $estUnLogiciel = 'true'
						or $estUnePrésentationHorsCongrès = 'true'
						or $estUneContributionÀunCongrès = 'true'
						or $estUnTravailÉtudiant = 'true'
						or $estUnMatérielDidactique = 'true'
						or $estUnDocumentAutre = 'true'
						">

					<xsl:variable name="p008_18-34">
								<xsl:value-of select="'|||| o||u|u||||||'"/>
					</xsl:variable>

					<controlfield tag="008">
						<xsl:value-of
							select="concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, $p008_18-34, $langue008, ' d')"/>
					</controlfield>

				</xsl:when>

				<xsl:when test="$estUnEnregistrementMusical = 'true'">
					<xsl:variable name="p008_18-34">
								<xsl:value-of select="'uunn o||||||  |n|'"/>
					</xsl:variable>

					<controlfield tag="008">
						<xsl:value-of
							select="concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, $p008_18-34, $langue008, ' d')"/>
					</controlfield>
				</xsl:when>

				<xsl:when test="$estUnePartition = 'true'">
					<xsl:variable name="p008_18-34">
								<xsl:value-of select="'uuu| o||||||n |||'"/>
					</xsl:variable>

					<controlfield tag="008">
						<xsl:value-of
							select="concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, $p008_18-34, $langue008, ' d')"/>
					</controlfield>
				</xsl:when>

				<xsl:when test="$estUnFilmOuVidéo = 'true'">
					<xsl:variable name="p008_18-34">
								<xsl:value-of select="'|||| |||||uo|||vu'"/>
					</xsl:variable>

					<controlfield tag="008">
						<xsl:value-of
							select="concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, $p008_18-34, $langue008, ' d')"/>
					</controlfield>
				</xsl:when>

				<xsl:when test="$estUneCarteGéographique = 'true'">
					<xsl:variable name="p008_18-34">
								<xsl:value-of select="'|||||||u||uo|0|||'"/>
					</xsl:variable>

					<controlfield tag="008">
						<xsl:value-of
							select="concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, $p008_18-34, $langue008, ' d')"/>
					</controlfield>
				</xsl:when>
				
				<!-- MHV fallback si aucune variable de type de définie....-->
				<xsl:otherwise>
					<xsl:variable name="p008_18-34">
								<xsl:value-of select="'|||| o||u|u||||||'"/>
					</xsl:variable>

					<controlfield tag="008">
						<xsl:value-of
							select="concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, $p008_18-34, $langue008, ' d')"/>
					</controlfield>
				</xsl:otherwise>

			</xsl:choose>

		<!-- débogage - la taille de ce champ doit être 40
			<xsl:value-of select="string-length(concat($dateEnregistrement, 's', $z008date1, $z008date2, $placeOfPublication, $p008_18-34, $langue008, ' d'))"/>
		-->

	</xsl:template>


	<!-- Formater la date pour le champs de contrôle 008
	MHV : Affreux format : aammjj
		input date: 2015-04-09
		output date: 150409  or
		input date: 2015-04
		output date: 150401  or
		input date: 2015
		output date: 150101     
	-->
	<xsl:template name="formatAnneeAPartirDeLaDate">
		<xsl:param name="datestring"/>
		<xsl:variable name="yy">
			<xsl:choose>
				<xsl:when test="string-length($datestring) >= 4">
					<xsl:value-of select="substring($datestring, 3, 2)"/>
				</xsl:when>
				<xsl:otherwise>00</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="mm">
			<xsl:choose>
				<xsl:when test="string-length($datestring) >= 7">
					<xsl:value-of select="substring($datestring, 6, 2)"/>
				</xsl:when>
				<xsl:otherwise>01</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dd">
			<xsl:choose>
				<xsl:when test="string-length($datestring) >= 10">
					<xsl:value-of select="substring($datestring, 9, 2)"/>
				</xsl:when>
				<xsl:otherwise>01</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($yy, $mm, $dd)"/>
	</xsl:template>

	<!--   DATA FIELDS  -->

	<!--   
		// [MHV] ******************************************************************************
		// 020 Numéro international normalisé des livres 
	-->

	<xsl:template name="createDataField020">
		<xsl:for-each
			select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'isbn']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">020</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="."/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<!--   
		// [MHV] ******************************************************************************
		// 024 Autre numéro ou code normalisé 
	-->

	<xsl:template name="createDataField024">
		<xsl:for-each
			select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'issn']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">024</xsl:with-param>
				<xsl:with-param name="ind1" select="'7'"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
						<code>2</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="."/>
						</value>
					<value>issn</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<!--   
		// [MHV] ******************************************************************************
		// Notes sur le 035 Numéro de contrôle de système 
		// Subfield Codes
		//$a - 
	-->

	<xsl:template name="createDataField035">
		<xsl:for-each
			select="$others/doc:field[@name = 'handle' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">035</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="."/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!--   
		// [MHV] ******************************************************************************
		// Notes sur le 040 - Source du catalogage 
		// Subfield Codes
		//$a - Original cataloging agency (NR) 
		//$b - Language of cataloging (NR)
		//$e - Description conventions (R)
		//$c - Transcribing agency 
	-->
	<xsl:template name="createDataField040">
		<xsl:call-template name="createDataField">
			<xsl:with-param name="tag">040</xsl:with-param>
			<xsl:with-param name="ind1" select="' '"/>
			<xsl:with-param name="ind2" select="' '"/>
			<xsl:with-param name="subfieldCodes">
				<subfieldcodes xmlns="">
					<code>a</code>
					<code>b</code>
					<code>e</code>
					<code>c</code>
				</subfieldcodes>
			</xsl:with-param>
			<xsl:with-param name="subfieldValues">
				<subfieldvalues xmlns="">
					<value>MUQ</value>
					<value>fre</value>
					<value>local</value>
					<value>MUQ</value>
				</subfieldvalues>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- 
		// [MHV] ******************************************************************************
		// Notes sur le 041 - Language Code (R)
		// Subfield Codes
		// $a - Language code of text/sound track or separate title (R)
		
		//041 0B Code de langue utiliser seulement si : 
		//le type de document « Thèse ou mémoire » : 
		//•        en français : $a fre $ b eng 
		//•        en anglais : $a eng $ b fre 
		
		// Idéalement il faudrait aller lire les langues des abstracts ajoutés à la notices (et avoir une
		// bonne identification des langues).
		
		// MAJ 27 avril 2009: Avant, seules les langues qui différaient de la langue du document devaient être
		// inscrites dans la sous-zone $b. Maintenant, toute langue pertinente doit être enregistrée sans tenir
		// compte qu'elle soit la même ou qu'elle soit différente de celle déjà inscrite dans la sous-zone $a.
		// Je vais donc mettre la langue du document dans le $a et tjrs mettre « $beng $bfre » dans le résumé
		// (car doit être présenté en ordre alphabétique…). Pour les langue de document autre que anglais et français
		// il faudra reprendre la langue et trier en ordre alphabétique.... (à faire)			
		
	-->



	<xsl:template name="createDataField041">
		<xsl:choose>
			<xsl:when test="$estUneTME_UdeM = 'true'">
				<!-- si c'est une TME une *seule* langue (obligatoire) demandee dans bordereau -->
				<xsl:choose>
					<xsl:when test="$langue008 = 'fre' or $langue008 = 'eng'">
						<xsl:call-template name="createDataField">
							<xsl:with-param name="tag">041</xsl:with-param>
							<xsl:with-param name="ind1">0</xsl:with-param>
							<xsl:with-param name="ind2" select="' '"/>
							<xsl:with-param name="subfieldCodes">
								<subfieldcodes xmlns="">
									<code>a</code>
									<code>b</code>
									<code>b</code>
								</subfieldcodes>
							</xsl:with-param>
							<xsl:with-param name="subfieldValues">
								<subfieldvalues xmlns="">
									<value>
										<xsl:value-of select="$langue008"/>
									</value>
									<value>eng</value>
									<value>fre</value>
								</subfieldvalues>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="createDataField">
							<xsl:with-param name="tag">041</xsl:with-param>
							<xsl:with-param name="ind1">0</xsl:with-param>
							<xsl:with-param name="ind2" select="' '"/>
							<xsl:with-param name="subfieldCodes">
								<subfieldcodes xmlns="">
									<code>a</code>
									<code>b</code>
									<code>b</code>
									<code>b</code>
								</subfieldcodes>
							</xsl:with-param>
							<xsl:with-param name="subfieldValues">
								<subfieldvalues xmlns="">
									<value>
										<xsl:value-of select="$langue008"/>
									</value>
									<value>
										<xsl:value-of select="$langue008"/>
									</value>
									<value>eng</value>
									<value>fre</value>
								</subfieldvalues>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<!-- si ce n'est pas une TME -->
				<xsl:choose>
					<xsl:when test="($nombreLangues and $nombreLangues > 1)">
						<xsl:call-template name="createDataField">
							<xsl:with-param name="tag">041</xsl:with-param>
							<xsl:with-param name="ind1">0</xsl:with-param>
							<xsl:with-param name="ind2" select="' '"/>
							<xsl:with-param name="subfieldCodes">
								<subfieldcodes xmlns="">
									<xsl:for-each
										select="$dcterms/doc:element[@name = 'language']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][not(contains(., 'zxx'))]">
										<code>a</code>
									</xsl:for-each>
								</subfieldcodes>
							</xsl:with-param>
							<xsl:with-param name="subfieldValues">
								<subfieldvalues xmlns="">
									<xsl:for-each
										select="$dcterms/doc:element[@name = 'language']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][not(contains(., 'zxx'))]">
										<value>
											<xsl:call-template name="ConvertirCodeLangueEnMARC">
												<xsl:with-param name="cettelangue" select="."/>
											</xsl:call-template>
										</value>
									</xsl:for-each>
								</subfieldvalues>
							</xsl:with-param>


						</xsl:call-template>

					</xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>



			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!--		
				// [MHV] ******************************************************************************
				// Notes sur le 100 et 700 - Added Entry-Personal Name (R)
			-->

	<xsl:template name="createDataField100_700">
		<xsl:choose>
			<!--    TME ou travaux dirigés avec *un seul auteur* on le mets ds la zone 100 et on regarde pour id ORCID
			-->
			<xsl:when
				test="($estUneTME = 'true' or $estUnTravailÉtudiant = 'true') and $nombreAuteurs = 1">

				<!-- MHV fevrier 2017 : cas special integration orcid id pour les auteurs; il y a toujours et seulement un seul auteur de theses ou memoire -->
				<xsl:variable name="orcidAuteurThese"
					select="$UdeM/doc:element[@name = 'ORCIDAuteurThese'][1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"/>

				<xsl:variable name="author">
					<xsl:value-of
						select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'author']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]/text()"
					/>
				</xsl:variable>
				<xsl:call-template name="createDataField">
					<xsl:with-param name="tag">100</xsl:with-param>
					<xsl:with-param name="ind1">1</xsl:with-param>
					<xsl:with-param name="ind2" select="' '"/>
					<xsl:with-param name="subfieldCodes">
						<subfieldcodes xmlns="">
							<code>a</code>
							<code>e</code>
							<!-- MHV fevrier 2017 : cas special integration orcid id pour les auteurs de TME; il y a toujours et seulement un seul auteur de theses ou memoire -->
							<xsl:if test="$orcidAuteurThese != ''">
								<code>1</code>
							</xsl:if>
						</subfieldcodes>
					</xsl:with-param>
					<xsl:with-param name="subfieldValues">
						<subfieldvalues xmlns="">
							<value>
								<xsl:value-of select="concat($author, ',')"/>
							</value>
							<value>auteur.</value>
							<xsl:if test="$orcidAuteurThese != ''">
								<value>
									<xsl:value-of select="concat('https://orcid.org/', $orcidAuteurThese)"/>
								</value>	
							</xsl:if>
						</subfieldvalues>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<!--   Travaux dirigés avec plus d'un auteur - pour le 1er auteur  on le mets ds la zone 100, le reste ds la zone 700 -->
			<xsl:when test="$estUnTravailÉtudiant = 'true' and $nombreAuteurs > 1">
				<xsl:variable name="author">
					<xsl:value-of
						select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'author'][1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]/text()"
					/>
				</xsl:variable>
				<xsl:call-template name="createDataField">
					<xsl:with-param name="tag">100</xsl:with-param>
					<xsl:with-param name="ind1">1</xsl:with-param>
					<xsl:with-param name="ind2" select="' '"/>
					<xsl:with-param name="subfieldCodes">
						<subfieldcodes xmlns="">
							<code>a</code>
							<code>e</code>
						</subfieldcodes>
					</xsl:with-param>
					<xsl:with-param name="subfieldValues">
						<subfieldvalues xmlns="">
							<value>
								<xsl:value-of select="concat($author, ',')"/>
							</value>
							<value>auteur.</value>
						</subfieldvalues>
					</xsl:with-param>
				</xsl:call-template>
				<!-- Pour les auteurs additionnels - si c'est un travail c'est vraisemblablement un nom personnel donc 700$a -->
				<xsl:variable name="tag700">700</xsl:variable>
				<xsl:for-each
					select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'author'][position() != 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]/text()">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag" select="$tag700"/>
						<xsl:with-param name="ind1" select="'1'"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes">
							<subfieldcodes xmlns="">
								<code>a</code>
								<code>e</code>
							</subfieldcodes>
						</xsl:with-param>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>
									<xsl:value-of select="concat(., ',')"/>
								</value>
								<value>auteur.</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>


			<!--		
				// [MHV] ******************************************************************************
				// Notes sur le 720 - Added Entry-Uncontrolled Name 
			-->
			<xsl:otherwise>
				<xsl:for-each
					select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'author']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag" select="720"/>
						<xsl:with-param name="ind1" select="' '"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes">
							<subfieldcodes xmlns="">
								<code>a</code>
								<code>e</code>
							</subfieldcodes>
						</xsl:with-param>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>
									<xsl:value-of select="concat(., ',')"/>
								</value>
								<value>auteur</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	<!-- 
		// [MHV] ******************************************************************************
		// Notes sur le 710 - Vedette secondaire - Nom de collectivité
		// Subfield Codes
		// $a - Nom de collectivité
		// $e - Affiliation de l'auteur 

	-->

	<xsl:template name="createDataField710">
		<!-- ex.: Université de Montréal. Faculté des sciences. Département du bonheur -->
		<!-- MHV Je prévois 2 $b maximum -->
		<xsl:for-each
			select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'affiliation']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:variable name="dollarA">
				<xsl:choose>
					<xsl:when test="contains(normalize-space(.), '.')">
						<!-- get everything in front of the first delimiter -->
						<xsl:value-of select="substring-before(normalize-space(.), '.')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="resteSansLeDollarA">
				<xsl:choose>
					<xsl:when test="contains(normalize-space(.), '.')">
						<!-- get everything in front of the first delimiter -->
						<xsl:value-of select="substring-after(normalize-space(.), '.')"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="dollarB">
				<xsl:choose>
					<xsl:when test="contains(normalize-space($resteSansLeDollarA), '.')">
						<xsl:value-of
							select="substring-before(normalize-space($resteSansLeDollarA), '.')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space($resteSansLeDollarA)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="dollarBB">
				<xsl:choose>
					<xsl:when test="contains(normalize-space($resteSansLeDollarA), '.')">
						<!-- get everything in front of the first delimiter -->
						<xsl:value-of
							select="substring-after(normalize-space($resteSansLeDollarA), '. ')"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:variable>


			<xsl:variable name="ponctuationFinDuA">
				<xsl:choose>
					<xsl:when test="string-length($dollarB) > 0">
						<xsl:value-of select="''"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'.'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>


			<xsl:variable name="ponctuationFinDuB">
				<xsl:choose>
					<xsl:when test="string-length($dollarBB) > 0">
						<xsl:value-of select="''"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'.'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>


			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">710</xsl:with-param>
				<xsl:with-param name="ind1" select="'2'"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<xsl:if test="$dollarA and $dollarA != ''">
							<code>a</code>
						</xsl:if>
						<xsl:if test="$dollarB and $dollarB != ''">
							<code>b</code>
						</xsl:if>
						<xsl:if test="$dollarBB and $dollarBB != ''">
							<code>b</code>
						</xsl:if>
<!-- MHV DTDM decide de ne plus avoir $e...pour l'instant je commente -->
<!--
						<code>e</code>
-->
					</subfieldcodes>

				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<xsl:if test="$dollarA and $dollarA != ''">
							<value>
								<xsl:value-of select="concat($dollarA, '.')"/>
							</value>
						</xsl:if>

						<xsl:if test="$dollarB and $dollarB != ''">
							<value>
								<xsl:value-of select="concat($dollarB, '.')"/>
							</value>
						</xsl:if>

						<xsl:if test="$dollarBB and $dollarBB != ''">
							<value>
								<xsl:value-of select="concat($dollarBB, '.')"/>
							</value>
						</xsl:if>
<!-- MHV DTDM decide de ne plus avoir $e...pour l'instant je commente -->
<!--
						<xsl:if test="$dollarA and $dollarA != ''">
							<value>affiliation de l'auteur.</value>
						</xsl:if>
-->
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>




	<!-- 
		// [MHV] ******************************************************************************
		// Notes sur le 720 - Vedette secondaire - Contributeur (Éditeur intellectuel, al.)
		// Subfield Codes
		// $a - Nom, prénom

	-->

	<xsl:template name="createDataField720Contributor">
		<xsl:for-each
			select="$dc/doc:element[@name = 'contributor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">720</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value><xsl:value-of select="."/></value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<!-- 
		// [MHV] ******************************************************************************
		// Notes sur le 720 - Vedette secondaire - Directeur recherche
		// Subfield Codes
		// $a - Nom, prénom
	-->

	<xsl:template name="createDataField720DirecteurRecherche">
		<xsl:for-each
			select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'advisor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">720</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
						<code>e</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value><xsl:value-of select="."/>,</value>
						<value>directeur de recherche</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<!-- 
		// [MHV] ******************************************************************************
		// Notes sur le 245 - Mention du titre
	-->


	<xsl:template name="getAuthorNameNotInversed">
		<xsl:param name="name"/>
		<!-- en prévision de la mention de responsabilité dans le $c, on va inverser pour avoir (prénom + espace + nom)
		-->
		<xsl:choose>
			<xsl:when test="contains($name, ',')">
				<xsl:value-of
					select="concat(normalize-space(substring-after($name, ',')), ' ', normalize-space(substring-before($name, ',')))"
				/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="createDataField245">
		<xsl:variable name="nombreTitres"
			select="count($dc/doc:element[@name = 'title']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]])"/>
		<!-- 
			// [MHV] je remplace tous les caractères d'espacements (simple ou suite multiples)
			// par un espace simple (ceci pour ne pas occasionner de problèmes plus loin ds le code)
			// survient lorsque les étudiants insèrent un retour de chariot dans le titre (souvent pour séparer titre du sous-titre)
			// \s représente tous les caractères d'espacements ([ \t\n\x0B\f\r])
		-->
		
		<!-- // [MHV] Janvier 2020. je retire
		<xsl:variable name="mainTitle"  -->
		<xsl:variable name="mainTitle2"
			select="$dc/doc:element[@name = 'title'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"/>
		<xsl:variable name="mainTitleLength" select="string-length($mainTitle2)"/>
		<!-- 
			// [MHV] verifions s'il y a un point final au titre, dans lequel cas on va l'enlever
			// [MHV] Janvier 2020. Je ne vais plus enlever le point final. On va renforcer les instructions de saisie et ainsi on ne vas pas enlever le point final d'une abréviation par erreur
			

		<xsl:variable name="mainTitle2">
			<xsl:choose>
				<xsl:when test="substring($mainTitle, string-length($mainTitle), 1) = '.'">
					<xsl:value-of select="substring($mainTitle, 1, $mainTitleLength - 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$mainTitle"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		-->
		<!-- 
			// [MHV] verifions s'il y a un sous-titre (i.e. une chaine après le premier ":" (c'est imparfait)).
			// dans ce cas on va changer le titre (amputation du sous-titre)		
		-->

		<xsl:variable name="mainTitle2AvantDeuxPoints" select="substring-before($mainTitle2, ':')"/>
		<xsl:variable name="PositionDu2Points">
			<xsl:choose>
				<xsl:when test="string-length($mainTitle2AvantDeuxPoints) > 0">
					<xsl:value-of select="string-length($mainTitle2AvantDeuxPoints) + 1"/>
				</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="characterAfterColon">
			<xsl:choose>
				<xsl:when test="string-length($mainTitle2AvantDeuxPoints) > 0">
					<xsl:value-of select="substring($mainTitle2, $PositionDu2Points + 1, 1)"/>
				</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- 
			// [MHV] Si il s'agit d'un espace, d'une tabulation, d'une nouvelle ligne ou d'un retour de chariot  je considère
			// qu'on a un sous-titre (sinon ça pourrait p-ê être un truc technique
			// (ex. "l'embolisation de la molécule de Po3:RH suit un patron cyclique" )		
		-->


		<xsl:variable name="mainTitle3">
			<xsl:choose>
				<xsl:when
					test="$characterAfterColon = ' ' or $characterAfterColon = '#x9' or $characterAfterColon = '#xA' or $characterAfterColon = '#xD'">
					<xsl:value-of select="$mainTitle2AvantDeuxPoints"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$mainTitle2"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="sousTitre">
			<xsl:choose>
				<xsl:when
					test="$characterAfterColon = ' ' or $characterAfterColon = '#x9' or $characterAfterColon = '#xA' or $characterAfterColon = '#xD'">
					<xsl:value-of
						select="concat(normalize-space(substring($mainTitle2, $PositionDu2Points + 1)), ' /')"
					/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="ponctuationAvantb">
			<xsl:choose>
				<xsl:when test="string-length($sousTitre) > 0">
					<xsl:value-of select="' :'"/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="mentionResponsabilite">
			<xsl:call-template name="getMentionResponsabilite"/>
		</xsl:variable>

		<xsl:variable name="titreNormalize">
			<xsl:choose>
				<xsl:when test="string-length($sousTitre) = 0 and string-length($mainTitle3) > 0">
					<xsl:value-of select="concat($mainTitle3, $ponctuationAvantb, ' /')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($mainTitle3, $ponctuationAvantb)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="subfieldCodes">
			<xsl:choose>
				<xsl:when test="string-length($sousTitre) > 0">
					<subfieldcodes xmlns="">
						<code>a</code>
						<code>b</code>
						<code>c</code>
					</subfieldcodes>
				</xsl:when>
				<xsl:otherwise>
					<subfieldcodes xmlns="">
						<code>a</code>
						<code>c</code>
					</subfieldcodes>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="subfieldValues">
			<xsl:choose>
				<xsl:when test="string-length($sousTitre) > 0">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$titreNormalize"/>
						</value>
						<value>
							<xsl:value-of select="$sousTitre"/>
						</value>
						<value>
							<xsl:value-of select="$mentionResponsabilite"/>
						</value>
					</subfieldvalues>
				</xsl:when>
				<xsl:otherwise>
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$titreNormalize"/>
						</value>
						<value>
							<xsl:value-of select="$mentionResponsabilite"/>
						</value>
					</subfieldvalues>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Le 1er indicateur : 0 si la zone 100 absente ; 1 si la zone 100 présente (donc si c'est une these ou un travail étudiant avec un seul auteur... -->
		<xsl:variable name="ind1">
			<xsl:choose>
				<xsl:when
					test="($estUneTME_UdeM = 'true' or $estUnTravailÉtudiant = 'true') and $nombreAuteurs = 1">
					<value>1</value>
				</xsl:when>
				<xsl:otherwise>
					<value>0</value>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="ind2">
			<xsl:call-template name="getInd2_nb_nonfiling_chars">
				<xsl:with-param name="title"
					select="$dc/doc:element[@name = 'title'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]/text()"
				/>
			</xsl:call-template>
		</xsl:variable>



		<xsl:call-template name="createDataField">
			<xsl:with-param name="tag">245</xsl:with-param>
			<xsl:with-param name="ind1" select="$ind1"/>
			<xsl:with-param name="ind2" select="$ind2"/>
			<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
			<xsl:with-param name="subfieldValues" select="$subfieldValues"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="getInd2_nb_nonfiling_chars">
		<xsl:param name="title"/>
		<!-- 
			
			// [MHV] Notes sur : Second Indicator - Nonfiling characters 
			// Je vais conserver ce hack boiteux en essayant de prévoir les articles initiaux
			// français et anglais et espagnol
			
			// Je me base sur la liste des articles initiaux ignorés dans ATRIUM, pour les titres, soit:
			
			// A AI AL AN DAS DER DIE E EEN EENE EIN EINE EIS EL
			// ENA ENAS GLI HAI HEIS HEN HENA HENAS HET HOI I L'
			// LA LAS LE LES LI LO LOS OI THE UM UMA UN UNA UNE UNO
			
			// Je retiens pour l'instant uniquement les articles anglais et français et espagnol (99% du contenu de notre DI)
			
			// Ce template donne la valeur à mettre dans le 2e indicateur du 245
			
			
		-->
		<xsl:variable name="articles3"> <!-- articles longueur 3 -->
			<values xmlns="">
				<value>the </value>
				<value>une </value>
				<value>les </value>
				<value>las </value>
				<value>los </value>
				<value>una </value>
				<value>uno </value>
			</values>
		</xsl:variable>
		<xsl:variable name="articles2"> <!-- articles longueur 2 -->
			<values xmlns="">
				<value>an </value>
				<value>le </value>
				<value>la </value>
				<value>un </value>
				<value>el </value>
				<value>lo </value>
			</values>
		</xsl:variable>
		<xsl:variable name="lapostrophe" select="concat('l', $apostrophe)"/> <!-- l suivi d'un apostrophe (2 graphies à prévoir), pas suivi d'un espace -->
		<xsl:variable name="lapostrophe2" select="concat('l', $apostrophe2)"/>
		<xsl:variable name="articles1"> <!-- articles longueur 1 -->
			<values xmlns="">
				<value>a </value>
				<value>
					<xsl:value-of select="$lapostrophe"/>
				</value>
				<value>
					<xsl:value-of select="$lapostrophe2"/>
				</value>
			</values>
		</xsl:variable>
		<!-- on transforme les x (4, puis 3, puis 2) premiers caracteres du titre en lower case pour pouvoir, par la suite, 
		les comparer à notre liste et on les met dans une variable-->
		
		<!-- ex. de titre : "La capoiera" --> 
		<xsl:variable name="s14" select="translate(substring($title, 1, 4), $uc, $lc)"/>
		<xsl:variable name="s13" select="translate(substring($title, 1, 3), $uc, $lc)"/>
		<xsl:variable name="s12" select="translate(substring($title, 1, 2), $uc, $lc)"/>
		
		<!-- on compare ensuite ce debut de titre pour voir s'il s'agit bel et bien d'un article retenus dans notre liste et donc a exlure -->
		<xsl:variable name="isArticle3"> <!-- contiendra donc vrai ou faux i.e. oui on a un article à exclure ou non, ce mot de 3 lettres est qqchose d'autre qu'on ne veut pas exclure -->
			<xsl:call-template name="is3LengthArticle"> 
				<xsl:with-param name="articles3" select="$articles3"/>
				<xsl:with-param name="s" select="$s14"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="isArticle2">
			<xsl:call-template name="is2LengthArticle">
				<xsl:with-param name="articles2" select="$articles2"/>
				<xsl:with-param name="s" select="$s13"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="isArticle1">
			<xsl:call-template name="is1LengthArticle">
				<xsl:with-param name="articles1" select="$articles1"/>
				<xsl:with-param name="s" select="$s12"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<!-- on verifie que notre titre soit assez long et qu'on a bien un article à exclure (et donc à considérer dans le calcul du 2e indicateur).-->
			<xsl:when test="string-length($title) > 5 and $isArticle3 = 'true'">
				<!-- lorsqu'on a un article initial a exclure, on va  -->
				<xsl:variable name="s" select="translate(substring($title, 5, 1), $uc, $lc)"/>
				<xsl:variable name="hasPonctuation">
					<xsl:call-template name="hasPonctuation">
						<xsl:with-param name="s" select="$s"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$hasPonctuation = 'true'">5</xsl:when>
					<xsl:otherwise>4</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="string-length($title) > 4 and $isArticle2 = 'true'"> <!--(par ex. cette condition est vraie pour le titre : 'La Capoeira....') -->
				<!-- je regarde en suite si le caractère qui suit cet article est un caractère de ponctuation à enlever éventuellement : ex. 'La "Capoeira".... ') -->
				<xsl:variable name="s" select="translate(substring($title, 4, 1), $uc, $lc)"/>
				<xsl:variable name="hasPonctuation">
					<xsl:call-template name="hasPonctuation">
						<xsl:with-param name="s" select="$s"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$hasPonctuation = 'true'">4</xsl:when> <!-- si c'est un caractere de ponctuation je vais l'ajouter au compte des caractères à enlever (donc à comptabiliser dans le 2e indicateur) -->
					<xsl:otherwise>3</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="string-length($title) > 3 and $isArticle1 = 'true'">
				<xsl:variable name="s" select="translate(substring($title, 3, 1), $uc, $lc)"/>
				<xsl:variable name="hasPonctuation">
					<xsl:call-template name="hasPonctuation">
						<xsl:with-param name="s" select="$s"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$hasPonctuation = 'true'">2</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- Ça ne commence pas par un article -->
			<xsl:otherwise>
				<xsl:variable name="s" select="translate(substring($title, 1, 1), $uc, $lc)"/>
				<xsl:variable name="hasPonctuation"> <!-- mais est-ce que ca commence par un signe de ponctuation qu'on voudrait exclure? verifions....-->
					<xsl:call-template name="hasPonctuation">
						<xsl:with-param name="s" select="$s"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<!-- Commence par ponctuaction -->
					<xsl:when test="$hasPonctuation = 'true'"><!-- lorsque ca commence par un signe de ponctuation on va vérifier si c'est suivi d'un article également à exclure.... on reprend donc la meme approche de comparaison de la courte chaine qui suit le caractere de ponctuation -->
						<xsl:variable name="s25"
							select="translate(substring($title, 2, 5), $uc, $lc)"/>
						<xsl:variable name="s24"
							select="translate(substring($title, 2, 4), $uc, $lc)"/>
						<xsl:variable name="s23"
							select="translate(substring($title, 2, 3), $uc, $lc)"/>
						<xsl:variable name="isArticle3a">
							<xsl:call-template name="is3LengthArticle">
								<xsl:with-param name="articles3" select="$articles3"/>
								<xsl:with-param name="s" select="$s25"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="isArticle2a">
							<xsl:call-template name="is2LengthArticle">
								<xsl:with-param name="articles2" select="$articles2"/>
								<xsl:with-param name="s" select="$s24"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="isArticle1a">
							<xsl:call-template name="is1LengthArticle">
								<xsl:with-param name="articles1" select="$articles1"/>
								<xsl:with-param name="s" select="$s23"/>
							</xsl:call-template>
						</xsl:variable>
						<!-- si la ponctuation est effectivement suivie d'un article on va calculer la longueur de la chaine ponctuation + article en vue de la valeur du 2e ind. -->
						<xsl:choose>
							<xsl:when test="$isArticle3a = 'true'">5</xsl:when>
							<xsl:when test="$isArticle2a = 'true'">4</xsl:when>
							<xsl:when test="$isArticle1a = 'true'">3</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="hasPonctuation">
		<xsl:param name="s"/>
		<xsl:variable name="CarPonctuationAExclure">
			<values xmlns="">
				<value>«</value>
				<value>[</value>
				<value>(</value>
				<value>
					<xsl:value-of select="$apostrophe"/>
				</value>
				<value>
					<xsl:value-of select="$apostrophe2"/>
				</value>
				<value>
					<xsl:value-of select="$guillemet"/>
				</value>
				<value>“</value>
				<value>…</value>
			</values>
		</xsl:variable>
		<xsl:choose>
			<xsl:when
				test="contains($s, exsl:node-set($CarPonctuationAExclure)/values/value[1]) or contains($s, exsl:node-set($CarPonctuationAExclure)/values/value[2]) or contains($s, exsl:node-set($CarPonctuationAExclure)/values/value[3]) or contains($s, exsl:node-set($CarPonctuationAExclure)/values/value[4]) or contains($s, exsl:node-set($CarPonctuationAExclure)/values/value[5]) or contains($s, exsl:node-set($CarPonctuationAExclure)/values/value[6]) or contains($s, exsl:node-set($CarPonctuationAExclure)/values/value[7]) or contains($s, exsl:node-set($CarPonctuationAExclure)/values/value[8])">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="is3LengthArticle">
		<xsl:param name="articles3"/>
		<xsl:param name="s"/>
		<xsl:choose>
			<xsl:when
				test="contains($s, exsl:node-set($articles3)/values/value[1]) or contains($s, exsl:node-set($articles3)/values/value[2]) or contains($s, exsl:node-set($articles3)/values/value[3]) or contains($s, exsl:node-set($articles3)/values/value[4]) or contains($s, exsl:node-set($articles3)/values/value[5]) or contains($s, exsl:node-set($articles3)/values/value[6])">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="is2LengthArticle">
		<xsl:param name="articles2"/>
		<xsl:param name="s"/>
		<xsl:choose>
			<xsl:when
				test="contains($s, exsl:node-set($articles2)/values/value[1]) or contains($s, exsl:node-set($articles2)/values/value[2]) or contains($s, exsl:node-set($articles2)/values/value[3]) or contains($s, exsl:node-set($articles2)/values/value[4]) or contains($s, exsl:node-set($articles2)/values/value[5]) or contains($s, exsl:node-set($articles2)/values/value[6])">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="is1LengthArticle">
		<xsl:param name="articles1"/>
		<xsl:param name="s"/>
		<xsl:choose>
			<xsl:when
				test="contains($s, exsl:node-set($articles1)/values/value[1]) or contains($s, exsl:node-set($articles1)/values/value[2]) or contains($s, exsl:node-set($articles1)/values/value[3])">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="getMentionResponsabilite">
		<xsl:variable name="NomAuteur">
			<xsl:call-template name="joinAuthors">
				<xsl:with-param name="valueList"
					select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'author']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"
				/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$NomAuteur != ''">
				<xsl:value-of select="concat($NomAuteur, '.')"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="joinAuthors">
		<xsl:param name="valueList" select="''"/>
		<xsl:param name="separator" select="', '"/>
		<xsl:for-each select="$valueList">
			<xsl:variable name="authorName">
				<xsl:call-template name="getAuthorNameNotInversed">
					<xsl:with-param name="name" select="."/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="position() = 1">
					<xsl:value-of select="$authorName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($separator, $authorName)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<!-- 
		// [MHV] ******************************************************************************
		// Notes sur le 246 - 246 3# (Variante du titre) : $ a 
	-->

	<xsl:template name="createDataField246">
		<xsl:for-each
			select="$dcterms/doc:element[@name = 'alternative']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">246</xsl:with-param>
				<xsl:with-param name="ind1" select="'3'"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="."/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>



	<xsl:template name="createDataField251">
		<!-- en principe une seule version -->
		<xsl:for-each
			select="$UdeM/doc:element[@name = 'VersionRioxx']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:variable name="valeurfr">
				<xsl:value-of select="normalize-space(substring-before((.), '/'))"/>
			</xsl:variable>
			<xsl:variable name="valeuren">
				<xsl:value-of select="normalize-space(substring-after((.), '/'))"/>
			</xsl:variable>
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">251</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
						<code>1</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$valeurfr"/>
						</value>
						<value>
							
<xsl:choose>
					<xsl:when test="starts-with(normalize-space($valeuren),    concat('Author', $apostrophe,'s Original')       )">
							<xsl:value-of select="'http://purl.org/coar/version/c_b1a7d7d4d402bcce'"/>
					</xsl:when>

					<xsl:when test="starts-with(normalize-space($valeuren), 'Submitted Manuscript Under Review')">
							<xsl:value-of select="'http://purl.org/coar/version/c_71e4c1898caa6e32'"/>
					</xsl:when>

					<xsl:when test="starts-with(normalize-space($valeuren), 'Accepted Manuscript')">
							<xsl:value-of select="'http://purl.org/coar/version/c_ab4af688f83e57aa'"/>
					</xsl:when>

					<xsl:when test="starts-with(normalize-space($valeuren), 'Proof')">
							<xsl:value-of select="'http://purl.org/coar/version/c_fa2ee174bc00049f'"/>
					</xsl:when>

					<xsl:when test="starts-with(normalize-space($valeuren), 'Version of Record')">
							<xsl:value-of select="'http://purl.org/coar/version/c_970fb48d4fbd8a85'"/>
					</xsl:when>

					<xsl:when test="starts-with(normalize-space($valeuren), 'Corrected Version of Record')">
							<xsl:value-of select="'http://purl.org/coar/version/c_e19f295774971610'"/>
					</xsl:when>

					<xsl:when test="starts-with(normalize-space($valeuren), 'Enhanced Version of Record')">
							<xsl:value-of select="'http://purl.org/coar/version/c_dc82b40f9837b551'"/>
					</xsl:when>

					<xsl:when test="contains(normalize-space($valeuren), 'Unknown')">
							<xsl:value-of select="'http://purl.org/coar/version/c_be7fb7dd8ff6fe43'"/>
					</xsl:when>

					<xsl:otherwise>
							<xsl:value-of select="'http://purl.org/coar/version/c_be7fb7dd8ff6fe43'"/>
					</xsl:otherwise>

</xsl:choose>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>




	<!-- 
		// [MHV] ******************************************************************************
		// Notes sur le 264 - Mention du titre
	-->


	<xsl:template name="createDataField264">

		<xsl:variable name="estVersionPubliée">
			<xsl:for-each
				select="$UdeM/doc:element[@name = 'VersionRioxx']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<xsl:if test="contains(normalize-space(.), 'Version of Record')">
					<!-- donc aussi pour Corrected Version of Record et Enhanced Version of Record -->
					<xsl:value-of select="'true'"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="publishersNonVides"
			select="count($dc/doc:element[@name = 'publisher']/doc:element/doc:field[@name = 'value']/text()[normalize-space()])">
			<!-- a au moins un publisher non vide -->
		</xsl:variable>


		<xsl:variable name="publié">
			<xsl:choose>
				<xsl:when test="$estUneTME_UdeM = 'true'">
					<xsl:value-of select="'1'"/>
				</xsl:when>
				<xsl:when test="$estUnArticle = 'true' and $estVersionPubliée = 'true'">
					<xsl:value-of select="'1'"/>
				</xsl:when>
				<xsl:when
					test="$estUnArticle != 'true' and $estUneTME_UdeM != 'true' and $publishersNonVides > 0">
					<xsl:value-of select="'1'"/>
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="'0'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="zone264a">
			<xsl:choose>
				<xsl:when test="$estUneTME_UdeM = 'true'">[Montréal] :</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$publié = '1'">[Lieu de publication non identifié] :</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="grantor"
			select="count($etdms/doc:element[@name = 'grantor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]])"/>

		<xsl:variable name="zone264c">
			<xsl:choose>
				<xsl:when test="$dateSoumission and string-length($dateSoumission) > 0">
					<!-- seules les TME ont des date de soumission -->
					<xsl:value-of select="concat(substring($dateSoumission, 1, 4), '.')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="string-length($datePublication) > 0 and string-length($dateSoumission) = 0">
							<xsl:value-of select="concat(substring($datePublication, 1, 4), '.')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>



		<xsl:variable name="subfieldCodes">
			<xsl:choose>
				<xsl:when test="$publié = '1'">
					<subfieldcodes xmlns="">
						<code>a</code>


						<xsl:choose>
							<xsl:when test="$estUneTME_UdeM = 'true' and $grantor = 1">
								<xsl:for-each
									select="$etdms/doc:element[@name = 'grantor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
									<code>b</code>
								</xsl:for-each>
							</xsl:when>

							<xsl:when
								test="$estUnArticle = 'true' and $publishersNonVides > 0 and $publié = '1'">
								<code>b</code>
							</xsl:when>

							<!-- je prévois plusieurs editeurs -->
							<xsl:when test="$estUneTME_UdeM != 'true' and $publishersNonVides > 0">
								<xsl:for-each
									select="$dc/doc:element[@name = 'publisher']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
									<code>b</code>
								</xsl:for-each>
							</xsl:when>

							<xsl:otherwise/>
						</xsl:choose>


						<code>c</code>
					</subfieldcodes>
				</xsl:when>
				<xsl:otherwise>
					<subfieldcodes xmlns="">
						<code>c</code>
					</subfieldcodes>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="subfieldValues">
			<xsl:choose>
				<xsl:when test="$publié = '1'">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$zone264a"/>
						</value>



						<xsl:choose>
							<xsl:when test="$estUneTME_UdeM = 'true' and $grantor = 1">
								<xsl:for-each
									select="$etdms/doc:element[@name = 'grantor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
									<value>
										<xsl:value-of select="concat(., ',')"/>
									</value>
								</xsl:for-each>
							</xsl:when>

							<xsl:when
								test="$estUnArticle = 'true' and $publishersNonVides > 0 and $publié = '1'">
								<value>[éditeur non identifié],</value>
							</xsl:when>
							<!-- je prévois plusieurs editeurs -->
							<xsl:when test="$estUneTME_UdeM != 'true' and $publishersNonVides > 0">
								<xsl:for-each
									select="$dc/doc:element[@name = 'publisher']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
									<value>
										<xsl:value-of select="concat(., ',')"/>
									</value>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>



						<value>
							<xsl:value-of select="$zone264c"/>
						</value>
					</subfieldvalues>
				</xsl:when>
				<xsl:otherwise>
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$zone264c"/>
						</value>
					</subfieldvalues>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="createDataField">
			<xsl:with-param name="tag">264</xsl:with-param>
			<xsl:with-param name="ind1" select="' '"/>
			<xsl:with-param name="ind2">
				<xsl:value-of select="$publié"/>
			</xsl:with-param>
			<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
			<xsl:with-param name="subfieldValues" select="$subfieldValues"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="createDataField300">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">300</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>1 ressource en ligne</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>

	</xsl:template>


	<xsl:template name="createDataField336_337_338">
		<xsl:for-each
			select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:variable name="subfieldCodes">
				<subfieldcodes xmlns="">
					<code>a</code>
					<code>b</code>
					<code>2</code>
				</subfieldcodes>
			</xsl:variable>
			<xsl:choose>
				<xsl:when
					test="
						$estUnActesDeCongres = 'true' or
						$estUnArticle = 'true' or
						$estUneRevue = 'true' or
						$estUnLivre = 'true' or
						$estUnChapitredeLivre = 'true' or
						$estUnRapport = 'true' or
						$estUneTME = 'true'
						">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag">336</xsl:with-param>
						<xsl:with-param name="ind1" select="' '"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>texte</value>
								<value>txt</value>
								<value>rdacontent/fre</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$estUnFilmOuVidéo = 'true'">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag">336</xsl:with-param>
						<xsl:with-param name="ind1" select="' '"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>image animée bidimensionnelle</value>
								<value>tdi</value>
								<value>rdacontent/fre</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$estUnEnregistrementMusical = 'true'">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag">336</xsl:with-param>
						<xsl:with-param name="ind1" select="' '"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>musique exécutée</value>
								<value>prm</value>
								<value>rdacontent/fre</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when
					test="
						$estUnEnsembleDeDonnées = 'true' or
						$estUnePrésentationHorsCongrès = 'true' or
						$estUneContributionÀunCongrès = 'true' or
						$estUnTravailÉtudiant = 'true' or
						$estUnMatérielDidactique = 'true' or
						$estUnDocumentAutre = 'true'
						">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag">336</xsl:with-param>
						<xsl:with-param name="ind1" select="' '"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>données informatiques</value>
								<value>cod</value>
								<value>rdacontent/fre</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$estUnePartition = 'true'">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag">336</xsl:with-param>
						<xsl:with-param name="ind1" select="' '"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>musique notée</value>
								<value>ntm</value>
								<value>rdacontent/fre</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$estUnLogiciel = 'true'">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag">336</xsl:with-param>
						<xsl:with-param name="ind1" select="' '"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>programme informatique</value>
								<value>cop</value>
								<value>rdacontent/fre</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$estUneCarteGéographique = 'true'">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag">336</xsl:with-param>
						<xsl:with-param name="ind1" select="' '"/>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>image cartographique</value>
								<value>cri</value>
								<value>rdacontent/fre</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>


			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">337</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>informatique</value>
						<value>c</value>
						<value>rdamedia/fre</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">338</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>ressource en ligne</value>
						<value>cr</value>
						<value>rdacarrier/fre</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="createDataField490">
		<!-- MHV : je remplace les tirets longs et courts dans les noms de collections -->

		<xsl:if test="$estUneTME = 'true'">
			<xsl:variable name="degreename"
				select="$etdms/doc:element[@name = 'name']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> </xsl:variable>
			<xsl:variable name="discipline"
				select="$etdms/doc:element[@name = 'discipline']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> </xsl:variable>
			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when
						test="$estUneTME = 'true' and $discipline and string-length($discipline) > 0">
						<xsl:choose>
							<xsl:when test="$degreename and string-length($degreename) > 0">
								<xsl:value-of select="concat($discipline, ' (', $degreename, ')')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$discipline"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$value and string-length($value) > 0">
					<xsl:call-template name="createDataField">
						<xsl:with-param name="tag">490</xsl:with-param>
						<xsl:with-param name="ind1">0</xsl:with-param>
						<xsl:with-param name="ind2" select="' '"/>
						<xsl:with-param name="subfieldCodes">
							<subfieldcodes xmlns="">
								<code>a</code>
							</subfieldcodes>
						</xsl:with-param>
						<xsl:with-param name="subfieldValues">
							<subfieldvalues xmlns="">
								<value>
									<xsl:value-of select="$value"/>
								</value>
							</subfieldvalues>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>


		</xsl:if>
	</xsl:template>


	<xsl:template name="createDataField500Directeur">
		<!-- desuet -->
		<xsl:if test="$estUneTME_UdeM = 'true' or $estUnTravailÉtudiant_UdeM = 'true'">
			<xsl:variable name="nombreDirecteurs"
				select="count($dc/doc:element[@name = 'contributor']/doc:element[@name = 'advisor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]])"/>
			<xsl:if test="$nombreDirecteurs > 0">
				<xsl:variable name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:variable>
				<xsl:variable name="directeurs">
					<xsl:for-each
						select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'advisor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
						<xsl:if test="position() != 1">, </xsl:if>
						<xsl:call-template name="getAuthorNameNotInversed">
							<xsl:with-param name="name" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:choose>
								<xsl:when test="$estUneTME_UdeM = 'true'">
									<xsl:value-of
										select="(concat('Directeur(s) de thèse : ', $directeurs, '.'))"
									/>
								</xsl:when>
								<xsl:when test="$estUnTravailÉtudiant_UdeM = 'true'">
									<xsl:value-of
										select="(concat('Directeur(s) de recherche : ', $directeurs, '.'))"
									/>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</value>
					</subfieldvalues>
				</xsl:variable>
				<xsl:call-template name="createDataField">
					<xsl:with-param name="tag">500</xsl:with-param>
					<xsl:with-param name="ind1" select="' '"/>
					<xsl:with-param name="ind2" select="' '"/>
					<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
					<xsl:with-param name="subfieldValues" select="$subfieldValues"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>



	<!-- dec 2016: ajout des autres notes (dc.description) -->

	<xsl:template name="createDataField500">
		<xsl:for-each
			select="$dcterms/doc:element[@name = 'description']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">500</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="."/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="createDataField502">
		<xsl:if test="$estUneTME = 'true'">
			<xsl:variable name="degreename"
				select="$etdms/doc:element[@name = 'name']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"/>
			<xsl:variable name="date">
				<xsl:choose>
					<xsl:when
						test="string-length($dc/doc:element[@name = 'date']/doc:element[@name = 'issued'][position() = 1]/doc:element/doc:field[@name = 'value']/text()) > 0">
						<xsl:value-of
							select="concat(substring($dc/doc:element[@name = 'date']/doc:element[@name = 'issued'][position() = 1]/doc:element/doc:field[@name = 'value']/text(), 1, 4), '.')"
						/>
					</xsl:when>
					<xsl:when
						test="string-length($dc/doc:element[@name = 'date']/doc:element[@name = 'submitted'][position() = 1]/doc:element/doc:field[@name = 'value']/text()) > 0">
						<xsl:value-of
							select="concat(substring($dc/doc:element[@name = 'date']/doc:element[@name = 'submitted'][position() = 1]/doc:element/doc:field[@name = 'value']/text(), 1, 4), '.')"
						/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="degreegrantor"
				select="$etdms/doc:element[@name = 'grantor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"/>

			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">502</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>b</code>
						<code>c</code>
						<code>d</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$degreename"/>
						</value>
						<value>
							<xsl:value-of select="$degreegrantor"/>
						</value>
						<value>
							<xsl:value-of select="$date"/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	<!-- MHV : sepratation titre/auteur . Finalement on ne retient pas car syntaxe trop inconstante 

	<xsl:template name="createDataField505">
	<xsl:variable name="nombreToC"
			select="count($dcterms/doc:element[@name = 'tableOfContents']/doc:element/doc:field[@name = 'value'])"/>
		<xsl:if test="$nombreToC > 0">
				<datafield ind2="0" ind1="0" tag="505">
			<xsl:for-each
				select="$dcterms/doc:element[@name = 'tableOfContents']/doc:element/doc:field[@name = 'value']">
							<xsl:call-template name="splitToC">
								<xsl:with-param name="pText" select="."/>
							</xsl:call-template>
					</xsl:for-each>
				</datafield>
		</xsl:if>
	</xsl:template>

	<xsl:template name="splitToC">
		<xsl:param name="pText" select="."/>
		<xsl:if test="string-length($pText)">
			<xsl:if test="not($pText = .)"></xsl:if>
			<xsl:variable name="untitreetsonauteur" select="substring-before(concat($pText, ';'), ';')"/>
					<xsl:if test="string-length($untitreetsonauteur)">
						<subfield code="t"><xsl:value-of select="concat(substring-before($untitreetsonauteur, '/'), '/')"/></subfield>
						<subfield code="r"><xsl:value-of select="substring-after($untitreetsonauteur, '/')"/>
							</subfield>
			</xsl:if>
				<xsl:call-template name="splitToC"><xsl:with-param name="pText" select="substring-after($pText, ';')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
-->

	<xsl:template name="createDataField505">
		<xsl:for-each
			select="$dcterms/doc:element[@name = 'tableOfContents']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">505</xsl:with-param>
				<xsl:with-param name="ind1" select="'0'"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="."/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="createDataField506">

   <xsl:variable name="dateAvailable">
		<xsl:for-each
			select="$dc/doc:element[@name = 'date']/doc:element[@name = 'available']/doc:element/doc:field[@name = 'value']">
			<xsl:if test="contains(normalize-space(.), 'MONTHS_WITHHELD')">
				<xsl:value-of select="normalize-space(substring-after(., ':'))"/>
			</xsl:if>
		</xsl:for-each>
   </xsl:variable>

        <xsl:variable name="dateIssued">
					<xsl:if test="string-length($dc/doc:element[@name = 'date']/doc:element[@name = 'issued'][position() = 1]/doc:element/doc:field[@name = 'value']/text()) > 0">
						<xsl:value-of
							select="substring($dc/doc:element[@name = 'date']/doc:element[@name = 'issued'][position() = 1]/doc:element/doc:field[@name = 'value']/text(), 1, 10)"/>
					</xsl:if>
        </xsl:variable>

        <xsl:variable name="thereIsEmbargo">
            <xsl:choose>
                <xsl:when test="$dateAvailable and $dateIssued">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>




			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">506</xsl:with-param>
				<xsl:with-param name="ind1" select="'0'"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
						<code>f</code>

						<!-- testons si il y a un embargo (donc un date.issued et un date.available avec la chaine "MONTHS_WITHHELD" et si le nb de mois est bien une valeur numérique-->
						<xsl:if test="$dateIssued and (string(number($dateAvailable)) != 'NaN')">
								<code>g</code>
						</xsl:if>
								
						<code>q</code>
						<code>2</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>Accès ouvert</value>
						<value>libre accès en ligne</value>
						<!-- testons si il y a un embargo (donc un date.issued et un date.available avec la chaine "MONTHS-WITHHELD" et si le nb de mois est bien une valeur numérique-->
						<xsl:if test="$dateIssued and (string(number($dateAvailable)) != 'NaN')">
							<value>
	            <xsl:call-template name="AjouterMoisAUneDate">
	                <xsl:with-param name="dateTime" select="$dateIssued"/>
	                <xsl:with-param name="months-to-add" select="$dateAvailable"/>
	            </xsl:call-template>
	            </value>
						</xsl:if>
						<value>Papyrus : Dépôt institutionnel de l'Université de Montréal</value>
						<value>star</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>

	</xsl:template>


	<xsl:template name="createDataField516">

		<!-- nombre de formats differents contenus ds ORIGINAL -->
		<xsl:variable name="nombreFormatsDifferents">
				<xsl:value-of select="count($bundles/doc:element[@name = 'bundle']/
									doc:field[@name = 'name' and text() = 'ORIGINAL']/../doc:element[@name = 'bitstreams']/
									doc:element[@name = 'bitstream'][not(doc:field[@name = 'format']=preceding-sibling::
										doc:element[@name = 'bitstream']/doc:field[@name = 'format']
										)])"/>
</xsl:variable>
		<!-- MHV octobre 2020. On ne mettra cette note que lorsque 2 ou plus formats différents ; "Disponible en formats" tjrs au pluriel  -->
		<xsl:choose>
			<xsl:when test="($nombreFormatsDifferents and $nombreFormatsDifferents >= 2)">
				<xsl:call-template name="createDataField">
					<xsl:with-param name="tag">516</xsl:with-param>
					<xsl:with-param name="ind1" select="'8'"/>
					<xsl:with-param name="ind2" select="' '"/>
					<xsl:with-param name="subfieldCodes">
						<subfieldcodes xmlns="">
							<code>a</code>
						</subfieldcodes>
					</xsl:with-param>
					<xsl:with-param name="subfieldValues">
						<subfieldvalues xmlns="">
							<value><xsl:text>Disponible en formats </xsl:text>
								<xsl:for-each
									select="$bundles/doc:element[@name = 'bundle']/
									doc:field[@name = 'name' and text() = 'ORIGINAL']/../doc:element[@name = 'bitstreams']/
									doc:element[@name = 'bitstream'][not(doc:field[@name = 'format']=preceding-sibling::
										doc:element[@name = 'bitstream']/doc:field[@name = 'format']
										)]">
										<xsl:value-of
										select="substring-after(./doc:field[@name = 'format'], '/')"/>
										<xsl:choose>
											<xsl:when test="position() = last() - 1"> et </xsl:when>
											<xsl:when test="position() != last()">, </xsl:when>
											<xsl:when test="position() = last()">.</xsl:when>
										</xsl:choose>
								</xsl:for-each>
							</value>
						</subfieldvalues>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>





	<xsl:template name="createDataField520">
		<xsl:for-each
			select="$dcterms/doc:element[@name = 'abstract']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">520</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="."/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


<!-- MHV Juin 2020 : Je retire puisqu'on a fait le ménage des dc.identifier.citation -->
<!--
	<xsl:template name="createDataField524">

		<xsl:for-each
			select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'citation']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">524</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="."/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

-->

	<xsl:template name="createDataField542">
<!-- MHV : Je teste si on a au moins la présence d'un dc.rights ou d'un dc.rights.uri non-vide -->
<xsl:if test="(count($dc/doc:element[@name='rights']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) +
			count($dc/doc:element[@name='rights']/doc:element[@name='uri']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) ) > 0  "> 
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">542</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
				<xsl:for-each
					select="$dc/doc:element[@name = 'rights']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
						<code>f</code>
				</xsl:for-each>
				<xsl:for-each
					select="$dc/doc:element[@name = 'rights']/doc:element[@name = 'uri']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
						<code>u</code>
				</xsl:for-each>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
				<xsl:for-each
					select="$dc/doc:element[@name = 'rights']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
						<value>
							<xsl:value-of select="."/>
						</value>
				</xsl:for-each>
				<xsl:for-each
					select="$dc/doc:element[@name = 'rights']/doc:element[@name = 'uri']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
						<value>
							<xsl:value-of select="."/>
						</value>
				</xsl:for-each>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
			</xsl:if>
	</xsl:template>

	<xsl:template name="createDataField546">
		<xsl:choose>
			<xsl:when test="$estUneTME_UdeM = 'true'">
				<!-- si c'est une TME une *seule* langue (obligatoire) demandee dans bordereau -->
				<xsl:call-template name="createDataField">
					<xsl:with-param name="tag">546</xsl:with-param>
					<xsl:with-param name="ind1" select="' '"/>
					<xsl:with-param name="ind2" select="' '"/>
					<xsl:with-param name="subfieldCodes">
						<subfieldcodes xmlns="">
							<code>a</code>
						</subfieldcodes>
					</xsl:with-param>
					<xsl:with-param name="subfieldValues">
						<subfieldvalues xmlns="">
							<value>Comprend un résumé en anglais et en français.</value>
						</subfieldvalues>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- si ce n'est pas une TME -->
				<xsl:choose>
					<xsl:when test="($nombreLangues and $nombreLangues > 1)">
						<xsl:call-template name="createDataField">
							<xsl:with-param name="tag">546</xsl:with-param>
							<xsl:with-param name="ind1" select="' '"/>
							<xsl:with-param name="ind2" select="' '"/>
							<xsl:with-param name="subfieldCodes">
								<subfieldcodes xmlns="">
									<code>a</code>
								</subfieldcodes>
							</xsl:with-param>
							<xsl:with-param name="subfieldValues">

								<subfieldvalues xmlns="">
									<value>Texte en <xsl:for-each
											select="$dcterms/doc:element[@name = 'language']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][not(contains(., 'zxx' or 'und'))]">
											<xsl:call-template
												name="ConvertirCodeLangueEnTexteFrançais"
												><xsl:with-param name="cettelangue" select="."/>
											</xsl:call-template>
											<xsl:choose>
												<xsl:when test="position() = last() - 1"> et </xsl:when>
												<xsl:when test="position() != last()">, </xsl:when>
												<xsl:when test="position() = last()">.</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</value>
								</subfieldvalues>
							</xsl:with-param>

						</xsl:call-template>

					</xsl:when>
					<xsl:otherwise> </xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="createDataField653BB">
		<xsl:if
			test="(count($dc/doc:element[@name = 'subject']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) > 1)">
				<xsl:for-each
					select="$dc/doc:element[@name = 'subject']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
						<xsl:call-template name="createDataField">
							<xsl:with-param name="tag">653</xsl:with-param>
							<xsl:with-param name="ind1" select="' '"/>
							<xsl:with-param name="ind2" select="' '"/>
							<xsl:with-param name="subfieldCodes">
								<subfieldcodes xmlns="">
									<code>a</code>
								</subfieldcodes>
							</xsl:with-param>
							<xsl:with-param name="subfieldValues">
								<subfieldvalues xmlns="">
									<value>
										<xsl:value-of select="."/>
									</value>
								</subfieldvalues>
							</xsl:with-param>
						</xsl:call-template>
				</xsl:for-each>
		</xsl:if>
	</xsl:template>



	<xsl:template name="createDataField653B6">
		<xsl:if
			test="
				$estUnArticle = 'true'
				or $estUnRapport = 'true'
				or $estUnChapitredeLivre = 'true'
				or $estUnEnregistrementMusical = 'true'
				or $estUnEnsembleDeDonnées = 'true'
				or $estUnLogiciel = 'true'
				or $estUnePrésentationHorsCongrès = 'true'
				or $estUneContributionÀunCongrès = 'true'
				or $estUnTravailÉtudiant = 'true'
				">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">653</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2">6</xsl:with-param>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:choose>

								
								<xsl:when test="$estUnTravailÉtudiant = 'true'">
									
								<xsl:variable name="udemcycle"
				select="$UdeM/doc:element[@name = 'cycle']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"/>
											<xsl:choose>
												<xsl:when test="contains( $udemcycle,'cycles supérieurs')">
													<xsl:value-of select="'Travail étudiant aux cycles supérieurs'"/>
												</xsl:when>
												<xsl:when
													test="contains( $udemcycle, 'premier cycle')">
													<xsl:value-of select="'Travail étudiant au premier cycle'"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of
														select="normalize-space(substring-before($dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']/text(), '/'))"	/>
												</xsl:otherwise>
											</xsl:choose>
									
									
								</xsl:when>
								<xsl:otherwise>
												<xsl:choose>
												<xsl:when
													test="contains($dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']/text(),'/')">
													<xsl:value-of
														select="normalize-space(substring-before($dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']/text(), '/'))"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of
														select="normalize-space($dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']/text())"
													/>
												</xsl:otherwise>
												</xsl:choose>
								
								</xsl:otherwise>

								
							</xsl:choose>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>




	<xsl:template name="createDataField655">
		<xsl:if
			test="
				$estUnActesDeCongres = 'true'
				or $estUneRevue = 'true'
				or $estUnLivre = 'true'
				or $estUnePartition = 'true'
				or $estUnFilmOuVidéo = 'true'
				or $estUneCarteGéographique = 'true'
				or $estUneTME = 'true'
				or $estUnMatérielDidactique = 'true'
				">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">655</xsl:with-param>
				<xsl:with-param name="ind1" select="' '"/>
				<xsl:with-param name="ind2">7</xsl:with-param>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
						<code>2</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:choose>
								<xsl:when test="$estUnActesDeCongres = 'true'">Actes de congrès</xsl:when>
								<xsl:when test="$estUneRevue = 'true'">Publications en série numériques</xsl:when>
								<xsl:when test="$estUnLivre = 'true'">Livres numériques</xsl:when>
								<xsl:when test="$estUnePartition = 'true'">Partitions (Musique)</xsl:when>
								<xsl:when test="$estUnFilmOuVidéo = 'true'">Vidéos</xsl:when>
								<xsl:when test="$estUneCarteGéographique = 'true'">Cartes géographiques</xsl:when>
								<xsl:when test="$estUneTME = 'true'">Thèses et écrits académiques</xsl:when>
								<xsl:when test="$estUnMatérielDidactique = 'true'">Matériel d'éducation et de formation</xsl:when>
							</xsl:choose>
						</value>
						<value>rvmgf</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="createDataField730">
		<!-- On n'affiche plus -->
		<xsl:if test="$estUneTME_UdeM = 'true' or $estUnTravailÉtudiant_UdeM = 'true'">
			<xsl:variable name="degree">
				<xsl:choose>
					<xsl:when
						test="contains($etdms/doc:element[@name = 'level']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]], 'Maîtrise')"
						>Maîtrise</xsl:when>
					<xsl:when
						test="contains($etdms/doc:element[@name = 'level']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]], 'Doctorat')"
						>Doctorat</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="discipline"
				select="$etdms/doc:element[@name = 'discipline']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> </xsl:variable>
			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$estUneTME_UdeM = 'true'">
						<xsl:value-of select="concat('Thèse. ', $discipline, ' (', $degree, ')')"/>
					</xsl:when>
					<xsl:when test="$estUnTravailÉtudiant_UdeM = 'true'">
						<xsl:value-of
							select="concat('Travail aux cycles supérieurs. ', $discipline, ' (', $degree, ')')"
						/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">730</xsl:with-param>
				<xsl:with-param name="ind1">0</xsl:with-param>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$value"/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Titre alternative -->
	<xsl:template name="createDataField740">
		<!-- Champ répétable -->
		<xsl:for-each
			select="$dc/doc:element[@name = 'title']/doc:element[@name = 'alternative'][position() = 1]/doc:element/doc:field[@name = 'value']/text()">
			<xsl:variable name="alternativeTitle" select="."/>

			<xsl:variable name="subfieldCodes">
				<subfieldcodes xmlns="">
					<code>a</code>
				</subfieldcodes>
			</xsl:variable>
			<xsl:variable name="subfieldValues">
				<subfieldvalues xmlns="">
					<value>
						<xsl:call-template name="getAlternatifTitle">
							<xsl:with-param name="altTitle" select="$alternativeTitle"/>
						</xsl:call-template>
					</value>
				</subfieldvalues>
			</xsl:variable>

			<xsl:variable name="ind2">
				<xsl:call-template name="getInd2_nb_nonfiling_chars">
					<xsl:with-param name="title"
						select="$dc/doc:element[@name = 'title']/doc:element[@name = 'alternative'][position() = 1]/doc:element/doc:field[@name = 'value']/text()"/>

				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">740</xsl:with-param>
				<xsl:with-param name="ind1"/>
				<xsl:with-param name="ind2" select="$ind2"/>
				<xsl:with-param name="subfieldCodes" select="$subfieldCodes"/>
				<xsl:with-param name="subfieldValues" select="$subfieldValues"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getAlternatifTitle">
		<xsl:param name="altTitle"/>
		<xsl:variable name="altTitleLength" select="string-length($altTitle)"/>
		<!-- 
			// [MHV] verifions s'il y a un point final au titre, dans lequel cas on va l'enlever			
		-->
		<xsl:variable name="lastChar" select="substring($altTitle, string-length($altTitle), 1)"/>
		<xsl:variable name="altTitleWithoutPoint">
			<xsl:choose>
				<xsl:when test="$lastChar = '.'">
					<xsl:value-of select="substring($altTitle, 1, $altTitleLength - 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$altTitle"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="altTitleLength2" select="string-length($altTitleWithoutPoint)"/>
		<!-- Field 740 ends with a mark of punctuation or a closing parenthesis.
			A mark of punctuation is placed inside a closing quotation mark.			
		-->
		<xsl:variable name="ClosingChars">
			<values xmlns="">
				<value>»</value>
				<value>]</value>
				<value>)</value>
				<value>
					<xsl:value-of select="$apostrophe"/>
				</value>
				<value>
					<xsl:value-of select="$guillemet"/>
				</value>
			</values>
		</xsl:variable>
		<xsl:variable name="hasClosingChars"
			select="$lastChar = exsl:node-set($ClosingChars)/values/value[1] or $lastChar = exsl:node-set($ClosingChars)/values/value[2] or $lastChar = exsl:node-set($ClosingChars)/values/value[3] or $lastChar = exsl:node-set($ClosingChars)/values/value[4] or $lastChar = exsl:node-set($ClosingChars)/values/value[5]"/>
		<xsl:variable name="altTitleWithoutClosingChar">
			<xsl:choose>
				<xsl:when test="$hasClosingChars">
					<xsl:value-of select="substring($altTitleWithoutPoint, 1, $altTitleLength2 - 1)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$altTitleWithoutPoint"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="altTitleLength3" select="string-length($altTitleWithoutClosingChar)"/>
		<xsl:variable name="lastChar2"
			select="substring($altTitleWithoutClosingChar, string-length($altTitleWithoutClosingChar), 1)"/>
		<xsl:variable name="altTitleWithoutEndingSpace">
			<xsl:choose>
				<xsl:when test="$lastChar2 = ' '">
					<xsl:value-of
						select="substring($altTitleWithoutClosingChar, 1, $altTitleLength3 - 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$altTitleWithoutClosingChar"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$hasClosingChars">
				<xsl:choose>
					<xsl:when test="$lastChar2 = ' '">
						<xsl:value-of select="concat($altTitleWithoutEndingSpace, '. ', $lastChar)"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($altTitleWithoutEndingSpace, '.', $lastChar)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($altTitleWithoutEndingSpace, '.')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="OLDcreateDataField773">
<!-- MHV juin 2020 : ancienne forme pour dcterms.bibliographicCitation (desuet sous peu)-->
		<xsl:for-each
			select="$dcterms/doc:element[@name = 'bibliographicCitation']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:variable name="t">
				<xsl:choose>
					<xsl:when test="contains(., ';')">
						<xsl:value-of select="normalize-space(substring-before(., ';'))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="g">
				<xsl:choose>
					<xsl:when test="contains(., ';')">
						<xsl:value-of select="normalize-space(substring-after(., ';'))"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="x">
				<!-- MHV : on prend seulement le 1er ISSN puisque $x n'est pas repetable -->
				<xsl:value-of
					select="normalize-space(substring-after($dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'urn:ISSN:')][position() = 1], 'urn:ISSN:'))"
				/>
			</xsl:variable>


			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">773</xsl:with-param>
				<xsl:with-param name="ind1">0</xsl:with-param>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<xsl:if test="$t != ''">
							<code>t</code>
						</xsl:if>
						<xsl:if test="$g != ''">
							<code>g</code>
						</xsl:if>
						<xsl:if test="$x != ''">
							<code>x</code>
						</xsl:if>
						<xsl:for-each
							select="$dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'urn:ISBN:')]">
							<code>z</code>
						</xsl:for-each>
						<xsl:for-each
							select="$dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'doi:')]">
							<code>o</code>
						</xsl:for-each>

					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<xsl:if test="$t != ''">
							<value>
								<xsl:value-of select="$t"/>
							</value>
						</xsl:if>
						<xsl:if test="$g != ''">
							<value>
								<xsl:value-of select="$g"/>
							</value>
						</xsl:if>
						<xsl:if test="$x != ''">
							<value>
								<xsl:value-of select="$x"/>
							</value>
						</xsl:if>
						<xsl:for-each
							select="$dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'urn:ISBN:')]">
							<value>
								<xsl:value-of select="substring-after(., 'urn:ISBN:')"/>
							</value>
						</xsl:for-each>

						<xsl:for-each
							select="$dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'doi:')]">
							<value>
								<xsl:value-of
									select="concat('https://doi.org/', substring-after(., 'doi:'))"
								/>
							</value>
						</xsl:for-each>

					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<!--
		<xsl:if test="$estUnChapitredeLivre = 'true'">
			<xsl:variable name="livreSource"
				select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'citation']/doc:element/doc:field[@name = 'value']"> </xsl:variable>

			<xsl:variable name="t">
				<xsl:choose>
					<xsl:when test="contains($livreSource, 'In:')">
						<xsl:value-of select="normalize-space(substring-after($livreSource, 'In:'))"
						/>
					</xsl:when>
					<xsl:when test="contains($livreSource, 'In :')">
						<xsl:value-of
							select="normalize-space(substring-after($livreSource, 'In :'))"/>
					</xsl:when>
					<xsl:when test="contains($livreSource, 'Dans:')">
						<xsl:value-of
							select="normalize-space(substring-after($livreSource, 'Dans:'))"/>
					</xsl:when>
					<xsl:when test="contains($livreSource, 'Dans :')">
						<xsl:value-of
							select="normalize-space(substring-after($livreSource, 'Dans :'))"/>
					</xsl:when>
					<xsl:when test="contains($livreSource, ', dans ')">
						<xsl:value-of
							select="normalize-space(substring-after($livreSource, ', dans '))"/>
					</xsl:when>
					<xsl:when test="contains($livreSource, ', In ')">
						<xsl:value-of
							select="normalize-space(substring-after($livreSource, ', In '))"/>
					</xsl:when>
					<xsl:when test="contains($livreSource, ', in ')">
						<xsl:value-of
							select="normalize-space(substring-after($livreSource, ', in '))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$livreSource"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">773</xsl:with-param>
				<xsl:with-param name="ind1">0</xsl:with-param>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>t</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$t"/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
-->
	</xsl:template>

	<xsl:template name="createDataField773new">

<!-- verification si au moins un element citation pour faire un 773-->

	<xsl:variable name="t"
		select="$oaire/doc:element[@name = 'citationTitle'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"/>

	<xsl:variable name="b"
		select="$oaire/doc:element[@name = 'citationEdition'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"/>

	<xsl:variable name="g">
<!-- $g  -->

<!-- citationVolume -->
<!-- pour article (et ds qqs rares cas chapitre livre)-->
          <xsl:for-each select="$oaire/doc:element[@name = 'citationVolume'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 
              <xsl:text>vol. </xsl:text><xsl:copy-of select="./node()"/>
                 <xsl:choose> 
                     <!-- si il y a un numero qui s'en vient je mets une virgule. -->
											<xsl:when test="count(./../../following-sibling::doc:element[@name ='citationIssue'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 "><xsl:text>, </xsl:text></xsl:when>
                     	<xsl:otherwise>
                     <!-- si il y n'y a pas de numero mais qu'il y a des pages qui s'en viennent je mets une virgule   -->
												<xsl:if test="count(./../../following-sibling::doc:element[@name ='citationStartPage'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 "><xsl:text>, </xsl:text></xsl:if>
                     </xsl:otherwise>
                </xsl:choose>
          </xsl:for-each>


<!-- citationIssue -->
<!-- pour article (et ds qqs rares cas contribution congres)-->
           <xsl:for-each select="$oaire/doc:element[@name = 'citationIssue'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 
                <xsl:text>no </xsl:text><xsl:copy-of select="./node()"/>
                 <!-- si il y a des pages qui s'en viennent (ou une place/date de congres) je mets une virgule   -->
								<xsl:if test="count(./../../following-sibling::doc:element[@name ='citationStartPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) = 1 
						or
					count(./../../following-sibling::doc:element[starts-with(@name,'citation') and contains(@name,'Conference')]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 
																		"><xsl:text>, </xsl:text></xsl:if>
           </xsl:for-each>


<!-- citationStartPage et citationEndPage-->
<!-- "groupe page" pour article et chapitre de livre et conference-->
            
                <xsl:for-each select="$oaire/doc:element[@name = 'citationStartPage'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 
				                   <xsl:text>p. </xsl:text><xsl:copy-of select="./node()"/>
                <!-- si il y a une page de fin qui s'en vient je mets un tiret -->
											<xsl:if test="count(./../../following-sibling::doc:element[@name ='citationEndPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) = 1 "><xsl:text>-</xsl:text></xsl:if>
                </xsl:for-each>
                
                <xsl:for-each select="$oaire/doc:element[@name = 'citationEndPage'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
                    <xsl:copy-of select="./node()"/>
                </xsl:for-each>
<!-- fin $g  -->
			</xsl:variable>

	<xsl:variable name="n">
<!-- $n  -->
<!-- citationConferencePlace -->
<!-- pour conference place -->
        <xsl:if test="count($oaire/doc:element[starts-with(@name,'citation') and contains(@name,'Conference')]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1">

                <xsl:for-each select="$oaire/doc:element[@name = 'citationConferencePlace'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 
                    <xsl:copy-of select="./node()"/>
                    <!-- si il y a une date qui s'en vient je mets une virgule. -->
                    <xsl:if test="count(./../../following-sibling::doc:element[@name ='citationConferenceDate']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 "><xsl:text>, </xsl:text></xsl:if>
                </xsl:for-each>

<!-- pour conference date -->
                <xsl:for-each select="$oaire/doc:element[@name = 'citationConferenceDate'][position() = 1]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 
                    <xsl:copy-of select="./node()"/>
                </xsl:for-each>
                
        </xsl:if>

<!-- fin $n  -->
			</xsl:variable>


			<xsl:variable name="x">
				<!-- MHV : on prend seulement le 1er ISSN puisque $x n'est pas repetable -->
				<xsl:value-of
					select="normalize-space(substring-after($dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'urn:ISSN:')][position() = 1], 'urn:ISSN:'))"
				/>
			</xsl:variable>
<!-- </xsl:if>	-->

<!-- on verifie la presence d'un contenu de citation (en theorie minimalement $t) pour ne pas crééer un 773 vide -->
<xsl:if test="$t != ''  or  $b != ''  or  $g != '' or  $n != '' or  $x != '' ">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">773</xsl:with-param>
				<xsl:with-param name="ind1">0</xsl:with-param>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">



					<xsl:if test="$t != ''">
							<code>t</code>
						</xsl:if>
					<xsl:if test="$b != ''">
							<code>b</code>
						</xsl:if>
					<xsl:if test="$g != ''">
							<code>g</code>
						</xsl:if>  
					<xsl:if test="$n != ''">
							<code>n</code>
						</xsl:if> 
					<xsl:if test="$x != ''">
							<code>x</code>
						</xsl:if>
						<xsl:for-each
							select="$dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'urn:ISBN:')]">
							<code>z</code>
						</xsl:for-each>
						<xsl:for-each
							select="$dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'doi:')]">
							<code>o</code>
						</xsl:for-each> 

					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
					<xsl:if test="$t != ''">
							<value>
								<xsl:value-of select="$t"/>
							</value>
						</xsl:if>
					<xsl:if test="$b != ''">
							<value>
								<xsl:value-of select="concat($b,'e éd.')"/>
							</value>
						</xsl:if>
						<xsl:if test="$g != ''">
							<value>
								<xsl:value-of select="$g"/>
							</value>
						</xsl:if>
						<xsl:if test="$n != ''">
							<value>
								<xsl:value-of select="$n"/>
							</value>
						</xsl:if>
						<xsl:if test="$x != ''">
							<value>
								<xsl:value-of select="$x"/>
							</value>
						</xsl:if>
						<xsl:for-each
							select="$dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'urn:ISBN:')]">
							<value>
								<xsl:value-of select="substring-after(., 'urn:ISBN:')"/>
							</value>
						</xsl:for-each>

						<xsl:for-each
							select="$dcterms/doc:element[@name = 'isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]][starts-with(., 'doi:')]">
							<value>
								<xsl:value-of
									select="concat('https://doi.org/', substring-after(., 'doi:'))"
								/>
							</value>
						</xsl:for-each> 

					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
</xsl:if>

</xsl:template>


	<xsl:template name="createDataField767">
		<xsl:for-each
			select="$dcterms/doc:element[@name = 'hasVersion']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">767</xsl:with-param>
				<xsl:with-param name="ind1" select="'0'"/>
				<xsl:with-param name="ind2" select="'8'"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>i</code>
						<code>o</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>Autre version linguistique</value>
						<value><xsl:value-of select="."/></value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="createDataField787">
		<xsl:for-each
			select="$dcterms/doc:element[@name = 'relation']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">787</xsl:with-param>
				<xsl:with-param name="ind1" select="'0'"/>
				<xsl:with-param name="ind2" select="'8'"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>i</code>
						<code>o</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>Ensemble de données de recherche liées</value>
						<value><xsl:value-of select="."/></value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="createDataField793">
		<xsl:if test="$estUnTravailÉtudiant_UdeM = 'true' or $estUneTME_UdeM = 'true'">
			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$estUneTME_UdeM = 'true'">
						<xsl:value-of select="'TheseUdeM'"/>
					</xsl:when>
					<xsl:when test="$estUnTravailÉtudiant_UdeM = 'true'">
						<xsl:value-of select="'TravauxUdeM'"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="createDataField">
				<xsl:with-param name="tag">793</xsl:with-param>
				<xsl:with-param name="ind1" select="'0'"/>
				<xsl:with-param name="ind2" select="' '"/>
				<xsl:with-param name="subfieldCodes">
					<subfieldcodes xmlns="">
						<code>a</code>
					</subfieldcodes>
				</xsl:with-param>
				<xsl:with-param name="subfieldValues">
					<subfieldvalues xmlns="">
						<value>
							<xsl:value-of select="$value"/>
						</value>
					</subfieldvalues>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="createDataField799">
		<!-- MHV : je remplace les tirets longs et courts dans les noms de collections -->
		<xsl:variable name="nombreCollectionsPapyrus"
			select="count($others/doc:element[@name = 'collections']/doc:field[@name = 'collection']/text())"/>

		<xsl:if test="$nombreCollectionsPapyrus > 0">
			<xsl:for-each
				select="$others/doc:element[@name = 'collections']/doc:field[@name = 'collection' and descendant::text()[normalize-space()]]">
				<xsl:call-template name="createDataField">
					<xsl:with-param name="tag">799</xsl:with-param>
					<xsl:with-param name="ind1" select="'0'"/>
					<xsl:with-param name="ind2" select="' '"/>
					<xsl:with-param name="subfieldCodes">
						<subfieldcodes xmlns="">
							<code>a</code>
						</subfieldcodes>
					</xsl:with-param>
					<xsl:with-param name="subfieldValues">
						<subfieldvalues xmlns="">
							<value>

						<xsl:variable name="texteSansTiretCourt">
								<xsl:call-template name="remplaceTout">
									<xsl:with-param name="texte" select="."/>
									<xsl:with-param name="replace" select="' - '"/>
									<xsl:with-param name="par" select="'. '"/>
								</xsl:call-template>
						</xsl:variable>

								<xsl:call-template name="remplaceTout">
									<xsl:with-param name="texte" select="$texteSansTiretCourt"/>
									<xsl:with-param name="replace" select="' – '"/> 
									<xsl:with-param name="par" select="'. '"/>
								</xsl:call-template>

							</value>
						</subfieldvalues>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>


	<xsl:template name="createDataField856">
		<!-- en principe on a toujours minimalement un identifier.uri (le handle local), donc au moins un 856 ; je ne fais donc pas de vérification préliminaire pour voir si ce champ existe-->

		<xsl:choose>
			<!-- cas special des theses en musique.... en principe pas d'autres doi ou uri..... -->
			<xsl:when
				test="$estTME_Musique = 'true' and $aUnLienVersVersionCompleteTME_Musique = 'true'">
				<xsl:for-each
					select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'uri' or @name = 'doi']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
					<xsl:variable name="uri" select="."/>
					<xsl:choose>
						<xsl:when
							test="contains($uri, 'hdl.handle.net/1866') or contains($uri, 'hdl.handle.net/1973')">
							<xsl:call-template name="createDataField">
								<xsl:with-param name="tag">856</xsl:with-param>
								<xsl:with-param name="ind1">4</xsl:with-param>
								<xsl:with-param name="ind2">1</xsl:with-param>
								<xsl:with-param name="subfieldCodes">
									<subfieldcodes xmlns="">
										<code>3</code>
										<code>u</code>
									</subfieldcodes>
								</xsl:with-param>
								<xsl:with-param name="subfieldValues">
									<subfieldvalues xmlns="">
										<value>Version tronquée d'éléments protégés par le droit
											d'auteur</value>
										<value>
											<xsl:value-of select="$uri"/>
										</value>
									</subfieldvalues>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="contains($uri, 'docs.bib.umontreal.ca/musique')">
							<xsl:call-template name="createDataField">
								<xsl:with-param name="tag">856</xsl:with-param>
								<xsl:with-param name="ind1">4</xsl:with-param>
								<xsl:with-param name="ind2">0</xsl:with-param>
								<xsl:with-param name="subfieldCodes">
									<subfieldcodes xmlns="">
										<code>z</code>
										<code>u</code>
									</subfieldcodes>
								</xsl:with-param>
								<xsl:with-param name="subfieldValues">
									<subfieldvalues xmlns="">
										<value>Accès réservé UdeM</value>
										<value>
											<xsl:value-of select="$uri"/>
										</value>
									</subfieldvalues>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>



			<!-- MHV sept. 2019 Je change 856 avec multiples $u (normes MARC), pour plusieurs 856 avec un $u chacun...because limitation de PRIMO à bien afficher les liens :-( -->

				<xsl:for-each
					select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'uri' or @name = 'doi']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">

						<xsl:variable name="typeidentifier" select="../../@name"/>

							<xsl:call-template name="createDataField">
								<xsl:with-param name="tag">856</xsl:with-param>
								<xsl:with-param name="ind1">4</xsl:with-param>
								<xsl:with-param name="ind2">0</xsl:with-param>
								<xsl:with-param name="subfieldCodes">
									<subfieldcodes xmlns="">
										<code>u</code>
									</subfieldcodes>
								</xsl:with-param>
								<xsl:with-param name="subfieldValues">

									<subfieldvalues xmlns="">
										<xsl:choose>
											<!-- est sous la forme "10.1186/1471-2105-7-391" -->
											<xsl:when test="contains($typeidentifier, 'doi')">
											<value>
												<xsl:value-of select="concat('https://doi.org/', .)"/>
											</value>
										</xsl:when>

											<xsl:when test="contains($typeidentifier, 'uri')">
											<value>
												<xsl:value-of select="."/>
											</value>
										</xsl:when>

										<xsl:otherwise> 
											<value>
												<xsl:value-of select="."/>
											</value>
										</xsl:otherwise>
										</xsl:choose>
									</subfieldvalues>

								</xsl:with-param>
							</xsl:call-template>
				</xsl:for-each>
				</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<!--
				<xsl:call-template name="createDataField">
					<xsl:with-param name="tag">856</xsl:with-param>
					<xsl:with-param name="ind1">4</xsl:with-param>
					<xsl:with-param name="ind2">0</xsl:with-param>
					<xsl:with-param name="subfieldCodes">
						<subfieldcodes xmlns="">
							<xsl:for-each
								select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'uri' or @name = 'doi']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
								<code>u</code>
							</xsl:for-each>
						</subfieldcodes>
					</xsl:with-param>
					<xsl:with-param name="subfieldValues">
						<subfieldvalues xmlns="">
							<xsl:for-each
								select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'doi']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
								<value>
									<xsl:value-of select="concat('https://doi.org/', .)"/>
								</value>
							</xsl:for-each>
							<xsl:for-each
								select="$dc/doc:element[@name = 'identifier']/doc:element[@name = 'uri']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
								<value>
									<xsl:value-of select="."/>
								</value>
							</xsl:for-each>
						</subfieldvalues>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
-->

	<xsl:template name="createDataField">
		<xsl:param name="tag"/>
		<xsl:param name="ind1"/>
		<xsl:param name="ind2"/>
		<xsl:param name="subfieldCodes"/>
		<xsl:param name="subfieldValues"/>
<!-- MHV aout 2020 : l'ancienne façon (ci-apres en commentaires) ne contrôlait pas bien l'ordre d'affichage des attributs.
je veux en contrôler l'ordre pour mettre ind1 avant ind2 -->
<!--		<datafield tag="{$tag}" ind1="{$ind1}" ind2="{$ind2}"> -->
		<xsl:element name="datafield">
					<xsl:attribute name="tag"><xsl:value-of select="$tag"/></xsl:attribute>
					<xsl:attribute name="ind1"><xsl:value-of select="$ind1"/></xsl:attribute>
					<xsl:attribute name="ind2"><xsl:value-of select="$ind2"/></xsl:attribute>
			<xsl:for-each select="exsl:node-set($subfieldCodes)//code">
				<xsl:variable name="position" select="position()"/>
				<xsl:element name="subfield">
					<xsl:attribute name="code">
						<xsl:value-of select="."/>
					</xsl:attribute>
					<xsl:value-of
						select="exsl:node-set($subfieldValues)/subfieldvalues/value[$position]"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		<!-- </datafield> -->
	</xsl:template>













</xsl:stylesheet>
