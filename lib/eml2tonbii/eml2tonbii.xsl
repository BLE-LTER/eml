<?xml version="1.0"?>
<!--
  *  '$RCSfile: eml2tonbii.xsl,v $'
  *      Authors: Dan Higgins
  *    Copyright: 2000 Regents of the University of California and the
  *               National Center for Ecological Analysis and Synthesis
  *  For Details: http://www.nceas.ucsb.edu/
  *
  *   '$Author: higgins $'
  *     '$Date: 2003-05-03 00:19:51 $'
  * '$Revision: 1.6 $'
  * 
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
  * This is an XSLT (http://www.w3.org/TR/xslt) stylesheet designed to
  * convert an XML file in eml2 format to nbii fromat
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:eml="eml://ecoinformatics.org/eml-2.0.0"
xmlns:xalan="http://xml.apache.org/xalan"
version="1.0">
<xsl:output method="xml" indent="yes"/>
<xsl:output encoding="ISO-8859-1"/>
<xsl:strip-space elements="*"/>

  <xsl:variable name="show_optional" select="0"/>
  <xsl:template match="/">
  
    <xsl:element name="metadata">
      <!-- only the 'idinfo' and 'metainfo' elements are required -->
      <!-- start the 'idinfo' branch -->      
      <xsl:element name="idinfo">
        <xsl:element name="citation">
          <xsl:element name="citeinfo">
            <xsl:for-each select="/eml:eml/dataset/creator">
            <!-- This is a loop over all the dataset 'creator' elements
             Note that dataset itself might be 'referenced' rather
             than exist 'in-place'. More likely, however, is that
             the creator element may have a 'references' child rather
             than inline children! -->
              <xsl:variable name="cc">
                <xsl:variable name="ref_id" select="./references"/>
                <xsl:choose>
                  <xsl:when test="./references!=''">
                    <xsl:variable name="ref_id" select="./references"/>
                    <!-- current element just references its contents 
                    There should only be a single node with an id attribute
                    which matches the value of the references element -->
                    <xsl:copy-of select="//*[@id=$ref_id]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- no references tag, thus use the current node -->
                    <xsl:copy-of select="."/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:element name="origin">
              <!-- 'origin' should correspond to the name of the 'creator' RP in eml2 -->
                  <xsl:choose>
                    <xsl:when test="xalan:nodeset($cc)//individualName/surName!=''">
                      <xsl:value-of select="xalan:nodeset($cc)//individualName/surName"/>
                    </xsl:when>
                    <xsl:when test="xalan:nodeset($cc)//organizationName!=''">
                      <xsl:value-of select="xalan:nodeset($cc)//organizationName"/>
                    </xsl:when>
                    <xsl:when test="xalan:nodeset($cc)//positionName!=''">
                      <xsl:value-of select="xalan:nodeset($cc)//positionName"/>
                    </xsl:when>
                  </xsl:choose>
              </xsl:element>
            </xsl:for-each>  
            <xsl:element name="pubdate">
            <!-- pubdate is optional in eml2 -->
              <xsl:choose>
                <xsl:when test="/eml:eml/dataset/pubDate!=''">
                  <xsl:value-of select="/eml:eml/dataset/pubDate"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'N/A'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
            <xsl:if test="$show_optional">
              <xsl:element name="pubtime">
              
              </xsl:element>
            </xsl:if>
            <xsl:element name="title">
              <xsl:value-of select="/eml:eml/dataset/title"/>
            </xsl:element>
             <xsl:if test="$show_optional">
              <xsl:element name="edition">
              
              </xsl:element>
            </xsl:if>
            <xsl:element name="geoform">
            <!-- Geospatial Data Presentation Form - the mode in which the 
                       geospatial data are represented. -->
            <!-- NEED TO LOOP OVER ALL ENTITIES IN EML2 HERE ??? -->           
              <xsl:choose>
                <xsl:when test="/eml:eml/dataset/dataTable!=''">
                  <xsl:value-of select="'dataTable'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'unknown'"/>
                </xsl:otherwise>              
              </xsl:choose>
            </xsl:element>
             <xsl:if test="$show_optional">
              <xsl:element name="serinfo">
                <xsl:element name="sername">
                
                </xsl:element>
                <xsl:element name="issue">
                
                </xsl:element>
              </xsl:element>
            </xsl:if>
             <xsl:if test="$show_optional">
              <xsl:element name="pubinfo">
                <xsl:element name="pubplace">
                
                </xsl:element>
                <xsl:element name="publish">
                
                </xsl:element>
              </xsl:element>
            </xsl:if>
             <xsl:if test="$show_optional">
              <xsl:element name="othercit">
              
              </xsl:element>
            </xsl:if>
             <xsl:if test="$show_optional">
              <xsl:element name="onlink">
              
              </xsl:element>
            </xsl:if>
             <xsl:if test="$show_optional">
              <xsl:element name="lworkcit">
                recursive link to citinfo
              </xsl:element>
            </xsl:if>
         </xsl:element>
        </xsl:element>
        <xsl:element name="descript">
          <xsl:element name="abstract">
            <xsl:choose>
              <xsl:when test="/eml:eml/dataset/abstract!=''">
                <xsl:value-of select="/eml:eml/dataset/abstract"/>
                <!-- abstract can be complex element in eml2; this useage will simply concatenate text -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="'N/A'"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
          <xsl:element name="purpose">
            <xsl:value-of select="'N/A'"/>
          </xsl:element>
          <xsl:if test="$show_optional">
            <xsl:element name="supplinf">
          
            </xsl:element>
          </xsl:if>
        </xsl:element>
        <xsl:element name="timeperd">
          <xsl:element name="timeinfo">
            <xsl:choose>
              <xsl:when test="1">
                <xsl:element name="sngdate">
                  <xsl:choose>
                    <xsl:when test="1">
                      <xsl:element name="caldate">
                      
                      </xsl:element>
                      <xsl:if test="$show_optional">
                        <xsl:element name="time">
                      
                        </xsl:element>
                      </xsl:if>  
                    </xsl:when>
                    <xsl:when test="0">
                      <xsl:element name="geolage">
                        <xsl:element name="geolscal">
                        
                        </xsl:element>
                        <xsl:element name="geolest">
                        
                        </xsl:element>
                        <xsl:if test="$show_optional">
                          <xsl:element name="geolun">
                          
                          </xsl:element>
                        </xsl:if>
                        <xsl:if test="$show_optional">
                          <xsl:element name="geolexpl">
                          
                          </xsl:element>
                        </xsl:if>
                      </xsl:element>
                    </xsl:when>
                  </xsl:choose>
                </xsl:element>
              </xsl:when>
              <xsl:when test="0">
                <xsl:element name="mdattim">
                  <xsl:element name="sngdate">
                    <xsl:choose>
                      <xsl:when test="1">
                        <xsl:element name="caldate">
                        
                        </xsl:element>
                        <xsl:if test="$show_optional">
                          <xsl:element name="time">
                           
                          </xsl:element>
                        </xsl:if>  
                      </xsl:when>
                      <xsl:when test="0">
                        <xsl:element name="geolage">
                          <xsl:element name="geolscal">
                        
                          </xsl:element>
                          <xsl:element name="geolest">
                        
                          </xsl:element>
                          <xsl:if test="$show_optional">
                            <xsl:element name="geolun">
                          
                            </xsl:element>
                          </xsl:if>
                          <xsl:if test="$show_optional">
                            <xsl:element name="geolexpl">
                          
                            </xsl:element>
                          </xsl:if>
                        </xsl:element>
                      </xsl:when>
                    </xsl:choose>  
                  </xsl:element>
                </xsl:element>
              </xsl:when>
              <xsl:when test="0">
                <xsl:element name="rngdates">
                  <xsl:choose>
                    <xsl:when test="1">
                      <xsl:element name="begdate">
                      
                      </xsl:element>
                      <xsl:if test="$show_optional">
                        <xsl:element name="begtime">
                      
                        </xsl:element>
                      </xsl:if>
                      <xsl:element name="enddate">
                      
                      </xsl:element>
                      <xsl:if test="$show_optional">
                        <xsl:element name="endtime">
                      
                        </xsl:element>
                      </xsl:if>
                    </xsl:when>
                    <xsl:when test="0">
                      <xsl:element name="beggeol">
                      
                      </xsl:element>
                      <xsl:element name="endgeol">
                      
                      </xsl:element>
                    </xsl:when>
                  </xsl:choose>
                </xsl:element>
              </xsl:when>
            </xsl:choose>
          </xsl:element>
          <xsl:element name="current">
          
          </xsl:element>
        </xsl:element>
        <xsl:element name="status">
          <xsl:element name="progress">
          
          </xsl:element>
          <xsl:element name="update">
          
          </xsl:element>
        </xsl:element>
        <xsl:if test="$show_optional">
          <xsl:element name="spdom">
          </xsl:element>
        </xsl:if>
        <xsl:element name="keywords">
          <xsl:choose>
            <xsl:when test="/eml:eml/dataset/keywordSet!=''">
              <xsl:for-each select="/eml:eml/dataset/keywordSet">
                <xsl:variable name="current_thes" select="/eml:eml/dataset/keywordSet/keywordThesaurus"/>
                <xsl:for-each select="./keyword">
                  <xsl:choose>
                    <xsl:when test="./@keywordType='theme'">
                      <xsl:element name="theme">
                        <xsl:element name="themekt">
                          <xsl:choose>
                            <xsl:when test="$current_thes!=''">
                              <xsl:value-of select="$current_thes"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="'N/A'"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                        <xsl:element name="themekey">
                          <xsl:value-of select="."/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:when>
                    <xsl:when test="./@keywordType='place'">
                      <xsl:element name="place">
                        <xsl:element name="placekt">
                          <xsl:choose>
                            <xsl:when test="$current_thes!=''">
                              <xsl:value-of select="$current_thes"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="'N/A'"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                        <xsl:element name="placekey">
                          <xsl:value-of select="."/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:when>
                    <xsl:when test="./@keywordType='stratum'">
                      <xsl:element name="stratum">
                        <xsl:element name="stratkt">
                          <xsl:choose>
                            <xsl:when test="$current_thes!=''">
                              <xsl:value-of select="$current_thes"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="'N/A'"/>
                            </xsl:otherwise>
                          </xsl:choose>
                      </xsl:element>
                        <xsl:element name="stratkey">
                          <xsl:value-of select="."/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:when>
                    <xsl:when test="./@keywordType='temporal'">
                      <xsl:element name="temporal">
                        <xsl:element name="tempkt">
                          <xsl:choose>
                            <xsl:when test="$current_thes!=''">
                              <xsl:value-of select="$current_thes"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="'N/A'"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                        <xsl:element name="tempkey">
                          <xsl:value-of select="."/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                       <xsl:element name="theme">
                        <xsl:element name="themekt">
                          <xsl:choose>
                            <xsl:when test="$current_thes!=''">
                              <xsl:value-of select="$current_thes"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="'N/A'"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:element>
                        <xsl:element name="themekey">
                          <xsl:value-of select="."/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="theme">
                <xsl:element name="themekt">
                  <xsl:value-of select="'N/A'"/>
                </xsl:element>
                <xsl:element name="themekey">
                  <xsl:value-of select="'N/A'"/>
                </xsl:element>
              </xsl:element>  
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>  
          
        <xsl:if test="$show_optional">
          <xsl:element name="taxonomy">
          
          </xsl:element>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="/eml:eml/dataset/access!=''">
            <xsl:element name="accconst">
              <xsl:value-of select="/eml:eml/dataset/access"/>
            </xsl:element>  
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="accconst">
              <xsl:value-of select="'N/A'"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>  
        <xsl:choose>
          <xsl:when test="/eml:eml/dataset/access!=''">
            <xsl:element name="useconst">
              <xsl:value-of select="/eml:eml/dataset/access"/>
            </xsl:element>  
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="useconst">
              <xsl:value-of select="'N/A'"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>  

        <xsl:if test="$show_optional">
          <xsl:element name="ptcontac">
          </xsl:element>
        </xsl:if>
        <xsl:if test="$show_optional">
          <xsl:element name="browse">
          </xsl:element>
        </xsl:if>
        <xsl:if test="$show_optional">
          <xsl:element name="datacred">
          </xsl:element>
        </xsl:if>
        <xsl:if test="$show_optional">
          <xsl:element name="secinfo">
          </xsl:element>
        </xsl:if>
        <xsl:if test="$show_optional">
          <xsl:element name="native">
          </xsl:element>
        </xsl:if>
        <xsl:if test="$show_optional">
          <xsl:element name="crossref">
          </xsl:element>
        </xsl:if>
        <xsl:if test="$show_optional">
          <xsl:element name="tool">
          </xsl:element>
        </xsl:if>
     </xsl:element>
      
      <xsl:if test="$show_optional">
        <xsl:element name="dataqual">
      
        </xsl:element>
      </xsl:if>
      <xsl:if test="$show_optional">
        <xsl:element name="spdoinfo">
      
        </xsl:element>
      </xsl:if>
      <xsl:if test="$show_optional">
        <xsl:element name="spref">
      
        </xsl:element>
      </xsl:if>
      <xsl:if test="$show_optional">
        <xsl:element name="eainfo">
      
        </xsl:element>
      </xsl:if>
      <xsl:if test="$show_optional">
        <xsl:element name="distinfo">
      
        </xsl:element>
      </xsl:if>
      
<!-- start the 'eainfo' branch -->      
<!-- create only if there is entity data in the eml2 document --> 
   <!-- initially just consider datatable entities -->
      <xsl:if test="/eml:eml/dataset/dataTable!=''">
        <xsl:element name="eainfo">
          <xsl:for-each select="/eml:eml/dataset/dataTable">
            <xsl:element name="detailed">
              <xsl:element name="enttyp">
                <xsl:element name="enttypl">
                  <xsl:value-of select="./entityName"/>
                </xsl:element>
                <xsl:choose>
                  <xsl:when test="./entityDescription!=''">
                    <xsl:element name="enttypd">
                      <xsl:value-of select="./entityDescription"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="enttypd">
                      <xsl:value-of select="'N/A'"/>
                    </xsl:element>                  
                  </xsl:otherwise>
                </xsl:choose> 
                <xsl:element name="enttypds">
                  <xsl:value-of select="'N/A'"/>
                </xsl:element>
              </xsl:element>
              <xsl:for-each select="./attributeList/attribute">
                <xsl:element name="attr">
                  <xsl:element name="attrlabl">
                    <xsl:value-of select="concat(./attributeName,':::',./attributeLabel)"/>
                  </xsl:element>
                  <xsl:element name="attrdef">
                    <xsl:value-of select="./attributeDefinition"/>
                  </xsl:element>
                  <xsl:element name="attrdefs">
                    <xsl:value-of select="'N/A'"/>
                  </xsl:element>
                  <xsl:element name="attrdomv">
                    <xsl:choose>
                      <xsl:when test="./measurementScale//enumeratedDomain/codeDefinition!=''">
                        <xsl:for-each select="./measurementScale//enumeratedDomain/codeDefinition">
                          <xsl:element name="edom">
                            <xsl:element name="edomv">
                              <xsl:value-of select="./code"/>
                            </xsl:element>
                            <xsl:element name="edomvd">
                              <xsl:value-of select="./definition"/>                            
                            </xsl:element>
                            <xsl:element name="edomvds">
                              <xsl:choose>
                                <xsl:when test="./source!=''">
                                  <xsl:value-of select="./source"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="N/A"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:element>
                          </xsl:element>
                        </xsl:for-each>
                      </xsl:when>
                      <xsl:when test="./measurementScale//textDomain!=''">
                        <xsl:element name="udom">
                          <xsl:value-of select="'free text'"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="./measurementScale//numericDomain!=''">
                        <xsl:element name="rdom">
                          <xsl:element name="rdommin">
                            <xsl:choose>
                              <xsl:when test="./measurementScale//numericDomain/bounds/minimum!=''">
                                <xsl:value-of select="./measurementScale//numericDomain/bounds/minimum"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="N/A"/>
                              </xsl:otherwise>
                            </xsl:choose>    
                          </xsl:element>
                          <xsl:element name="rdommax">
                            <xsl:choose>
                              <xsl:when test="./measurementScale//numericDomain/bounds/maximum!=''">
                                <xsl:value-of select="./measurementScale//numericDomain/bounds/maximum"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="N/A"/>
                              </xsl:otherwise>
                            </xsl:choose>    
                          </xsl:element>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="./measurementScale/datetime!=''">
                        <xsl:element name="udom">
                          <xsl:value-of select="'free text'"/>
                        </xsl:element>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>  
            </xsl:element>
          </xsl:for-each>
        </xsl:element>  
      </xsl:if>
      
<!-- start the 'metainfo' branch -->      
      <xsl:element name="metainfo">
        <xsl:element name="metd">
          <xsl:value-of select="'N/A'"/>
        </xsl:element>
        <xsl:element name="metrd">
          <xsl:value-of select="'N/A'"/>      
        </xsl:element>
        <xsl:if test="$show_optional">
          <xsl:element name="metfrd">
          <xsl:value-of select="'N/A'"/>
          </xsl:element>
        </xsl:if>  
        <xsl:element name="metc">
          <xsl:element name="cntinfo">
            <xsl:choose>
              <xsl:when test="/eml:eml/dataset/contact/individualName!=''">
                <xsl:element name="cntperp">
                <!-- there is only a single 'cntperp' in nbii;
                 thus we only reproduce the first contact in eml2 -->
                  <xsl:element name="cntper">
                    <xsl:value-of select="/eml:eml/dataset/contact/individualName"/>
                  </xsl:element>
                  <xsl:if test="$show_optional">
                    <xsl:element name="cntorg">
                  
                    </xsl:element>
                  </xsl:if>  
                </xsl:element>
              </xsl:when>
              <xsl:when test="/eml:eml/dataset/contact/organizationName!=''">
                <xsl:element name="cntorgp">
                  <xsl:element name="cntorg">
                    <xsl:value-of select="/eml:eml/dataset/contact/organizationName"/>
                  </xsl:element>
                  <xsl:if test="$show_optional">
                    <xsl:element name="cntper">
                  
                    </xsl:element>
                  </xsl:if>  
                </xsl:element>
              </xsl:when>
              <xsl:when test="/eml:eml/dataset/contact/positionName!=''">
                <xsl:element name="cntorgp">
                  <xsl:element name="cntorg">
                    <xsl:value-of select="/eml:eml/dataset/contact/positionName"/>
                  </xsl:element>
                  <xsl:if test="$show_optional">
                    <xsl:element name="cntper">
                  
                    </xsl:element>
                  </xsl:if>  
                </xsl:element>
              </xsl:when>
            </xsl:choose>
            <xsl:if test="/eml:eml/dataset/contact/positionName!=''">
              <xsl:element name="cntpos">
                <xsl:value-of select="/eml:eml/dataset/contact/positionName"/>
              </xsl:element>
            </xsl:if>
            <xsl:element name="cntaddr">
               <xsl:element name="addrtype">
                 <xsl:value-of select="'mailing'"/>
               </xsl:element>
               <xsl:choose>
                 <xsl:when test="/eml:eml/dataset/contact/address/deliveryPoint!=''">
                   <xsl:element name="address">
                     <xsl:value-of select="/eml:eml/dataset/contact/address/deliveryPoint"/>
                   </xsl:element>
                 </xsl:when>
               </xsl:choose>
               
               <xsl:choose>
                 <xsl:when test="/eml:eml/dataset/contact/address/city!=''">
                   <xsl:element name="city">
                     <xsl:value-of select="/eml:eml/dataset/contact/address/city"/>
                   </xsl:element>
                 </xsl:when>
                 <xsl:otherwise>
                   <xsl:value-of select="'N/A'"/>
                 </xsl:otherwise>
               </xsl:choose>
               
               <xsl:choose>
                 <xsl:when test="/eml:eml/dataset/contact/address/administrativaArea!=''">
                   <xsl:element name="state">
                     <xsl:value-of select="/eml:eml/dataset/contact/address/administrativaArea"/>
                   </xsl:element>
                 </xsl:when>
                 <xsl:otherwise>
                   <xsl:value-of select="'N/A'"/>
                 </xsl:otherwise>
               </xsl:choose>
               
               <xsl:choose>
                 <xsl:when test="/eml:eml/dataset/contact/address/postalCode!=''">
                   <xsl:element name="postal">
                     <xsl:value-of select="/eml:eml/dataset/contact/address/postalCode"/>
                   </xsl:element>
                 </xsl:when>
                 <xsl:otherwise>
                   <xsl:value-of select="'N/A'"/>
                 </xsl:otherwise>
               </xsl:choose>
               
               <xsl:choose>
                 <xsl:when test="/eml:eml/dataset/contact/address/country!=''">
                   <xsl:element name="country">
                     <xsl:value-of select="/eml:eml/dataset/contact/address/country"/>
                   </xsl:element>
                 </xsl:when>
               </xsl:choose>
               
            </xsl:element>

             <xsl:choose>
               <xsl:when test="/eml:eml/dataset/contact/phone!=''">
                 <xsl:element name="cntvoice">
                   <xsl:value-of select="/eml:eml/dataset/contact/phone"/>
                 </xsl:element>
               </xsl:when>
             </xsl:choose>
               
            <xsl:if test="$show_optional">
              <xsl:element name="cnttdd">
              
              </xsl:element>
            </xsl:if>
            <xsl:if test="$show_optional">
              <xsl:element name="cntfax">
              
              </xsl:element>
            </xsl:if>
            <xsl:if test="$show_optional">
              <xsl:element name="cntemail">
              
              </xsl:element>
            </xsl:if>
            <xsl:if test="$show_optional">
              <xsl:element name="hours">
              
              </xsl:element>
            </xsl:if>
            <xsl:if test="$show_optional">
              <xsl:element name="cntinst">
              
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:element>
        <xsl:element name="metstdn">
          <xsl:value-of select="'FGDC/NBII Content Standard for Digital Geospatial Metadata (from Ecological Metadata Langualge 2.0)'"/>
        </xsl:element>
        <xsl:element name="metstdv">
          <xsl:value-of select="'1999 Version (from Ecological Metadata Langualge 2.0)'"/>
        </xsl:element>
        <xsl:if test="$show_optional">
          <xsl:element name="mettc">
      
          </xsl:element>
        </xsl:if>  
        <xsl:if test="$show_optional">
          <xsl:element name="mettac">
      
          </xsl:element>
        </xsl:if>  
        <xsl:if test="$show_optional">
          <xsl:element name="mettuc">
      
          </xsl:element>
        </xsl:if>  
        <xsl:if test="$show_optional">
          <xsl:element name="metsi">
      
          </xsl:element>
        </xsl:if>  
        <xsl:if test="$show_optional">
          <xsl:element name="metextns">
            <xsl:element name="onlink">
            
            </xsl:element>
            <xsl:element name="metprof">
            
            </xsl:element>
          </xsl:element>
        </xsl:if>  
      </xsl:element>      
    </xsl:element>
  
  </xsl:template>

  
</xsl:stylesheet>