<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="0" styleCategories="AllStyleCategories" simplifyAlgorithm="0" version="3.16.14-Hannover" minScale="100000000" readOnly="0" simplifyMaxScale="1" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" maxScale="0" hasScaleBasedVisibilityFlag="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <temporal mode="0" startExpression="" enabled="0" endField="" endExpression="" durationUnit="min" startField="" accumulate="0" durationField="" fixedDuration="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 type="categorizedSymbol" enableorderby="0" attr="loc_zx" symbollevels="0" forceraster="0">
    <categories>
      <category value="In" render="true" symbol="0" label="En zone inondable"/>
      <category value="Out" render="true" symbol="1" label="Hors zone inondable"/>
    </categories>
    <symbols>
      <symbol type="fill" force_rhr="0" name="0" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="0,0,255,255"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="1" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="157,157,157,255"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol type="fill" force_rhr="0" name="0" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="152,125,183,255"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory sizeScale="3x:0,0,0,0,0,0" spacing="5" labelPlacementMethod="XHeight" direction="0" width="15" backgroundColor="#ffffff" lineSizeScale="3x:0,0,0,0,0,0" showAxis="1" penWidth="0" scaleDependency="Area" scaleBasedVisibility="0" minimumSize="0" maxScaleDenominator="1e+08" opacity="1" lineSizeType="MM" backgroundAlpha="255" enabled="0" diagramOrientation="Up" penAlpha="255" spacingUnitScale="3x:0,0,0,0,0,0" minScaleDenominator="0" sizeType="MM" barWidth="5" rotationOffset="270" penColor="#000000" spacingUnit="MM" height="15">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
      <axisSymbol>
        <symbol type="line" force_rhr="0" name="" clip_to_extent="1" alpha="1">
          <layer pass="0" enabled="1" class="SimpleLine" locked="0">
            <prop k="align_dash_pattern" v="0"/>
            <prop k="capstyle" v="square"/>
            <prop k="customdash" v="5;2"/>
            <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="customdash_unit" v="MM"/>
            <prop k="dash_pattern_offset" v="0"/>
            <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="dash_pattern_offset_unit" v="MM"/>
            <prop k="draw_inside_polygon" v="0"/>
            <prop k="joinstyle" v="bevel"/>
            <prop k="line_color" v="35,35,35,255"/>
            <prop k="line_style" v="solid"/>
            <prop k="line_width" v="0.26"/>
            <prop k="line_width_unit" v="MM"/>
            <prop k="offset" v="0"/>
            <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="offset_unit" v="MM"/>
            <prop k="ring_filter" v="0"/>
            <prop k="tweak_dash_pattern_on_corners" v="0"/>
            <prop k="use_custom_dash" v="0"/>
            <prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" linePlacementFlags="18" dist="0" placement="1" priority="0" zIndex="0" obstacle="0">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration type="Map">
      <Option type="Map" name="QgsGeometryGapCheck">
        <Option type="double" value="0" name="allowedGapsBuffer"/>
        <Option type="bool" value="false" name="allowedGapsEnabled"/>
        <Option type="QString" value="" name="allowedGapsLayer"/>
      </Option>
    </checkConfiguration>
  </geometryOptions>
  <legend type="default-vector"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="id_bdt">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="territoire">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="id_epci">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="nom_epci">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="id_commune">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="nom_commune">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="id_iris">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="nom_iris">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="loc_zx">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="type_alea">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="code_occurrence">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pop6_haut">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pop6_bas">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="date_calcul">
      <editWidget type="DateTime">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="modalite_calcul">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="geomloc">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="" field="id"/>
    <alias index="1" name="" field="id_bdt"/>
    <alias index="2" name="" field="territoire"/>
    <alias index="3" name="" field="id_epci"/>
    <alias index="4" name="" field="nom_epci"/>
    <alias index="5" name="" field="id_commune"/>
    <alias index="6" name="" field="nom_commune"/>
    <alias index="7" name="" field="id_iris"/>
    <alias index="8" name="" field="nom_iris"/>
    <alias index="9" name="" field="loc_zx"/>
    <alias index="10" name="" field="type_alea"/>
    <alias index="11" name="" field="code_occurrence"/>
    <alias index="12" name="" field="pop6_haut"/>
    <alias index="13" name="" field="pop6_bas"/>
    <alias index="14" name="" field="date_calcul"/>
    <alias index="15" name="" field="modalite_calcul"/>
    <alias index="16" name="" field="geomloc"/>
  </aliases>
  <defaults>
    <default expression="" field="id" applyOnUpdate="0"/>
    <default expression="" field="id_bdt" applyOnUpdate="0"/>
    <default expression="" field="territoire" applyOnUpdate="0"/>
    <default expression="" field="id_epci" applyOnUpdate="0"/>
    <default expression="" field="nom_epci" applyOnUpdate="0"/>
    <default expression="" field="id_commune" applyOnUpdate="0"/>
    <default expression="" field="nom_commune" applyOnUpdate="0"/>
    <default expression="" field="id_iris" applyOnUpdate="0"/>
    <default expression="" field="nom_iris" applyOnUpdate="0"/>
    <default expression="" field="loc_zx" applyOnUpdate="0"/>
    <default expression="" field="type_alea" applyOnUpdate="0"/>
    <default expression="" field="code_occurrence" applyOnUpdate="0"/>
    <default expression="" field="pop6_haut" applyOnUpdate="0"/>
    <default expression="" field="pop6_bas" applyOnUpdate="0"/>
    <default expression="" field="date_calcul" applyOnUpdate="0"/>
    <default expression="" field="modalite_calcul" applyOnUpdate="0"/>
    <default expression="" field="geomloc" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint notnull_strength="1" unique_strength="1" constraints="3" exp_strength="0" field="id"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_bdt"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="territoire"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_epci"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="nom_epci"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_commune"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="nom_commune"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_iris"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="nom_iris"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="loc_zx"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="type_alea"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="code_occurrence"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="pop6_haut"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="pop6_bas"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="date_calcul"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="modalite_calcul"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="geomloc"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="id_bdt" desc=""/>
    <constraint exp="" field="territoire" desc=""/>
    <constraint exp="" field="id_epci" desc=""/>
    <constraint exp="" field="nom_epci" desc=""/>
    <constraint exp="" field="id_commune" desc=""/>
    <constraint exp="" field="nom_commune" desc=""/>
    <constraint exp="" field="id_iris" desc=""/>
    <constraint exp="" field="nom_iris" desc=""/>
    <constraint exp="" field="loc_zx" desc=""/>
    <constraint exp="" field="type_alea" desc=""/>
    <constraint exp="" field="code_occurrence" desc=""/>
    <constraint exp="" field="pop6_haut" desc=""/>
    <constraint exp="" field="pop6_bas" desc=""/>
    <constraint exp="" field="date_calcul" desc=""/>
    <constraint exp="" field="modalite_calcul" desc=""/>
    <constraint exp="" field="geomloc" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="&quot;loc_zx&quot;" actionWidgetStyle="dropDown" sortOrder="0">
    <columns>
      <column type="field" name="id" width="-1" hidden="0"/>
      <column type="field" name="territoire" width="-1" hidden="0"/>
      <column type="field" name="id_epci" width="-1" hidden="0"/>
      <column type="field" name="nom_epci" width="-1" hidden="0"/>
      <column type="field" name="id_commune" width="-1" hidden="0"/>
      <column type="field" name="nom_commune" width="-1" hidden="0"/>
      <column type="field" name="id_iris" width="-1" hidden="0"/>
      <column type="field" name="nom_iris" width="-1" hidden="0"/>
      <column type="field" name="loc_zx" width="-1" hidden="0"/>
      <column type="field" name="code_occurrence" width="-1" hidden="0"/>
      <column type="field" name="type_alea" width="-1" hidden="0"/>
      <column type="field" name="date_calcul" width="-1" hidden="0"/>
      <column type="field" name="modalite_calcul" width="-1" hidden="0"/>
      <column type="actions" width="-1" hidden="1"/>
      <column type="field" name="id_bdt" width="-1" hidden="0"/>
      <column type="field" name="pop6_haut" width="-1" hidden="0"/>
      <column type="field" name="pop6_bas" width="-1" hidden="0"/>
      <column type="field" name="geomloc" width="-1" hidden="0"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
Les formulaires QGIS peuvent avoir une fonction Python qui sera appelée à l'ouverture du formulaire.

Utilisez cette fonction pour ajouter plus de fonctionnalités à vos formulaires.

Entrez le nom de la fonction dans le champ "Fonction d'initialisation Python".
Voici un exemple à suivre:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")

]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="code_occurrence" editable="1"/>
    <field name="date_calcul" editable="1"/>
    <field name="geomloc" editable="1"/>
    <field name="id" editable="1"/>
    <field name="id_bdt" editable="1"/>
    <field name="id_commune" editable="1"/>
    <field name="id_epci" editable="1"/>
    <field name="id_iris" editable="1"/>
    <field name="loc_zx" editable="1"/>
    <field name="modalite_calcul" editable="1"/>
    <field name="nom_commune" editable="1"/>
    <field name="nom_epci" editable="1"/>
    <field name="nom_iris" editable="1"/>
    <field name="pct_pop6_zx_pop6_tot_com" editable="1"/>
    <field name="pct_pop6_zx_pop6_tot_epci" editable="1"/>
    <field name="pct_pop6_zx_pop6_tot_iris" editable="1"/>
    <field name="pop6_bas" editable="1"/>
    <field name="pop6_haut" editable="1"/>
    <field name="pop6_tot_com" editable="1"/>
    <field name="pop6_tot_epci" editable="1"/>
    <field name="pop6_tot_iris" editable="1"/>
    <field name="pop6_zx_com" editable="1"/>
    <field name="pop6_zx_epci" editable="1"/>
    <field name="pop6_zx_iris" editable="1"/>
    <field name="territoire" editable="1"/>
    <field name="type_alea" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="code_occurrence"/>
    <field labelOnTop="0" name="date_calcul"/>
    <field labelOnTop="0" name="geomloc"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="id_bdt"/>
    <field labelOnTop="0" name="id_commune"/>
    <field labelOnTop="0" name="id_epci"/>
    <field labelOnTop="0" name="id_iris"/>
    <field labelOnTop="0" name="loc_zx"/>
    <field labelOnTop="0" name="modalite_calcul"/>
    <field labelOnTop="0" name="nom_commune"/>
    <field labelOnTop="0" name="nom_epci"/>
    <field labelOnTop="0" name="nom_iris"/>
    <field labelOnTop="0" name="pct_pop6_zx_pop6_tot_com"/>
    <field labelOnTop="0" name="pct_pop6_zx_pop6_tot_epci"/>
    <field labelOnTop="0" name="pct_pop6_zx_pop6_tot_iris"/>
    <field labelOnTop="0" name="pop6_bas"/>
    <field labelOnTop="0" name="pop6_haut"/>
    <field labelOnTop="0" name="pop6_tot_com"/>
    <field labelOnTop="0" name="pop6_tot_epci"/>
    <field labelOnTop="0" name="pop6_tot_iris"/>
    <field labelOnTop="0" name="pop6_zx_com"/>
    <field labelOnTop="0" name="pop6_zx_epci"/>
    <field labelOnTop="0" name="pop6_zx_iris"/>
    <field labelOnTop="0" name="territoire"/>
    <field labelOnTop="0" name="type_alea"/>
  </labelOnTop>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"nom_epci"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
