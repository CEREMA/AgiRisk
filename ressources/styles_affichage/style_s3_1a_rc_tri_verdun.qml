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
      <rule key="{b0b1264f-d9ac-41ed-ad76-35e114db699b}" symbol="0" filter="&quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe'" label="Aléa débordement de cours d'eau">
        <rule key="{77dbe6be-35b3-414b-b0a6-b500f22b7fce}" symbol="1" filter="&quot;code_occurrence&quot; = 'QRef diag'" label="QRef diag">
          <rule scalemaxdenom="10000" key="{e2698c71-50f6-4e23-96b1-c8d6d193c847}" symbol="2" filter="&quot;type_result&quot; = 'Entite'" scalemindenom="1" label="Bâtiments">
            <rule key="{00c2ec02-be52-48f3-abff-e18a0cf6f337}" symbol="3" filter="&quot;loc_zx&quot; = 'In'" label="En zone inondable"/>
            <rule key="{feea384a-4bc5-44c2-871d-c38b70972179}" symbol="4" filter="&quot;loc_zx&quot; = 'Out'" label="Hors zone inondable"/>
          </rule>
          <rule scalemaxdenom="20000" key="{6b8ca00b-a121-446a-8b84-5981e3ab5640}" symbol="5" filter="&quot;type_result&quot; = 'Hexag_1ha'" scalemindenom="5000" label="Hexag_1ha">
            <rule key="{6024230b-424d-490a-8adb-3fdb15ef4440}" symbol="6" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 4" label="Moins de 4"/>
            <rule key="{60f2d643-d4a8-4c18-a133-eb19a5961399}" symbol="7" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 4 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 14" label="4 - 13"/>
            <rule key="{733dd7ac-367a-499a-b2d1-4aaea520d13b}" symbol="8" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 14 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 26" label="14 - 25"/>
            <rule key="{ead9a129-56a7-4cc2-8b5d-8d2e50b444ee}" symbol="9" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 26 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 44" label="26 - 43"/>
            <rule key="{6ae68ae1-cfb0-4a37-8458-ec137420053e}" symbol="10" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 44 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 69" label="44 - 68"/>
            <rule key="{a86ad823-5633-43a5-a39b-766b30ed1d03}" symbol="11" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 69 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 115" label="69 - 114"/>
            <rule key="{c8ab2c67-493e-4c5a-82d5-3db142d40350}" symbol="12" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 115 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 154" label="115 - 153"/>
            <rule key="{7ec90be9-c94d-4516-8fc9-824df23e5c41}" symbol="13" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 154 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 259" label="154 - 258"/>
            <rule key="{dca86dd2-9d92-464c-b1c4-7513e79df857}" symbol="14" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 259 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) &lt; 415" label="259 - 414"/>
            <rule key="{9d8d5ecc-bac1-4502-bb6f-307a28d656e2}" symbol="15" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_1ha' THEN &quot;pop6_haut_in&quot; END) >= 415" label="415 et plus"/>
          </rule>
          <rule scalemaxdenom="30000" key="{bb780b3d-6804-4644-bdcf-768ed48a506a}" symbol="16" filter="&quot;type_result&quot; = 'Hexag_5ha'" scalemindenom="20000" label="Hexag_5ha">
            <rule key="{1d6a9310-4a32-468f-b8fb-d2cb843cfc2f}" symbol="17" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 3" label="Moins de 3"/>
            <rule key="{c0937a26-d3bf-4850-a74d-8f74ac4f5193}" symbol="18" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 3 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 18" label="3 - 17"/>
            <rule key="{bc7084cd-ed5b-4b9f-94f7-60dfd24699ec}" symbol="19" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 18 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 40" label="18 - 39"/>
            <rule key="{0e17d500-afc0-48b6-82bb-22631f60bd80}" symbol="20" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 40 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 80" label="40 - 79"/>
            <rule key="{9131853f-b11b-472e-b32a-524a2d86e6b5}" symbol="21" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 80 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 118" label="80 - 117"/>
            <rule key="{1a2bcf75-e0bf-433d-809c-413c45e4e0dc}" symbol="22" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 118 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 161" label="118 - 160"/>
            <rule key="{ad2320d4-f8a2-40ff-92d3-bddc1dd6065e}" symbol="23" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 161 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 204" label="161 - 203"/>
            <rule key="{8a463fce-b2cb-4993-a8b6-cdc1a9e561da}" symbol="24" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 204 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 276" label="204 - 275"/>
            <rule key="{64a1522f-e86e-453a-9ca4-456e5810e4ea}" symbol="25" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 276 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) &lt; 719" label="276 - 718"/>
            <rule key="{43ab7cd4-a6f7-48b0-94e5-e6f3e7e39baf}" symbol="26" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_5ha' THEN &quot;pop6_haut_in&quot; END) >= 719" label="719 et plus"/>
          </rule>
          <rule scalemaxdenom="40000" key="{5c6eebf5-aa97-48d9-adbd-53b58054b6fb}" symbol="27" filter="&quot;type_result&quot; = 'Hexag_10ha'" scalemindenom="30000" label="Hexag_10ha">
            <rule key="{507e4384-74d5-4b4a-9d12-bfc0928a0ac6}" symbol="28" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 5" label="Moins de 5"/>
            <rule key="{2f032cc7-f8bf-4c34-a22f-d11f23bbe6fe}" symbol="29" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 5 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 17" label="5 - 16"/>
            <rule key="{1e218043-028c-47b7-bbbb-94916ad26d06}" symbol="30" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 17 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 51" label="17 - 50"/>
            <rule key="{3bd0a4ba-6633-4d36-a564-a15bcbad2003}" symbol="31" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 51 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 88" label="51 - 87"/>
            <rule key="{dac0c1c8-11f7-4e0e-9d9e-800f63b039fc}" symbol="32" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 88 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 140" label="88 - 139"/>
            <rule key="{aed504b2-b957-4b96-8796-af95986d4576}" symbol="33" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 140 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 231" label="140 - 230"/>
            <rule key="{10103621-6c98-42fc-86c6-fa951692f242}" symbol="34" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 231 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 322" label="231 - 321"/>
            <rule key="{e6a5c7f7-6eab-4f64-96b6-f6e2b838fb42}" symbol="35" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 322 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 401" label="322 - 400"/>
            <rule key="{00b17a0c-eddb-4c17-ad93-8be480b02d09}" symbol="36" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 401 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) &lt; 710" label="401 - 709"/>
            <rule key="{d9c4d4e4-a3b6-4bcc-8ce0-dd4d8187adf3}" symbol="37" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_10ha' THEN &quot;pop6_haut_in&quot; END) >= 710" label="710 et plus"/>
          </rule>
          <rule scalemaxdenom="50000" key="{a22b7821-a382-4946-b20f-1c95df231176}" symbol="38" filter="&quot;type_result&quot; = 'Hexag_50ha'" scalemindenom="40000" label="Hexag_50ha">
            <rule key="{683cae79-762c-4690-8740-889fc07c71d9}" symbol="39" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 2" label="Moins de 2"/>
            <rule key="{88147052-4b2a-4581-b1c1-2792b2d6a9ed}" symbol="40" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 2 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 10" label="2 - 9"/>
            <rule key="{33c13982-349d-4738-b488-9eaf2cfd1168}" symbol="41" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 10 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 16" label="10 - 15"/>
            <rule key="{0a1d3fcd-4131-4a84-919e-2b17ee978335}" symbol="42" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 16 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 82" label="16 - 81"/>
            <rule key="{fa107adf-3f91-41ff-bad0-c437d1f72dba}" symbol="43" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 82 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 133" label="82 - 132"/>
            <rule key="{778a9e9f-8181-4dad-bd44-0bd26a3ec3b9}" symbol="44" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 133 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 161" label="133 - 160"/>
            <rule key="{9d7ac81a-43fa-4b9e-a7c7-0859939bf026}" symbol="45" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 161 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 476" label="161 - 475"/>
            <rule key="{8db6b1c8-8093-42f3-8ee7-c3e1a365ea3e}" symbol="46" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 476 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 945" label="476 - 944"/>
            <rule key="{c5b50c30-6d7c-4b57-b757-078df9ee63d6}" symbol="47" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 945 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) &lt; 1842" label="945 - 1841"/>
            <rule key="{2bdef2b7-f913-4664-ad62-632c2b5d5b09}" symbol="48" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Hexag_50ha' THEN &quot;pop6_haut_in&quot; END) >= 1842" label="1842 et plus"/>
          </rule>
          <rule scalemaxdenom="65000" key="{28b6e6be-3aa5-4615-8207-f816b1ff0ae7}" symbol="49" filter="&quot;type_result&quot; = 'IRIS'" scalemindenom="50000" label="IRIS">
            <rule key="{3eb5048f-854b-4050-9272-3b5d1b45cba9}" symbol="50" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) = 0" label="0"/>
            <rule key="{112da34a-f954-4b34-b503-bf2d7963e3cb}" symbol="51" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 500" label="Moins de 500"/>
            <rule key="{a8e215c4-bafd-4738-9654-ff3c27e7010a}" symbol="52" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 500 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 1000" label="500 - 999"/>
            <rule key="{8663342a-9c43-4f46-b0d5-74df73a306a6}" symbol="53" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 1000 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 1500" label="1000 - 1499"/>
            <rule key="{a76771d6-4020-48a3-81d7-d1ab9edc003c}" symbol="54" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 1500 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 2000" label="1500 - 1999"/>
            <rule key="{42e7647a-3aeb-4e55-b601-b8f2a7551263}" symbol="55" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 2000 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) &lt; 2500" label="2000 - 2499"/>
            <rule key="{ad83a9d7-dfe8-4886-a5e8-e212505fab0c}" symbol="56" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='IRIS' THEN &quot;pop6_haut_in&quot; END) >= 2500" label="2500 et plus"/>
          </rule>
          <rule scalemaxdenom="1000000" key="{c26e4a87-5f48-4e9a-98a4-9ad374057ee3}" symbol="57" filter="&quot;type_result&quot; = 'Commune'" scalemindenom="65000" label="Communes">
            <rule key="{ca3020fd-578d-4973-b9c3-6b902b310c23}" symbol="58" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) = 0" label="0"/>
            <rule key="{99db233f-dfd5-4c1c-8a79-fcb6e28c9608}" symbol="59" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) > 0 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 2330" label="Moins de 2330"/>
            <rule key="{14bc2667-fc29-4e42-a1f6-d1fbe2449184}" symbol="60" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 2330 AND (CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) &lt; 4430" label="2330 - 4429"/>
            <rule key="{613b39a3-bb6c-488e-9a37-ce97d1aeac9b}" symbol="61" filter="(CASE WHEN &quot;type_alea&quot; = 'débordement de cours d''eau + remontée de nappe' AND &quot;code_occurrence&quot; = 'QRef diag' AND &quot;type_result&quot;='Commune' THEN &quot;pop6_haut_in&quot; END) >= 4430" label="4430 et plus"/>
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
      <symbol force_rhr="0" name="11" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="12" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="13" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="14" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="15" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="16" clip_to_extent="1" alpha="1" type="fill">
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
      <symbol force_rhr="0" name="17" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="18" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="19" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="21" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="22" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="23" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="24" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="25" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="26" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="27" clip_to_extent="1" alpha="1" type="fill">
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
      <symbol force_rhr="0" name="28" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="29" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="31" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="32" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="33" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="34" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="35" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="36" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="37" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="38" clip_to_extent="1" alpha="1" type="fill">
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
      <symbol force_rhr="0" name="39" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="41" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="42" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="43" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="44" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="45" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="46" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="47" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="48" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="49" clip_to_extent="1" alpha="0.4" type="fill">
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
          <prop k="color" v="221,221,221,255"/>
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
      <symbol force_rhr="0" name="52" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="253,218,182,255"/>
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
          <prop k="color" v="253,171,103,255"/>
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
          <prop k="color" v="246,119,35,255"/>
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
          <prop k="color" v="209,69,1,255"/>
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
      <symbol force_rhr="0" name="57" clip_to_extent="1" alpha="0.4" type="fill">
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
      <symbol force_rhr="0" name="58" clip_to_extent="1" alpha="0.7" type="fill">
        <layer locked="0" enabled="1" class="SimpleFill" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="221,221,221,255"/>
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
      <symbol force_rhr="0" name="59" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="6" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="60" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="61" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="8" clip_to_extent="1" alpha="0.7" type="fill">
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
      <symbol force_rhr="0" name="9" clip_to_extent="1" alpha="0.7" type="fill">
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
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{7c1f3349-eafc-4426-ab14-76a7a1d948d1}">
      <rule scalemaxdenom="65000" key="{3668ff53-a556-4aaf-9a48-64204cb5ab6e}" description="Noms IRIS" filter="&quot;type_result&quot; = 'IRIS' AND &quot;pop6_haut_in&quot; > 0" scalemindenom="50000">
        <settings calloutType="simple">
          <text-style fontItalic="0" fieldName="nom_id_geom" fontWordSpacing="0" isExpression="0" fontFamily="MS Shell Dlg 2" fontSize="9" previewBkgrdColor="255,255,255,255" textOrientation="horizontal" fontUnderline="0" fontSizeUnit="Point" fontLetterSpacing="0" blendMode="0" textOpacity="1" fontWeight="50" fontKerning="1" textColor="0,0,0,255" fontStrikeout="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" allowHtml="0" multilineHeight="1.5000000000000004" capitalization="0" useSubstitutions="0" namedStyle="Normal">
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
      <rule scalemaxdenom="1000000" key="{5db8c589-9aeb-4266-a500-fad81fe61324}" description="Noms communes" filter="&quot;type_result&quot; = 'Commune' AND &quot;pop6_haut_in&quot; > 0" scalemindenom="65000">
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
