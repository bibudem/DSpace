<?xml version="1.0" encoding="UTF-8" ?>
<!-- 


    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/
	Developed by DSpace @ Lyncode <jmelo@lyncode.com>
	
	> http://www.openarchives.org/OAI/2.0/oai_dc.xsd


	MHV. FEV 2017 : je m'appuie sur le fichier [SOURCE]\dspace\config\crosswalks\QDC.properties et http://dublincore.org/documents/dc-xml-guidelines/ pour completer la
	transformation. J'ai aussi consulté [SOURCE]\dspace\crosswalks\oai\metadataFormats\uketd_dc.xsl et https://raw.githubusercontent.com/swigroup/dspace-semantic-search/master/dspace/config/crosswalks/oai/metadataFormats/qdc.xsl.
	Je vais prévoir surtout pour les éléments utilisés dans Papyrus. À ajuster au besoin si on introduit de nouveaux éléments.

 -->
<!--// MHV Rappel:Pour modifier ce fichier sans recompiler les sources; faire les modifs dans installation/config/crosswalk/oai/metadataformat/*.xsl puis repartir tomcat puis faire un oai clean-cache.-->

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:doc="http://www.lyncode.com/xoai"
	version="1.0">
	<xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />

<!-- VARIABLES -->
	<xsl:variable name="UdeM" select="doc:metadata/doc:element[@name = 'UdeM']"/>
	<xsl:variable name="dc" select="doc:metadata/doc:element[@name = 'dc']"/>
	<xsl:variable name="dcterms" select="doc:metadata/doc:element[@name = 'dcterms']"/>
	<xsl:variable name="oaire" select="doc:metadata/doc:element[@name = 'oaire']"/>
	<xsl:variable name="etdms" select="doc:metadata/doc:element[@name = 'etd']"/>
	<xsl:variable name="bundles" select="doc:metadata/doc:element[@name = 'bundles']"/>
	<!-- to lower case -->
	<xsl:variable name="lc" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uc" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

<!-- variable est-ce une these ou un memoire electronique (i.e. "TME" = "EDT") -->
	<xsl:variable name="TME">
		<xsl:for-each select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']" >
			<xsl:if test="contains(normalize-space(.), 'Thesis or Dissertation')">
				<xsl:value-of select="'true'"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="level">
		<xsl:for-each select="$etdms/doc:element[@name = 'degree']/doc:element[@name = 'level']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<xsl:choose>
					<xsl:when test="contains(.,'Maîtrise')">
					<xsl:value-of select="'Maîtrise'"/>
					</xsl:when>
					<xsl:when
					test="contains(., 'Doctorat')">
					<xsl:value-of select="'Doctorat'"/>
					</xsl:when>
					<xsl:otherwise>
					</xsl:otherwise>
				</xsl:choose>
		</xsl:for-each>
	</xsl:variable>


<!-- MHV. Pour la grande majorité des theses, on a un dc.date.submitted et un dc.date.issued; pour l'instant (oct. 2016) on veut mettre ds l'element "date"
de etdms, la valeur de dc.date.submitted. Mais si on n'en a pas (de dc.date.submitted), on va mettre la valeur de dc.date.issued (en principe tjrs present).
Par ex. ceci est le cas des theses des collections retrospectives -->

	<xsl:variable name="dateSoumission"
		select="$dc/doc:element[@name = 'date']/doc:element[@name = 'submitted']/doc:element/doc:field[@name = 'value' and position() = 1]"/>
	<xsl:variable name="datePublication"
		select="$dc/doc:element[@name = 'date']/doc:element[@name = 'issued']/doc:element/doc:field[@name = 'value' and position() = 1]"/>	

	<xsl:variable name="laDate">
			<xsl:choose>
				<xsl:when test="$dateSoumission and string-length($dateSoumission) > 0">
					<xsl:value-of select="substring($dateSoumission,0, 11)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="string-length($datePublication) > 0 and string-length($dateSoumission) = 0">
							<xsl:value-of select="substring($datePublication, 1, 4)"
							/></xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:variable>




	<xsl:template match="/">
		<qdc:qualifieddc
				xmlns:qdc="http://dspace.org/qualifieddc/"
				xmlns:dc="http://purl.org/dc/elements/1.1/"
				xmlns:dcterms="http://purl.org/dc/terms/"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
				xsi:schemaLocation="http://purl.org/dc/elements/1.1/ 
				http://dublincore.org/schemas/xmls/qdc/2006/01/06/dc.xsd
				http://purl.org/dc/terms/
				http://dublincore.org/schemas/xmls/qdc/2006/01/06/dcterms.xsd
				http://dspace.org/qualifieddc/
				http://www.ukoln.ac.uk/metadata/dcmi/xmlschema/qualifieddc.xsd
				http://www.w3.org/1999/02/22-rdf-syntax-ns#
				http://www.openarchives.org/OAI/2.0/rdf.xsd ">

            <!-- ******* Titre: <dc:title> ******* -->
            <!-- dc.title -->
			<xsl:for-each select="$dc/doc:element[@name='title']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:title><xsl:value-of select="." /></dc:title>
			</xsl:for-each>


            <!-- ******* Titre alternatif: <dcterms:alternative> ******* -->

		<!-- MHV ajout: -->
			<xsl:for-each select="$dc/doc:element[@name='title']/doc:element[@name='alternative']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:alternative><xsl:value-of select="." /></dcterms:alternative>
			</xsl:for-each>

			<xsl:for-each select="$dcterms/doc:element[@name='alternative']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:alternative><xsl:value-of select="." /></dcterms:alternative>
			</xsl:for-each>


            <!-- ******* Auteur: <dc.creator> ******* -->
            <!-- dc.contributor.author -->
		<!-- MHV. Note: pour dc.contributor on a des "literal values" donc tout dans dc et non dcterms -->
			<xsl:for-each select="$dc/doc:element[@name='creator']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:creator>
					<xsl:value-of select="." />
				</dc:creator>
			</xsl:for-each>
			<xsl:for-each select="$dc/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:creator>
					<xsl:value-of select="." />
				</dc:creator>
			</xsl:for-each>


            <!-- ******* Supervisor(s)/Advisor(s) : <dc:contributor> ******* -->
            <!-- dc.contributor.advisor -->
			<xsl:for-each select="$dc/doc:element[@name='contributor']/doc:element[@name!='author']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:contributor>
					<xsl:value-of select="." />
				</dc:contributor>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='contributor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:contributor>
					<xsl:value-of select="." />
				</dc:contributor>
			</xsl:for-each>


           <!-- ******* Subject Keywords: <dc:subject> ******* -->
           <!-- dc.subject -->
			<xsl:for-each select="$dc/doc:element[@name='subject']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:subject>
					<xsl:value-of select="." />
				</dc:subject>
			</xsl:for-each>

            <!-- dc.subject.other -->
            <xsl:for-each select="$dc/doc:element[@name='subject']/doc:element[@name='other']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
                <dc:subject><xsl:value-of select="." /></dc:subject>
            </xsl:for-each>

            <!-- ******* DDC Keywords: <dc:subject xsi:type="dcterms:DDC"> ******* -->
            <!-- dc.subject.ddc -->
            <xsl:for-each select="$dc/doc:element[@name='subject']/doc:element[@name='ddc']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
                <dc:subject xsi:type="dcterms:DDC"><xsl:value-of select="." /></dc:subject>
            </xsl:for-each>

            <!-- ******* LCC Keywords: <dc:subject xsi:type="dcterms:LCC"> ******* -->
            <!-- dc.subject.lcc -->
            <xsl:for-each select="$dc/doc:element[@name='subject']/doc:element[@name='lcc']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
                <dc:subject xsi:type="dcterms:LCC"><xsl:value-of select="." /></dc:subject>
            </xsl:for-each>

            <!-- ******* LCSH Keywords: <dc:subject xsi:type="dcterms:LCSH"> ******* -->
            <!-- dc.subject.lcsh -->
            <xsl:for-each select="$dc/doc:element[@name='subject']/doc:element[@name='lcsh']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
                <dc:subject xsi:type="dcterms:LCSH"><xsl:value-of select="." /></dc:subject>
            </xsl:for-each>

            <!-- ******* MESH Keywords: <dc:subject xsi:type="dcterms:MESH"> ******* -->
            <!-- dc.subject.mesh -->
            <xsl:for-each select="$dc/doc:element[@name='subject']/doc:element[@name='mesh']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
                <dc:subject xsi:type="dcterms:MESH"><xsl:value-of select="." /></dc:subject>
            </xsl:for-each>


            <!-- ******* Abstract: <dcterms:abstract> ******* -->
            <!-- dc.description.abstract -->
			<xsl:for-each select="$dcterms/doc:element[@name='abstract']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:abstract>
					<xsl:value-of select="." />
				</dcterms:abstract>
			</xsl:for-each>


            <!-- dc.description.tableofcontents -->
			<xsl:for-each select="$dcterms/doc:element[@name='tableOfContents']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:tableOfContents>
					<xsl:value-of select="." />
				</dcterms:tableOfContents>
			</xsl:for-each>

            <!-- ******* Notes: <dc:description> ******* -->
            <!-- dc:description -->
			<xsl:for-each select="$dcterms/doc:element[@name='description']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:description>
					<xsl:value-of select="." />
				</dcterms:description>
			</xsl:for-each>


            <!-- ******* Dates ******* -->

			<xsl:for-each select="$dc/doc:element[@name='date']/doc:element[@name='submitted']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:dateSubmitted xsi:type="dcterms:ISO8601">
					<xsl:value-of select="." />
				</dcterms:dateSubmitted>
			</xsl:for-each>
			
			<xsl:for-each select="$dc/doc:element[@name='date']/doc:element[@name='available']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
			<xsl:if test="not(contains(normalize-space(.), 'NO_RESTRICTION')) and not(contains(normalize-space(.), 'MONTHS_WITHHELD'))">
				<dcterms:available xsi:type="dcterms:ISO8601">
					<xsl:value-of select="." />
				</dcterms:available>
				</xsl:if>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:issued xsi:type="dcterms:ISO8601">
					<xsl:value-of select="." />
				</dcterms:issued>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='date']/doc:element[@name='created']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:created xsi:type="dcterms:ISO8601">
					<xsl:value-of select="." />
				</dcterms:created>
			</xsl:for-each>
			

<!-- on exprime uniquement en COAR -->
<!--			
			<xsl:for-each
				select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
				<dc:type>
					<xsl:attribute name="xml:lang">
						<xsl:value-of select="'fr'"/>
					</xsl:attribute>

												<xsl:choose>
												<xsl:when
													test="contains(.,'/')">
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

				</dc:type>


				<dc:type>
					<xsl:attribute name="xml:lang">
						<xsl:value-of select="'en'"/>
					</xsl:attribute>

												<xsl:choose>
												<xsl:when
													test="contains(.,'/')">
													<xsl:value-of
														select="normalize-space(substring-after($dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']/text(), '/'))"
													/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of
														select="normalize-space($dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']/text())"
													/>
												</xsl:otherwise>
												</xsl:choose>
				</dc:type>
			</xsl:for-each>
			
-->


			<xsl:for-each
				select="$dc/doc:element[@name = 'type']/doc:element/doc:field[@name = 'value']">
													<xsl:choose>
												<xsl:when
													test="contains(.,'Actes de congrès')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_f744"/>

												</xsl:when>
												<xsl:when
													test="contains(.,'Article')"> <!-- on a choisi de faire correspondre à "Journal article" et non "article" -->
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_6501"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Revue')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_0640"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Livre')"> <!-- Livre avec majuscule donc pas chapitre-->
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_2f33"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Chapitre de livre')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_3248"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Enregistrement musical')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_18cd"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Partition')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_18cw"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Film ou vidéo')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_12ce"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Ensemble de données')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_ddb1"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Logiciel')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_5ce6"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Carte géographique')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_12cd"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Rapport')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_93fc"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Présentation hors congrès')"> <!-- autre -->
													<dcterms:type rdf:resource="	http://purl.org/coar/resource_type/c_1843"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Contribution à un congrès')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_c94f"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Thèse ou mémoire')"> <!-- en couplant avec le degree je vais faire un type plus exlicite : maitrise ou doctorat.... -->
														<xsl:choose>
														<xsl:when test="$TME = 'true' and $level = 'Maîtrise'">
															<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_bdcc"/>
														</xsl:when>
														<xsl:when test="$TME = 'true' and $level = 'Doctorat'">
															<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_db06"/>
														</xsl:when>
														<xsl:otherwise>
															<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_46ec"/>
														</xsl:otherwise>
														</xsl:choose>
												</xsl:when>
												<xsl:when
													test="contains(.,'Travail étudiant')"> <!-- generique : text...mais est-ce que c'est toujours du text...? -->
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_18cf"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Matériel didactique')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_e059"/>
												</xsl:when>
												<xsl:when
													test="contains(.,'Autre')">
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_1843"/>
												</xsl:when>
												<xsl:otherwise>
													<dcterms:type rdf:resource="http://purl.org/coar/resource_type/c_1843"/>
												</xsl:otherwise>
												</xsl:choose>

			</xsl:for-each>








            <!-- ******* Identifiants ******* -->
			<!-- identifier sans attribut -->
			<xsl:for-each select="$dc/doc:element[@name='identifier']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
						<dc:identifier>
							<xsl:value-of select="."/>
						</dc:identifier>
			</xsl:for-each>

			
			<xsl:for-each select="$dc/doc:element[@name='identifier']/doc:element/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
		    <xsl:variable name="qualifier" select="ancestor::doc:element[2]/@name"/>
		    <xsl:variable name="value" select="."/>
       <xsl:choose>
         <xsl:when test="$qualifier='citation'">
					<dcterms:bibliographicCitation>
							<xsl:value-of select="$value" />
					</dcterms:bibliographicCitation>
        </xsl:when>

        <xsl:when test="$qualifier='doi'">
						<dcterms:identifier xsi:type="dcterms:URI">https://doi.org/<xsl:value-of select="$value"/>
						</dcterms:identifier>
        </xsl:when>
 
         <xsl:when test="$qualifier='uri'">
						<dcterms:identifier xsi:type="dcterms:URI">
							<xsl:value-of select="$value"/>
						</dcterms:identifier>
        </xsl:when>

         <xsl:when test="$qualifier='isbn'">
						<dcterms:identifier xsi:type="dcterms:ISBN">
							<xsl:value-of select="$value"/>
						</dcterms:identifier>
        </xsl:when>

         <xsl:when test="$qualifier='issn'">
						<dcterms:identifier xsi:type="dcterms:ISSN">
							<xsl:value-of select="$value"/>
						</dcterms:identifier>
        </xsl:when>


 				<!-- autre attribut (ex.: isbn) -->
        <xsl:otherwise>
						<dc:identifier>
							<xsl:value-of select="$value"/>
						</dc:identifier>
        </xsl:otherwise>
      </xsl:choose>
			</xsl:for-each>


				<xsl:for-each select="doc:metadata/doc:element[@name='UdeM']/doc:element[@name='ORCIDAuteurThese']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:identifier xsi:type="dcterms:URI"><xsl:value-of select="concat('https://orcid.org/', .)" /></dc:identifier>
			</xsl:for-each>


            <!-- ******* Language: <dc:language xsi:type="dcterms:ISO639-3"> ******* -->
			<xsl:for-each select="$dcterms/doc:element[@name='language']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:language xsi:type="dcterms:ISO639-3">
					<xsl:value-of select="." />
				</dcterms:language>
			</xsl:for-each>




            <!-- ******* Relation ******* -->

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:relation>
					<xsl:value-of select="." />
				</dc:relation>
			</xsl:for-each>
			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:relation>
					<xsl:value-of select="." />
				</dc:relation>
			</xsl:for-each>
			<!-- dcterms.relation : Recommended practice is to identify the related resource by means of a URI.-->
			<xsl:for-each select="$dcterms/doc:element[@name='relation']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:relation>
					<xsl:value-of select="." />
				</dcterms:relation>
			</xsl:for-each>






			<xsl:for-each select="$dcterms/doc:element[@name='isFormatOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isFormatOf>
					<xsl:value-of select="." />
				</dcterms:isFormatOf>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='isformatof']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isFormatOf>
					<xsl:value-of select="." />
				</dcterms:isFormatOf>
			</xsl:for-each>


			<xsl:for-each select="$dcterms/doc:element[@name='isPartOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isPartOf>
					<xsl:value-of select="." />
				</dcterms:isPartOf>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='ispartof']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isPartOf>
					<xsl:value-of select="." />
				</dcterms:isPartOf>
			</xsl:for-each>


			<xsl:for-each select="$dcterms/doc:element[@name='hasPart']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:hasPart>
					<xsl:value-of select="." />
				</dcterms:hasPart>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='haspart']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:hasPart>
					<xsl:value-of select="." />
				</dcterms:hasPart>
			</xsl:for-each>

			<xsl:for-each select="$dcterms/doc:element[@name='isVersionOf']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isVersionOf>
					<xsl:value-of select="." />
				</dcterms:isVersionOf>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='isversionof']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isVersionOf>
					<xsl:value-of select="." />
				</dcterms:isVersionOf>
			</xsl:for-each>


			<xsl:for-each select="$dcterms/doc:element[@name='hasVersion']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:hasVersion>
					<xsl:value-of select="." />
				</dcterms:hasVersion>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='hasversion']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:hasVersion>
					<xsl:value-of select="." />
				</dcterms:hasVersion>
			</xsl:for-each>


			<xsl:for-each select="$dcterms/doc:element[@name='isReferencedBy']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isReferencedBy>
					<xsl:value-of select="." />
				</dcterms:isReferencedBy>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='isreferencedby']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isReferencedBy>
					<xsl:value-of select="." />
				</dcterms:isReferencedBy>
			</xsl:for-each>


			<xsl:for-each select="$dcterms/doc:element[@name='requires']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:requires>
					<xsl:value-of select="." />
				</dcterms:requires>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='requires']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:requires>
					<xsl:value-of select="." />
				</dcterms:requires>
			</xsl:for-each>


			<xsl:for-each select="$dcterms/doc:element[@name='replaces']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:replaces>
					<xsl:value-of select="." />
				</dcterms:replaces>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='replaces']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:replaces>
					<xsl:value-of select="." />
				</dcterms:replaces>
			</xsl:for-each>


			<xsl:for-each select="$dcterms/doc:element[@name='isReplacedBy']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isReplacedBy>
					<xsl:value-of select="." />
				</dcterms:isReplacedBy>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='isreplacedby']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:isReplacedBy>
					<xsl:value-of select="." />
				</dcterms:isReplacedBy>
			</xsl:for-each>


			<xsl:for-each select="$dc/doc:element[@name='relation']/doc:element[@name='uri']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:relation xsi:type="dcterms:URI">
					<xsl:value-of select="." />
				</dc:relation>
			</xsl:for-each>



			<xsl:for-each select="$dc/doc:element[@name='rights']/doc:element/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:rights>
					<xsl:value-of select="." />
				</dc:rights>
			</xsl:for-each>
			<xsl:for-each select="$dc/doc:element[@name='rights']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:rights>
					<xsl:value-of select="." />
				</dc:rights>
			</xsl:for-each>
			
			<!-- cas special des theses et memoire avec mention droits d'auteur a l'auteur -->
				<xsl:if test="$TME = 'true'">
						<dc:rights>
								<xsl:variable name="auteur">
									<xsl:call-template name="obtenirNomAuteur">
										<xsl:with-param name="auteur"
											select="$dc/doc:element[@name = 'contributor']/doc:element[@name = 'author']/doc:element/doc:field[@name = 'value']"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:variable name="annee"
											select="substring($laDate, 0, 5)"/>
									<xsl:value-of select="concat('© ', $auteur, ', ', $annee)"/>
						</dc:rights>
				</xsl:if>


            <!-- ******* URLs for digital object(s) (obtained from file 'bundles') ******* -->
<!--            <xsl:for-each select="doc:metadata/doc:element[@name='bundles']/doc:element[@name='bundle']"> -->
                <!-- ******* URLs for content bitstreams (from ORIGINAL bundle): <dc:identifier xsi:type="dcterms:URI"> ******* -->
<!--                <xsl:if test="doc:field[@name='name']/text() = 'ORIGINAL'">
                    <xsl:for-each select="doc:element[@name='bitstreams']/doc:element">
                        <dc:identifier xsi:type="dcterms:URI"><xsl:value-of select="doc:field[@name='url']/text()" /></dc:identifier>
                        <dc:format><xsl:value-of select="doc:field[@name='format']/text()" /></dc:format>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
-->

		<!-- nombre de formats differents contenus ds ORIGINAL -->
		<xsl:variable name="nombreFormatsDifferents">
				<xsl:value-of select="count($bundles/doc:element[@name = 'bundle']/
									doc:field[@name = 'name' and text() = 'ORIGINAL']/../doc:element[@name = 'bitstreams']/
									doc:element[@name = 'bitstream'][not(doc:field[@name = 'format']=preceding-sibling::
										doc:element[@name = 'bitstream']/doc:field[@name = 'format']
										)])"/>
		</xsl:variable>


		<xsl:choose>
			<xsl:when test="($nombreFormatsDifferents and $nombreFormatsDifferents >= 1)">
				<dc:format>
								<xsl:for-each
									select="$bundles/doc:element[@name = 'bundle']/
									doc:field[@name = 'name' and text() = 'ORIGINAL']/../doc:element[@name = 'bitstreams']/
									doc:element[@name = 'bitstream'][not(doc:field[@name = 'format']=preceding-sibling::
										doc:element[@name = 'bitstream']/doc:field[@name = 'format']
										)]">
										<xsl:value-of
										select="./doc:field[@name = 'format']"/>
										<xsl:choose>
											<xsl:when test="position() = last() - 1"> et </xsl:when>
											<xsl:when test="position() != last()">, </xsl:when>
										</xsl:choose>
								</xsl:for-each>
				</dc:format>
			</xsl:when>
			<xsl:otherwise /> 
		</xsl:choose>
			
			
			
			
			<xsl:for-each select="$dc/doc:element[@name='coverage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:coverage>
					<xsl:value-of select="." />
				</dc:coverage>
			</xsl:for-each>
			<xsl:for-each select="$dc/doc:element[@name='coverage']/doc:element/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:coverage>
					<xsl:value-of select="." />
				</dc:coverage>
			</xsl:for-each>


            <!-- ******* Éditeur / Institution : <dcterms:publisher> ******* -->


			
			<xsl:for-each select="$dc/doc:element[@name='publisher']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:publisher>
					<xsl:value-of select="." />
				</dc:publisher>
			</xsl:for-each>
			<xsl:for-each select="$dc/doc:element[@name='publisher']/doc:element/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:publisher>
					<xsl:value-of select="." />
				</dc:publisher>
			</xsl:for-each>



			<xsl:for-each select="doc:metadata/doc:element[@name='etd']/doc:element[@name='degree']/doc:element[@name='grantor']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:publisher>
					<xsl:value-of select="." />
				</dc:publisher>
			</xsl:for-each>

<!-- non-litteral values -->
			<xsl:for-each select="$dcterms/doc:element[@name='publisher']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dcterms:publisher>
					<xsl:value-of select="." />
				</dcterms:publisher>
			</xsl:for-each>

			<xsl:for-each select="$dc/doc:element[@name='source']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:source>
					<xsl:value-of select="." />
				</dc:source>
			</xsl:for-each>
			<xsl:for-each select="$dc/doc:element[@name='source']/doc:element/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]">
				<dc:source>
					<xsl:value-of select="." />
				</dc:source>
			</xsl:for-each>
	

<!-- mars 2020 : fragmentation de la ref bibliographique selon element Open Aire. Pour l'affichage fr et en je vais m'inspirer du style MLA -->

			<!-- je mets citationEdition dans une variable-->
        <xsl:variable name="mentionEdition"
            select="normalize-space($oaire/doc:element[@name='citationEdition']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]])"/>

      <xsl:variable name="langdudoc" select="$dcterms/doc:element[@name='language']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]" />


		<!-- verification si au moins un element citation pour ouvrir element bibliographicCitation-->
<xsl:if test="count($oaire/doc:element[starts-with(@name,'citation')]) >= 1">
<dcterms:bibliographicCitation>
<!-- citationTitle -->
<!-- pour article, chapitre de livre et contribution congres-->

        <xsl:if test="count($oaire/doc:element[@name = 'citationTitle']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1">

                <xsl:for-each select="$oaire/doc:element[@name = 'citationTitle']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 
                    <xsl:value-of select="."/>

                    <!-- si chapitre de livre on concatene la mention d'édition si non vide-->
				                    <xsl:if test="$mentionEdition != ''">
				                    		<xsl:choose>
				                    			<xsl:when test="$langdudoc = 'fra'">
				                    				(<xsl:value-of select="normalize-space($mentionEdition)"/><xsl:text>e éd.)</xsl:text>
				                    			</xsl:when>
				                    		<xsl:otherwise>
															<!-- MHV si interface affichage anglais ou non specifie je vais faire mettre des regles pour l'anglais: -->
				                    			(<xsl:value-of select="normalize-space($mentionEdition)"/>
						                    		<xsl:choose>
						                    			<!-- MHV je fais un equivalent de ends-with pour XSLT 1.0 -->
																				<xsl:when test="'1' = substring((normalize-space($mentionEdition)), string-length(normalize-space($mentionEdition)) - string-length('1') +1)"><xsl:text>st</xsl:text></xsl:when>
																				<xsl:when test="'2' = substring((normalize-space($mentionEdition)), string-length(normalize-space($mentionEdition)) - string-length('2') +1)"><xsl:text>nd</xsl:text></xsl:when>
																				<xsl:when test="'3' = substring((normalize-space($mentionEdition)), string-length(normalize-space($mentionEdition)) - string-length('3') +1)"><xsl:text>rd</xsl:text></xsl:when>
																				<xsl:otherwise><xsl:text>th</xsl:text></xsl:otherwise>
						                    				</xsl:choose>
				                    			<xsl:text>ed.)</xsl:text>
				                    		</xsl:otherwise>
				                    	</xsl:choose>
				                    </xsl:if>
				                    <!-- si il y a d'autres elements citation non-vide a venir on ajoute une ponctuation de separation (;)-->
				<xsl:if test="count(./../../following-sibling::doc:element[starts-with(@name,'citation')]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 "><xsl:text> ; </xsl:text></xsl:if>
                </xsl:for-each>
          </xsl:if>

<!-- citationVolume -->
<!-- pour article (et ds qqs rares cas chapitre livre)-->
                <xsl:for-each select="$oaire/doc:element[@name = 'citationVolume']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 
                    <xsl:text>vol. </xsl:text><xsl:copy-of select="./node()"/>
                       <xsl:choose> 
                                 <!-- si il y a un numero qui s'en vient je mets une virgule. -->
				<xsl:when test="count(./../../following-sibling::doc:element[@name ='citationIssue']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 "><xsl:text>, </xsl:text></xsl:when>
                           <xsl:otherwise>
                                 <!-- si il y n'y a pas de numero mais qu'il y a des pages qui s'en viennent je mets une virgule sinon point final apres le volume  -->
								                		<xsl:choose>
				<xsl:when test="count(./../../following-sibling::doc:element[@name ='citationStartPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 "><xsl:text>, </xsl:text></xsl:when>
																			<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
																		</xsl:choose>
                           </xsl:otherwise>
                      </xsl:choose>
                </xsl:for-each>

<!-- citationIssue -->
<!-- pour article (et ds qqs rares cas contribution congres)-->
                <xsl:for-each select="$oaire/doc:element[@name = 'citationIssue']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 
                    <xsl:text>no</xsl:text><xsl:if test="$langdudoc != 'fra'"><xsl:text>.</xsl:text></xsl:if><xsl:text> </xsl:text><xsl:copy-of select="./node()"/>
                                 <!-- si il y a des pages qui s'en viennent (ou une place/date de congres) je mets une virgule sinon point final apres le issue  -->
								                		<xsl:choose>

				<xsl:when test="count(./../../following-sibling::doc:element[@name ='citationStartPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) = 1 
						or
							count(./../../following-sibling::doc:element[starts-with(@name,'citation') and contains(@name,'Conference')]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 
																				"><xsl:text>, </xsl:text></xsl:when>
																			<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
																		</xsl:choose>
               </xsl:for-each>

<!-- citationConferencePlace -->
<!-- pour conference -->
        <xsl:if test="count($oaire/doc:element[starts-with(@name,'citation') and contains(@name,'Conference')]/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1">

                <xsl:for-each select="$oaire/doc:element[@name = 'citationConferencePlace']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 

                    <xsl:copy-of select="./node()"/>
                      <xsl:choose> 
                                 <!-- si il y a une date qui s'en vient je mets une virgule. -->
                                 <xsl:when test="count(./../../following-sibling::doc:element[@name ='citationConferenceDate']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 ">, </xsl:when>
                           <xsl:otherwise>
                                 <!-- si il y a des pages qui s'en viennent je mets une virgule sinon point final apres le groupe date/place conf. -->
								                		<xsl:choose>
                                 <xsl:when test="count(./../../preceding-sibling::doc:element[@name ='citationStartPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 ">, </xsl:when>
																			<xsl:otherwise>.</xsl:otherwise>
																		</xsl:choose>
                           	
                           </xsl:otherwise>
                      </xsl:choose>
                </xsl:for-each>

<!-- pour conference -->
                <xsl:for-each select="$oaire/doc:element[@name = 'citationConferenceDate']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 

                    <xsl:copy-of select="./node()"/>
                <!-- si il y a des pages qui s'en viennent je mets une virgule sinon point final apres le groupe date/place conf. -->
										<xsl:choose>
                                 <xsl:when test="count(./../../preceding-sibling::doc:element[@name ='citationStartPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) >= 1 ">, </xsl:when>
											<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
										</xsl:choose>
                </xsl:for-each>
                
            </xsl:if>



<!-- citationStartPage et citationEndPage-->
<!-- "groupe page" pour article et chapitre de livre et conference-->
            
                <xsl:for-each select="$oaire/doc:element[@name = 'citationStartPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 


				                    		<xsl:choose>
				                    			<xsl:when test="$langdudoc = 'fra'">
				                    				p. <xsl:copy-of select="./node()"/>
				                    			</xsl:when>
				                    		<xsl:otherwise>
																		<!-- pour affichage anglais pp. ou p. selon le contexte -->
																		<xsl:choose>
																			<xsl:when test="count(./../../following-sibling::doc:element[@name ='citationEndPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) = 1 "><xsl:text>pp. </xsl:text><xsl:copy-of select="./node()"/></xsl:when>
																			<xsl:otherwise><xsl:text>p. </xsl:text><xsl:copy-of select="./node()"/></xsl:otherwise>
																		</xsl:choose>

				                    		</xsl:otherwise>
				                    		</xsl:choose>


                <!-- si il y a une page de fin qui s'en vient je mets un tiret sinon point final de la référence biblio-->
										<xsl:choose>
											<xsl:when test="count(./../../following-sibling::doc:element[@name ='citationEndPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]) = 1 "><xsl:text>-</xsl:text></xsl:when>
											<xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
										</xsl:choose>

                </xsl:for-each>
                
                <xsl:for-each select="$oaire/doc:element[@name = 'citationEndPage']/doc:element/doc:field[@name = 'value' and descendant::text()[normalize-space()]]"> 

                <!-- avec point final de la référence biblio-->
                    <xsl:copy-of select="./node()"/><xsl:text>.</xsl:text>
                </xsl:for-each>

				</dcterms:bibliographicCitation>
      </xsl:if>


		</qdc:qualifieddc>
	</xsl:template>

	<xsl:template name="obtenirNomAuteur">
		<xsl:param name="auteur"/>
		<xsl:variable name="nomFamille" select="substring-before($auteur, ',')"/>
		<xsl:variable name="prenom" select="substring-after($auteur, ', ')"/>
		<xsl:value-of select="concat($prenom, ' ', $nomFamille)"/>
	</xsl:template>

</xsl:stylesheet>


