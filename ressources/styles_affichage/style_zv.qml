<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="0" styleCategories="AllStyleCategories" simplifyAlgorithm="0" version="3.16.14-Hannover" minScale="100000000" readOnly="0" simplifyMaxScale="1" simplifyDrawingHints="0" simplifyDrawingTol="1" simplifyLocal="1" maxScale="0" hasScaleBasedVisibilityFlag="0">
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
  <renderer-v2 type="RuleRenderer" enableorderby="0" symbollevels="0" forceraster="0">
    <rules key="{a53fd8d7-eb70-4f12-adbc-23291e8cab7f}">
      <rule filter="&quot;vitesse_maxi&quot; &lt; 0.2" symbol="0" key="{66416f30-2e7a-491c-9550-849227127e4b}" label="Vitesse d'écoulement faible : &lt; 0,2 m/s (stockage)"/>
      <rule filter="&quot;vitesse_maxi&quot; >= 0.2 AND &quot;vitesse_maxi&quot; &lt; 0.5" symbol="1" key="{70e1af4c-b547-421b-a6a5-5d1f66f4911c}" label="Vitesse d'écoulement moyenne : 0,2 à 0,5 m/s (écoulement)"/>
      <rule filter="&quot;vitesse_maxi&quot; >= 0.5" symbol="2" key="{e720f0ea-854f-4251-b37e-ba8ee4cb58b6}" label="Vitesse d'écoulement forte : > 0,5 m/s (grand écoulement)"/>
    </rules>
    <symbols>
      <symbol type="marker" force_rhr="0" name="0" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="121,188,102,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" force_rhr="0" name="1" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="255,255,52,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" force_rhr="0" name="2" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="210,40,40,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
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
  <DiagramLayerSettings showAll="1" linePlacementFlags="18" dist="0" placement="0" priority="0" zIndex="0" obstacle="0">
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
    <checkConfiguration/>
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
    <field configurationFlags="None" name="nompt2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="vitesse_maxi">
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
    <field configurationFlags="None" name="modele_hydro_ref">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="occurrence">
      <editWidget type="Range">
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
    <field configurationFlags="None" name="code_occurrence">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="" field="id"/>
    <alias index="1" name="" field="nompt2"/>
    <alias index="2" name="" field="vitesse_maxi"/>
    <alias index="3" name="" field="type_alea"/>
    <alias index="4" name="" field="modele_hydro_ref"/>
    <alias index="5" name="" field="occurrence"/>
    <alias index="6" name="" field="territoire"/>
    <alias index="7" name="" field="code_occurrence"/>
  </aliases>
  <defaults>
    <default expression="" field="id" applyOnUpdate="0"/>
    <default expression="" field="nompt2" applyOnUpdate="0"/>
    <default expression="" field="vitesse_maxi" applyOnUpdate="0"/>
    <default expression="" field="type_alea" applyOnUpdate="0"/>
    <default expression="" field="modele_hydro_ref" applyOnUpdate="0"/>
    <default expression="" field="occurrence" applyOnUpdate="0"/>
    <default expression="" field="territoire" applyOnUpdate="0"/>
    <default expression="" field="code_occurrence" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint notnull_strength="1" unique_strength="1" constraints="3" exp_strength="0" field="id"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="nompt2"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="vitesse_maxi"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="type_alea"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="modele_hydro_ref"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="occurrence"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="territoire"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="code_occurrence"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="nompt2" desc=""/>
    <constraint exp="" field="vitesse_maxi" desc=""/>
    <constraint exp="" field="type_alea" desc=""/>
    <constraint exp="" field="modele_hydro_ref" desc=""/>
    <constraint exp="" field="occurrence" desc=""/>
    <constraint exp="" field="territoire" desc=""/>
    <constraint exp="" field="code_occurrence" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
    <columns>
      <column type="field" name="id" width="-1" hidden="0"/>
      <column type="field" name="nompt2" width="-1" hidden="0"/>
      <column type="field" name="vitesse_maxi" width="-1" hidden="0"/>
      <column type="field" name="type_alea" width="-1" hidden="0"/>
      <column type="field" name="modele_hydro_ref" width="-1" hidden="0"/>
      <column type="field" name="occurrence" width="-1" hidden="0"/>
      <column type="field" name="territoire" width="-1" hidden="0"/>
      <column type="field" name="code_occurrence" width="-1" hidden="0"/>
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
    <field name="code_occurrence" editable="1"/>
    <field name="id" editable="1"/>
    <field name="modele_hydro_ref" editable="1"/>
    <field name="nompt2" editable="1"/>
    <field name="occurrence" editable="1"/>
    <field name="territoire" editable="1"/>
    <field name="type_alea" editable="1"/>
    <field name="vitesse_maxi" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="code_occurrence"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="modele_hydro_ref"/>
    <field labelOnTop="0" name="nompt2"/>
    <field labelOnTop="0" name="occurrence"/>
    <field labelOnTop="0" name="territoire"/>
    <field labelOnTop="0" name="type_alea"/>
    <field labelOnTop="0" name="vitesse_maxi"/>
  </labelOnTop>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"nompt2"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
