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
  <renderer-v2 type="singleSymbol" enableorderby="0" symbollevels="0" forceraster="0">
    <symbols>
      <symbol type="fill" force_rhr="0" name="0" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="164,164,164,255"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="220,90,183,255"/>
          <prop k="outline_style" v="dot"/>
          <prop k="outline_width" v="0.46"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="no"/>
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
    <field configurationFlags="None" name="territoire">
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
    <field configurationFlags="None" name="libelle">
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
    <field configurationFlags="None" name="id_epci">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="id_dpt">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="id_region">
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
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="" field="id"/>
    <alias index="1" name="" field="territoire"/>
    <alias index="2" name="" field="id_iris"/>
    <alias index="3" name="" field="libelle"/>
    <alias index="4" name="" field="id_commune"/>
    <alias index="5" name="" field="id_epci"/>
    <alias index="6" name="" field="id_dpt"/>
    <alias index="7" name="" field="id_region"/>
    <alias index="8" name="" field="date_calcul"/>
  </aliases>
  <defaults>
    <default expression="" field="id" applyOnUpdate="0"/>
    <default expression="" field="territoire" applyOnUpdate="0"/>
    <default expression="" field="id_iris" applyOnUpdate="0"/>
    <default expression="" field="libelle" applyOnUpdate="0"/>
    <default expression="" field="id_commune" applyOnUpdate="0"/>
    <default expression="" field="id_epci" applyOnUpdate="0"/>
    <default expression="" field="id_dpt" applyOnUpdate="0"/>
    <default expression="" field="id_region" applyOnUpdate="0"/>
    <default expression="" field="date_calcul" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint notnull_strength="1" unique_strength="1" constraints="3" exp_strength="0" field="id"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="territoire"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_iris"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="libelle"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_commune"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_epci"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_dpt"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_region"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="date_calcul"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="territoire" desc=""/>
    <constraint exp="" field="id_iris" desc=""/>
    <constraint exp="" field="libelle" desc=""/>
    <constraint exp="" field="id_commune" desc=""/>
    <constraint exp="" field="id_epci" desc=""/>
    <constraint exp="" field="id_dpt" desc=""/>
    <constraint exp="" field="id_region" desc=""/>
    <constraint exp="" field="date_calcul" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
    <columns>
      <column type="field" name="id" width="-1" hidden="0"/>
      <column type="field" name="territoire" width="-1" hidden="0"/>
      <column type="field" name="id_iris" width="-1" hidden="0"/>
      <column type="field" name="libelle" width="-1" hidden="0"/>
      <column type="field" name="id_commune" width="-1" hidden="0"/>
      <column type="field" name="id_epci" width="-1" hidden="0"/>
      <column type="field" name="id_dpt" width="-1" hidden="0"/>
      <column type="field" name="id_region" width="-1" hidden="0"/>
      <column type="field" name="date_calcul" width="-1" hidden="0"/>
      <column type="actions" width="-1" hidden="1"/>
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
    <field name="date_calcul" editable="1"/>
    <field name="id" editable="1"/>
    <field name="id_commune" editable="1"/>
    <field name="id_dpt" editable="1"/>
    <field name="id_epci" editable="1"/>
    <field name="id_iris" editable="1"/>
    <field name="id_region" editable="1"/>
    <field name="libelle" editable="1"/>
    <field name="territoire" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="date_calcul"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="id_commune"/>
    <field labelOnTop="0" name="id_dpt"/>
    <field labelOnTop="0" name="id_epci"/>
    <field labelOnTop="0" name="id_iris"/>
    <field labelOnTop="0" name="id_region"/>
    <field labelOnTop="0" name="libelle"/>
    <field labelOnTop="0" name="territoire"/>
  </labelOnTop>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
