<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis labelsEnabled="1" styleCategories="AllStyleCategories" simplifyAlgorithm="0" version="3.16.14-Hannover" minScale="100000000" readOnly="0" simplifyMaxScale="1" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyLocal="1" maxScale="0" hasScaleBasedVisibilityFlag="0">
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
    <rules key="{c9f9ea8c-e957-41b3-a7a9-f6c1dc507b5d}">
      <rule filter="&quot;type_alea&quot; = 'débordement de cours d''eau'" symbol="0" key="{24ddcdab-7a82-4429-b26a-803d58bfe582}" label="Aléa débordement de cours d'eau">
        <rule filter="&quot;code_occurrence&quot; = 'QRef'" symbol="1" key="{639e8953-f863-4472-b96d-83064d8afb7f}" label="QRef">
          <rule filter="&quot;type_result&quot; = 'Entite'" symbol="2" scalemaxdenom="15000" key="{04d4964d-20e5-48d6-be3c-82bb7bc30dc3}" scalemindenom="1" label="Bâtiments">
            <rule filter="&quot;pop6_pp_in_fort_tresfort&quot; > 0" symbol="3" key="{01a4f879-fc61-4314-9061-9c5d5dee4fd6}" label="En zone inondable"/>
            <rule filter="&quot;pop6_pp_in_fort_tresfort&quot; = 0 and  &quot;pop6_pp_in_fai_moyen&quot; = 0" symbol="4" key="{84ac47f4-2e8a-443f-bfde-0fefd618f22b}" label="Hors zone inondable"/>
          </rule>
          <rule filter=" &quot;type_result&quot; =  'Hexag_1ha' " symbol="5" scalemaxdenom="10000" key="{fed8f653-5b44-4337-8113-8fc490a46541}" scalemindenom="1" label="Hexag_1ha">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" symbol="6" key="{523994f4-7c70-4580-9af9-263927583095}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="7" key="{73911f35-0619-4c69-aa5f-54938d4457df}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="8" key="{de4ef318-9368-478b-ba97-042d239d38c4}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="9" key="{58104274-2088-4c06-b766-5a7d6a77ac42}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_1ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="10" key="{5d1637b5-7a91-4e44-b26c-cb1c3e62366c}" label="200 et plus"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'Hexag_5ha'" symbol="11" scalemaxdenom="25000" key="{33e447a2-1e7d-4da2-a5f9-7e651972380e}" scalemindenom="10000" label="Hexag_5ha">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" symbol="12" key="{fe65927f-5d7b-4da2-9a8b-cbda47486591}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="13" key="{9582bf03-b437-4e5c-99fa-8170145223d7}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="14" key="{bacc57d8-1e95-49d9-8969-ab6a2f743012}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="15" key="{45a80355-4e8d-4a78-b71a-5fd1bc921511}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_5ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="16" key="{894fb803-e93d-4a88-b195-df7685a1c0b3}" label="200 et plus"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'Hexag_10ha'" symbol="17" scalemaxdenom="35000" key="{26aa0f86-064a-4f25-86b4-b3d1e064bb74}" scalemindenom="25000" label="Hexag_10ha">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" symbol="18" key="{c7836fde-545e-482d-b8b4-d10f9ffad907}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="19" key="{84e3fdd0-8382-4be1-b968-16ee6b5bade7}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="20" key="{5cd2f736-f20d-4fca-b56b-db520f334fc4}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="21" key="{09b13518-2335-4528-9bad-1dd37037a788}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_10ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="22" key="{fd9a588a-8292-4a02-9edf-a2aee730ff6f}" label="200 et plus"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'Hexag_50ha'" symbol="23" scalemaxdenom="50000" key="{35f9ad22-4d59-4278-81bf-58463a98ecf8}" scalemindenom="35000" label="Hexag_50ha">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" symbol="24" key="{04fed555-8cde-4628-b673-aa4cab25fd33}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="25" key="{d7f32fde-3701-4626-bb6b-effc41194d97}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="26" key="{fd20225e-ef09-4e24-98bf-c974d5a4541e}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="27" key="{18359d0a-b21f-4627-829d-385e5d6d28c7}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_50ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="28" key="{1d8758a7-ad34-48e6-be24-ae79ab05152c}" label="200 et plus"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'Hexag_100ha'" symbol="29" scalemaxdenom="75000" key="{ef170507-66b0-40f7-9477-e0ccc7495880}" scalemindenom="50000" label="Hexag_100ha">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" symbol="30" key="{b3873e52-ba89-4762-99ae-14e96c74ec13}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="31" key="{6684403b-a371-4c0a-a22a-91274ff41c30}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="32" key="{3ee45e1c-354e-4cf2-9aa6-94ed14f52f3c}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="33" key="{e8236ec6-1103-48a7-bcc1-558695c4852d}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_100ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="34" key="{09b89950-62f2-4a4d-b8d8-87f25142ed1c}" label="200 et plus"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'Hexag_250ha'" symbol="35" scalemaxdenom="100000" key="{0594a0d9-ea85-47b7-ae65-1cc7af147443}" scalemindenom="75000" label="Hexag_250ha">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" symbol="36" key="{28dbadf1-a58a-4f8a-b764-508b674d01b6}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="37" key="{7a2cb615-f205-46df-9064-f47f551b00f3}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="38" key="{93502577-c9ca-4c7f-84a6-2d7bd5600d49}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="39" key="{5e33ba0e-3aaf-45d6-a2c7-dcba7b750059}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_250ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="40" key="{96d48f5e-172c-4547-be97-8fe9f6bcead1}" label="200 et plus"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'Hexag_500ha'" symbol="41" scalemaxdenom="150000" key="{c97588d4-5224-4e29-9918-69015f140c0c}" scalemindenom="100000" label="Hexag_500ha">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt;= 15" symbol="42" key="{2d0d287b-5e93-4fe5-a139-7ccbeb0f2beb}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="43" key="{f91b8f1e-3d13-4615-9a8c-d0ca8dd0decf}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="44" key="{004fa12e-9933-44c6-8f54-6720b39f0640}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="45" key="{9c00097a-3483-4e15-8cef-f177a08ab43d}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Hexag_500ha') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="46" key="{4c2a4cb6-3421-4be2-b0ca-50b511259ae5}" label="200 et plus"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'IRIS'" symbol="47" scalemaxdenom="300000" key="{1fe00951-8fac-4435-9c01-a3926324fd25}" scalemindenom="150000" label="IRIS">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) = 0" symbol="48" key="{c03db44e-2d71-43ce-b9a4-5ee16cf0153b}" label="0"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 15" symbol="49" key="{8abf8686-8109-4a0f-acb1-29f926aa0b1a}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="50" key="{429b0de5-a623-4173-a3fb-3b907a303c1f}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="51" key="{1177b03a-12a5-4c3e-9240-5238e8d24386}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="52" key="{743d951b-d7a1-42a9-acfd-b4f605b0b5f4}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='IRIS') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="53" key="{12a89adf-12c5-478a-bfa4-98dff7e7323d}" label="Plus de 200"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'Commune'" symbol="54" scalemaxdenom="500000" key="{f45a4036-2900-46b9-b5ef-02639324c13c}" scalemindenom="300000" label="Communes">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) = 0" symbol="55" key="{5cf2ae05-ef64-474f-b752-b5963d4ec10f}" label="0"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 15" symbol="56" key="{a51b80f9-68e4-43d7-b6a0-38b38f9acc52}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="57" key="{c6bd1e58-5e98-4180-b8c3-ed6ae57fc6c4}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="58" key="{247cc1cf-4b26-4719-9ec0-cf3605765cfa}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="59" key="{cf4475dc-1f37-495f-9193-17d3b4bde8fe}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='Commune') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="60" key="{42b5f214-4c35-4942-a0d6-7c2ea7c2ed43}" label="Plus de 200"/>
          </rule>
          <rule filter="&quot;type_result&quot; = 'EPCI'" symbol="61" scalemaxdenom="1000000" key="{4c03bdb7-e65d-40d0-abdc-ef20f4d645e0}" scalemindenom="500000" label="EPCI">
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) = 0" symbol="62" key="{3c3018c2-f991-4704-bcd4-8c8760ddc23a}" label="0"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) > 0 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 15" symbol="63" key="{30a7c603-581c-4bce-ac5a-15f0224ef795}" label="Moins de 15"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 15 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 50" symbol="64" key="{304849fe-aed0-4741-90d0-a50e54ef632a}" label="15 - 50"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 50 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 150" symbol="65" key="{1a89f77d-654e-4ca0-bd5b-b1b4f52ed3de}" label="50 - 150"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 150 AND (CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) &lt; 200" symbol="66" key="{f41937f5-c389-404b-b1bf-19c42757b0d3}" label="150 - 200"/>
            <rule filter="(CASE WHEN(&quot;type_alea&quot; = 'débordement de cours d''eau' AND &quot;code_occurrence&quot; = 'QRef' AND &quot;type_result&quot;='EPCI') THEN &quot;pop6_pp_in_fort_tresfort&quot; END) >= 200" symbol="67" key="{e80dbbf7-3697-46c3-9fcc-0bf586c023a9}" label="Plus de 200"/>
          </rule>
        </rule>
      </rule>
    </rules>
    <symbols>
      <symbol type="fill" force_rhr="0" name="0" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="10" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="11" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="12" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="13" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="14" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="15" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="16" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="17" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="18" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="19" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="2" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="20" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="21" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="22" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="23" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="24" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="25" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="26" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="27" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="28" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="29" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="3" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="30" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="31" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="32" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="33" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="34" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="35" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="36" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="37" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="38" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="39" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="4" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="40" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="41" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="42" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="43" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="44" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="45" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="46" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="47" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="48" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="49" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="5" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="50" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="51" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="52" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="53" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="54" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="55" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="56" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="57" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="58" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="59" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="6" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="60" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="61" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="62" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="63" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="64" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="65" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="66" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="67" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="7" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="8" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="fill" force_rhr="0" name="9" clip_to_extent="1" alpha="1">
        <layer pass="0" enabled="1" class="SimpleFill" locked="0">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="rule-based">
    <rules key="{663a73ed-d103-4b10-b21c-901f0ff645e2}">
      <rule filter="&quot;type_result&quot; = 'IRIS' AND &quot;pop6_pp_in_fort_tresfort&quot; > 0" description="Nom IRIS" scalemaxdenom="300000" key="{4dbcea4e-8b6a-47d8-a24b-58d1bf9f078e}" scalemindenom="150000">
        <settings calloutType="simple">
          <text-style fontFamily="MS Shell Dlg 2" fontItalic="0" namedStyle="Normal" fontWeight="50" textOrientation="horizontal" fontUnderline="0" blendMode="0" capitalization="0" previewBkgrdColor="255,255,255,255" textOpacity="1" fontStrikeout="0" textColor="50,50,50,255" fontWordSpacing="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fieldName="nom_id_geom" allowHtml="0" fontSize="9" fontKerning="1" multilineHeight="1" isExpression="0" useSubstitutions="0" fontSizeUnit="Point" fontLetterSpacing="0">
            <text-buffer bufferJoinStyle="128" bufferSize="0.59999999999999998" bufferColor="250,250,250,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferBlendMode="0" bufferOpacity="1" bufferSizeUnits="MM" bufferDraw="1" bufferNoFill="1"/>
            <text-mask maskJoinStyle="128" maskSizeUnits="MM" maskEnabled="0" maskType="0" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskOpacity="1" maskedSymbolLayers="" maskSize="0"/>
            <background shapeRotation="0" shapeOffsetUnit="Point" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeDraw="0" shapeBlendMode="0" shapeJoinStyle="64" shapeOpacity="1" shapeRadiiX="0" shapeOffsetX="0" shapeRadiiY="0" shapeBorderColor="128,128,128,255" shapeSVGFile="" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="Point" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRotationType="0" shapeType="0" shapeSizeUnit="Point" shapeSizeY="0" shapeSizeType="0" shapeSizeX="0" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="Point" shapeOffsetY="0">
              <symbol type="marker" force_rhr="0" name="markerSymbol" clip_to_extent="1" alpha="1">
                <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
                      <Option type="QString" value="" name="name"/>
                      <Option name="properties"/>
                      <Option type="QString" value="collection" name="type"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowScale="100" shadowOpacity="0.69999999999999996" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowDraw="0" shadowRadius="1.5" shadowRadiusUnit="MM" shadowOffsetAngle="135" shadowUnder="0" shadowOffsetUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255"/>
            <dd_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format leftDirectionSymbol="&lt;" decimals="3" addDirectionSymbol="0" autoWrapLength="0" formatNumbers="0" reverseDirectionSymbol="0" plussign="0" multilineAlign="3" rightDirectionSymbol=">" wrapChar="" useMaxLineLengthForAutoWrap="1" placeDirectionSymbol="0"/>
          <placement repeatDistanceUnits="MM" centroidInside="0" geometryGeneratorEnabled="0" quadOffset="4" overrunDistance="0" yOffset="0" preserveRotation="1" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" polygonPlacementFlags="2" fitInPolygonOnly="0" priority="5" lineAnchorPercent="0.5" geometryGeneratorType="PointGeometry" centroidWhole="0" offsetType="0" maxCurvedCharAngleOut="-25" overrunDistanceUnit="MM" distUnits="MM" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" dist="0" repeatDistance="0" lineAnchorType="0" layerType="PolygonGeometry" distMapUnitScale="3x:0,0,0,0,0,0" maxCurvedCharAngleIn="25" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" offsetUnits="MM" rotationAngle="0" placementFlags="10" geometryGenerator="" placement="0" xOffset="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0"/>
          <rendering upsidedownLabels="0" obstacle="1" fontMinPixelSize="3" zIndex="0" limitNumLabels="0" drawLabels="1" mergeLines="0" labelPerPart="0" obstacleType="1" maxNumLabels="2000" scaleVisibility="0" scaleMin="0" displayAll="0" minFeatureSize="0" scaleMax="0" obstacleFactor="1" fontMaxPixelSize="10000" fontLimitPixelSize="0"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option type="QString" value="pole_of_inaccessibility" name="anchorPoint"/>
              <Option type="Map" name="ddProperties">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
              <Option type="bool" value="false" name="drawToAllParts"/>
              <Option type="QString" value="0" name="enabled"/>
              <Option type="QString" value="point_on_exterior" name="labelAnchorPoint"/>
              <Option type="QString" value="&lt;symbol type=&quot;line&quot; force_rhr=&quot;0&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot;>&lt;layer pass=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; locked=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;&quot; name=&quot;name&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;collection&quot; name=&quot;type&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol"/>
              <Option type="double" value="0" name="minLength"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale"/>
              <Option type="QString" value="MM" name="minLengthUnit"/>
              <Option type="double" value="0" name="offsetFromAnchor"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale"/>
              <Option type="QString" value="MM" name="offsetFromAnchorUnit"/>
              <Option type="double" value="0" name="offsetFromLabel"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale"/>
              <Option type="QString" value="MM" name="offsetFromLabelUnit"/>
            </Option>
          </callout>
        </settings>
      </rule>
      <rule filter="&quot;type_result&quot; = 'Commune' AND &quot;pop6_pp_in_fort_tresfort&quot; > 0" description="Nom communes" scalemaxdenom="500000" key="{72c65494-c63c-49a8-ba13-ac8d804f2852}" scalemindenom="300000">
        <settings calloutType="simple">
          <text-style fontFamily="MS Shell Dlg 2" fontItalic="0" namedStyle="Normal" fontWeight="50" textOrientation="horizontal" fontUnderline="0" blendMode="0" capitalization="0" previewBkgrdColor="255,255,255,255" textOpacity="1" fontStrikeout="0" textColor="50,50,50,255" fontWordSpacing="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fieldName="nom_id_geom" allowHtml="0" fontSize="9" fontKerning="1" multilineHeight="1" isExpression="0" useSubstitutions="0" fontSizeUnit="Point" fontLetterSpacing="0">
            <text-buffer bufferJoinStyle="128" bufferSize="0.59999999999999998" bufferColor="250,250,250,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferBlendMode="0" bufferOpacity="1" bufferSizeUnits="MM" bufferDraw="1" bufferNoFill="1"/>
            <text-mask maskJoinStyle="128" maskSizeUnits="MM" maskEnabled="0" maskType="0" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskOpacity="1" maskedSymbolLayers="" maskSize="0"/>
            <background shapeRotation="0" shapeOffsetUnit="Point" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeDraw="0" shapeBlendMode="0" shapeJoinStyle="64" shapeOpacity="1" shapeRadiiX="0" shapeOffsetX="0" shapeRadiiY="0" shapeBorderColor="128,128,128,255" shapeSVGFile="" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="Point" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRotationType="0" shapeType="0" shapeSizeUnit="Point" shapeSizeY="0" shapeSizeType="0" shapeSizeX="0" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="Point" shapeOffsetY="0">
              <symbol type="marker" force_rhr="0" name="markerSymbol" clip_to_extent="1" alpha="1">
                <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
                      <Option type="QString" value="" name="name"/>
                      <Option name="properties"/>
                      <Option type="QString" value="collection" name="type"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowScale="100" shadowOpacity="0.69999999999999996" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowDraw="0" shadowRadius="1.5" shadowRadiusUnit="MM" shadowOffsetAngle="135" shadowUnder="0" shadowOffsetUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255"/>
            <dd_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format leftDirectionSymbol="&lt;" decimals="3" addDirectionSymbol="0" autoWrapLength="0" formatNumbers="0" reverseDirectionSymbol="0" plussign="0" multilineAlign="3" rightDirectionSymbol=">" wrapChar="" useMaxLineLengthForAutoWrap="1" placeDirectionSymbol="0"/>
          <placement repeatDistanceUnits="MM" centroidInside="0" geometryGeneratorEnabled="0" quadOffset="4" overrunDistance="0" yOffset="0" preserveRotation="1" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" polygonPlacementFlags="2" fitInPolygonOnly="0" priority="5" lineAnchorPercent="0.5" geometryGeneratorType="PointGeometry" centroidWhole="0" offsetType="0" maxCurvedCharAngleOut="-25" overrunDistanceUnit="MM" distUnits="MM" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" dist="0" repeatDistance="0" lineAnchorType="0" layerType="PolygonGeometry" distMapUnitScale="3x:0,0,0,0,0,0" maxCurvedCharAngleIn="25" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" offsetUnits="MM" rotationAngle="0" placementFlags="10" geometryGenerator="" placement="0" xOffset="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0"/>
          <rendering upsidedownLabels="0" obstacle="1" fontMinPixelSize="3" zIndex="0" limitNumLabels="0" drawLabels="1" mergeLines="0" labelPerPart="0" obstacleType="1" maxNumLabels="2000" scaleVisibility="0" scaleMin="0" displayAll="0" minFeatureSize="0" scaleMax="0" obstacleFactor="1" fontMaxPixelSize="10000" fontLimitPixelSize="0"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option type="QString" value="pole_of_inaccessibility" name="anchorPoint"/>
              <Option type="Map" name="ddProperties">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
              <Option type="bool" value="false" name="drawToAllParts"/>
              <Option type="QString" value="0" name="enabled"/>
              <Option type="QString" value="point_on_exterior" name="labelAnchorPoint"/>
              <Option type="QString" value="&lt;symbol type=&quot;line&quot; force_rhr=&quot;0&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot;>&lt;layer pass=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; locked=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;&quot; name=&quot;name&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;collection&quot; name=&quot;type&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol"/>
              <Option type="double" value="0" name="minLength"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale"/>
              <Option type="QString" value="MM" name="minLengthUnit"/>
              <Option type="double" value="0" name="offsetFromAnchor"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale"/>
              <Option type="QString" value="MM" name="offsetFromAnchorUnit"/>
              <Option type="double" value="0" name="offsetFromLabel"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale"/>
              <Option type="QString" value="MM" name="offsetFromLabelUnit"/>
            </Option>
          </callout>
        </settings>
      </rule>
      <rule filter="&quot;type_result&quot; = 'EPCI' AND &quot;pop6_pp_in_fort_tresfort&quot; > 0" description="Nom EPCI" scalemaxdenom="1000000" key="{b155b2e7-dbd4-4215-bfec-880262e30b07}" scalemindenom="500000">
        <settings calloutType="simple">
          <text-style fontFamily="MS Shell Dlg 2" fontItalic="0" namedStyle="Normal" fontWeight="50" textOrientation="horizontal" fontUnderline="0" blendMode="0" capitalization="0" previewBkgrdColor="255,255,255,255" textOpacity="1" fontStrikeout="0" textColor="50,50,50,255" fontWordSpacing="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fieldName="nom_id_geom" allowHtml="0" fontSize="9" fontKerning="1" multilineHeight="1" isExpression="0" useSubstitutions="0" fontSizeUnit="Point" fontLetterSpacing="0">
            <text-buffer bufferJoinStyle="128" bufferSize="0.59999999999999998" bufferColor="250,250,250,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferBlendMode="0" bufferOpacity="1" bufferSizeUnits="MM" bufferDraw="1" bufferNoFill="1"/>
            <text-mask maskJoinStyle="128" maskSizeUnits="MM" maskEnabled="0" maskType="0" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskOpacity="1" maskedSymbolLayers="" maskSize="0"/>
            <background shapeRotation="0" shapeOffsetUnit="Point" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidth="0" shapeDraw="0" shapeBlendMode="0" shapeJoinStyle="64" shapeOpacity="1" shapeRadiiX="0" shapeOffsetX="0" shapeRadiiY="0" shapeBorderColor="128,128,128,255" shapeSVGFile="" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="Point" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRotationType="0" shapeType="0" shapeSizeUnit="Point" shapeSizeY="0" shapeSizeType="0" shapeSizeX="0" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="Point" shapeOffsetY="0">
              <symbol type="marker" force_rhr="0" name="markerSymbol" clip_to_extent="1" alpha="1">
                <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
                      <Option type="QString" value="" name="name"/>
                      <Option name="properties"/>
                      <Option type="QString" value="collection" name="type"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </background>
            <shadow shadowOffsetDist="1" shadowScale="100" shadowOpacity="0.69999999999999996" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowBlendMode="6" shadowDraw="0" shadowRadius="1.5" shadowRadiusUnit="MM" shadowOffsetAngle="135" shadowUnder="0" shadowOffsetUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255"/>
            <dd_properties>
              <Option type="Map">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
            </dd_properties>
            <substitutions/>
          </text-style>
          <text-format leftDirectionSymbol="&lt;" decimals="3" addDirectionSymbol="0" autoWrapLength="0" formatNumbers="0" reverseDirectionSymbol="0" plussign="0" multilineAlign="3" rightDirectionSymbol=">" wrapChar="" useMaxLineLengthForAutoWrap="1" placeDirectionSymbol="0"/>
          <placement repeatDistanceUnits="MM" centroidInside="0" geometryGeneratorEnabled="0" quadOffset="4" overrunDistance="0" yOffset="0" preserveRotation="1" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" polygonPlacementFlags="2" fitInPolygonOnly="0" priority="5" lineAnchorPercent="0.5" geometryGeneratorType="PointGeometry" centroidWhole="0" offsetType="0" maxCurvedCharAngleOut="-25" overrunDistanceUnit="MM" distUnits="MM" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" dist="0" repeatDistance="0" lineAnchorType="0" layerType="PolygonGeometry" distMapUnitScale="3x:0,0,0,0,0,0" maxCurvedCharAngleIn="25" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" offsetUnits="MM" rotationAngle="0" placementFlags="10" geometryGenerator="" placement="0" xOffset="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0"/>
          <rendering upsidedownLabels="0" obstacle="1" fontMinPixelSize="3" zIndex="0" limitNumLabels="0" drawLabels="1" mergeLines="0" labelPerPart="0" obstacleType="1" maxNumLabels="2000" scaleVisibility="0" scaleMin="0" displayAll="0" minFeatureSize="0" scaleMax="0" obstacleFactor="1" fontMaxPixelSize="10000" fontLimitPixelSize="0"/>
          <dd_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </dd_properties>
          <callout type="simple">
            <Option type="Map">
              <Option type="QString" value="pole_of_inaccessibility" name="anchorPoint"/>
              <Option type="Map" name="ddProperties">
                <Option type="QString" value="" name="name"/>
                <Option name="properties"/>
                <Option type="QString" value="collection" name="type"/>
              </Option>
              <Option type="bool" value="false" name="drawToAllParts"/>
              <Option type="QString" value="0" name="enabled"/>
              <Option type="QString" value="point_on_exterior" name="labelAnchorPoint"/>
              <Option type="QString" value="&lt;symbol type=&quot;line&quot; force_rhr=&quot;0&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot;>&lt;layer pass=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; locked=&quot;0&quot;>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;&quot; name=&quot;name&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;collection&quot; name=&quot;type&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol"/>
              <Option type="double" value="0" name="minLength"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale"/>
              <Option type="QString" value="MM" name="minLengthUnit"/>
              <Option type="double" value="0" name="offsetFromAnchor"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale"/>
              <Option type="QString" value="MM" name="offsetFromAnchorUnit"/>
              <Option type="double" value="0" name="offsetFromLabel"/>
              <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale"/>
              <Option type="QString" value="MM" name="offsetFromLabelUnit"/>
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
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory sizeScale="3x:0,0,0,0,0,0" spacing="5" labelPlacementMethod="XHeight" direction="0" width="15" backgroundColor="#ffffff" lineSizeScale="3x:0,0,0,0,0,0" showAxis="1" penWidth="0" scaleDependency="Area" scaleBasedVisibility="0" minimumSize="0" maxScaleDenominator="1e+08" opacity="1" lineSizeType="MM" backgroundAlpha="255" enabled="0" diagramOrientation="Up" penAlpha="255" spacingUnitScale="3x:0,0,0,0,0,0" minScaleDenominator="0" sizeType="MM" barWidth="5" rotationOffset="270" penColor="#000000" spacingUnit="MM" height="15">
      <fontProperties description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" style=""/>
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
    <alias index="0" name="" field="id"/>
    <alias index="1" name="" field="territoire"/>
    <alias index="2" name="" field="type_alea"/>
    <alias index="3" name="" field="code_occurrence"/>
    <alias index="4" name="" field="type_result"/>
    <alias index="5" name="" field="id_geom"/>
    <alias index="6" name="" field="nom_id_geom"/>
    <alias index="7" name="" field="pop6_pp_in_fort_tresfort"/>
    <alias index="8" name="" field="pop6_pp_in_fai_moyen"/>
    <alias index="9" name="" field="pop6_pp_out_zq"/>
    <alias index="10" name="" field="pct_pp_in_fort_tresfort"/>
    <alias index="11" name="" field="pct_pp_in_fai_moyen"/>
    <alias index="12" name="" field="pct_pp_out_zq"/>
    <alias index="13" name="" field="total_pp"/>
    <alias index="14" name="" field="date_calcul"/>
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
    <constraint notnull_strength="1" unique_strength="1" constraints="3" exp_strength="0" field="id"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="territoire"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="type_alea"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="code_occurrence"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="type_result"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="id_geom"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="nom_id_geom"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="pop6_pp_in_fort_tresfort"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="pop6_pp_in_fai_moyen"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="pop6_pp_out_zq"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="pct_pp_in_fort_tresfort"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="pct_pp_in_fai_moyen"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="pct_pp_out_zq"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="total_pp"/>
    <constraint notnull_strength="0" unique_strength="0" constraints="0" exp_strength="0" field="date_calcul"/>
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
  <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
    <columns>
      <column type="field" name="id" width="-1" hidden="0"/>
      <column type="field" name="territoire" width="-1" hidden="0"/>
      <column type="field" name="type_alea" width="-1" hidden="0"/>
      <column type="field" name="code_occurrence" width="-1" hidden="0"/>
      <column type="field" name="type_result" width="-1" hidden="0"/>
      <column type="field" name="id_geom" width="-1" hidden="0"/>
      <column type="field" name="nom_id_geom" width="-1" hidden="0"/>
      <column type="field" name="pop6_pp_in_fort_tresfort" width="198" hidden="0"/>
      <column type="field" name="pop6_pp_in_fai_moyen" width="253" hidden="0"/>
      <column type="field" name="pop6_pp_out_zq" width="201" hidden="0"/>
      <column type="field" name="pct_pp_in_fort_tresfort" width="-1" hidden="0"/>
      <column type="field" name="pct_pp_in_fai_moyen" width="-1" hidden="0"/>
      <column type="field" name="pct_pp_out_zq" width="-1" hidden="0"/>
      <column type="field" name="total_pp" width="-1" hidden="0"/>
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
