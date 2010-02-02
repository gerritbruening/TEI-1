<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:cals="http://www.oasis-open.org/specs/tm9901"
                xmlns:iso="http://www.iso.org/ns/1.0"
                xmlns:its="http://www.w3.org/2005/11/its"
                xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:o="urn:schemas-microsoft-com:office:office"
                xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
                xmlns:v="urn:schemas-microsoft-com:vml"
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
                xmlns:w10="urn:schemas-microsoft-com:office:word"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                exclude-result-prefixes="teidocx cals ve o r m v wp w10 w wne mml tbx iso tei a xs pic fn its">
    <!-- import conversion style -->
    <xsl:import href="../../../docx/to/to.xsl"/>
    <xsl:import href="../isoutils.xsl"/>
    
    <!-- import functions -->
    <xsl:include href="iso-functions.xsl"/>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>ISO-specific overrides for TEI stylesheet to convert TEI XML to Word DOCX XML.</p>
         <p>
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  
      </p>
         <p>Author: See AUTHORS</p>
         <p>Id: $Id$</p>
         <p>Copyright: 2008, TEI Consortium</p>
      </desc>
   </doc>

    <xsl:param name="tableMethod">cals</xsl:param>
    <xsl:param name="template">ISO</xsl:param>
    <xsl:param name="isofreestanding">false</xsl:param>

    <xsl:variable name="align">
      <xsl:choose>
    	    <xsl:when test="$template='ISO'">left</xsl:when>
	        <xsl:otherwise>right</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:param name="word-directory">..</xsl:param>
    <xsl:param name="tei-directory">./</xsl:param>
    <xsl:param name="debug">false</xsl:param>   
    <xsl:param name="numberFormat">fr</xsl:param>
    
    <xsl:variable name="orig" select="/"/>

    <!-- Styles -->
    
    <xsl:template match="tei:abbr" mode="get-style">abbr</xsl:template>
    <xsl:template match="tei:cit" mode="get-style">Quote</xsl:template>
    <xsl:template match="tei:date" mode="get-style">date</xsl:template>
    <xsl:template match="tei:formula" mode="get-style">Formula</xsl:template>
    <xsl:template match="tei:list[@type='termlist' and ancestor-or-self::*/@type='termsAndDefinitions']/tei:item/tei:abbr"
                 mode="get-style">ExtRef</xsl:template>
    <xsl:template match="tei:mentioned" mode="get-style">mentioned</xsl:template>
    <xsl:template match="tei:orgName" mode="get-style">orgName</xsl:template>
    <xsl:template match="tei:p[@rend]" mode="get-style">
        <xsl:call-template name="getStyleName">
            <xsl:with-param name="in" select="@rend"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="tei:quote" mode="get-style">Quote</xsl:template>
    <xsl:template match="tei:ref" mode="get-style">ExtXref</xsl:template>
    <xsl:template match="tei:ref[@rend]" mode="get-style">
      <xsl:value-of select="@rend"/>
   </xsl:template>
    <xsl:template match="tei:seg[@rend='FormulaReference']">FormulaReference</xsl:template>
    <xsl:template match="tei:seg[@iso:provision]" mode="get-style">
      <xsl:value-of select="@iso:provision"/>
   </xsl:template>
    <xsl:template match="tei:seg[@rend]" mode="get-style">
      <xsl:value-of select="@rend"/>
   </xsl:template>
    <xsl:template match="tei:hi[@rend='domain']" mode="get-style">
      <xsl:text>domain</xsl:text>
    </xsl:template>
    <xsl:template match="tbx:descrip" mode="get-style">Definition</xsl:template>
    <xsl:template match="tbx:note" mode="get-style">noteTermEntry</xsl:template>
    <xsl:template match="tei:hi[@rend='gender']" mode="get-style">
      <xsl:text>gender</xsl:text>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='geographicalUse']" mode="get-style">
      <xsl:text>geographicalUse</xsl:text>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='language']" mode="get-style">
      <xsl:text>language</xsl:text>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='partOfSpeech']" mode="get-style">
      <xsl:text>partOfSpeech</xsl:text>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='pronunciation']" mode="get-style">
      <xsl:text>pronunciation</xsl:text>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='source']" mode="get-style">
      <xsl:text>source</xsl:text>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='termRef']" mode="get-style">
      <xsl:text>termRef</xsl:text>
    </xsl:template>
    
       <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc>
        Inline Templates:
        Here we can overwrite how inline elements are rendered
      </desc>
       </doc>

    <xsl:template match="tei:c[@iso:font and @n]">
        <w:r>
            <xsl:variable name="renderingProperties">
                <xsl:call-template name="applyRend"/>
            </xsl:variable>

            <xsl:if test="not(empty($renderingProperties))">
                <w:rPr>
                    <xsl:copy-of select="$renderingProperties"/>
                </w:rPr>
            </xsl:if>
	        <w:sym w:font="{@iso:font}" w:char="{@n}"/>
        </w:r>
    </xsl:template>

    <xsl:template match="tei:editionStmt">
        <w:r>
            <w:t>
            <xsl:value-of select="tei:edition"/> Edition</w:t>
        </w:r>
    </xsl:template>

       <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> 
        Handle Numbers 
      </desc>
       </doc>
    <xsl:template match="tei:num">
        <w:r>
            <w:rPr>
                <w:rStyle w:val="isonumber"/>
		          <xsl:if test="teidocx:render-bold(.)">
                    <w:b/>
		          </xsl:if>
            </w:rPr>
            <w:t>
                <xsl:choose>
                    <xsl:when test="$numberFormat='fr'">
                        <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate(.,', ','.,')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </w:t>
        </w:r>
    </xsl:template>
    
    <xsl:template match="tei:num" mode="iden">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <w:r>
            <w:br w:type="page"/>
        </w:r>
    </xsl:template>
    
    <xsl:template match="tei:seg[not(@*) and normalize-space(.)='']">
        <w:r>
            <w:t>
                <xsl:attribute name="xml:space">preserve</xsl:attribute>
                <xsl:text> </xsl:text>
            </w:t>
        </w:r>
    </xsl:template>

    
    <!--
	Block Templates:
	Here we can overwrite how block elements are rendered
    -->
    
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> Dates </desc>
    </doc>
    <xsl:template match="tei:date">
        <w:r>
            <w:rPr>
                <w:rStyle w:val="date"/>
            </w:rPr>
            <w:t>
                <xsl:value-of select="."/>
            </w:t>
        </w:r>
    </xsl:template>

      <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> Process formulae </desc></doc>

    <xsl:template match="tei:formula">
      <xsl:choose>
	        <xsl:when test="parent::cals:entry or parent::tei:title">
	           <xsl:apply-templates/>
	        </xsl:when>
	        <xsl:otherwise>
            <w:p>    
               <w:pPr>
                  <w:pStyle w:val="Formula"/>
               </w:pPr>
               <xsl:call-template name="block-element">                   
                  <xsl:with-param name="nop">true</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="@n">
                  <w:r>
                    <w:tab/>
                  </w:r>
                  <w:r>
                    <w:rPr>
                        <w:rStyle w:val="FormulaReference"/>
                    </w:rPr>
                    <w:t xml:space="preserve"><xsl:value-of select="@n"/></w:t>
                  </w:r>
               </xsl:if>
            </w:p>
	        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> Process bibliography</desc></doc>

    <xsl:template match="tei:listBibl">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::*[@type='normativeReferences']">
                <xsl:for-each select="tei:bibl">
                    <xsl:call-template name="block-element">
                        <xsl:with-param name="pPr">
                            <w:pPr>
                                <w:pStyle>
                                    <xsl:attribute name="w:val">
                                        <xsl:call-template name="getStyleName">
                                            <xsl:with-param name="in">
                                                <xsl:text>RefNorm</xsl:text>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                </w:pStyle>
                            </w:pPr>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="tei:bibl">
                    <xsl:call-template name="block-element">
                        <xsl:with-param name="style">Bibliography</xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> Process notes which have a place attribute</desc>
  </doc>
    
    <xsl:template match="tei:note[@place]">
      <xsl:choose>
	<xsl:when test="@place='comment'">
	  <xsl:call-template name="create-comment"/>
	</xsl:when>
	<xsl:when test="@place='foot'  or @place='bottom' ">
	  <xsl:call-template name="create-footnote"/>
	</xsl:when>
	<xsl:when test="@place='end'">
	  <xsl:call-template name="create-endnote"/>
	</xsl:when>
	<xsl:when test="ancestor::tei:cell or ancestor::cals:entry">
	  <xsl:call-template name="create-inlinenote"/>
	</xsl:when>
	<xsl:when test="@place='inline'">
	  <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="block-element">
	    <xsl:with-param name="pPr">
	      <w:pPr>
		<w:pStyle>
		  <xsl:attribute name="w:val">Note</xsl:attribute>
		</w:pStyle>
	      </w:pPr>
	    </xsl:with-param>
	    <xsl:with-param name="nop">false</xsl:with-param>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> Process notes which have a rend attribute</desc>
  </doc>
    
    <xsl:template match="tei:note[@rend]">
	<xsl:call-template name="block-element">
	  <xsl:with-param name="pPr">
	    <w:pPr>
	      <w:pStyle>
		<xsl:attribute name="w:val">
		  <xsl:choose>
		    <xsl:when
			test="@rend='Notenumbered'">Notenumbered</xsl:when>
		    <xsl:when
			test="@rend='Noteparagraph'">Noteparagraph</xsl:when>
		    <xsl:when
			test="@rend='Notelist'">Notelist</xsl:when>
		    <xsl:when
			test="@rend='Tablenote'">Tablenote</xsl:when>
		    <xsl:when
			test="@rend='Figurenote'">Figurenote</xsl:when>
		    <xsl:when
			test="@rend='Exampleparagraph'">Exampleparagraph</xsl:when>
		    <xsl:when
			test="@rend='Examplenumbered'">Examplenumbered</xsl:when>
		    <xsl:otherwise>Note</xsl:otherwise>
		  </xsl:choose>
		</xsl:attribute>
	      </w:pStyle>
	    </w:pPr>
	  </xsl:with-param>
	  <xsl:with-param name="nop">false</xsl:with-param>
	</xsl:call-template>
    </xsl:template>

    <xsl:template name="create-footnote">           
      <xsl:variable name="pPr">
	        <xsl:choose>
	           <xsl:when test="(@place='foot'  or @place='bottom') and      (parent::tei:cell or parent::cals:entry)">
	              <w:pPr>
	                 <w:pStyle w:val="Tablefootnote"/>
	              </w:pPr>
	              <w:r>
	                 <w:rPr>
		                   <w:rStyle w:val="TableFootnoteXref"/>
		                   <w:position w:val="6"/>
		                   <w:sz w:val="16"/>
	                 </w:rPr>
	                 <w:t>
		                   <xsl:value-of select="@n"/>
	                 </w:t>
	              </w:r>
	              <w:r>
	                 <w:t>
		                   <xsl:text> </xsl:text>
	                 </w:t>
	              </w:r>
	           </xsl:when>
	           <xsl:when test="@type='Example'">
	              <w:pPr>
	                 <w:pStyle w:val="Example"/>
	              </w:pPr>
	           </xsl:when>
	           <xsl:when test="parent::tei:cell or parent::cals:entry">	    
	              <w:pPr>
	                 <xsl:variable name="Tablenote">
		                   <xsl:call-template name="getStyleName">
		                      <xsl:with-param name="in">
		                         <xsl:value-of select="$Note"/>
		                      </xsl:with-param>
		                   </xsl:call-template>
	                 </xsl:variable>
	                 <w:pStyle w:val="Tablenote"/>
	              </w:pPr>
	           </xsl:when>
	           <xsl:otherwise>
	              <w:pPr>
	                 <w:pStyle w:val="Footnote"/>
	              </w:pPr>	    
	           </xsl:otherwise>
	        </xsl:choose>
      </xsl:variable>
      
      <xsl:choose>
	        <xsl:when test="$pPr=''">
	           <xsl:variable name="num">
	              <xsl:number count="tei:note[@place='foot' or @place='bottom'][not(ancestor::cals:entry)]"
                           level="any"/>
	           </xsl:variable>
	           <xsl:variable name="id" select="$num+1"/>
	           <w:r>
	              <w:rPr>
	                 <w:rStyle w:val="FootnoteReference"/>
	              </w:rPr>
	              <w:footnoteReference w:id="{$id}"/>
	           </w:r>
	           <w:r>
	              <w:t xml:space="preserve"> </w:t>
	           </w:r>
	        </xsl:when>
	        <xsl:otherwise>
	           <xsl:call-template name="block-element">
	              <xsl:with-param name="pPr" select="$pPr"/>
	           </xsl:call-template>
	        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
      
    <xsl:template name="create-inlinenote">           
      <xsl:variable name="pPr">
	        <w:pPr>
	           <w:pStyle w:val="Tablenote"/>
	        </w:pPr>
      </xsl:variable>
      
      <xsl:call-template name="block-element">
	        <xsl:with-param name="pPr" select="$pPr"/>
	        <xsl:with-param name="nop">false</xsl:with-param>
      </xsl:call-template>
    </xsl:template>
    
    
       <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc>
	Paragraphs in the front matter 
      </desc>
       </doc>
    <xsl:template match="tei:front/tei:div/tei:p[@type='foreword']">
        <xsl:call-template name="block-element">
            <xsl:with-param name="pPr">
                <w:pPr>
                    <w:pStyle>
                        <xsl:attribute name="w:val">
                            <xsl:value-of select="concat(translate(substring(parent::tei:div/@type,1,1),$lowercase,$uppercase),substring(parent::tei:div/@type,2))"/>
                        </xsl:attribute>
                    </w:pStyle>
                </w:pPr>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> Definition lists </desc></doc>
    <xsl:template match="tei:list[@type='gloss']">
      <xsl:for-each select="tei:head">
        <xsl:call-template name="block-element">
            <xsl:with-param name="pPr">
                <w:pPr>
                        <w:pStyle w:val="dl"/>
                        <w:tabs>
                            <w:tab w:val="left" w:pos="403"/>
                        </w:tabs>
                </w:pPr>
            </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
        
        
      <xsl:for-each select="tei:label">
        <w:p>
            <w:pPr>
                <w:pStyle w:val="dl"/>
                <w:tabs>
                    <w:tab w:val="left" w:pos="403"/>
                </w:tabs>
            </w:pPr>
    	       <xsl:apply-templates>
    	          <xsl:with-param name="nop">true</xsl:with-param>
    	       </xsl:apply-templates>
            <w:r>
                <w:tab/>
            </w:r>
            <xsl:for-each select="following-sibling::tei:item[1]">
                <xsl:apply-templates>
                    <xsl:with-param name="nop">true</xsl:with-param>
                </xsl:apply-templates> 
            </xsl:for-each>
        </w:p>
      </xsl:for-each>
    </xsl:template>
    
    <!-- Terms and Definitions -->
    <xsl:template match="tei:list[@type='termlist' and ancestor-or-self::*/@type='termsAndDefinitions']/tei:item/tei:term">
        <w:p>
            <w:pPr>
                <w:pStyle>
                    <xsl:attribute name="w:val">
                        <xsl:call-template name="getStyleName">
                            <xsl:with-param name="in">
                                <xsl:text>TermNum</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:attribute>
                </w:pStyle>
            </w:pPr>
            <w:r>
                <w:t>
                    <xsl:value-of select="ancestor-or-self::*[@n][1]/@n"/>
                </w:t>
            </w:r>
        </w:p>
        
        <xsl:call-template name="block-element">
            <xsl:with-param name="style">termPreferred</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:list[@type='termlist' and ancestor-or-self::*/@type='termsAndDefinitions']/tei:item/tei:gloss">
        <xsl:call-template name="block-element">
            <xsl:with-param name="style">
                <xsl:variable name="style">
                    <xsl:call-template name="getStyleName">
                        <xsl:with-param name="in">
                            <xsl:text>GlossText</xsl:text>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$style=''">
                        <xsl:text>Definition</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$style"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- titleStmt -->
    <xsl:template match="tei:titleStmt">
        <xsl:param name="language" as="xs:string"/>
        <xsl:param name="id_start" as="xs:integer"/>
        <xsl:for-each select="tei:title">
            <xsl:if test="@xml:lang=$language">
                <xsl:variable name="title_type">
               <xsl:value-of select="@type"/>Title</xsl:variable>
                <xsl:variable name="id">
                    <xsl:value-of select="position()+$id_start"/>
                </xsl:variable>
                <w:sdt>
                    <w:sdtPr>
                        <w:alias w:val="{$title_type}"/>
                        <w:tag w:val="{$title_type}"/>
                        <w:id w:val="{$id}"/>
                        <w:lock w:val="sdtLocked"/>
                        <w:placeholder>
                            <w:docPart w:val="0949DFCE5F58405499B2741B51A42BCD"/>
                        </w:placeholder>
                        <w:text/>
                    </w:sdtPr>
                    <w:sdtContent>
                        <w:r>
                            <w:t>
                                <xsl:value-of select="normalize-space(.)"/>
                            </w:t>
                        </w:r>
                    </w:sdtContent>
                </w:sdt>
                <xsl:choose>
                    <xsl:when test="position()=1 or position()=4">
                        <w:r>
                            <w:t xml:space="preserve"> </w:t>
                        </w:r>
                        <w:r>
                            <w:t xml:space="preserve">– </w:t>
                        </w:r>
                    </xsl:when>
                    <xsl:when test="position()=2 or position()=5">
                        <w:r>
                            <w:t xml:space="preserve"> </w:t>
                        </w:r>
                        <w:r>
                            <xsl:choose>
                                <xsl:when test="$language='en'">
                                    <w:t xml:space="preserve">– Part </w:t>
                                </xsl:when>
                                <xsl:otherwise>
                                    <w:t xml:space="preserve">– Partie </w:t>
                                </xsl:otherwise>
                            </xsl:choose>
                        </w:r>
                        <w:sdt>
                            <w:sdtPr>
                                <w:alias w:val="partNumber"/>
                                <w:tag w:val="partNumber"/>
                                <xsl:choose>
                                    <xsl:when test="$language='en'">
                                        <w:id w:val="680634476"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <w:id w:val="680634477"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <w:lock w:val="sdtLocked"/>
                                <w:placeholder>
                                    <w:docPart w:val="0949DFCE5F58405499B2741B51A42BCD"/>
                                </w:placeholder>
                                <w:text/>
                            </w:sdtPr>
                            <w:sdtContent>
                                <w:r>
                                    <w:t>
                                        <xsl:value-of select="//tei:publicationStmt/tei:idno[@iso:meta='partNumber']"/>
                                    </w:t>
                                </w:r>
                            </w:sdtContent>
                        </w:sdt>
                        <w:r>
                            <w:t xml:space="preserve">: </w:t>
                        </w:r>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> Document title </desc>
    </doc>
    <xsl:template name="document-title">
        <w:p>
            <w:pPr>
                <w:pStyle w:val="zzSTDTitle"/>
            </w:pPr>
            <w:r>
                <w:t>
                    <xsl:call-template name="generateTitle"/>
                </w:t>
            </w:r>
        </w:p>
    </xsl:template>
    
    
           <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc>
        Table of Contents
      </desc></doc>
    <xsl:template name="generate-toc">
        <w:p>
            <w:pPr>
                <w:pStyle w:val="TOC1"/>
                <w:tabs>
                    <w:tab w:val="right" w:leader="dot" w:pos="9350"/>
                </w:tabs>
            </w:pPr>
            <w:r>
                <w:fldChar w:fldCharType="begin"/>
            </w:r>
            <w:r>
                <w:rPr>
                    <w:noProof/>
                </w:rPr>
                <w:instrText xml:space="preserve"> TOC \o "1-6" \h \z \t "ANNEX;1;a2;2;a3;3;a4;4;a5;5;a6;6;zzForeword;1;Introduction;1;zzBiblio;1;zzIndex;1" </w:instrText>
            </w:r>
            <w:r>
                <w:fldChar w:fldCharType="separate"/>
            </w:r>
            <w:r>
                <w:fldChar w:fldCharType="end"/>
            </w:r>
        </w:p>
    </xsl:template>
    
           <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc>
 who created this document </desc></doc>
    <xsl:template name="created-by">
        <xsl:value-of select="key('ISOMETA','secretariat')"/>
    </xsl:template>


  <xsl:template match="tei:availability" mode="titlepage">
      <xsl:param name="style"/>
      <xsl:for-each select="tei:p">
         <xsl:call-template name="block-element">
	           <xsl:with-param name="style" select="$style"/>
         </xsl:call-template>
      </xsl:for-each>
  </xsl:template>



  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc>TBX processing</desc>
</doc>

<xsl:template match="tbx:termEntry">
      <xsl:for-each select="tbx:langSet">
         <xsl:choose>
            <xsl:when test="starts-with(../@id,'autoTermNum')">
	              <w:p>
	                 <w:pPr>
	                    <w:pStyle w:val="{substring-before(../@id,'_')}"/>
	                 </w:pPr>
	                 <w:bookmarkStart w:id="{substring-after(../@id,'_')}" w:name="_Ref244494009"/>
	              </w:p>
	              <w:bookmarkEnd w:id="{substring-after(../@id,'_')}"/>
            </xsl:when>
            <xsl:otherwise>
	              <w:p>
	                 <w:pPr>
	                    <w:pStyle w:val="TermNum"/>
	                 </w:pPr>
	                 <w:r>
	                    <w:t>
	                       <xsl:value-of select="substring-after(../@id,'CDB_')"/>
	                    </w:t>
	                 </w:r>
	              </w:p>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:for-each select="tbx:ntig">
	           <xsl:variable name="Thing">
	              <xsl:value-of select="substring-before(tbx:termGrp/tbx:termNote[@type='administrativeStatus'],'-admn-sts')"/>
	           </xsl:variable>
	           <xsl:variable name="style">
	              <xsl:choose>
	                 <xsl:when test="$Thing='preferredTerm'">termPreferred</xsl:when>
	                 <xsl:when test="$Thing='deprecatedTerm'">termDeprecated</xsl:when>
	                 <xsl:when test="$Thing='admittedTerm'">termAdmitted</xsl:when>
	                 <xsl:when test="$Thing='symbol'">symbol</xsl:when>
	              </xsl:choose>
	           </xsl:variable>
            <xsl:call-template name="block-element">
	              <xsl:with-param name="pPr">
	                 <xsl:if test="not($style='')">
	                    <w:pPr>
	                       <w:pStyle w:val="{$style}"/>
	                    </w:pPr>
	                 </xsl:if>
	              </xsl:with-param>
            </xsl:call-template>
         </xsl:for-each>

         <xsl:apply-templates select="tbx:descripGrp/tbx:descrip[@type='definition']"/>
         <xsl:apply-templates select="tbx:descripGrp/tbx:admin"/>
         <xsl:apply-templates select="tbx:note"/>
      </xsl:for-each>
      <xsl:apply-templates select="tbx:descripGrp/tbx:descrip[@type='definition']"/>
      <xsl:apply-templates select="tbx:descripGrp/tbx:admin"/>
      <xsl:apply-templates select="tbx:note"/>
   </xsl:template>

   <xsl:template match="tbx:termGrp/tbx:termNote"/>

   <xsl:template match="tbx:descrip">
      <xsl:call-template name="block-element">
         <xsl:with-param name="style">Definition</xsl:with-param>
         <!--    <xsl:with-param name="pPr">
      <w:pPr>
	<w:pStyle w:val="Definition"/>
      </w:pPr>
    </xsl:with-param>-->
  </xsl:call-template>
   </xsl:template>

   <xsl:template match="tbx:note">
      <xsl:call-template name="block-element">
         <xsl:with-param name="style">
	   <xsl:text>noteTermEntry</xsl:text>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <xsl:template match="tbx:admin">
      <xsl:call-template name="block-element">
         <xsl:with-param name="style">entrySource</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Create all the files of the docx archive;    for ISO, don't write out most of the auxiliary files.

    </desc>
   </doc>
    <xsl:template name="write-docxfiles">
      <xsl:if test="$isofreestanding='true'">
        <!-- header and footers -->
	<xsl:call-template name="write-docxfile-header-files"/>

        <!-- footer files -->
	<xsl:call-template name="write-docxfile-footer-files"/>

        <!-- numbering file -->
	<xsl:call-template name="write-docxfile-numbering-definition"/>

        <!-- footnotes file -->
	<xsl:call-template name="write-docxfile-footnotes-file"/>

        <!-- endnotes file -->
	<xsl:call-template name="write-docxfile-endnotes-file"/>

        <!-- main relationships -->
	<xsl:call-template name="write-docxfile-main-relationships"/>

        <!-- relationships -->
	 <xsl:call-template name="write-docxfile-relationships"/>

        <!-- write Content Types -->
	<xsl:call-template name="write-docxfile-content-types"/>

        <!--  settings -->
	<xsl:call-template name="write-docxfile-settings"/>

        <!-- app files -->
        <xsl:call-template name="write-docxfile-docprops-app"/>

        <!-- comments file -->
        <xsl:call-template name="write-docxfile-comments-file"/>

      </xsl:if>
      <xsl:call-template name="write-docxfile-docprops-core"/>
      <xsl:call-template name="write-docxfile-docprops-custom"/>
    </xsl:template>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
        Writes the main document.xml file, that contains all "real" content.
    </desc>
   </doc>
    <xsl:template name="create-document-dot-xml">
        <w:document>

            <w:body>

	           <xsl:choose>
		             <xsl:when test="$isofreestanding='true'">
		                <xsl:call-template name="write-document-dot-xml-frontmatter"/>
		                <xsl:call-template name="write-document-dot-xml-maincontent"/>
		                <xsl:call-template name="write-document-dot-xml-backmatter"/>
		             </xsl:when>
		             <xsl:otherwise>
		  <!-- Front -->
		  <front>
		                   <xsl:call-template name="write-document-dot-xml-frontmatter"/>
		                </front>
		                <!-- Main -->
		  <main>
		                   <xsl:call-template name="write-document-dot-xml-maincontent"/>
		                </main>
		                <!-- Back -->
		  <back>
		                   <xsl:call-template name="write-document-dot-xml-backmatter"/>
		                </back>
		             </xsl:otherwise>
	           </xsl:choose>
            </w:body>
        </w:document>
    </xsl:template>

    <xsl:template name="write-docxfile-docprops-custom">
	     <xsl:if test="$debug='true'">
	        <xsl:message>Writing out <xsl:value-of select="concat($word-directory,'/docProps/newcustom.xml')"/>
         </xsl:message>
	     </xsl:if>

        <xsl:result-document href="{concat($word-directory,'/docProps/newcustom.xml')}" standalone="yes">
            <Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/custom-properties"
                     xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
                <property pid="2" name="DocIdentSDO">
                    <xsl:attribute name="fmtid">
                        <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                    </xsl:attribute>
                    <vt:lpwstr>
                        <xsl:value-of select="key('ISOMETA','organization')"/>
                    </vt:lpwstr>
                </property>
                <property pid="3" name="DocIdentProjectId">
                    <xsl:attribute name="fmtid">
                        <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                    </xsl:attribute>
                    <vt:lpwstr>
                        <xsl:value-of select="key('ISOMETA','projectId')"/>
                    </vt:lpwstr>
                </property>
                <property pid="4" name="DocIdentLanguage">
                    <xsl:attribute name="fmtid">
                        <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                    </xsl:attribute>
                    <vt:lpwstr>
                        <xsl:value-of select="/tei:TEI/@xml:lang"/>
                    </vt:lpwstr>
                </property>
                <property pid="5" name="DocIdentStage">
                    <xsl:attribute name="fmtid">
                        <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                    </xsl:attribute>
                    <vt:lpwstr>
                        <xsl:value-of select="key('ISOMETA','stage')"/>
                    </vt:lpwstr>
                </property>
                <property pid="6" name="DocIdentDate">
                    <xsl:attribute name="fmtid">
                        <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                    </xsl:attribute>
                    <vt:lpwstr>
                        <xsl:value-of select="key('ISOMETA','docdate')"/>
                    </vt:lpwstr>
                </property>
                <xsl:for-each select="key('ALLMETA',1)">
                    <xsl:if test="@iso:meta != 'projectId' and not(starts-with(@iso:meta, 'fw_'))">
                        <property name="{@iso:meta}">
                            <xsl:attribute name="pid">
                                <xsl:value-of select="position()+6"/>
                            </xsl:attribute>
                            <xsl:attribute name="fmtid">
                                <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                            </xsl:attribute>
                            <vt:lpwstr>
                                <xsl:value-of select="."/>
                            </vt:lpwstr>
                        </property>
                    </xsl:if>
                </xsl:for-each>
                <property pid="1000" name="TEI_toDOCX">
                    <xsl:attribute name="fmtid">
                        <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                    </xsl:attribute>
		             <vt:lpwstr>2.8.0</vt:lpwstr>
                </property>
                <property pid="1001" name="WordTemplateURI">
                    <xsl:attribute name="fmtid">
                        <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                    </xsl:attribute>
                    <vt:lpwstr>
                        <xsl:value-of select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:encodingDesc/tei:appInfo/tei:application[@ident='WordTemplate']/tei:ptr/@target"/>
                    </vt:lpwstr>
                </property>
                <xsl:for-each select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:encodingDesc/tei:appInfo/tei:application">
                    <xsl:if test="not(@ident='TEI_toDOCX')">
                        <property name="{@ident}">
                            <xsl:attribute name="pid">
                                <xsl:value-of select="position()+1001"/>
                            </xsl:attribute>
                            <xsl:attribute name="fmtid">
                                <xsl:text>{D5CDD505-2E9C-101B-9397-08002B2CF9AE}</xsl:text>
                            </xsl:attribute>
                            <vt:lpwstr>
                                <xsl:value-of select="@version"/>
                            </vt:lpwstr>
                        </property>
                    </xsl:if>
                </xsl:for-each>
            </Properties>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="write-document-dot-xml-maincontent">
        <!-- document title -->
	<xsl:if test="$isofreestanding='true'">
	        <xsl:call-template name="document-title"/>
	     </xsl:if>
        <!-- Describes the main part of the document -->
        <xsl:apply-templates select="tei:text/tei:body"/>
    </xsl:template>

    <xsl:template match="tei:q[@type='sdt']">
      <w:sdt>
	<w:sdtPr>
	  <w:rPr>
	    <w:noProof/>
	    <w:lang w:val="en-GB"/>
	  </w:rPr>
	  <w:alias w:val="{@iso:meta}"/>
	  <w:tag w:val="{@iso:meta}"/>
	  <xsl:variable name="stdId">
	    <xsl:number level="any"/>
	  </xsl:variable>
	  <w:id w:val="158666506{$stdId}"/>
	</w:sdtPr>
	<w:sdtContent>
	  <xsl:apply-templates/>
	</w:sdtContent>
      </w:sdt>
    </xsl:template>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
      <desc> Process CALS tables </desc>
    </doc>
    <xsl:template match="cals:table">
      <xsl:choose>
	<xsl:when test="@tei:corresp and $tableMethod='word'">
	  <xsl:call-template name="cals-table-header"/>
	  <xsl:if test="$debug='true'">
	    <xsl:message>read table from <xsl:value-of select="@tei:corresp"/></xsl:message>
	  </xsl:if>
	  <xsl:for-each select="document(concat($tei-directory,@tei:corresp))">
	    <xsl:apply-templates 	mode="copytable"/>
	  </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-imports/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template
	match="
	       w:bottom | 
	       w:gridCol | 
	       w:gridSpan | 
	       w:insideH | 
	       w:insideV | 
	       w:jc | 
	       w:left | 
	       w:pPr |
	       w:p |
	       w:right |
	       w:spacing |  
	       w:tbl | 
	       w:tblBorders | 
	       w:tblCellMar | 
	       w:tblGrid | 
	       w:tblLayout | 
	       w:tblLook | 
	       w:tblPr | 
	       w:tblStyle | 
	       w:tblW | 
	       w:tc | 
	       w:tcBorders | 
	       w:tcPr | 
	       w:tcW | 
	       w:top | 
	       w:tr | 
	       w:trPr | 
	       w:vAlign "
	mode="copytable">      
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>


    <xsl:template match="tei:milestone[@unit='section']" mode="part2"/>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl"  >
    <desc>Deleted parts removed </desc></doc>

    <xsl:template match="tei:del"/>
    
    <xsl:template name="simpleRun">
      <xsl:param name="text"/>
      <w:r>
	<w:t>
	  <xsl:attribute name="xml:space">preserve</xsl:attribute>
	  <xsl:value-of select="$text"/>
	</w:t>
      </w:r>
    </xsl:template>

</xsl:stylesheet>