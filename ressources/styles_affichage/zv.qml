<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="Symbology|Labeling|MapTips|Rendering" maxScale="0" simplifyLocal="1" labelsEnabled="1" hasScaleBasedVisibilityFlag="0" simplifyMaxScale="1" simplifyDrawingHints="0" simplifyDrawingTol="1" version="3.16.14-Hannover" minScale="100000000" simplifyAlgorithm="0">
  <renderer-v2 forceraster="0" tolerance="20" type="pointCluster" toleranceUnitScale="3x:0,0,0,0,0,0" enableorderby="0" toleranceUnit="MM">
    <renderer-v2 forceraster="0" symbollevels="0" type="RuleRenderer" enableorderby="0">
      <rules key="{a53fd8d7-eb70-4f12-adbc-23291e8cab7f}">
        <rule key="{66416f30-2e7a-491c-9550-849227127e4b}" filter="&quot;vitesse_maxi&quot; &lt; 0.2" symbol="0" label="Vitesse d'écoulement faible : &lt; 0,2 m/s (stockage)"/>
        <rule key="{70e1af4c-b547-421b-a6a5-5d1f66f4911c}" filter="&quot;vitesse_maxi&quot; >= 0.2 AND &quot;vitesse_maxi&quot; &lt; 0.5" symbol="1" label="Vitesse d'écoulement moyenne : 0,2 à 0,5 m/s (écoulement)"/>
        <rule key="{e720f0ea-854f-4251-b37e-ba8ee4cb58b6}" filter="&quot;vitesse_maxi&quot; >= 0.5" symbol="2" label="Vitesse d'écoulement forte : ≥ 0,5 m/s (grand écoulement)"/>
      </rules>
      <symbols>
        <symbol name="0" alpha="1" force_rhr="0" type="marker" clip_to_extent="1">
          <layer locked="0" pass="0" class="SimpleMarker" enabled="1">
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
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
        <symbol name="1" alpha="1" force_rhr="0" type="marker" clip_to_extent="1">
          <layer locked="0" pass="0" class="SimpleMarker" enabled="1">
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
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
        <symbol name="2" alpha="1" force_rhr="0" type="marker" clip_to_extent="1">
          <layer locked="0" pass="0" class="SimpleMarker" enabled="1">
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
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
      </symbols>
    </renderer-v2>
    <symbol name="centerSymbol" alpha="1" force_rhr="0" type="marker" clip_to_extent="1">
      <layer locked="0" pass="0" class="SimpleMarker" enabled="1">
        <prop k="angle" v="0"/>
        <prop k="color" v="221,221,221,255"/>
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
        <prop k="size" v="5"/>
        <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
        <prop k="size_unit" v="MM"/>
        <prop k="vertical_anchor_point" v="1"/>
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
      </layer>
      <layer locked="0" pass="0" class="FontMarker" enabled="1">
        <prop k="angle" v="0"/>
        <prop k="chr" v="A"/>
        <prop k="color" v="0,0,0,255"/>
        <prop k="font" v="Arial"/>
        <prop k="font_style" v="Normal"/>
        <prop k="horizontal_anchor_point" v="1"/>
        <prop k="joinstyle" v="miter"/>
        <prop k="offset" v="0,-0.40000000000000002"/>
        <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
        <prop k="offset_unit" v="MM"/>
        <prop k="outline_color" v="255,255,255,255"/>
        <prop k="outline_width" v="0"/>
        <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
        <prop k="outline_width_unit" v="MM"/>
        <prop k="size" v="3.2"/>
        <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
        <prop k="size_unit" v="MM"/>
        <prop k="vertical_anchor_point" v="1"/>
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties" type="Map">
              <Option name="char" type="Map">
                <Option value="true" name="active" type="bool"/>
                <Option value="@cluster_size" name="expression" type="QString"/>
                <Option value="3" name="type" type="int"/>
              </Option>
            </Option>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
      </layer>
    </symbol>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{54955e94-cce3-46e1-adf4-d1f04f85523e}">
      <rule key="{a6f07d30-5f38-472d-9c8b-4dc3db73237b}" scalemaxdenom="10000" scalemindenom="1" description="Vitesse d'écoulement faible : &lt; 0,2 m/s (stockage)" filter="&quot;vitesse_maxi&quot; &lt; 0.2">
        <settings calloutType="simple">
          <text-style fontStrikeout="0" fontWordSpacing="0" fontKerning="1" fontSize="10" multilineHeight="1" fontFamily="Arial" fontUnderline="0" textOpacity="1" useSubstitutions="0" blendMode="0" fontSizeUnit="Point" textColor="121,188,102,255" allowHtml="0" capitalization="0" isExpression="0" textOrientation="horizontal" fieldName="vitesse_maxi" namedStyle="Bold" previewBkgrdColor="255,255,255,255" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontLetterSpacing="0" fontWeight="75" fontItalic="0">
            <text-buffer bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferOpacity="1" bufferJoinStyle="128" bufferColor="0,0,0,255" bufferSizeUnits="MM" bufferBlendMode="0" bufferDraw="0" bufferSize="0.29999999999999999" bufferNoFill="1"/>
            <text-mask maskOpacity="1" maskSize="1.5" maskSizeUnits="MM" maskJoinStyle="128" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskedSymbolLayers="" maskEnabled="0" maskType="0"/>
            <background shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeRotationType="0" shapeDraw="0" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="MM" shapeBorderWidth="0" shapeRadiiX="0" shapeRadiiY="0" shapeBlendMode="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRotation="0" shapeSVGFile="" shapeOffsetX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeOffsetUnit="MM" shapeOpacity="1" shapeSizeUnit="MM" shapeOffsetY="0" shapeSizeX="0" shapeSizeY="0" shapeRadiiUnit="MM" shapeSizeType="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBorderColor="128,128,128,255">
              <symbol name="markerSymbol" alpha="1" force_rhr="0" type="marker" clip_to_extent="1">
                <layer locked="0" pass="0" class="SimpleMarker" enabled="1">
                  <prop k="angle" v="0"/>
                  <prop k="color" v="231,113,72,255"/>
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
                      <Option value="" name="name" type="QString"/>
                      <Option name="properties"/>
                      <Option value="collection" name="type" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowRadius="1.5" shadowRadiusUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowDraw="0" shadowScale="100" shadowOffsetAngle="135" shadowOffsetGlobal="1" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255" shadowOffsetUnit="MM" shadowRadiusAlphaOnly="0" shadowOpacity="0.69999999999999996" shadowUnder="0"/>
            <dd_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format rightDirectionSymbol=">" useMaxLineLengthForAutoWrap="1" multilineAlign="3" placeDirectionSymbol="0" wrapChar="" decimals="3" plussign="0" addDirectionSymbol="0" leftDirectionSymbol="&lt;" reverseDirectionSymbol="0" formatNumbers="0" autoWrapLength="0"/>
          <placement predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" polygonPlacementFlags="2" maxCurvedCharAngleOut="-25" geometryGenerator="" repeatDistanceUnits="MM" priority="5" placementFlags="10" distUnits="MM" maxCurvedCharAngleIn="25" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceUnit="MM" distMapUnitScale="3x:0,0,0,0,0,0" overrunDistance="0" repeatDistance="0" placement="1" yOffset="-1" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" centroidWhole="0" centroidInside="0" preserveRotation="1" lineAnchorPercent="0.5" rotationAngle="0" xOffset="0" offsetUnits="MM" offsetType="0" geometryGeneratorEnabled="0" quadOffset="1" fitInPolygonOnly="0" layerType="PointGeometry" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" lineAnchorType="0" dist="0"/>
          <rendering labelPerPart="0" fontLimitPixelSize="0" minFeatureSize="0" obstacle="1" obstacleFactor="1" fontMaxPixelSize="10000" displayAll="0" fontMinPixelSize="3" scaleVisibility="0" obstacleType="1" mergeLines="0" scaleMin="0" scaleMax="0" zIndex="0" drawLabels="1" limitNumLabels="0" maxNumLabels="2000" upsidedownLabels="0"/>
          <dd_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
              <Option name="ddProperties" type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
              <Option value="false" name="drawToAllParts" type="bool"/>
              <Option value="0" name="enabled" type="QString"/>
              <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
              <Option value="&lt;symbol name=&quot;symbol&quot; alpha=&quot;1&quot; force_rhr=&quot;0&quot; type=&quot;line&quot; clip_to_extent=&quot;1&quot;>&lt;layer locked=&quot;0&quot; pass=&quot;0&quot; class=&quot;SimpleLine&quot; enabled=&quot;1&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
              <Option value="0" name="minLength" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
              <Option value="MM" name="minLengthUnit" type="QString"/>
              <Option value="0" name="offsetFromAnchor" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
              <Option value="0" name="offsetFromLabel" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
            </Option>
          </callout>
        </settings>
      </rule>
      <rule key="{dd6db592-90e1-49fd-bc52-f530e0ca3e01}" scalemaxdenom="10000" scalemindenom="1" description="Vitesse d'écoulement moyenne : 0,2 à 0,5 m/s (écoulement)" filter="&quot;vitesse_maxi&quot; >= 0.2 AND &quot;vitesse_maxi&quot; &lt; 0.5">
        <settings calloutType="simple">
          <text-style fontStrikeout="0" fontWordSpacing="0" fontKerning="1" fontSize="10" multilineHeight="1" fontFamily="Arial" fontUnderline="0" textOpacity="1" useSubstitutions="0" blendMode="0" fontSizeUnit="Point" textColor="255,255,52,255" allowHtml="0" capitalization="0" isExpression="0" textOrientation="horizontal" fieldName="vitesse_maxi" namedStyle="Bold" previewBkgrdColor="255,255,255,255" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontLetterSpacing="0" fontWeight="75" fontItalic="0">
            <text-buffer bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferOpacity="1" bufferJoinStyle="128" bufferColor="0,0,0,255" bufferSizeUnits="MM" bufferBlendMode="0" bufferDraw="1" bufferSize="0.25" bufferNoFill="1"/>
            <text-mask maskOpacity="1" maskSize="1.5" maskSizeUnits="MM" maskJoinStyle="128" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskedSymbolLayers="" maskEnabled="0" maskType="0"/>
            <background shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeRotationType="0" shapeDraw="0" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="MM" shapeBorderWidth="0" shapeRadiiX="0" shapeRadiiY="0" shapeBlendMode="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRotation="0" shapeSVGFile="" shapeOffsetX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeOffsetUnit="MM" shapeOpacity="1" shapeSizeUnit="MM" shapeOffsetY="0" shapeSizeX="0" shapeSizeY="0" shapeRadiiUnit="MM" shapeSizeType="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBorderColor="128,128,128,255">
              <symbol name="markerSymbol" alpha="1" force_rhr="0" type="marker" clip_to_extent="1">
                <layer locked="0" pass="0" class="SimpleMarker" enabled="1">
                  <prop k="angle" v="0"/>
                  <prop k="color" v="231,113,72,255"/>
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
                      <Option value="" name="name" type="QString"/>
                      <Option name="properties"/>
                      <Option value="collection" name="type" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowRadius="1.5" shadowRadiusUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowDraw="0" shadowScale="100" shadowOffsetAngle="135" shadowOffsetGlobal="1" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255" shadowOffsetUnit="MM" shadowRadiusAlphaOnly="0" shadowOpacity="0.69999999999999996" shadowUnder="0"/>
            <dd_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format rightDirectionSymbol=">" useMaxLineLengthForAutoWrap="1" multilineAlign="3" placeDirectionSymbol="0" wrapChar="" decimals="3" plussign="0" addDirectionSymbol="0" leftDirectionSymbol="&lt;" reverseDirectionSymbol="0" formatNumbers="0" autoWrapLength="0"/>
          <placement predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" polygonPlacementFlags="2" maxCurvedCharAngleOut="-25" geometryGenerator="" repeatDistanceUnits="MM" priority="5" placementFlags="10" distUnits="MM" maxCurvedCharAngleIn="25" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceUnit="MM" distMapUnitScale="3x:0,0,0,0,0,0" overrunDistance="0" repeatDistance="0" placement="1" yOffset="-1" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" centroidWhole="0" centroidInside="0" preserveRotation="1" lineAnchorPercent="0.5" rotationAngle="0" xOffset="0" offsetUnits="MM" offsetType="0" geometryGeneratorEnabled="0" quadOffset="1" fitInPolygonOnly="0" layerType="PointGeometry" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" lineAnchorType="0" dist="0"/>
          <rendering labelPerPart="0" fontLimitPixelSize="0" minFeatureSize="0" obstacle="1" obstacleFactor="1" fontMaxPixelSize="10000" displayAll="0" fontMinPixelSize="3" scaleVisibility="0" obstacleType="1" mergeLines="0" scaleMin="0" scaleMax="0" zIndex="0" drawLabels="1" limitNumLabels="0" maxNumLabels="2000" upsidedownLabels="0"/>
          <dd_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
              <Option name="ddProperties" type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
              <Option value="false" name="drawToAllParts" type="bool"/>
              <Option value="0" name="enabled" type="QString"/>
              <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
              <Option value="&lt;symbol name=&quot;symbol&quot; alpha=&quot;1&quot; force_rhr=&quot;0&quot; type=&quot;line&quot; clip_to_extent=&quot;1&quot;>&lt;layer locked=&quot;0&quot; pass=&quot;0&quot; class=&quot;SimpleLine&quot; enabled=&quot;1&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
              <Option value="0" name="minLength" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
              <Option value="MM" name="minLengthUnit" type="QString"/>
              <Option value="0" name="offsetFromAnchor" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
              <Option value="0" name="offsetFromLabel" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
            </Option>
          </callout>
        </settings>
      </rule>
      <rule key="{1ad7e1a3-f1b5-469e-a921-1cd38cc78447}" scalemaxdenom="10000" scalemindenom="1" description="Vitesse d'écoulement forte : ≥ 0,5 m/s (grand écoulement)" filter="&quot;vitesse_maxi&quot; >= 0.5">
        <settings calloutType="simple">
          <text-style fontStrikeout="0" fontWordSpacing="0" fontKerning="1" fontSize="10" multilineHeight="1" fontFamily="Arial" fontUnderline="0" textOpacity="1" useSubstitutions="0" blendMode="0" fontSizeUnit="Point" textColor="210,40,40,255" allowHtml="0" capitalization="0" isExpression="0" textOrientation="horizontal" fieldName="vitesse_maxi" namedStyle="Bold" previewBkgrdColor="255,255,255,255" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontLetterSpacing="0" fontWeight="75" fontItalic="0">
            <text-buffer bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferOpacity="1" bufferJoinStyle="128" bufferColor="0,0,0,255" bufferSizeUnits="MM" bufferBlendMode="0" bufferDraw="0" bufferSize="0.29999999999999999" bufferNoFill="1"/>
            <text-mask maskOpacity="1" maskSize="1.5" maskSizeUnits="MM" maskJoinStyle="128" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskedSymbolLayers="" maskEnabled="0" maskType="0"/>
            <background shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeRotationType="0" shapeDraw="0" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="MM" shapeBorderWidth="0" shapeRadiiX="0" shapeRadiiY="0" shapeBlendMode="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRotation="0" shapeSVGFile="" shapeOffsetX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeOffsetUnit="MM" shapeOpacity="1" shapeSizeUnit="MM" shapeOffsetY="0" shapeSizeX="0" shapeSizeY="0" shapeRadiiUnit="MM" shapeSizeType="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBorderColor="128,128,128,255">
              <symbol name="markerSymbol" alpha="1" force_rhr="0" type="marker" clip_to_extent="1">
                <layer locked="0" pass="0" class="SimpleMarker" enabled="1">
                  <prop k="angle" v="0"/>
                  <prop k="color" v="231,113,72,255"/>
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
                      <Option value="" name="name" type="QString"/>
                      <Option name="properties"/>
                      <Option value="collection" name="type" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowRadius="1.5" shadowRadiusUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowDraw="0" shadowScale="100" shadowOffsetAngle="135" shadowOffsetGlobal="1" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255" shadowOffsetUnit="MM" shadowRadiusAlphaOnly="0" shadowOpacity="0.69999999999999996" shadowUnder="0"/>
            <dd_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format rightDirectionSymbol=">" useMaxLineLengthForAutoWrap="1" multilineAlign="3" placeDirectionSymbol="0" wrapChar="" decimals="3" plussign="0" addDirectionSymbol="0" leftDirectionSymbol="&lt;" reverseDirectionSymbol="0" formatNumbers="0" autoWrapLength="0"/>
          <placement predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" polygonPlacementFlags="2" maxCurvedCharAngleOut="-25" geometryGenerator="" repeatDistanceUnits="MM" priority="5" placementFlags="10" distUnits="MM" maxCurvedCharAngleIn="25" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceUnit="MM" distMapUnitScale="3x:0,0,0,0,0,0" overrunDistance="0" repeatDistance="0" placement="1" yOffset="-1" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" centroidWhole="0" centroidInside="0" preserveRotation="1" lineAnchorPercent="0.5" rotationAngle="0" xOffset="0" offsetUnits="MM" offsetType="0" geometryGeneratorEnabled="0" quadOffset="1" fitInPolygonOnly="0" layerType="PointGeometry" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" lineAnchorType="0" dist="0"/>
          <rendering labelPerPart="0" fontLimitPixelSize="0" minFeatureSize="0" obstacle="1" obstacleFactor="1" fontMaxPixelSize="10000" displayAll="0" fontMinPixelSize="3" scaleVisibility="0" obstacleType="1" mergeLines="0" scaleMin="0" scaleMax="0" zIndex="0" drawLabels="1" limitNumLabels="0" maxNumLabels="2000" upsidedownLabels="0"/>
          <dd_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
              <Option name="ddProperties" type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
              <Option value="false" name="drawToAllParts" type="bool"/>
              <Option value="0" name="enabled" type="QString"/>
              <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
              <Option value="&lt;symbol name=&quot;symbol&quot; alpha=&quot;1&quot; force_rhr=&quot;0&quot; type=&quot;line&quot; clip_to_extent=&quot;1&quot;>&lt;layer locked=&quot;0&quot; pass=&quot;0&quot; class=&quot;SimpleLine&quot; enabled=&quot;1&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
              <Option value="0" name="minLength" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
              <Option value="MM" name="minLengthUnit" type="QString"/>
              <Option value="0" name="offsetFromAnchor" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
              <Option value="0" name="offsetFromLabel" type="double"/>
              <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
              <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
            </Option>
          </callout>
        </settings>
      </rule>
    </rules>
  </labeling>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <mapTip>[% "vitesse_maxi" %]</mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
