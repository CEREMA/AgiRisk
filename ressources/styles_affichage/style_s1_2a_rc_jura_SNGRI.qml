<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis minScale="100000000" hasScaleBasedVisibilityFlag="0" simplifyMaxScale="1" readOnly="0" labelsEnabled="1" maxScale="0" simplifyDrawingHints="1" simplifyAlgorithm="0" simplifyLocal="1" simplifyDrawingTol="1" version="3.16.14-Hannover" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <temporal durationField="" endField="" enabled="0" mode="0" endExpression="" accumulate="0" startExpression="" durationUnit="min" startField="" fixedDuration="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 forceraster="0" enableorderby="0" symbollevels="0" type="RuleRenderer">
    <rules key="{c9f9ea8c-e957-41b3-a7a9-f6c1dc507b5d}">
      <rule symbol="0" filter="&quot;type_alea&quot; = 'débordement de cours d''eau'" label="Aléa débordement de cours d'eau" key="{24ddcdab-7a82-4429-b26a-803d58bfe582}">
        <rule symbol="1" filter="&quot;code_occurrence&quot; = 'QRef'" label="QRef" key="{639e8953-f863-4472-b96d-83064d8afb7f}">
          <rule symbol="2" filter="&quot;type_result&quot; = 'Entite'" label="Bâtiments" scalemindenom="1" key="{04d4964d-20e5-48d6-be3c-82bb7bc30dc3}" scalemaxdenom="15000">
            <rule symbol="3" filter="&quot;pop6_pp_in_fort_tresfort&quot; > 0" label="En zone inondable" key="{01a4f879-fc61-4314-9061-9c5d5dee4fd6}"/>
            <rule symbol="4" filter="&quot;pop6_pp_in_fort_tresfort&quot; = 0 and  &quot;pop6_pp_in_fai_moyen&quot; = 0" label="Hors zone inondable" key="{84ac47f4-2e8a-443f-bfde-0fefd618f22b}"/>
          </rule>
          <rule symbol="5" filter=" &quot;type_result&quot; =  'Hexag_1ha' " label="Hexag_1ha" scalemindenom="1" key="{fed8f653-5b44-4337-8113-8fc490a46541}" scalemaxdenom="10000">
            <rule symbol="6" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" label="Moins de 15" key="{523994f4-7c70-4580-9af9-263927583095}"/>
            <rule symbol="7" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{73911f35-0619-4c69-aa5f-54938d4457df}"/>
            <rule symbol="8" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{de4ef318-9368-478b-ba97-042d239d38c4}"/>
            <rule symbol="9" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{58104274-2088-4c06-b766-5a7d6a77ac42}"/>
            <rule symbol="10" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="200 et plus" key="{5d1637b5-7a91-4e44-b26c-cb1c3e62366c}"/>
          </rule>
          <rule symbol="11" filter="&quot;type_result&quot; = 'Hexag_5ha'" label="Hexag_5ha" scalemindenom="10000" key="{33e447a2-1e7d-4da2-a5f9-7e651972380e}" scalemaxdenom="25000">
            <rule symbol="12" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" label="Moins de 15" key="{fe65927f-5d7b-4da2-9a8b-cbda47486591}"/>
            <rule symbol="13" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{9582bf03-b437-4e5c-99fa-8170145223d7}"/>
            <rule symbol="14" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{bacc57d8-1e95-49d9-8969-ab6a2f743012}"/>
            <rule symbol="15" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{45a80355-4e8d-4a78-b71a-5fd1bc921511}"/>
            <rule symbol="16" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="200 et plus" key="{894fb803-e93d-4a88-b195-df7685a1c0b3}"/>
          </rule>
          <rule symbol="17" filter="&quot;type_result&quot; = 'Hexag_10ha'" label="Hexag_10ha" scalemindenom="25000" key="{26aa0f86-064a-4f25-86b4-b3d1e064bb74}" scalemaxdenom="35000">
            <rule symbol="18" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" label="Moins de 15" key="{c7836fde-545e-482d-b8b4-d10f9ffad907}"/>
            <rule symbol="19" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{84e3fdd0-8382-4be1-b968-16ee6b5bade7}"/>
            <rule symbol="20" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{5cd2f736-f20d-4fca-b56b-db520f334fc4}"/>
            <rule symbol="21" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{09b13518-2335-4528-9bad-1dd37037a788}"/>
            <rule symbol="22" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="200 et plus" key="{fd9a588a-8292-4a02-9edf-a2aee730ff6f}"/>
          </rule>
          <rule symbol="23" filter="&quot;type_result&quot; = 'Hexag_50ha'" label="Hexag_50ha" scalemindenom="35000" key="{35f9ad22-4d59-4278-81bf-58463a98ecf8}" scalemaxdenom="50000">
            <rule symbol="24" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" label="Moins de 15" key="{04fed555-8cde-4628-b673-aa4cab25fd33}"/>
            <rule symbol="25" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{d7f32fde-3701-4626-bb6b-effc41194d97}"/>
            <rule symbol="26" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{fd20225e-ef09-4e24-98bf-c974d5a4541e}"/>
            <rule symbol="27" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{18359d0a-b21f-4627-829d-385e5d6d28c7}"/>
            <rule symbol="28" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="200 et plus" key="{1d8758a7-ad34-48e6-be24-ae79ab05152c}"/>
          </rule>
          <rule symbol="29" filter="&quot;type_result&quot; = 'Hexag_100ha'" label="Hexag_100ha" scalemindenom="50000" key="{ef170507-66b0-40f7-9477-e0ccc7495880}" scalemaxdenom="75000">
            <rule symbol="30" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" label="Moins de 15" key="{b3873e52-ba89-4762-99ae-14e96c74ec13}"/>
            <rule symbol="31" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{6684403b-a371-4c0a-a22a-91274ff41c30}"/>
            <rule symbol="32" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{3ee45e1c-354e-4cf2-9aa6-94ed14f52f3c}"/>
            <rule symbol="33" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{e8236ec6-1103-48a7-bcc1-558695c4852d}"/>
            <rule symbol="34" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="200 et plus" key="{09b89950-62f2-4a4d-b8d8-87f25142ed1c}"/>
          </rule>
          <rule symbol="35" filter="&quot;type_result&quot; = 'Hexag_250ha'" label="Hexag_250ha" scalemindenom="75000" key="{0594a0d9-ea85-47b7-ae65-1cc7af147443}" scalemaxdenom="100000">
            <rule symbol="36" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" label="Moins de 15" key="{28dbadf1-a58a-4f8a-b764-508b674d01b6}"/>
            <rule symbol="37" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{7a2cb615-f205-46df-9064-f47f551b00f3}"/>
            <rule symbol="38" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{93502577-c9ca-4c7f-84a6-2d7bd5600d49}"/>
            <rule symbol="39" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{5e33ba0e-3aaf-45d6-a2c7-dcba7b750059}"/>
            <rule symbol="40" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="200 et plus" key="{96d48f5e-172c-4547-be97-8fe9f6bcead1}"/>
          </rule>
          <rule symbol="41" filter="&quot;type_result&quot; = 'Hexag_500ha'" label="Hexag_500ha" scalemindenom="100000" key="{c97588d4-5224-4e29-9918-69015f140c0c}" scalemaxdenom="150000">
            <rule symbol="42" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" label="Moins de 15" key="{2d0d287b-5e93-4fe5-a139-7ccbeb0f2beb}"/>
            <rule symbol="43" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{f91b8f1e-3d13-4615-9a8c-d0ca8dd0decf}"/>
            <rule symbol="44" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{004fa12e-9933-44c6-8f54-6720b39f0640}"/>
            <rule symbol="45" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{9c00097a-3483-4e15-8cef-f177a08ab43d}"/>
            <rule symbol="46" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="200 et plus" key="{4c2a4cb6-3421-4be2-b0ca-50b511259ae5}"/>
          </rule>
          <rule symbol="47" filter="&quot;type_result&quot; = 'IRIS'" label="IRIS" scalemindenom="150000" key="{1fe00951-8fac-4435-9c01-a3926324fd25}" scalemaxdenom="300000">
            <rule symbol="48" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) = 0" label="0" key="{c03db44e-2d71-43ce-b9a4-5ee16cf0153b}"/>
            <rule symbol="49" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 15" label="Moins de 15" key="{8abf8686-8109-4a0f-acb1-29f926aa0b1a}"/>
            <rule symbol="50" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{429b0de5-a623-4173-a3fb-3b907a303c1f}"/>
            <rule symbol="51" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{1177b03a-12a5-4c3e-9240-5238e8d24386}"/>
            <rule symbol="52" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{743d951b-d7a1-42a9-acfd-b4f605b0b5f4}"/>
            <rule symbol="53" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="Plus de 200" key="{12a89adf-12c5-478a-bfa4-98dff7e7323d}"/>
          </rule>
          <rule symbol="54" filter="&quot;type_result&quot; = 'Commune'" label="Communes" scalemindenom="300000" key="{f45a4036-2900-46b9-b5ef-02639324c13c}" scalemaxdenom="500000">
            <rule symbol="55" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) = 0" label="0" key="{5cf2ae05-ef64-474f-b752-b5963d4ec10f}"/>
            <rule symbol="56" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 15" label="Moins de 15" key="{a51b80f9-68e4-43d7-b6a0-38b38f9acc52}"/>
            <rule symbol="57" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{c6bd1e58-5e98-4180-b8c3-ed6ae57fc6c4}"/>
            <rule symbol="58" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{247cc1cf-4b26-4719-9ec0-cf3605765cfa}"/>
            <rule symbol="59" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{cf4475dc-1f37-495f-9193-17d3b4bde8fe}"/>
            <rule symbol="60" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="Plus de 200" key="{42b5f214-4c35-4942-a0d6-7c2ea7c2ed43}"/>
          </rule>
          <rule symbol="61" filter="&quot;type_result&quot; = 'EPCI'" label="EPCI" scalemindenom="500000" key="{4c03bdb7-e65d-40d0-abdc-ef20f4d645e0}" scalemaxdenom="1000000">
            <rule symbol="62" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) = 0" label="0" key="{3c3018c2-f991-4704-bcd4-8c8760ddc23a}"/>
            <rule symbol="63" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 15" label="Moins de 15" key="{30a7c603-581c-4bce-ac5a-15f0224ef795}"/>
            <rule symbol="64" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" label="15 - 50" key="{304849fe-aed0-4741-90d0-a50e54ef632a}"/>
            <rule symbol="65" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" label="50 - 150" key="{1a89f77d-654e-4ca0-bd5b-b1b4f52ed3de}"/>
            <rule symbol="66" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" label="150 - 200" key="{f41937f5-c389-404b-b1bf-19c42757b0d3}"/>
            <rule symbol="67" filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" label="Plus de 200" key="{e80dbbf7-3697-46c3-9fcc-0bf586c023a9}"/>
          </rule>
        </rule>
      </rule>
    </rules>
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="0" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="225,108,217,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="1" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="80,169,221,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="10" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="11" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="228,118,182,0"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="12" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="13" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="14" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="15" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="16" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="17" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="227,51,65,0"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="18" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="19" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="2" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="58,236,221,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="20" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="21" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="22" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="23" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="207,199,110,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="24" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="25" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="26" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="27" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="28" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="29" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="128,179,216,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="3" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="17,14,188,255"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.06"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="30" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="31" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="32" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="33" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="34" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="35" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="206,121,60,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="36" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="37" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="38" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="39" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="4" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="189,186,186,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="40" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="41" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="135,220,16,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="42" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="43" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="44" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="45" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="46" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="47" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="40,224,116,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="48" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="49" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="5" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="117,46,210,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="50" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="51" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="52" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="53" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="54" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="98,237,86,0"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="55" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="56" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="57" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="58" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="59" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="6" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="60" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="61" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="103,113,218,0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="no"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="solid"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="62" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="63" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,255,255,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="64" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="65" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="66" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="67" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,0,0,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="7" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,191,191,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="8" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,128,128,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="9" type="fill">
        <layer class="SimpleFill" enabled="1" locked="0" pass="0">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="255,64,64,255"/>
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
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{af7cc5c8-33db-4f3f-a7f1-cc583ed4c216}">
      <rule filter="&quot;type_result&quot; = 'IRIS' AND &quot;pop6_pp_in_fort_tresfort&quot; > 0" scalemindenom="150000" key="{46962ac4-e746-4125-86b5-bb3be61ace1b}" scalemaxdenom="300000" description="Nom IRIS">
        <settings calloutType="simple">
          <text-style fontSizeUnit="Point" fontSizeMapUnitScale="3x:0,0,0,0,0,0" textOpacity="1" capitalization="0" fontUnderline="0" fontWordSpacing="0" namedStyle="Normal" fontFamily="MS Shell Dlg 2" allowHtml="0" fontWeight="50" useSubstitutions="0" fontLetterSpacing="0" textColor="50,50,50,255" multilineHeight="1" fontSize="9" previewBkgrdColor="255,255,255,255" fontKerning="1" fontStrikeout="0" isExpression="0" fontItalic="0" blendMode="0" textOrientation="horizontal" fieldName="nom_id_geom">
            <text-buffer bufferNoFill="1" bufferOpacity="1" bufferJoinStyle="128" bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferColor="250,250,250,255" bufferBlendMode="0" bufferDraw="1" bufferSize="0.59999999999999998"/>
            <text-mask maskedSymbolLayers="" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskType="0" maskJoinStyle="128" maskSizeUnits="MM" maskEnabled="0" maskSize="0" maskOpacity="1"/>
            <background shapeRadiiUnit="Point" shapeSizeY="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeJoinStyle="64" shapeBorderWidthUnit="Point" shapeRotationType="0" shapeRotation="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetUnit="Point" shapeRadiiX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeDraw="0" shapeSizeX="0" shapeBorderColor="128,128,128,255" shapeFillColor="255,255,255,255" shapeOpacity="1" shapeRadiiY="0" shapeBorderWidth="0" shapeOffsetX="0" shapeSizeUnit="Point" shapeSVGFile="" shapeType="0" shapeOffsetY="0" shapeSizeType="0">
              <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="markerSymbol" type="marker">
                <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
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
                      <Option value="" name="name" type="QString"/>
                      <Option name="properties"/>
                      <Option value="collection" name="type" type="QString"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowRadiusUnit="MM" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadius="1.5" shadowOpacity="0.69999999999999996" shadowOffsetAngle="135" shadowRadiusAlphaOnly="0" shadowOffsetUnit="MM" shadowOffsetGlobal="1" shadowScale="100" shadowColor="0,0,0,255" shadowBlendMode="6" shadowDraw="0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowUnder="0"/>
            <dd_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" decimals="3" wrapChar="" multilineAlign="3" leftDirectionSymbol="&lt;" autoWrapLength="0" formatNumbers="0" plussign="0" reverseDirectionSymbol="0" rightDirectionSymbol=">" placeDirectionSymbol="0"/>
          <placement priority="5" maxCurvedCharAngleIn="25" offsetType="0" distUnits="MM" geometryGeneratorType="PointGeometry" repeatDistance="0" overrunDistance="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" centroidWhole="0" lineAnchorType="0" distMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" offsetUnits="MM" placementFlags="10" geometryGeneratorEnabled="0" centroidInside="0" rotationAngle="0" placement="0" repeatDistanceUnits="MM" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceUnit="MM" yOffset="0" polygonPlacementFlags="2" lineAnchorPercent="0.5" geometryGenerator="" dist="0" xOffset="0" fitInPolygonOnly="0" maxCurvedCharAngleOut="-25" layerType="PolygonGeometry"/>
          <rendering upsidedownLabels="0" displayAll="0" labelPerPart="0" maxNumLabels="2000" drawLabels="1" fontMaxPixelSize="10000" obstacleFactor="1" minFeatureSize="0" fontLimitPixelSize="0" limitNumLabels="0" scaleMax="0" mergeLines="0" zIndex="0" obstacle="1" scaleMin="0" fontMinPixelSize="3" obstacleType="1" scaleVisibility="0"/>
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
              <Option value="&lt;symbol alpha=&quot;1&quot; clip_to_extent=&quot;1&quot; force_rhr=&quot;0&quot; name=&quot;symbol&quot; type=&quot;line&quot;>&lt;layer class=&quot;SimpleLine&quot; enabled=&quot;1&quot; locked=&quot;0&quot; pass=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
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
      <rule filter="&quot;type_result&quot; = 'Commune' AND &quot;pop6_pp_in_fort_tresfort&quot; > 0" scalemindenom="300000" key="{d0699857-980b-429c-b725-2be17789eec9}" scalemaxdenom="500000" description="Nom communes">
        <settings calloutType="simple">
          <text-style fontSizeUnit="Point" fontSizeMapUnitScale="3x:0,0,0,0,0,0" textOpacity="1" capitalization="0" fontUnderline="0" fontWordSpacing="0" namedStyle="Normal" fontFamily="MS Shell Dlg 2" allowHtml="0" fontWeight="50" useSubstitutions="0" fontLetterSpacing="0" textColor="50,50,50,255" multilineHeight="1" fontSize="9" previewBkgrdColor="255,255,255,255" fontKerning="1" fontStrikeout="0" isExpression="0" fontItalic="0" blendMode="0" textOrientation="horizontal" fieldName="nom_id_geom">
            <text-buffer bufferNoFill="1" bufferOpacity="1" bufferJoinStyle="128" bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferColor="250,250,250,255" bufferBlendMode="0" bufferDraw="1" bufferSize="0.59999999999999998"/>
            <text-mask maskedSymbolLayers="" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskType="0" maskJoinStyle="128" maskSizeUnits="MM" maskEnabled="0" maskSize="0" maskOpacity="1"/>
            <background shapeRadiiUnit="Point" shapeSizeY="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeJoinStyle="64" shapeBorderWidthUnit="Point" shapeRotationType="0" shapeRotation="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetUnit="Point" shapeRadiiX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeDraw="0" shapeSizeX="0" shapeBorderColor="128,128,128,255" shapeFillColor="255,255,255,255" shapeOpacity="1" shapeRadiiY="0" shapeBorderWidth="0" shapeOffsetX="0" shapeSizeUnit="Point" shapeSVGFile="" shapeType="0" shapeOffsetY="0" shapeSizeType="0">
              <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="markerSymbol" type="marker">
                <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
                  <prop k="angle" v="0"/>
                  <prop k="color" v="183,72,75,255"/>
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
            <shadow shadowRadiusUnit="MM" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadius="1.5" shadowOpacity="0.69999999999999996" shadowOffsetAngle="135" shadowRadiusAlphaOnly="0" shadowOffsetUnit="MM" shadowOffsetGlobal="1" shadowScale="100" shadowColor="0,0,0,255" shadowBlendMode="6" shadowDraw="0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowUnder="0"/>
            <dd_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" decimals="3" wrapChar="" multilineAlign="3" leftDirectionSymbol="&lt;" autoWrapLength="0" formatNumbers="0" plussign="0" reverseDirectionSymbol="0" rightDirectionSymbol=">" placeDirectionSymbol="0"/>
          <placement priority="5" maxCurvedCharAngleIn="25" offsetType="0" distUnits="MM" geometryGeneratorType="PointGeometry" repeatDistance="0" overrunDistance="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" centroidWhole="0" lineAnchorType="0" distMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" offsetUnits="MM" placementFlags="10" geometryGeneratorEnabled="0" centroidInside="0" rotationAngle="0" placement="0" repeatDistanceUnits="MM" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceUnit="MM" yOffset="0" polygonPlacementFlags="2" lineAnchorPercent="0.5" geometryGenerator="" dist="0" xOffset="0" fitInPolygonOnly="0" maxCurvedCharAngleOut="-25" layerType="PolygonGeometry"/>
          <rendering upsidedownLabels="0" displayAll="0" labelPerPart="0" maxNumLabels="2000" drawLabels="1" fontMaxPixelSize="10000" obstacleFactor="1" minFeatureSize="0" fontLimitPixelSize="0" limitNumLabels="0" scaleMax="0" mergeLines="0" zIndex="0" obstacle="1" scaleMin="0" fontMinPixelSize="3" obstacleType="1" scaleVisibility="0"/>
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
              <Option value="&lt;symbol alpha=&quot;1&quot; clip_to_extent=&quot;1&quot; force_rhr=&quot;0&quot; name=&quot;symbol&quot; type=&quot;line&quot;>&lt;layer class=&quot;SimpleLine&quot; enabled=&quot;1&quot; locked=&quot;0&quot; pass=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
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
      <rule filter="&quot;type_result&quot; = 'EPCI' AND &quot;pop6_pp_in_fort_tresfort&quot; > 0" scalemindenom="500000" key="{7410c7d7-89bf-427a-b253-b49d0cf910dd}" scalemaxdenom="1000000" description="Nom EPCI">
        <settings calloutType="simple">
          <text-style fontSizeUnit="Point" fontSizeMapUnitScale="3x:0,0,0,0,0,0" textOpacity="1" capitalization="0" fontUnderline="0" fontWordSpacing="0" namedStyle="Normal" fontFamily="MS Shell Dlg 2" allowHtml="0" fontWeight="50" useSubstitutions="0" fontLetterSpacing="0" textColor="50,50,50,255" multilineHeight="1" fontSize="9" previewBkgrdColor="255,255,255,255" fontKerning="1" fontStrikeout="0" isExpression="0" fontItalic="0" blendMode="0" textOrientation="horizontal" fieldName="nom_id_geom">
            <text-buffer bufferNoFill="1" bufferOpacity="1" bufferJoinStyle="128" bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferColor="250,250,250,255" bufferBlendMode="0" bufferDraw="1" bufferSize="0.59999999999999998"/>
            <text-mask maskedSymbolLayers="" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskType="0" maskJoinStyle="128" maskSizeUnits="MM" maskEnabled="0" maskSize="0" maskOpacity="1"/>
            <background shapeRadiiUnit="Point" shapeSizeY="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeJoinStyle="64" shapeBorderWidthUnit="Point" shapeRotationType="0" shapeRotation="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetUnit="Point" shapeRadiiX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeDraw="0" shapeSizeX="0" shapeBorderColor="128,128,128,255" shapeFillColor="255,255,255,255" shapeOpacity="1" shapeRadiiY="0" shapeBorderWidth="0" shapeOffsetX="0" shapeSizeUnit="Point" shapeSVGFile="" shapeType="0" shapeOffsetY="0" shapeSizeType="0">
              <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="markerSymbol" type="marker">
                <layer class="SimpleMarker" enabled="1" locked="0" pass="0">
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
            <shadow shadowRadiusUnit="MM" shadowOffsetDist="1" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadius="1.5" shadowOpacity="0.69999999999999996" shadowOffsetAngle="135" shadowRadiusAlphaOnly="0" shadowOffsetUnit="MM" shadowOffsetGlobal="1" shadowScale="100" shadowColor="0,0,0,255" shadowBlendMode="6" shadowDraw="0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowUnder="0"/>
            <dd_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" decimals="3" wrapChar="" multilineAlign="3" leftDirectionSymbol="&lt;" autoWrapLength="0" formatNumbers="0" plussign="0" reverseDirectionSymbol="0" rightDirectionSymbol=">" placeDirectionSymbol="0"/>
          <placement priority="5" maxCurvedCharAngleIn="25" offsetType="0" distUnits="MM" geometryGeneratorType="PointGeometry" repeatDistance="0" overrunDistance="0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" centroidWhole="0" lineAnchorType="0" distMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" offsetUnits="MM" placementFlags="10" geometryGeneratorEnabled="0" centroidInside="0" rotationAngle="0" placement="0" repeatDistanceUnits="MM" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" overrunDistanceUnit="MM" yOffset="0" polygonPlacementFlags="2" lineAnchorPercent="0.5" geometryGenerator="" dist="0" xOffset="0" fitInPolygonOnly="0" maxCurvedCharAngleOut="-25" layerType="PolygonGeometry"/>
          <rendering upsidedownLabels="0" displayAll="0" labelPerPart="0" maxNumLabels="2000" drawLabels="1" fontMaxPixelSize="10000" obstacleFactor="1" minFeatureSize="0" fontLimitPixelSize="0" limitNumLabels="0" scaleMax="0" mergeLines="0" zIndex="0" obstacle="1" scaleMin="0" fontMinPixelSize="3" obstacleType="1" scaleVisibility="0"/>
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
              <Option value="&lt;symbol alpha=&quot;1&quot; clip_to_extent=&quot;1&quot; force_rhr=&quot;0&quot; name=&quot;symbol&quot; type=&quot;line&quot;>&lt;layer class=&quot;SimpleLine&quot; enabled=&quot;1&quot; locked=&quot;0&quot; pass=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
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
  <customproperties>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory penWidth="0" width="15" backgroundAlpha="255" barWidth="5" scaleBasedVisibility="0" spacingUnitScale="3x:0,0,0,0,0,0" lineSizeType="MM" maxScaleDenominator="1e+08" enabled="0" penColor="#000000" rotationOffset="270" sizeType="MM" spacingUnit="MM" minimumSize="0" opacity="1" showAxis="1" spacing="5" penAlpha="255" sizeScale="3x:0,0,0,0,0,0" labelPlacementMethod="XHeight" backgroundColor="#ffffff" lineSizeScale="3x:0,0,0,0,0,0" scaleDependency="Area" height="15" diagramOrientation="Up" minScaleDenominator="0" direction="0">
      <fontProperties style="" description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0"/>
      <attribute color="#000000" label="" field=""/>
      <axisSymbol>
        <symbol alpha="1" clip_to_extent="1" force_rhr="0" name="" type="line">
          <layer class="SimpleLine" enabled="1" locked="0" pass="0">
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
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings dist="0" placement="1" linePlacementFlags="18" zIndex="0" priority="0" obstacle="0" showAll="1">
    <properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration type="Map">
      <Option name="QgsGeometryGapCheck" type="Map">
        <Option value="0" name="allowedGapsBuffer" type="double"/>
        <Option value="false" name="allowedGapsEnabled" type="bool"/>
        <Option value="" name="allowedGapsLayer" type="QString"/>
      </Option>
    </checkConfiguration>
  </geometryOptions>
  <legend type="default-vector"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="id">
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
    <field configurationFlags="None" name="type_result">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="id_geom">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="nom_id_geom">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pop6_pp_in_fort_tresfort">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pop6_pp_in_fai_moyen">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pop6_pp_out_zq">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pct_pp_in_fort_tresfort">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pct_pp_in_fai_moyen">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="pct_pp_out_zq">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="total_pp">
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
    <alias index="0" field="id" name=""/>
    <alias index="1" field="territoire" name=""/>
    <alias index="2" field="type_alea" name=""/>
    <alias index="3" field="code_occurrence" name=""/>
    <alias index="4" field="type_result" name=""/>
    <alias index="5" field="id_geom" name=""/>
    <alias index="6" field="nom_id_geom" name=""/>
    <alias index="7" field="pop6_pp_in_fort_tresfort" name=""/>
    <alias index="8" field="pop6_pp_in_fai_moyen" name=""/>
    <alias index="9" field="pop6_pp_out_zq" name=""/>
    <alias index="10" field="pct_pp_in_fort_tresfort" name=""/>
    <alias index="11" field="pct_pp_in_fai_moyen" name=""/>
    <alias index="12" field="pct_pp_out_zq" name=""/>
    <alias index="13" field="total_pp" name=""/>
    <alias index="14" field="date_calcul" name=""/>
  </aliases>
  <defaults>
    <default expression="" field="id" applyOnUpdate="0"/>
    <default expression="" field="territoire" applyOnUpdate="0"/>
    <default expression="" field="type_alea" applyOnUpdate="0"/>
    <default expression="" field="code_occurrence" applyOnUpdate="0"/>
    <default expression="" field="type_result" applyOnUpdate="0"/>
    <default expression="" field="id_geom" applyOnUpdate="0"/>
    <default expression="" field="nom_id_geom" applyOnUpdate="0"/>
    <default expression="" field="pop6_pp_in_fort_tresfort" applyOnUpdate="0"/>
    <default expression="" field="pop6_pp_in_fai_moyen" applyOnUpdate="0"/>
    <default expression="" field="pop6_pp_out_zq" applyOnUpdate="0"/>
    <default expression="" field="pct_pp_in_fort_tresfort" applyOnUpdate="0"/>
    <default expression="" field="pct_pp_in_fai_moyen" applyOnUpdate="0"/>
    <default expression="" field="pct_pp_out_zq" applyOnUpdate="0"/>
    <default expression="" field="total_pp" applyOnUpdate="0"/>
    <default expression="" field="date_calcul" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" field="id" constraints="3" notnull_strength="1" exp_strength="0"/>
    <constraint unique_strength="0" field="territoire" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="type_alea" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="code_occurrence" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="type_result" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="id_geom" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="nom_id_geom" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="pop6_pp_in_fort_tresfort" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="pop6_pp_in_fai_moyen" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="pop6_pp_out_zq" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="pct_pp_in_fort_tresfort" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="pct_pp_in_fai_moyen" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="pct_pp_out_zq" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="total_pp" constraints="0" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" field="date_calcul" constraints="0" notnull_strength="0" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="id" desc=""/>
    <constraint exp="" field="territoire" desc=""/>
    <constraint exp="" field="type_alea" desc=""/>
    <constraint exp="" field="code_occurrence" desc=""/>
    <constraint exp="" field="type_result" desc=""/>
    <constraint exp="" field="id_geom" desc=""/>
    <constraint exp="" field="nom_id_geom" desc=""/>
    <constraint exp="" field="pop6_pp_in_fort_tresfort" desc=""/>
    <constraint exp="" field="pop6_pp_in_fai_moyen" desc=""/>
    <constraint exp="" field="pop6_pp_out_zq" desc=""/>
    <constraint exp="" field="pct_pp_in_fort_tresfort" desc=""/>
    <constraint exp="" field="pct_pp_in_fai_moyen" desc=""/>
    <constraint exp="" field="pct_pp_out_zq" desc=""/>
    <constraint exp="" field="total_pp" desc=""/>
    <constraint exp="" field="date_calcul" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column width="-1" hidden="0" name="id" type="field"/>
      <column width="-1" hidden="0" name="territoire" type="field"/>
      <column width="-1" hidden="0" name="type_alea" type="field"/>
      <column width="-1" hidden="0" name="code_occurrence" type="field"/>
      <column width="-1" hidden="0" name="type_result" type="field"/>
      <column width="-1" hidden="0" name="id_geom" type="field"/>
      <column width="-1" hidden="0" name="nom_id_geom" type="field"/>
      <column width="198" hidden="0" name="pop6_pp_in_fort_tresfort" type="field"/>
      <column width="253" hidden="0" name="pop6_pp_in_fai_moyen" type="field"/>
      <column width="201" hidden="0" name="pop6_pp_out_zq" type="field"/>
      <column width="-1" hidden="0" name="pct_pp_in_fort_tresfort" type="field"/>
      <column width="-1" hidden="0" name="pct_pp_in_fai_moyen" type="field"/>
      <column width="-1" hidden="0" name="pct_pp_out_zq" type="field"/>
      <column width="-1" hidden="0" name="total_pp" type="field"/>
      <column width="-1" hidden="0" name="date_calcul" type="field"/>
      <column width="-1" hidden="1" type="actions"/>
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
Les formulaires QGIS peuvent avoir une fonction Python qui est appelée lorsque le formulaire est
ouvert.

Utilisez cette fonction pour ajouter une logique supplémentaire à vos formulaires.

Entrez le nom de la fonction dans le champ 
"Fonction d'initialisation Python".
Voici un exemple:
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
    <field name="nom_id_geom" editable="1"/>
    <field name="pct_pp_in_fai_moyen" editable="1"/>
    <field name="pct_pp_in_fort_tresfort" editable="1"/>
    <field name="pct_pp_out_zq" editable="1"/>
    <field name="pop6_pp_in_fai_moyen" editable="1"/>
    <field name="pop6_pp_in_fort_tresfort" editable="1"/>
    <field name="pop6_pp_out_zq" editable="1"/>
    <field name="territoire" editable="1"/>
    <field name="total_pp" editable="1"/>
    <field name="type_alea" editable="1"/>
    <field name="type_result" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="code_occurrence"/>
    <field labelOnTop="0" name="date_calcul"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="id_geom"/>
    <field labelOnTop="0" name="nom_id_geom"/>
    <field labelOnTop="0" name="pct_pp_in_fai_moyen"/>
    <field labelOnTop="0" name="pct_pp_in_fort_tresfort"/>
    <field labelOnTop="0" name="pct_pp_out_zq"/>
    <field labelOnTop="0" name="pop6_pp_in_fai_moyen"/>
    <field labelOnTop="0" name="pop6_pp_in_fort_tresfort"/>
    <field labelOnTop="0" name="pop6_pp_out_zq"/>
    <field labelOnTop="0" name="territoire"/>
    <field labelOnTop="0" name="total_pp"/>
    <field labelOnTop="0" name="type_alea"/>
    <field labelOnTop="0" name="type_result"/>
  </labelOnTop>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"nom_id_geom"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
