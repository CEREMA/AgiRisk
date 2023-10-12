<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyAlgorithm="0" readOnly="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyMaxScale="1" version="3.16.14-Hannover" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" minScale="100000000" labelsEnabled="1" maxScale="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <temporal endField="" accumulate="0" mode="0" endExpression="" fixedDuration="0" enabled="0" startField="" durationField="" durationUnit="min" startExpression="">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="RuleRenderer">
    <rules key="{64fba71e-d516-4dc8-9c1a-da80c28cc830}">
      <rule key="{b0b1264f-d9ac-41ed-ad76-35e114db699b}" symbol="0" filter="&quot;type_alea&quot; = 'débordement de cours d''eau'" label="Aléa débordement de cours d'eau">
        <rule key="{77dbe6be-35b3-414b-b0a6-b500f22b7fce}" symbol="1" filter="&quot;code_occurrence&quot; = 'QRef'" label="QRef">
          <rule scalemaxdenom="10000" key="{e2698c71-50f6-4e23-96b1-c8d6d193c847}" symbol="2" filter="&quot;type_result&quot; = 'Entite'" scalemindenom="1" label="Bâtiments">
            <rule key="{00c2ec02-be52-48f3-abff-e18a0cf6f337}" symbol="3" filter="&quot;loc_zx&quot; = 'In'" label="En zone inondable"/>
            <rule key="{feea384a-4bc5-44c2-871d-c38b70972179}" symbol="4" filter="&quot;loc_zx&quot; = 'Out'" label="Hors zone inondable"/>
          </rule>
          <rule scalemaxdenom="20000" key="{6b8ca00b-a121-446a-8b84-5981e3ab5640}" symbol="5" filter="&quot;type_result&quot; = 'Hexag_1ha'" scalemindenom="5000" label="Hexag_1ha">
            <rule key="{f77cd966-dcf1-4b28-82f3-5a886111e1b0}" symbol="6" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 5" label="Moins de 5"/>
            <rule key="{6c14a178-68cb-42d5-b3fb-b42e1b73c1b1}" symbol="7" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 5 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 11" label="5 - 10"/>
            <rule key="{5bf20873-62bf-4051-926d-4981744e5529}" symbol="8" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 11 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 17" label="11 - 16"/>
            <rule key="{1dd9b446-2b6f-4418-a051-3afab48d8055}" symbol="9" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 17 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 25" label="17 - 24"/>
            <rule key="{ef7eacc4-5806-49bd-8ca1-4057af846590}" symbol="10" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 25 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 33" label="25 - 32"/>
            <rule key="{849a2845-a899-4a87-9ae8-8d9e9bf7f55c}" symbol="11" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 33 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 45" label="33 - 44"/>
            <rule key="{adefd72f-31f9-41a1-a18e-f72c49ee79d2}" symbol="12" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 45 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 97" label="45 - 96"/>
            <rule key="{d07a9e09-405a-44c0-ab81-902954677962}" symbol="13" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 97 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 311" label="97 - 310"/>
            <rule key="{28672a59-42b1-4862-8896-591e6d24dd5c}" symbol="14" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 311" label="311 et plus"/>
          </rule>
          <rule scalemaxdenom="30000" key="{bb780b3d-6804-4644-bdcf-768ed48a506a}" symbol="15" filter="&quot;type_result&quot; = 'Hexag_5ha'" scalemindenom="20000" label="Hexag_5ha">
            <rule key="{2178de48-8058-4925-941d-18b969ea0f36}" symbol="16" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 3" label="Moins de 3"/>
            <rule key="{b721c612-e2a2-448c-976f-114378665d23}" symbol="17" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 3 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 13" label="3 - 12"/>
            <rule key="{0e170b33-59fb-42e4-ad71-e607d0788344}" symbol="18" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 13 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 25" label="13 - 24"/>
            <rule key="{57f8ecc4-bcb6-413b-bbb6-bf7579fd8881}" symbol="19" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 25 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 44" label="25 - 43"/>
            <rule key="{898cda0f-bf06-413e-81a3-9a61e7141ccb}" symbol="20" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 44 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 67" label="44 - 66"/>
            <rule key="{d57fd573-5243-4007-9cfb-91bb5a2e62b2}" symbol="21" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 67 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 104" label="67 - 103"/>
            <rule key="{7c8d0c33-65d1-44d2-a7eb-65c263d0a84a}" symbol="22" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 104 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 141" label="104 - 140"/>
            <rule key="{1299ebe4-69b6-4864-9c81-e24356f3d4e3}" symbol="23" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 141 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 194" label="141 - 193"/>
            <rule key="{37894a80-5090-4773-819a-1a854f86ba48}" symbol="24" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 194 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 384" label="194 - 383"/>
            <rule key="{ee02e05b-9860-49d1-8aa3-254835bf3495}" symbol="25" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 384" label="384 et plus"/>
          </rule>
          <rule scalemaxdenom="40000" key="{5c6eebf5-aa97-48d9-adbd-53b58054b6fb}" symbol="26" filter="&quot;type_result&quot; = 'Hexag_10ha'" scalemindenom="30000" label="Hexag_10ha">
            <rule key="{c6d344da-842d-4973-8320-591180557ff9}" symbol="27" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 4" label="Moins de 4"/>
            <rule key="{51bbe01d-b8f4-4b8b-ad8a-1811810bab71}" symbol="28" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 4 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 15" label="4 - 14"/>
            <rule key="{fb7dc783-c8cc-433f-9c74-9fe479060c87}" symbol="29" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 15 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 26" label="15 - 25"/>
            <rule key="{89f609b9-6095-48f9-b9b7-74060ce16641}" symbol="30" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 26 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 42" label="26 - 41"/>
            <rule key="{79441803-34c1-4341-a4ce-a96ab0db5ea0}" symbol="31" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 42 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 61" label="42 - 60"/>
            <rule key="{5ccd0e34-5c34-41d5-8855-9898e9b40c06}" symbol="32" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 61 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 79" label="61 - 78"/>
            <rule key="{2289c1a8-5e1f-473f-b145-242fea44a69c}" symbol="33" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 79 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 113" label="79 - 112"/>
            <rule key="{fcbaa20b-85ed-4e2c-a528-557a5b1b91db}" symbol="34" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 113 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 165" label="113 - 164"/>
            <rule key="{8370df14-43b9-4d73-b9b6-c663a467fafc}" symbol="35" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 165 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 265" label="165 - 264"/>
            <rule key="{3bb4815d-e156-4069-94fd-57f847dd1e09}" symbol="36" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 265" label="265 et plus"/>
          </rule>
          <rule scalemaxdenom="50000" key="{a22b7821-a382-4946-b20f-1c95df231176}" symbol="37" filter="&quot;type_result&quot; = 'Hexag_50ha'" scalemindenom="40000" label="Hexag_50ha">
            <rule key="{51727872-9b5b-47f1-a327-585f6e4be684}" symbol="38" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 18" label="Moins de 18"/>
            <rule key="{0ffeebdc-c392-4b08-80c4-10ff6ea7beef}" symbol="39" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 18 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 55" label="18 - 54"/>
            <rule key="{b791a43b-13e0-462b-9d90-956d1152a11d}" symbol="40" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 55 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 99" label="55 - 98"/>
            <rule key="{32d7fe08-a068-47fa-82f6-c9fc5ae89e3d}" symbol="41" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 99 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 151" label="99 - 150"/>
            <rule key="{7ca41c7b-80e4-4111-84f1-264362a1415d}" symbol="42" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 151 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 202" label="151 - 201"/>
            <rule key="{a2fabe30-06c9-48a0-9c17-f08d92b2ee43}" symbol="43" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 202 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 253" label="202 - 252"/>
            <rule key="{e86c8d03-eef0-4675-a257-b60428337456}" symbol="44" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 253 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 367" label="253 - 366"/>
            <rule key="{96c7656e-eed0-4a2b-abc1-e0665b0dc94d}" symbol="45" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 367 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 574" label="367 - 573"/>
            <rule key="{400b8002-069f-4d31-824b-7c868c75531f}" symbol="46" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 574 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 896" label="574 - 895"/>
            <rule key="{ab3c1d24-3424-4d34-b624-1f3b98e90f90}" symbol="47" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 896" label="896 et plus"/>
          </rule>
          <rule scalemaxdenom="60000" key="{4bd55b2e-b189-4aa3-b158-e5440884a7e0}" symbol="48" filter="&quot;type_result&quot; = 'Hexag_100ha'" scalemindenom="50000" label="Hexag_100ha">
            <rule key="{bdf8766d-3d90-41b3-b562-0ed096f88c07}" symbol="49" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 17" label="Moins de 17"/>
            <rule key="{9afa6db2-6009-48b2-a13b-1cf85e2e1bf8}" symbol="50" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 17 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 52" label="17 - 51"/>
            <rule key="{175fd4e6-6b93-4172-aec4-e94cae02a948}" symbol="51" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 52 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 91" label="52 - 90"/>
            <rule key="{cfb06358-27cf-4b76-a13f-bfb070b1b006}" symbol="52" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 91 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 177" label="91 - 176"/>
            <rule key="{39593a8a-d11f-4e68-b9a6-062e33814e66}" symbol="53" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 177 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 276" label="177 - 275"/>
            <rule key="{e12490b3-421c-45c2-bc75-3552e09b2ef2}" symbol="54" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 276 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 388" label="276 - 387"/>
            <rule key="{7677d157-53df-4ef4-a2bd-6337420f9de8}" symbol="55" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 388 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 471" label="388 - 470"/>
            <rule key="{79c37033-4fea-40df-9093-2f89f9843be2}" symbol="56" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 471 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 743" label="471 - 742"/>
            <rule key="{6a25aefd-6e04-4ac7-bd5c-895a5f5953c1}" symbol="57" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 743 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) &lt; 1004" label="743 - 1003"/>
            <rule key="{53211014-cedc-4aa4-96cf-600925a311cb}" symbol="58" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha' THEN &quot;pop6_haut_in&quot; END) >= 1004" label="1004 et plus"/>
          </rule>
          <rule scalemaxdenom="70000" key="{88d434df-1172-48de-b75a-de03d3f22968}" symbol="59" filter="&quot;type_result&quot; = 'Hexag_250ha'" scalemindenom="60000" label="Hexag_250ha">
            <rule key="{107f6dde-7eec-4b16-ac66-1c6e7c01b0c8}" symbol="60" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 18" label="Moins de 18"/>
            <rule key="{a939244a-41a0-4baf-9e4b-2250aac34e69}" symbol="61" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 18 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 57" label="18 - 56"/>
            <rule key="{74a1f76d-142a-481c-842b-fe267af6b59b}" symbol="62" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 57 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 106" label="57 - 105"/>
            <rule key="{32a354e3-1935-4871-a6d0-c556df2d6885}" symbol="63" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 106 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 163" label="106 - 162"/>
            <rule key="{31ca028f-65d1-4f39-bf56-248dc16e0716}" symbol="64" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 163 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 238" label="163 - 237"/>
            <rule key="{568b055f-754e-4eb7-b8c2-ea948071fa58}" symbol="65" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 238 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 340" label="238 - 339"/>
            <rule key="{eb799ff6-ac93-4988-986b-b54a03d2d52b}" symbol="66" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 340 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 490" label="340 - 489"/>
            <rule key="{bccc4633-7373-441b-ae5f-74fd593bf134}" symbol="67" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 490 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 736" label="490 - 735"/>
            <rule key="{02dbde3d-e392-4398-aebc-38eb32e69dac}" symbol="68" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 736 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) &lt; 1314" label="736 - 1313"/>
            <rule key="{571d750a-8eb5-469d-9874-9ee3fc6645f0}" symbol="69" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha' THEN &quot;pop6_haut_in&quot; END) >= 1314" label="1314 et plus"/>
          </rule>
          <rule scalemaxdenom="80000" key="{e48c1258-e0b9-4c8b-bc9c-79beae68b4c7}" symbol="70" filter="&quot;type_result&quot; = 'Hexag_500ha'" scalemindenom="70000" label="Hexag_500ha">
            <rule key="{f4acbf21-abf6-4aa0-a619-c79d610dde2a}" symbol="71" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 33" label="Moins de 33"/>
            <rule key="{b02a44bb-cce9-4b61-92e3-3fc140c270af}" symbol="72" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 33 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 102" label="33 - 101"/>
            <rule key="{b978f842-caf1-48b3-ace3-1522aa09b545}" symbol="73" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 102 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 180" label="102 - 179"/>
            <rule key="{6a54cea0-4e88-46ec-8f15-f894223c8fce}" symbol="74" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 180 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 269" label="180 - 268"/>
            <rule key="{de8ce03e-3419-4169-bdd0-ccab627c775d}" symbol="75" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 269 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 428" label="269 - 427"/>
            <rule key="{b92ffb9b-b553-411f-bf42-a6c1654d37b8}" symbol="76" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 428 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 605" label="428 - 604"/>
            <rule key="{184ca0cf-143f-4b57-a748-7b8df2df1a3d}" symbol="77" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 605 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 777" label="605 - 776"/>
            <rule key="{64171d52-abab-487c-b84c-b2e1e916ee51}" symbol="78" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 777 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 1178" label="777 - 1177"/>
            <rule key="{a913effc-bfdb-41e9-91a3-12b61912c839}" symbol="79" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 1178 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) &lt; 1756" label="1178 - 1755"/>
            <rule key="{c9be23a8-b366-41a4-9838-59990f882c68}" symbol="80" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha' THEN &quot;pop6_haut_in&quot; END) >= 1756" label="1756 et plus"/>
          </rule>
          <rule scalemaxdenom="90000" key="{28b6e6be-3aa5-4615-8207-f816b1ff0ae7}" symbol="81" filter="&quot;type_result&quot; = 'IRIS'" scalemindenom="80000" label="IRIS">
            <rule key="{92130bd0-7aa3-45e0-ada6-3efb0f0e1fa0}" symbol="82" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) = 0" label="0"/>
            <rule key="{85bb2041-b855-43e0-8d75-53c147572a06}" symbol="83" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 22" label="Moins de 22"/>
            <rule key="{b1eb8057-6793-4167-a283-1fab7507ff6f}" symbol="84" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 22 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 67" label="22 - 66"/>
            <rule key="{e4cb0e44-b822-4938-aa8b-93695e16d3a9}" symbol="85" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 67 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 128" label="67 - 127"/>
            <rule key="{2675b367-9e67-41b5-a93d-0e1ed65e1e48}" symbol="86" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 128 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 222" label="128 - 221"/>
            <rule key="{3e383cc5-7516-4bd1-80b3-8e2230451ca3}" symbol="87" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 222 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 341" label="222 - 340"/>
            <rule key="{64712cd7-4930-4215-96ea-9c8069225998}" symbol="88" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 341 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 526" label="341 - 525"/>
            <rule key="{f5e504f5-c767-4d82-ba4d-8b362c9f0c12}" symbol="89" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 526 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 690" label="526 - 689"/>
            <rule key="{eaa6847b-2815-4b77-b046-342595d9bf75}" symbol="90" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 690 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 1041" label="690 - 1040"/>
            <rule key="{d7e9b8d3-7198-43e2-abb2-84492f99affb}" symbol="91" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 1041 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 1522" label="1041 - 1521"/>
            <rule key="{11f726ae-e5d3-4f63-b587-047c12831aa8}" symbol="92" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 1522" label="1522 et plus"/>
          </rule>
          <rule scalemaxdenom="100000" key="{c26e4a87-5f48-4e9a-98a4-9ad374057ee3}" symbol="93" filter="&quot;type_result&quot; = 'Commune'" scalemindenom="90000" label="Communes">
            <rule key="{c0007227-228f-4a02-8551-69ca08fcc5de}" symbol="94" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) = 0" label="0"/>
            <rule key="{436e00ac-64d6-49e4-8bf0-65c2d8577611}" symbol="95" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 24" label="Moins de 23"/>
            <rule key="{a05fd05e-563f-47c7-93f8-8b9af72d5c26}" symbol="96" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 24 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 94" label="24 - 93"/>
            <rule key="{93a9c433-6c17-428d-b258-d453448c9a62}" symbol="97" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 94 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 163" label="94 - 162"/>
            <rule key="{78392c12-d611-4959-8059-5693fcd534fd}" symbol="98" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 163 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 222" label="163 - 221"/>
            <rule key="{818ee37a-3aa4-44d3-ac1a-dc244fb5fffc}" symbol="99" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 222 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 385" label="222 - 384"/>
            <rule key="{a56580eb-a002-403a-b237-46d1d177933f}" symbol="100" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 385 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 526" label="385 - 525"/>
            <rule key="{2551ba2c-9dec-4abb-98ba-bcbab05ba8de}" symbol="101" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 526 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 680" label="526 - 679"/>
            <rule key="{b2714ae0-d69b-4940-a928-4c165ebb687a}" symbol="102" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 680 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 1041" label="680 - 1040"/>
            <rule key="{b8a9b467-1c85-4985-9e71-0078cd943fc8}" symbol="103" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 1041 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 1522" label="1041 - 1521"/>
            <rule key="{6370386b-dd54-4b83-8ea1-3b34d63d751a}" symbol="104" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 1522" label="1522 et plus"/>
          </rule>
          <rule scalemaxdenom="1000000" key="{f86277fb-e779-46a8-8c0d-0dfe3305f203}" symbol="105" filter="&quot;type_result&quot; = 'EPCI'" scalemindenom="100000" label="EPCI">
            <rule key="{f86ffa5a-4498-4069-958d-d1dafd99bc7a}" symbol="106" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) = 0" label="0"/>
            <rule key="{7cd99fa3-31a7-4447-be49-0f906ec1839e}" symbol="107" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) &lt; 173" label="Moins de 172"/>
            <rule key="{e02c4835-c8d4-4e63-8c98-614a028d6569}" symbol="108" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) >= 173 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) &lt; 1250" label="173 - 1249"/>
            <rule key="{ad7d8e68-5fb2-46a0-8c7a-f142dc36efcd}" symbol="109" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) >= 1250 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) &lt; 2004" label="1250 - 2003"/>
            <rule key="{d98f0319-1b67-42c4-812b-4a97ceed595f}" symbol="110" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) >= 2004 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) &lt; 5996" label="2004 - 5995"/>
            <rule key="{8b104758-2261-46f4-816c-1f03a036bd6c}" symbol="111" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI' THEN &quot;pop6_haut_in&quot; END) >= 5996" label="5996 et plus"/>
          </rule>
        </rule>
      </rule>
    </rules>
    <symbols>
      <symbol force_rhr="0" name="0" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="239,40,29,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="1" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="224,177,100,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="10" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="100" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="101" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="102" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="103" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="104" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="105" clip_to_extent="1" alpha="0.4" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="218,197,102,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="106" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="204,204,204,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="107" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="108" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,210,165,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="109" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,146,67,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="11" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="110" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="223,80,5,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="111" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="12" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="13" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="14" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="15" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="162,64,232,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="16" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="17" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="18" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="19" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="2" clip_to_extent="1" alpha="0.4" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="218,197,102,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="20" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="21" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="22" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="23" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="24" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="25" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="26" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="13,50,215,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="27" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="28" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="29" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="3" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="54,22,180,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="30" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="31" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="32" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="33" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="34" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="35" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="36" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="37" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="149,218,97,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="38" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="39" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="4" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="170,170,170,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="40" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="41" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="42" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="43" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="44" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="45" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="46" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="47" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="48" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="107,199,206,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="49" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="5" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="162,64,232,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="50" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="51" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="52" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="53" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="54" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="55" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="56" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="57" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="58" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="59" clip_to_extent="1" alpha="1" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="37,233,99,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="6" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="60" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="61" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="62" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="63" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="64" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="65" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="66" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="67" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="68" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="69" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="7" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="70" clip_to_extent="1" alpha="0.4" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="218,197,102,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="71" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="72" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="73" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="74" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="75" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="76" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="77" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="78" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="79" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="8" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="80" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="81" clip_to_extent="1" alpha="0.4" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="218,197,102,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="82" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="204,204,204,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="83" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="84" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="85" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="86" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="87" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="88" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="250,131,49,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="89" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,101,17,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="9" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="90" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="217,73,1,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="91" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="171,56,3,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="92" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="127,39,4,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="93" clip_to_extent="1" alpha="0.4" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="218,197,102,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="94" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="204,204,204,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="95" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,245,235,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="96" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="254,232,210,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="97" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,214,175,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="98" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,189,131,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="99" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,160,87,255"/>
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
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{14af67f8-9847-4b46-8ca8-30d657402b4e}">
      <rule scalemaxdenom="90000" key="{bf6b5372-dc04-468e-9488-8dfaa1119382}" description="Noms IRIS" filter="&quot;type_result&quot; = 'IRIS' AND &quot;pop6_haut_in&quot; > 0" scalemindenom="80000">
        <settings calloutType="simple">
          <text-style fontItalic="0" fieldName="nom_id_geom" fontWordSpacing="0" isExpression="0" fontFamily="MS Shell Dlg 2" fontSize="9" previewBkgrdColor="255,255,255,255" textOrientation="horizontal" fontUnderline="0" fontSizeUnit="Point" fontLetterSpacing="0" blendMode="0" textOpacity="1" fontWeight="50" fontKerning="1" textColor="0,0,0,255" fontStrikeout="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" allowHtml="0" multilineHeight="1" capitalization="0" useSubstitutions="0" namedStyle="Normal">
            <text-buffer bufferNoFill="1" bufferOpacity="1" bufferColor="255,255,255,255" bufferDraw="1" bufferSize="0.59999999999999998" bufferJoinStyle="128" bufferBlendMode="0" bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0"/>
            <text-mask maskType="0" maskSizeUnits="MM" maskSize="1.5" maskEnabled="0" maskOpacity="1" maskJoinStyle="128" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskedSymbolLayers=""/>
            <background shapeType="0" shapeBlendMode="0" shapeDraw="0" shapeFillColor="255,255,255,255" shapeSizeUnit="MM" shapeBorderWidthUnit="MM" shapeSVGFile="" shapeOffsetUnit="MM" shapeRotationType="0" shapeOpacity="1" shapeOffsetX="0" shapeJoinStyle="64" shapeSizeY="0" shapeSizeX="0" shapeSizeType="0" shapeRadiiUnit="MM" shapeRotation="0" shapeBorderColor="128,128,128,255" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeRadiiY="0" shapeOffsetY="0">
              <symbol force_rhr="0" name="markerSymbol" clip_to_extent="1" alpha="1" type="marker">
                <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
                  <prop k="angle" v="0"/>
                  <prop k="color" v="255,158,23,255"/>
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
                      <Option name="name" value="" type="QString"/>
                      <Option name="properties"/>
                      <Option name="type" value="collection" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowScale="100" shadowOffsetUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowOffsetGlobal="1" shadowRadius="1.5" shadowRadiusAlphaOnly="0" shadowOpacity="0.69999999999999996" shadowColor="0,0,0,255" shadowOffsetAngle="135" shadowUnder="0" shadowDraw="0" shadowRadiusUnit="MM"/>
            <dd_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format decimals="3" wrapChar="" reverseDirectionSymbol="0" leftDirectionSymbol="&lt;" placeDirectionSymbol="0" plussign="0" multilineAlign="3" useMaxLineLengthForAutoWrap="1" formatNumbers="0" addDirectionSymbol="0" rightDirectionSymbol=">" autoWrapLength="0"/>
          <placement distMapUnitScale="3x:0,0,0,0,0,0" centroidInside="0" geometryGenerator="" distUnits="MM" xOffset="0" quadOffset="4" dist="0" polygonPlacementFlags="2" centroidWhole="0" fitInPolygonOnly="0" offsetType="0" preserveRotation="1" overrunDistanceUnit="MM" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" layerType="PolygonGeometry" repeatDistanceUnits="MM" lineAnchorType="0" placementFlags="10" lineAnchorPercent="0.5" rotationAngle="0" yOffset="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" priority="5" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" offsetUnits="MM" overrunDistance="0" geometryGeneratorType="PointGeometry" maxCurvedCharAngleOut="-25" placement="0" maxCurvedCharAngleIn="25" repeatDistance="0" geometryGeneratorEnabled="0"/>
          <rendering obstacleFactor="1" fontLimitPixelSize="0" limitNumLabels="0" labelPerPart="0" zIndex="0" minFeatureSize="0" maxNumLabels="2000" obstacle="1" drawLabels="1" displayAll="0" upsidedownLabels="0" mergeLines="0" fontMaxPixelSize="10000" fontMinPixelSize="3" scaleMax="0" obstacleType="1" scaleMin="0" scaleVisibility="0"/>
          <dd_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option name="anchorPoint" value="pole_of_inaccessibility" type="QString"/>
              <Option name="ddProperties" type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
              <Option name="drawToAllParts" value="false" type="bool"/>
              <Option name="enabled" value="0" type="QString"/>
              <Option name="labelAnchorPoint" value="point_on_exterior" type="QString"/>
              <Option name="lineSymbol" value="&lt;symbol force_rhr=&quot;0&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot; type=&quot;line&quot;>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; pass=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option name=&quot;name&quot; value=&quot;&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option name=&quot;type&quot; value=&quot;collection&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" type="QString"/>
              <Option name="minLength" value="0" type="double"/>
              <Option name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="minLengthUnit" value="MM" type="QString"/>
              <Option name="offsetFromAnchor" value="0" type="double"/>
              <Option name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="offsetFromAnchorUnit" value="MM" type="QString"/>
              <Option name="offsetFromLabel" value="0" type="double"/>
              <Option name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="offsetFromLabelUnit" value="MM" type="QString"/>
            </Option>
          </callout>
        </settings>
      </rule>
      <rule scalemaxdenom="100000" key="{89396800-3c9e-4bcc-bd9a-f9bf20fd81b0}" description="Noms communes" filter="&quot;type_result&quot; = 'Commune' AND &quot;pop6_haut_in&quot; > 0" scalemindenom="90000">
        <settings calloutType="simple">
          <text-style fontItalic="0" fieldName="nom_id_geom" fontWordSpacing="0" isExpression="0" fontFamily="MS Shell Dlg 2" fontSize="9" previewBkgrdColor="255,255,255,255" textOrientation="horizontal" fontUnderline="0" fontSizeUnit="Point" fontLetterSpacing="0" blendMode="0" textOpacity="1" fontWeight="50" fontKerning="1" textColor="0,0,0,255" fontStrikeout="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" allowHtml="0" multilineHeight="1" capitalization="0" useSubstitutions="0" namedStyle="Normal">
            <text-buffer bufferNoFill="1" bufferOpacity="1" bufferColor="255,255,255,255" bufferDraw="1" bufferSize="0.59999999999999998" bufferJoinStyle="128" bufferBlendMode="0" bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0"/>
            <text-mask maskType="0" maskSizeUnits="MM" maskSize="1.5" maskEnabled="0" maskOpacity="1" maskJoinStyle="128" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskedSymbolLayers=""/>
            <background shapeType="0" shapeBlendMode="0" shapeDraw="0" shapeFillColor="255,255,255,255" shapeSizeUnit="MM" shapeBorderWidthUnit="MM" shapeSVGFile="" shapeOffsetUnit="MM" shapeRotationType="0" shapeOpacity="1" shapeOffsetX="0" shapeJoinStyle="64" shapeSizeY="0" shapeSizeX="0" shapeSizeType="0" shapeRadiiUnit="MM" shapeRotation="0" shapeBorderColor="128,128,128,255" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeRadiiY="0" shapeOffsetY="0">
              <symbol force_rhr="0" name="markerSymbol" clip_to_extent="1" alpha="1" type="marker">
                <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
                  <prop k="angle" v="0"/>
                  <prop k="color" v="255,158,23,255"/>
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
                      <Option name="name" value="" type="QString"/>
                      <Option name="properties"/>
                      <Option name="type" value="collection" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowScale="100" shadowOffsetUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowOffsetGlobal="1" shadowRadius="1.5" shadowRadiusAlphaOnly="0" shadowOpacity="0.69999999999999996" shadowColor="0,0,0,255" shadowOffsetAngle="135" shadowUnder="0" shadowDraw="0" shadowRadiusUnit="MM"/>
            <dd_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format decimals="3" wrapChar="" reverseDirectionSymbol="0" leftDirectionSymbol="&lt;" placeDirectionSymbol="0" plussign="0" multilineAlign="3" useMaxLineLengthForAutoWrap="1" formatNumbers="0" addDirectionSymbol="0" rightDirectionSymbol=">" autoWrapLength="0"/>
          <placement distMapUnitScale="3x:0,0,0,0,0,0" centroidInside="0" geometryGenerator="" distUnits="MM" xOffset="0" quadOffset="4" dist="0" polygonPlacementFlags="2" centroidWhole="0" fitInPolygonOnly="0" offsetType="0" preserveRotation="1" overrunDistanceUnit="MM" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" layerType="PolygonGeometry" repeatDistanceUnits="MM" lineAnchorType="0" placementFlags="10" lineAnchorPercent="0.5" rotationAngle="0" yOffset="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" priority="5" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" offsetUnits="MM" overrunDistance="0" geometryGeneratorType="PointGeometry" maxCurvedCharAngleOut="-25" placement="0" maxCurvedCharAngleIn="25" repeatDistance="0" geometryGeneratorEnabled="0"/>
          <rendering obstacleFactor="1" fontLimitPixelSize="0" limitNumLabels="0" labelPerPart="0" zIndex="0" minFeatureSize="0" maxNumLabels="2000" obstacle="1" drawLabels="1" displayAll="0" upsidedownLabels="0" mergeLines="0" fontMaxPixelSize="10000" fontMinPixelSize="3" scaleMax="0" obstacleType="1" scaleMin="0" scaleVisibility="0"/>
          <dd_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option name="anchorPoint" value="pole_of_inaccessibility" type="QString"/>
              <Option name="ddProperties" type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
              <Option name="drawToAllParts" value="false" type="bool"/>
              <Option name="enabled" value="0" type="QString"/>
              <Option name="labelAnchorPoint" value="point_on_exterior" type="QString"/>
              <Option name="lineSymbol" value="&lt;symbol force_rhr=&quot;0&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot; type=&quot;line&quot;>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; pass=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option name=&quot;name&quot; value=&quot;&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option name=&quot;type&quot; value=&quot;collection&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" type="QString"/>
              <Option name="minLength" value="0" type="double"/>
              <Option name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="minLengthUnit" value="MM" type="QString"/>
              <Option name="offsetFromAnchor" value="0" type="double"/>
              <Option name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="offsetFromAnchorUnit" value="MM" type="QString"/>
              <Option name="offsetFromLabel" value="0" type="double"/>
              <Option name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="offsetFromLabelUnit" value="MM" type="QString"/>
            </Option>
          </callout>
        </settings>
      </rule>
      <rule scalemaxdenom="1000000" key="{b1af9d85-d02a-462c-acb2-88df30838a5d}" description="Noms EPCI" filter="&quot;type_result&quot; = 'EPCI' AND &quot;pop6_haut_in&quot; > 0" scalemindenom="100000">
        <settings calloutType="simple">
          <text-style fontItalic="0" fieldName="nom_id_geom" fontWordSpacing="0" isExpression="0" fontFamily="MS Shell Dlg 2" fontSize="9" previewBkgrdColor="255,255,255,255" textOrientation="horizontal" fontUnderline="0" fontSizeUnit="Point" fontLetterSpacing="0" blendMode="0" textOpacity="1" fontWeight="50" fontKerning="1" textColor="0,0,0,255" fontStrikeout="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" allowHtml="0" multilineHeight="1" capitalization="0" useSubstitutions="0" namedStyle="Normal">
            <text-buffer bufferNoFill="1" bufferOpacity="1" bufferColor="255,255,255,255" bufferDraw="1" bufferSize="0.59999999999999998" bufferJoinStyle="128" bufferBlendMode="0" bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0"/>
            <text-mask maskType="0" maskSizeUnits="MM" maskSize="1.5" maskEnabled="0" maskOpacity="1" maskJoinStyle="128" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskedSymbolLayers=""/>
            <background shapeType="0" shapeBlendMode="0" shapeDraw="0" shapeFillColor="255,255,255,255" shapeSizeUnit="MM" shapeBorderWidthUnit="MM" shapeSVGFile="" shapeOffsetUnit="MM" shapeRotationType="0" shapeOpacity="1" shapeOffsetX="0" shapeJoinStyle="64" shapeSizeY="0" shapeSizeX="0" shapeSizeType="0" shapeRadiiUnit="MM" shapeRotation="0" shapeBorderColor="128,128,128,255" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeRadiiY="0" shapeOffsetY="0">
              <symbol force_rhr="0" name="markerSymbol" clip_to_extent="1" alpha="1" type="marker">
                <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
                  <prop k="angle" v="0"/>
                  <prop k="color" v="255,158,23,255"/>
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
                      <Option name="name" value="" type="QString"/>
                      <Option name="properties"/>
                      <Option name="type" value="collection" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowScale="100" shadowOffsetUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowOffsetGlobal="1" shadowRadius="1.5" shadowRadiusAlphaOnly="0" shadowOpacity="0.69999999999999996" shadowColor="0,0,0,255" shadowOffsetAngle="135" shadowUnder="0" shadowDraw="0" shadowRadiusUnit="MM"/>
            <dd_properties>
              <Option type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format decimals="3" wrapChar="" reverseDirectionSymbol="0" leftDirectionSymbol="&lt;" placeDirectionSymbol="0" plussign="0" multilineAlign="3" useMaxLineLengthForAutoWrap="1" formatNumbers="0" addDirectionSymbol="0" rightDirectionSymbol=">" autoWrapLength="0"/>
          <placement distMapUnitScale="3x:0,0,0,0,0,0" centroidInside="0" geometryGenerator="" distUnits="MM" xOffset="0" quadOffset="4" dist="0" polygonPlacementFlags="2" centroidWhole="0" fitInPolygonOnly="0" offsetType="0" preserveRotation="1" overrunDistanceUnit="MM" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" layerType="PolygonGeometry" repeatDistanceUnits="MM" lineAnchorType="0" placementFlags="10" lineAnchorPercent="0.5" rotationAngle="0" yOffset="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" priority="5" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" offsetUnits="MM" overrunDistance="0" geometryGeneratorType="PointGeometry" maxCurvedCharAngleOut="-25" placement="0" maxCurvedCharAngleIn="25" repeatDistance="0" geometryGeneratorEnabled="0"/>
          <rendering obstacleFactor="1" fontLimitPixelSize="0" limitNumLabels="0" labelPerPart="0" zIndex="0" minFeatureSize="0" maxNumLabels="2000" obstacle="1" drawLabels="1" displayAll="0" upsidedownLabels="0" mergeLines="0" fontMaxPixelSize="10000" fontMinPixelSize="3" scaleMax="0" obstacleType="1" scaleMin="0" scaleVisibility="0"/>
          <dd_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option name="anchorPoint" value="pole_of_inaccessibility" type="QString"/>
              <Option name="ddProperties" type="Map">
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
              <Option name="drawToAllParts" value="false" type="bool"/>
              <Option name="enabled" value="0" type="QString"/>
              <Option name="labelAnchorPoint" value="point_on_exterior" type="QString"/>
              <Option name="lineSymbol" value="&lt;symbol force_rhr=&quot;0&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot; type=&quot;line&quot;>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; pass=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option name=&quot;name&quot; value=&quot;&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option name=&quot;type&quot; value=&quot;collection&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" type="QString"/>
              <Option name="minLength" value="0" type="double"/>
              <Option name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="minLengthUnit" value="MM" type="QString"/>
              <Option name="offsetFromAnchor" value="0" type="double"/>
              <Option name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="offsetFromAnchorUnit" value="MM" type="QString"/>
              <Option name="offsetFromLabel" value="0" type="double"/>
              <Option name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0" type="QString"/>
              <Option name="offsetFromLabelUnit" value="MM" type="QString"/>
            </Option>
          </callout>
        </settings>
      </rule>
    </rules>
  </labeling>
  <customproperties>
    <property key="dualview/previewExpressions" value="&quot;id&quot;"/>
    <property key="embeddedWidgets/count" value="0"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory penWidth="0" opacity="1" spacing="5" spacingUnitScale="3x:0,0,0,0,0,0" rotationOffset="270" height="15" lineSizeType="MM" spacingUnit="MM" sizeType="MM" minimumSize="0" direction="0" sizeScale="3x:0,0,0,0,0,0" scaleBasedVisibility="0" backgroundColor="#ffffff" enabled="0" width="15" penAlpha="255" diagramOrientation="Up" penColor="#000000" maxScaleDenominator="1e+08" barWidth="5" lineSizeScale="3x:0,0,0,0,0,0" labelPlacementMethod="XHeight" scaleDependency="Area" showAxis="1" backgroundAlpha="255" minScaleDenominator="0">
      <fontProperties description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
      <axisSymbol>
        <symbol force_rhr="0" name="" clip_to_extent="1" alpha="1" type="line">
          <layer locked="0" enabled="1" class="SimpleLine" pass="0">
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
                <Option name="name" value="" type="QString"/>
                <Option name="properties"/>
                <Option name="type" value="collection" type="QString"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings placement="1" zIndex="0" priority="0" obstacle="0" showAll="1" linePlacementFlags="18" dist="0">
    <properties>
      <Option type="Map">
        <Option name="name" value="" type="QString"/>
        <Option name="properties"/>
        <Option name="type" value="collection" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration type="Map">
      <Option name="QgsGeometryGapCheck" type="Map">
        <Option name="allowedGapsBuffer" value="0" type="double"/>
        <Option name="allowedGapsEnabled" value="false" type="bool"/>
        <Option name="allowedGapsLayer" value="" type="QString"/>
      </Option>
    </checkConfiguration>
  </geometryOptions>
  <legend type="default-vector"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field name="id" configurationFlags="None">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="territoire" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="type_alea" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="code_occurrence" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="type_result" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="id_geom" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="nom_id_geom" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="loc_zx" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pop6_haut_in" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pop6_bas_in" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pop6_haut_out" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pop6_bas_out" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pct_haut_in" configurationFlags="None">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pct_bas_in" configurationFlags="None">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pct_haut_out" configurationFlags="None">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="pct_bas_out" configurationFlags="None">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="total_haut" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="total_bas" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="date_calcul" configurationFlags="None">
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
    <alias index="2" name="" field="type_alea"/>
    <alias index="3" name="" field="code_occurrence"/>
    <alias index="4" name="" field="type_result"/>
    <alias index="5" name="" field="id_geom"/>
    <alias index="6" name="" field="nom_id_geom"/>
    <alias index="7" name="" field="loc_zx"/>
    <alias index="8" name="" field="pop6_haut_in"/>
    <alias index="9" name="" field="pop6_bas_in"/>
    <alias index="10" name="" field="pop6_haut_out"/>
    <alias index="11" name="" field="pop6_bas_out"/>
    <alias index="12" name="" field="pct_haut_in"/>
    <alias index="13" name="" field="pct_bas_in"/>
    <alias index="14" name="" field="pct_haut_out"/>
    <alias index="15" name="" field="pct_bas_out"/>
    <alias index="16" name="" field="total_haut"/>
    <alias index="17" name="" field="total_bas"/>
    <alias index="18" name="" field="date_calcul"/>
  </aliases>
  <defaults>
    <default expression="" applyOnUpdate="0" field="id"/>
    <default expression="" applyOnUpdate="0" field="territoire"/>
    <default expression="" applyOnUpdate="0" field="type_alea"/>
    <default expression="" applyOnUpdate="0" field="code_occurrence"/>
    <default expression="" applyOnUpdate="0" field="type_result"/>
    <default expression="" applyOnUpdate="0" field="id_geom"/>
    <default expression="" applyOnUpdate="0" field="nom_id_geom"/>
    <default expression="" applyOnUpdate="0" field="loc_zx"/>
    <default expression="" applyOnUpdate="0" field="pop6_haut_in"/>
    <default expression="" applyOnUpdate="0" field="pop6_bas_in"/>
    <default expression="" applyOnUpdate="0" field="pop6_haut_out"/>
    <default expression="" applyOnUpdate="0" field="pop6_bas_out"/>
    <default expression="" applyOnUpdate="0" field="pct_haut_in"/>
    <default expression="" applyOnUpdate="0" field="pct_bas_in"/>
    <default expression="" applyOnUpdate="0" field="pct_haut_out"/>
    <default expression="" applyOnUpdate="0" field="pct_bas_out"/>
    <default expression="" applyOnUpdate="0" field="total_haut"/>
    <default expression="" applyOnUpdate="0" field="total_bas"/>
    <default expression="" applyOnUpdate="0" field="date_calcul"/>
  </defaults>
  <constraints>
    <constraint exp_strength="0" notnull_strength="1" constraints="3" unique_strength="1" field="id"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="territoire"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="type_alea"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="code_occurrence"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="type_result"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="id_geom"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="nom_id_geom"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="loc_zx"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="pop6_haut_in"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="pop6_bas_in"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="pop6_haut_out"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="pop6_bas_out"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="pct_haut_in"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="pct_bas_in"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="pct_haut_out"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="pct_bas_out"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="total_haut"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="total_bas"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" unique_strength="0" field="date_calcul"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="territoire"/>
    <constraint desc="" exp="" field="type_alea"/>
    <constraint desc="" exp="" field="code_occurrence"/>
    <constraint desc="" exp="" field="type_result"/>
    <constraint desc="" exp="" field="id_geom"/>
    <constraint desc="" exp="" field="nom_id_geom"/>
    <constraint desc="" exp="" field="loc_zx"/>
    <constraint desc="" exp="" field="pop6_haut_in"/>
    <constraint desc="" exp="" field="pop6_bas_in"/>
    <constraint desc="" exp="" field="pop6_haut_out"/>
    <constraint desc="" exp="" field="pop6_bas_out"/>
    <constraint desc="" exp="" field="pct_haut_in"/>
    <constraint desc="" exp="" field="pct_bas_in"/>
    <constraint desc="" exp="" field="pct_haut_out"/>
    <constraint desc="" exp="" field="pct_bas_out"/>
    <constraint desc="" exp="" field="total_haut"/>
    <constraint desc="" exp="" field="total_bas"/>
    <constraint desc="" exp="" field="date_calcul"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="&quot;type_result&quot;">
    <columns>
      <column width="-1" hidden="0" name="id" type="field"/>
      <column width="-1" hidden="0" name="territoire" type="field"/>
      <column width="417" hidden="0" name="type_alea" type="field"/>
      <column width="262" hidden="0" name="code_occurrence" type="field"/>
      <column width="-1" hidden="0" name="type_result" type="field"/>
      <column width="-1" hidden="0" name="id_geom" type="field"/>
      <column width="-1" hidden="1" type="actions"/>
      <column width="-1" hidden="0" name="pop6_haut_in" type="field"/>
      <column width="-1" hidden="0" name="pop6_bas_in" type="field"/>
      <column width="-1" hidden="0" name="pop6_haut_out" type="field"/>
      <column width="-1" hidden="0" name="pop6_bas_out" type="field"/>
      <column width="-1" hidden="0" name="pct_haut_in" type="field"/>
      <column width="-1" hidden="0" name="pct_bas_in" type="field"/>
      <column width="-1" hidden="0" name="pct_haut_out" type="field"/>
      <column width="-1" hidden="0" name="pct_bas_out" type="field"/>
      <column width="-1" hidden="0" name="total_haut" type="field"/>
      <column width="-1" hidden="0" name="total_bas" type="field"/>
      <column width="-1" hidden="0" name="nom_id_geom" type="field"/>
      <column width="-1" hidden="0" name="date_calcul" type="field"/>
      <column width="-1" hidden="0" name="loc_zx" type="field"/>
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
    <field name="id" editable="1"/>
    <field name="id_geom" editable="1"/>
    <field name="loc_zx" editable="1"/>
    <field name="nom_id_geom" editable="1"/>
    <field name="pct_bas_in" editable="1"/>
    <field name="pct_bas_out" editable="1"/>
    <field name="pct_haut_in" editable="1"/>
    <field name="pct_haut_out" editable="1"/>
    <field name="pop6_bas_in" editable="1"/>
    <field name="pop6_bas_out" editable="1"/>
    <field name="pop6_haut_in" editable="1"/>
    <field name="pop6_haut_out" editable="1"/>
    <field name="pop_s3_1a" editable="1"/>
    <field name="territoire" editable="1"/>
    <field name="total_bas" editable="1"/>
    <field name="total_haut" editable="1"/>
    <field name="type_alea" editable="1"/>
    <field name="type_result" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="code_occurrence" labelOnTop="0"/>
    <field name="date_calcul" labelOnTop="0"/>
    <field name="id" labelOnTop="0"/>
    <field name="id_geom" labelOnTop="0"/>
    <field name="loc_zx" labelOnTop="0"/>
    <field name="nom_id_geom" labelOnTop="0"/>
    <field name="pct_bas_in" labelOnTop="0"/>
    <field name="pct_bas_out" labelOnTop="0"/>
    <field name="pct_haut_in" labelOnTop="0"/>
    <field name="pct_haut_out" labelOnTop="0"/>
    <field name="pop6_bas_in" labelOnTop="0"/>
    <field name="pop6_bas_out" labelOnTop="0"/>
    <field name="pop6_haut_in" labelOnTop="0"/>
    <field name="pop6_haut_out" labelOnTop="0"/>
    <field name="pop_s3_1a" labelOnTop="0"/>
    <field name="territoire" labelOnTop="0"/>
    <field name="total_bas" labelOnTop="0"/>
    <field name="total_haut" labelOnTop="0"/>
    <field name="type_alea" labelOnTop="0"/>
    <field name="type_result" labelOnTop="0"/>
  </labelOnTop>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
