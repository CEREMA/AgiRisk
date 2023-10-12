CREATE OR REPLACE FUNCTION public.__indic_s2_2a_amc_lucie(nom_ter text, typ_alea text, code_occ text, an_fch_acb text, an_bdtopo text, an_fct_dmg text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

-- Fonction SQL d'incrémentation de la table p_indicateurs.s2_2a_amc "Montant des dommages aux logements en fonction de la hauteur d'eau et de la durée de submersion"
-- Copyright Cerema / GT AgiRisk
-- Auteur principal du script, inspiré de ceux mis en œuvre localement par d'autres membres du GT AgiRisk : Sébastien

-- Paramètres d'entrée :
-- nom_ter : nom du territoire d'étude tel que renseigné dans le champ `territoire` de la table c_general.territoires (ex : Baccarat IRIS GE, Jura, Scot de Tours, TRI Baccarat secteur 54, TRI Noirmoutier SJDM, TRI Verdun, Vienne Clain, Zorn)
-- typ_alea : type d'aléa considéré (ex : débordement de cours d'eau, submersion marine)
-- code_occ : période de retour considérée pour le type d'aléa choisi (ex : QRef, Q100, Q10...), donnée non strictement nécessaire pour l'application des fonctions de dommages mais intéressante pour discriminer les résultats selon l'occurrence de crue
-- an_fch_acb : millésime (année au format AAAA) des fichiers "logements" et "sous-sols" produits par le Cerema Méditerranée pour l'Analyse Coûts-Bénéfices (ACB) des projets de prévention des inondations (détail de la méthode dans cet article : https://www.cerema.fr/fr/actualites/cerema-ameliore-son-fichier-analyse-cout-benefice-projets)
-- an_bdtopo : millésime (année au format AAAA) des données de la BD TOPO®
-- an_fct_dmg : année (au format AAAA) d'actualisation des coûts dans les fonctions de dommages (dans l'objectif de suivi de l'évolution des coûts de dommages selon l'inflation)

-- Exemple d'appel à cette fonction :
-- SELECT public.__indic_s2_2a_amc_lucie('TRI Verdun', 'débordement de cours d''eau + remontée de nappe', 'QRef diag', '2021', '2022', '2021');

/* La présente fonction calcule les coûts de dommages aux logements en fonction de la hauteur d'eau et de la durée de submersion.
Son exécution nécessite d'avoir calculé au préalable les variables Oc2 (logements), Zh (classes de hauteur d'eau) et Zf (durée de submersion) sur le territoire renseigné.
Le calcul s'appuie également sur les fonctions de dommages mises à disposition sur le site du ministère de la Transition écologique. */

DECLARE
	c integer; -- un compteur des lignes modifiées pour logging
	heure1 varchar; -- heure de début du traitement
	heure2 varchar; -- heure de fin du traitement

/***********************************************************************
PRÉAMBULE : DESCRIPTION ET MÉTHODE D'UTILISATION DES FONCTIONS DE DOMMAGES
************************************************************************
Le ministère de la Transition écologique met à disposition sur son site Internet divers outils, tels que des "fonctions de dommages", permettant d'évaluer les coûts des dommages liés à une inondation selon le type d'enjeu exposé : https://www.ecologie.gouv.fr/levaluation-economique-des-projets-gestion-des-risques-naturels#scroll-nav__3
La description et la méthode d'application des fonctions de dommages qui suivent sont issues de la "Boîte à outils Dommages : comment évaluer les dommages liés à une inondation ?", chapitre 2, pages 86 à 118 du guide méthodologique pour l'analyse multicritère des projets de prévention des inondations (dit "guide AMC", version de mars 2018 : https://www.ecologie.gouv.fr/sites/default/files/Th%C3%A9ma%20-%20Analyse%20multicrit%C3%A8re%20des%20projets%20de%20pr%C3%A9vention%20des%20inondations%20-%20Guide.pdf).

************************************************************************
Définition des fonctions de dommages
************************************************************************
Une fonction de dommages est une fonction définie pour un enjeu (ex : logement, entreprise, établissement public, activité agricole), qui associe aux paramètres hydrologiques et/ou hydrauliques de l'inondation, le montant des dommages en valeur absolue induits par l'inondation de l'enjeu. Implicitement, il est sous-entendu "dommages directs" pour les enjeux de type logement, entreprise, établissement public ou activité agricole.
Le paramètre le plus fréquent est la hauteur maximale de submersion. En l'état actuel des fonctions de dommages, cette variable est appréciée par pas de 10 cm (unité 5). En réalité, les dommages physiques ont été évalués par seuil de 50 cm. Les dommages correspondants aux points intermédiaires des fonctions de dommages ont été construits par interpolation linéaire tous les 10 cm et ont été soumis à l'appréciation des experts d'assurances qui les ont jugés réalistes.
Néanmoins, les fonctions de dommages peuvent dépendre d'autres paramètres :
* Les paramètres "durée de submersion" (<48h / >48h ou courte / moyenne / longue / très longue) et "vitesse du courant (des écoulements)" (faible / moyen / fort), lorsqu'ils influencent notablement les dommages, sont considérés au travers d'un ou plusieurs seuils en fonction des enjeux considérés.
* Pour les cultures agricoles, le paramètre "saison d'occurrence" (printemps / été / automne / hiver) entre aussi en ligne de compte.
* Le paramètre lié à la "cinétique de l'inondation" (lente / rapide) est apprécié qualitativement d'après les connaissances tirées de retours d'expériences locaux. Par défaut pour les territoires étudiés dans le cadre du projet AgiRisk, il est proposé de se baser sur une cinétique lente lorsque le phénomène considéré est un débordement de fleuve.

************************************************************************
Catégories des fonctions de dommages
************************************************************************
Des fonctions de dommages directs moyennes nationales sont disponibles sur le site du ministère de la Transition écologique :
* pour les 4 catégories d'enjeux suivantes :
	- logements (individuels, collectifs, caves et sous-sols)
	- activités économiques hors secteur agricole (entreprises classifiées selon la Nomenclature d'Activités Française (codes NAF))
	- établissements publics (eux-mêmes regroupés en 6 catégories)
	- activités (cultures) agricolesf
* et pour les types d'aléa suivants :
	- fluvial = inondation de plaine
	- littoral = submersion marine

Il est recommandé au guide AMC d'utiliser en priorité les fonctions de dommages directs moyennes nationales fournies dans ce guide.
Nota : le guide AMC fournit également une fonction de dommages indirects moyenne nationale pour les réseaux de transport routier.

Les fonctions de dommages sont disponibles en deux formats :
* format graphique (courbes) : voir chapitre "A2 Indicateurs de dommages : les fonctions de dommages" pages 40 à 70 des annexes techniques du guide AMC (version de mars 2018 : https://www.ecologie.gouv.fr/sites/default/files/Th%C3%A9ma%20-%20Analyse%20multicrit%C3%A8re%20des%20projets%20de%20pr%C3%A9vention%20des%20inondations%20-%20Annexes.pdf)
* format tableur (privilégié pour les calculs des indicateurs de dommages monétaires) : fichiers Excel téléchargeables sur le site du ministère (https://www.ecologie.gouv.fr/levaluation-economique-des-projets-gestion-des-risques-naturels#scroll-nav__3)

************************************************************************
Méthode d'utilisation des fonctions de dommages aux logements (réf. chapitre 2.1.3, pages 90 et suivantes du guide AMC, version de mars 2018)
************************************************************************
Pour les logements exposés à des inondations de plaine (aléa fluvial), on cherche à évaluer :
- le coût des dommages au bâti d'une part,
- le coût des dommages au mobilier d'autre part.
Leur somme constitue le principal résultat de l'indicateur S2/2a (coût global des dommages aux logements).

Deux types de fonctions de dommages, correspondant à deux onglets différents, sont proposés dans le tableur téléchargeable à ce lien : https://www.ecologie.gouv.fr/sites/default/files/AMC%20-%20Fonctions%20de%20dommages%20fluvial%20logements.xls
* onglet "entité_de_bien (€2016)" = fonctions de dommages à l'entité de bien :
	-> Fonctions utilisées par Thomas sur le SCoT de Tours.
	-> Ces fonctions s'appliquent pour chaque logement recensé et nécessitent donc obligatoirement un décompte des logements sur le territoire étudié.
	-> L'application de ces fonctions nécessite de caractériser chaque logement en fonction des critères suivants :
		- logement individuel ou collectif (critère 1)
		- présence ou non d'un étage pour le logement individuel (critère 2)
		- présence ou non d'un sous-sol pour le logement (critère 3)
		- hauteur du plancher du rez-de-chaussée (critère 4)
* onglet "surfacique (€2016/m²)" = fonctions de dommages surfaciques :
	-> Fonctions utilisées par Dominique sur le TRI de Verdun.
	-> Fonctions utilisables avec les fichiers ACB produits par Christophe.
	-> Ces fonctions résultent d'une transformation des fonctions de dommages à l'entité de bien. Elles sont à croiser avec la surface au sol habitable (champ `surf_rect` dans les fichiers `logements` de Christophe, à multiplier par le dommage unitaire lu dans les fonctions de dommages - réf. § 4.2 de sa note d'application : https://www.cerema.fr/system/files/documents/2022/08/med_not_fichier_amc_juillet_22_signe.pdf#%5B%7B%22num%22%3A19%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22XYZ%22%7D%2C108.65%2C782.203%2C0%5D).

Le guide AMC indique que l'utilisateur peut choisir le type de fonction qui lui convient le mieux, selon la taille de son territoire et les moyens de recensement des enjeux dont il dispose.
Dans la méthode de calcul qui suit, il est proposé de se baser sur les valeurs de l'onglet "surfacique" des fonctions de dommages aux logements.

************************************************************************
Actualisation des fonctions de dommages
************************************************************************
Les fonctions de dommages disponibles à ce jour sur le site du ministère de la Transition écologique, évoquent des coûts datés de 2016, qui ne sont plus à jour en raison de l'inflation constatée ces dernières années et ne prennent donc pas en compte la valeur de l'euro en temps réel.
Il est recommandé au guide AMC (page 91), ainsi que par Christophe, d'actualiser les valeurs et de les exprimer en euros de l'année en cours dans la mesure du possible, afin de pouvoir traiter les différents indicateurs de dommages monétaires de façon comparable.

Pour les logements, l'actualisation est réalisée, sur recommandation de Christophe, à partir des données INSEE suivantes, au prorata de l'évolution entre l'indice le plus récent et l'indice de 2016 :
* pour la construction : Indice INSEE du Coût de la Construction (ICC) (référence : base 100 au 4e trimestre 1953) :
	- description : https://www.insee.fr/fr/metadonnees/source/indicateur/p1626/description
	- note méthodologique : https://www.insee.fr/fr/statistiques/documentation/icc_m_juin2022.pdf
	- indices parus au JO = valeurs proposées comme références pour l'actualisation des coûts de dommages au bâti : https://www.anil.org/outils/indices-et-plafonds/indice-insee-du-cout-de-la-construction
	- moyennes par trimestre des 4 derniers indices : https://www.insee.fr/fr/statistiques/serie/000604030
	- statistiques pour les immeubles à usage d'habitation : https://www.insee.fr/fr/statistiques/serie/000008630
	- exemple ICC premier trimestre 2021 : https://www.insee.fr/fr/statistiques/5396226
* pour le mobilier = Indice INSEE mensuel des Prix à la Consommation (IPC) (référence : base 100 en 2015) :
	- description : https://www.insee.fr/fr/metadonnees/source/indicateur/p1653/description
	- indices parus au JO = valeurs proposées comme références pour l'actualisation des coûts de dommages au mobilier : https://www.economie.gouv.fr/dgccrf/publications/juridiques/panorama-des-textes/Indice-des-prix-a-la-consommation

Les valeurs prises pour l'actualisation au 4e trimestre 2021 dans le cadre du projet AgiRisk, sont les suivantes :
* pour les dommages au bâti :
	ICC T4 2016 = 1645 - source : https://www.anil.org/outils/indices-et-plafonds/indice-insee-du-cout-de-la-construction
	ICC T4 2021 = 1886 - source : https://www.anil.org/outils/indices-et-plafonds/indice-insee-du-cout-de-la-construction
	soit +14,65% (formule : [ICC 2021 - ICC 2016] / ICC 2016)
* pour les dommages au mobilier :
	IPC dec2016 = 100,65 (IPC mensuel de l'ensemble des ménages paru au JO du 13/01/2017) - source : https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000033861371
	IPC dec2021 = 107,85 (IPC mensuel de l'ensemble des ménages paru au JO du 15/01/2022) - source : https://www.legifrance.gouv.fr/jorf/id/JORFTEXT000044993301
	soit +7,15% (formule : [IPC 2021 - IPC 2016] / IPC 2016) */

BEGIN
	heure1 = clock_timestamp();
	
	--************************************************************************
	-- Définition des schémas de travail
	--************************************************************************
    SET search_path TO public, c_general, c_phenomenes, c_occupation_sol, r_ign_bdtopo, r_cerema_acb;

    RAISE NOTICE '';
    RAISE NOTICE '====== RAPPORT ======';
    RAISE NOTICE 'Calcul de l''indicateur S2/2a (montant des dommages aux logements) sur le territoire "%" pour l''aléa "% - %", en euros de l''année %', nom_ter, typ_alea, code_occ, an_fct_dmg;
    RAISE NOTICE 'Début du traitement : %', heure1;

    --************************************************************************
    -- Vérification de l'existence du territoire renseigné dans la table c_general.territoires
    --************************************************************************
    IF NOT EXISTS(
        SELECT *
        FROM c_general.territoires
        WHERE territoire = ''||nom_ter||''
    )
    THEN
        RAISE EXCEPTION 'Il n''existe pas de territoire "%" dans la table c_general.territoires. Fin de l''exécution', nom_ter;
    END IF;

    --************************************************************************
    -- Vérification de l'absence dans la table p_indicateurs.s2_2a_amc à la fois du territoire, du type d'aléa et de l'occurrence de crue renseignés
	--************************************************************************
	IF EXISTS(
		SELECT *
		FROM p_indicateurs.s2_2a_amc_lucie
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il existe déjà des enregistrements pour le territoire "%" et l''aléa "% - %" dans la table p_indicateurs.s2_2a_amc_lucie. 
		Pour les supprimer, lancer la requête suivante : 
		DELETE FROM p_indicateurs.s2_2a_amc_lucie WHERE territoire = ''%'' AND type_alea = ''%'' AND code_occurrence = ''%'';', nom_ter, typ_alea, code_occ, REPLACE(nom_ter,'''',''''''), REPLACE(typ_alea,'''',''''''), REPLACE(code_occ,'''','''''');
	END IF;

    --************************************************************************
    -- Vérification de l'existence d'une table c_occupation_sol.oc2_amc pour le territoire renseigné
	--************************************************************************
	IF NOT EXISTS(
		SELECT *
		FROM c_occupation_sol.oc2_amc
		WHERE territoire = ''||nom_ter||''
	)
	THEN
		RAISE EXCEPTION 'Il n''existe pas de table oc2_amc pour le territoire "%" dans le schéma c_occupation_sol. Fin de l''exécution', nom_ter;
	END IF;

    --************************************************************************
    -- Vérification de l'existence d'une table c_phenomenes.zx pour le territoire, le type d'aléa et l'occurrence de crue renseignés
	--************************************************************************
	IF NOT EXISTS(
		SELECT *
		FROM c_phenomenes.zx
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
		RAISE EXCEPTION 'Il n''existe pas de table zx pour le territoire "%" et l''aléa "% - %" dans le schéma c_phenomenes. Fin de l''exécution', nom_ter, typ_alea, code_occ;
	END IF;

	--************************************************************************
	-- ÉTAPE 1 : CROISEMENT DE LA COUCHE DES LOGEMENTS AVEC LES COUCHES DU SCHÉMA C_PHENOMENES
	--************************************************************************
	/* L'idéal pour le calcul du coût des dommages est de disposer d'une couche des zones inondables par classes de hauteurs d'eau et d'une table fournissant une durée de submersion, les fonctions de dommages étant conçues selon de tels champs.
	La première étape consiste donc à vérifier l'existence d'une table Zh, puis d'une table Zf, dans le schéma c_phenomenes.
	Les réponses apportées par le présent script aux différents cas de figure qui peuvent être rencontrés, sont les suivantes :
	-- Si Zh calculé : attribution des classes de hauteurs d'eau aux logements selon leur localisation et proportionnellement à l'emprise de chaque aléa sur ces derniers (par exemple, si un bâtiment à usage d'habitation est "coupé en deux" avec deux classes de hauteurs d'eau différentes, le script retiendra deux enregistrements pour le même logement, avec pour chacun de ces enregistrements, un montant des dommages dépendant de la classe de hauteur d'eau et au prorata de la surface d'aléa impactant le bâtiment).
	-- Si Zh non calculé : utilisation de la couche des zones d'aléa Zq avec la catégorisation arbitraire suivante des niveaux d'aléa selon les hauteurs d'eau, en sachant qu'en réalité, il faut également tenir compte de la dynamique, objet de la variable Zs : aléa Faible = 0 à 0,5m / aléa Moyen ou Modéré = 0,5 à 1m / aléa Fort = 1 à 2m / aléa Très Fort > 2m.
	-- Si Zh et Zq n'existent pas : pas de calcul possible pour l'indicateur S2/2a (un croisement avec Zx sans distinction des niveaux d'aléa ou des hauteurs d'eau serait peu pertinent car il faudrait se baser sur un plafond haut des coûts de dommages, ce qui entraînerait une sur-estimation peu représentative de la réalité).
	-- Si Zf calculé : attribution de la durée de submersion contenue dans Zf.
	-- Si Zf non calculé : attribution d'une durée de submersion de manière arbitraire, en sachant que la durée de submersion est dépendante de nombreux facteurs lié au contexte hydrographique du secteur, et non seulement de la nature des cours d'eau et de la période de retour des crues. Proposition traduite dans le présent script : <48h pour ruissellement/coulée d'eau boueuse et débordement de cours d'eau d'occurrence inférieure à 30 (crues fréquentes), >48h pour débordement de cours d'eau type fleuve hors crues fréquentes, >48h (hypothèse la plus pénalisante) dans les autres cas. */

    -- Vérification de l'existence d'une table c_phenomenes.zh pour le territoire, le type d'aléa et l'occurrence de crue renseignés
	IF EXISTS(
		SELECT *
		FROM c_phenomenes.zh
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
	--************************************************************************
	-- Méthode de calcul avec couche Zh existante dans le schéma c_phenomenes
	--************************************************************************
	RAISE NOTICE 'Tables Zx et Zh existantes pour le territoire "%" et l''aléa "% - %". Poursuite du traitement', nom_ter, typ_alea, code_occ;

	-- Zh calculé / Étape 1a : intersection du fichier de points localisant les logements produit par Christophe avec la couche Zh et récupération de la géométrie d'Oc1 pour avoir obtenir dans le résultat de l'indicateur, et a fortiori dans la représentation cartographique, des polygones, plutôt que des points, représentant les bâtiments d'habitation
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 1a : intersection de la couche des logements avec Zh (classes de hauteur d''eau)';
	
		-- Identification des logements dans Zh
        EXECUTE 'INSERT INTO p_indicateurs.s2_2a_amc_lucie(
					territoire,
					loc_zx,
					type_alea,
					code_occurrence,
					h_eau_min,
					h_eau_max,
					id_bdt,
					nb_logts_ind,
					nb_appts,
					id_logt,
					type_logt,
					niv_logt,
					typo_acb,
					surf_polygon_tot,
					surf_polygon_alea,
					surf_rdc_rect_tot,
					sous_sol,
					surf_ssol_tot_bat,
					surf_ssol_rap_logt,
					date_actu_cout_dmg,
					sce_donnee,
					date_calc,
					moda_calc,
					geom,
					geomloc
					)
				SELECT
					zh.territoire AS territoire,
					''In'' AS loc_zx,
					zh.type_alea AS type_alea,
					zh.code_occurrence AS code_occurrence,
					zh.h_eau_min AS h_eau_min,
					zh.h_eau_max AS h_eau_max,
					oc2.id_bdt AS id_bdt,
					oc2.nb_logts_ind AS nb_logts_ind,
					oc2.nb_appts AS nb_appts,
					oc2.id_logt AS id_logt,
					oc2.type_logt AS type_logt,
					oc2.niv_logt AS niv_logt,
	                oc2.typo_acb AS typo_acb,
					oc2.surf_polygon_tot AS surf_polygon_tot,
					ROUND(CAST(ST_Area(ST_Intersection(oc2.geom, zh.geom)) AS numeric),2) AS surf_polygon_alea,
					oc2.surf_rdc_rect_tot AS surf_rdc_rect_tot,
					oc2.sous_sol AS sous_sol,
					oc2.surf_ssol_tot_bat AS surf_ssol_tot_bat,
					oc2.surf_ssol_rap_logt AS surf_ssol_rap_logt,
					'||an_fct_dmg||' AS date_actu_cout_dmg,
					oc2.sce_donnee,
					current_date AS date_calc,
	                ''__indic_s2_2a_amc_lucie''::varchar(50) AS moda_calc,
					oc2.geom AS geom,
					oc2.geomloc AS geomloc
                FROM oc2_amc AS oc2, c_phenomenes.zh
                WHERE ST_Intersects(oc2.geom, zh.geom)
					AND __util_to_snake_case(oc2.territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(zh.territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(zh.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(zh.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				GROUP BY zh.territoire,
					loc_zx,
					zh.type_alea,
					zh.code_occurrence,
					zh.h_eau_min,
					zh.h_eau_max,
					oc2.id_bdt,
					oc2.nb_logts_ind,
					oc2.nb_appts,
					oc2.id_logt,
					oc2.type_logt,
					oc2.niv_logt,
					oc2.typo_acb,
					oc2.surf_polygon_tot,
					surf_polygon_alea,
					oc2.surf_rdc_rect_tot,
					oc2.sous_sol,
					oc2.surf_ssol_tot_bat,
					oc2.surf_ssol_rap_logt,
					oc2.sce_donnee,
					oc2.geom,
					oc2.geomloc
				';
		
		-- Calcul de la proportion exposée à l'aléa de surface de local en rez-de-chaussée rectifiée à l'aide de la BD TOPO®
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET surf_rdc_rect_alea = ROUND(CAST(surf_rdc_rect_tot * (surf_polygon_alea / surf_polygon_tot) AS numeric),2)
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND loc_zx = ''In''
				AND typo_acb <> ''AUTRE''';
		
		-- Calcul de la proportion de surface de sous-sol exposée à l'aléa
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET surf_ssol_alea = ROUND(CAST(surf_ssol_rap_logt * (surf_polygon_alea / surf_polygon_tot) AS numeric),2)
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';
	
	-- Zh calculé / Étape 1b : récupération des logements situés hors zone inondable
	RAISE NOTICE 'Etape 1b : récupération des logements situés hors zone inondable sur le territoire "%"', nom_ter;
	
		-- Identification des logements hors Zx
        EXECUTE 'INSERT INTO p_indicateurs.s2_2a_amc_lucie(
					territoire,
					loc_zx,
					type_alea,
					code_occurrence,
					h_eau_min,
					h_eau_max,
					id_bdt,
					nb_logts_ind,
					nb_appts,
					id_logt,
					type_logt,
					niv_logt,
					typo_acb,
					surf_polygon_tot,
					surf_rdc_rect_tot,
					sous_sol,
					surf_ssol_tot_bat,
					surf_ssol_rap_logt,
					date_actu_cout_dmg,
					sce_donnee,
					date_calc,
					moda_calc,
					geom,
					geomloc
					)
				SELECT
					zx.territoire AS territoire,
					''Out'' AS loc_zx,
					zx.type_alea AS type_alea,
					zx.code_occurrence AS code_occurrence,
					0 AS h_eau_min,
					0 AS h_eau_max,
					oc2.id_bdt AS id_bdt,
					oc2.nb_logts_ind AS nb_logts_ind,
					oc2.nb_logts_ind AS nb_appts,
					oc2.id_logt AS id_logt,
					oc2.type_logt AS type_logt,
					oc2.niv_logt AS niv_logt,
	                oc2.typo_acb AS typo_acb,
					oc2.surf_polygon_tot AS surf_polygon_tot,
					oc2.surf_rdc_rect_tot AS surf_rdc_rect_tot,
					oc2.sous_sol AS sous_sol,
					oc2.surf_ssol_tot_bat AS surf_ssol_tot_bat,
					oc2.surf_ssol_rap_logt AS surf_ssol_rap_logt,
					'||an_fct_dmg||' AS date_actu_cout_dmg,
					oc2.sce_donnee,
					current_date AS date_calc,
	                ''__indic_s2_2a_amc_lucie''::varchar(50) AS moda_calc,
					oc2.geom AS geom,
					oc2.geomloc AS geomloc
                FROM oc2_amc AS oc2, c_phenomenes.zx
                WHERE NOT ST_Intersects(oc2.geom, zx.geom)
					AND __util_to_snake_case(oc2.territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(zx.territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				GROUP BY zx.territoire,
					loc_zx,
					zx.type_alea,
					zx.code_occurrence,
					h_eau_min,
					h_eau_max,
					oc2.id_bdt,
					oc2.nb_logts_ind,
					oc2.nb_appts,
					oc2.id_logt,
					oc2.type_logt,
					oc2.niv_logt,
					oc2.typo_acb,
					oc2.surf_polygon_tot,
					oc2.surf_rdc_rect_tot,
					oc2.sous_sol,
					oc2.surf_ssol_tot_bat,
					oc2.surf_ssol_rap_logt,
					oc2.sce_donnee,
					oc2.geom,
					oc2.geomloc
				';
	
	-- Zh calculé / Étape 1c : attribution d'un niveau d'aléa de manière arbitraire en fonction de la hauteur d'eau, mais ne tenant pas compte de la dynamique
	RAISE NOTICE 'Etape 1c : attribution d''un niveau d''aléa arbitraire en fonction de la hauteur d''eau, mais ne tenant pas compte de la dynamique';
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET intensite_alea = (
				CASE
					WHEN h_eau_max = 0 THEN ''nulle''
					WHEN h_eau_max = 50 THEN ''faible''
					WHEN h_eau_max = 100 THEN ''moyen''
					WHEN h_eau_max = 150 OR h_eau_max = 200 THEN ''fort''
					WHEN h_eau_max = 999 THEN ''très fort''
					ELSE intensite_alea
			END)
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND date_actu_cout_dmg = '''||an_fct_dmg||'''';
	
	ELSE
	--************************************************************************
	-- Méthode de calcul avec couche Zq, en l'absence de couche Zh dans le schéma c_phenomenes
	--************************************************************************
	RAISE NOTICE 'Aucune couche Zh n''est disponible pour le territoire ''%'' et l''aléa ''% - %''. Vérification de l''existence d''une couche Zq dans le schéma c_phenomenes', nom_ter, typ_alea, code_occ;
	-- Vérification de l'existence d'une table c_phenomenes.zq pour le territoire, le type d'aléa et l'occurrence de crue renseignés
	IF EXISTS(
		SELECT *
		FROM c_phenomenes.zq
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
   	RAISE NOTICE 'Tables Zx et Zq existantes pour le territoire ''%'' et l''aléa ''% - %''. Poursuite du traitement', nom_ter, typ_alea, code_occ;
	
	-- Zh non calculé / Zq calculé / Étape 1a : intersection du fichier de points localisant les logements produit par Christophe avec la couche Zq et récupération de la géométrie d'Oc1 pour avoir obtenir dans le résultat de l'indicateur, et a fortiori dans la représentation cartographique, des polygones, plutôt que des points, représentant les bâtiments d'habitation
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 1a : intersection de la couche des logements avec Zq (zones d''intensité de l''aléa)';
	
		-- Identification des logements dans Zq
        EXECUTE 'INSERT INTO p_indicateurs.s2_2a_amc_lucie(
					territoire,
					loc_zx,
					type_alea,
					code_occurrence,
					intensite_alea,
					id_bdt,
					nb_logts_ind,
					nb_appts,
					id_logt,
					type_logt,
					niv_logt,
					typo_acb,
					surf_polygon_tot,
					surf_polygon_alea,
					surf_rdc_rect_tot,
					sous_sol,
					surf_ssol_tot_bat,
					surf_ssol_rap_logt,
					date_actu_cout_dmg,
					sce_donnee,
					date_calc,
					moda_calc,
					geom,
					geomloc
					)
				SELECT
					zq.territoire AS territoire,
					''In'' AS loc_zx,
					zq.type_alea AS type_alea,
					zq.code_occurrence AS code_occurrence,
					zq.intensite_alea AS intensite_alea,
					oc2.id_bdt AS id_bdt,
					oc2.nb_logts_ind AS nb_logts_ind,
					oc2.nb_appts AS nb_appts,
					oc2.id_logt AS id_logt,
					oc2.type_logt AS type_logt,
					oc2.niv_logt AS niv_logt,
	                oc2.typo_acb AS typo_acb,
					oc2.surf_polygon_tot AS surf_polygon_tot,
					CASE
						WHEN ST_Within(oc2.geom,zq.geom) THEN ST_Area(oc2.geom)
						ELSE ROUND(CAST(ST_Area(ST_Intersection(oc2.geom, zq.geom)) AS numeric),2)
					END AS surf_polygon_alea,
					oc2.surf_rdc_rect_tot AS surf_rdc_rect_tot,
					oc2.sous_sol AS sous_sol,
					oc2.surf_ssol_tot_bat AS surf_ssol_tot_bat,
					oc2.surf_ssol_rap_logt AS surf_ssol_rap_logt,
					'||an_fct_dmg||' AS date_actu_cout_dmg,
					oc2.sce_donnee,
					current_date AS date_calc,
	                ''__indic_s2_2a_amc_lucie''::varchar(50) AS moda_calc,
					oc2.geom AS geom,
					oc2.geomloc AS geomloc
                FROM oc2_amc AS oc2, c_phenomenes.zq
                WHERE ST_Intersects(oc2.geom, zq.geom)
					AND __util_to_snake_case(oc2.territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(zq.territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(zq.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(zq.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				GROUP BY zq.territoire,
					loc_zx,
					zq.type_alea,
					zq.code_occurrence,
					zq.intensite_alea,
					oc2.id_bdt,
					oc2.nb_logts_ind,
					oc2.nb_appts,
					oc2.id_logt,
					oc2.type_logt,
					oc2.niv_logt,
					oc2.typo_acb,
					oc2.surf_polygon_tot,
					surf_polygon_alea,
					oc2.surf_rdc_rect_tot,
					oc2.sous_sol,
					oc2.surf_ssol_tot_bat,
					oc2.surf_ssol_rap_logt,
					oc2.sce_donnee,
					oc2.geom,
					oc2.geomloc
				';
        
		-- Calcul de la proportion exposée à l'aléa de surface de local en rez-de-chaussée rectifiée à l'aide de la BD TOPO®
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET surf_rdc_rect_alea = ROUND(CAST(surf_rdc_rect_tot * (surf_polygon_alea / surf_polygon_tot) AS numeric),2)
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND loc_zx = ''In''
				AND typo_acb <> ''AUTRE''';
	
		-- Calcul de la proportion de surface de sous-sol exposée à l'aléa
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET surf_ssol_alea = ROUND(CAST(surf_ssol_rap_logt * (surf_polygon_alea / surf_polygon_tot) AS numeric),2)
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''';
	
	-- Zh non calculé / Zq calculé / Étape 1b : récupération des logements situés hors zone inondable
	RAISE NOTICE 'Etape 1b : récupération des logements situés hors zone inondable sur le territoire ''%''', nom_ter;
	
		--Identification des logements hors Zx
		EXECUTE 'INSERT INTO p_indicateurs.s2_2a_amc_lucie(
					territoire,
					loc_zx,
					type_alea,
					code_occurrence,
					intensite_alea,
					id_bdt,
					nb_logts_ind,
					nb_appts,
					id_logt,
					type_logt,
					niv_logt,
					typo_acb,
					surf_polygon_tot,
					surf_rdc_rect_tot,
					sous_sol,
					surf_ssol_tot_bat,
					surf_ssol_rap_logt,
					date_actu_cout_dmg,
					sce_donnee,
					date_calc,
					moda_calc,
					geom,
					geomloc
					)
				SELECT 
					zx.territoire AS territoire,
					''Out'' AS loc_zx,
					zx.type_alea AS type_alea,
					zx.code_occurrence AS code_occurrence,
					''nulle'' AS intensite_alea,
					oc2.id_bdt AS id_bdt,
					oc2.nb_logts_ind AS nb_logts_ind,
					oc2.nb_appts AS nb_appts,
					oc2.id_logt AS id_logt,
					oc2.type_logt AS type_logt,
					oc2.niv_logt AS niv_logt,
	                oc2.typo_acb AS typo_acb,
					oc2.surf_polygon_tot AS surf_polygon_tot,
					oc2.surf_rdc_rect_tot AS surf_rdc_rect_tot,
					oc2.sous_sol AS sous_sol,
					oc2.surf_ssol_tot_bat AS surf_ssol_tot_bat,
					oc2.surf_ssol_rap_logt AS surf_ssol_rap_logt,
					'||an_fct_dmg||' AS date_actu_cout_dmg,
					oc2.sce_donnee,
					current_date AS date_calc,
	                ''__indic_s2_2a_amc_lucie''::varchar(50) AS moda_calc,
					oc2.geom AS geom,
					oc2.geomloc AS geomloc
                FROM oc2_amc AS oc2, c_phenomenes.zx
                WHERE NOT ST_Intersects(oc2.geom, zx.geom)
					AND __util_to_snake_case(oc2.territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(zx.territoire) = '''||__util_to_snake_case(nom_ter)||'''
					AND __util_to_snake_case(zx.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
					AND __util_to_snake_case(zx.code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				GROUP BY zx.territoire,
					loc_zx,
					zx.type_alea,
					zx.code_occurrence,
					intensite_alea,
					oc2.id_bdt,
					oc2.nb_logts_ind,
					oc2.nb_appts,
					oc2.id_logt,
					oc2.type_logt,
					oc2.niv_logt,
					oc2.typo_acb,
					oc2.surf_polygon_tot,
					oc2.surf_rdc_rect_tot,
					oc2.sous_sol,
					oc2.surf_ssol_tot_bat,
					oc2.surf_ssol_rap_logt,
					oc2.sce_donnee,
					oc2.geom,
					oc2.geomloc
				';
	
	-- Zh non calculé / Zq calculé / Étape 1c : attribution de hauteurs d'eau min et max de manière arbitraire en fonction de l'intensité de l'aléa, mais ne tenant pas compte de la dynamique
	RAISE NOTICE 'Etape 1c : attribution de hauteurs d''eau arbitraires en fonction de l''intensité de l''aléa, mais ne tenant pas compte de la dynamique';
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET h_eau_min = (
				CASE
					WHEN intensite_alea = ''nulle'' OR intensite_alea = ''faible'' THEN 0
					WHEN intensite_alea = ''moyen'' THEN 50
					WHEN intensite_alea = ''fort'' THEN 100
					WHEN intensite_alea = ''très fort'' THEN 200
					ELSE h_eau_min
			END)
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND date_actu_cout_dmg = '''||an_fct_dmg||'''';
		
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET h_eau_max = (
				CASE
					WHEN intensite_alea = ''nulle'' THEN 0
					WHEN intensite_alea = ''faible'' THEN 50
					WHEN intensite_alea = ''moyen'' THEN 100
					WHEN intensite_alea = ''fort'' THEN 200
					WHEN intensite_alea = ''très fort'' THEN 999
					ELSE h_eau_max
			END)
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND date_actu_cout_dmg = '''||an_fct_dmg||'''';
	
	ELSE
		RAISE NOTICE 'Aucune couche Zh ou Zq n''est disponible pour le territoire ''%'' et l''aléa ''% - %'' dans le schéma c_phenomenes. Fin de l''exécution', nom_ter, typ_alea, code_occ;
	END IF;
	END IF;

    --************************************************************************
	-- ÉTAPE 2 : ATTRIBUTION DES CODES ET DES NOMS DE PÉRIMÈTRES ADMINISTRATIFS
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 2 : attribution des codes et des noms de périmètres administratifs';
	
	-- a. Récupération des codes et noms des IRIS
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET id_iris = zt.id_iris, nom_iris = zt.libelle
			FROM c_phenomenes.zt
			WHERE ST_Intersects(s2_2a_amc_lucie.geom, zt.geom)
				AND s2_2a_amc_lucie.date_actu_cout_dmg = '''||an_fct_dmg||'''
				AND __util_to_snake_case(s2_2a_amc_lucie.territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(s2_2a_amc_lucie.type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(s2_2a_amc_lucie.code_occurrence) = '''||__util_to_snake_case(code_occ)||''''; -- conditions ajoutées pour réduire le temps de calcul aux seules entités associées au territoire et à l'aléa renseignés
		RAISE NOTICE 'Récupération des codes et noms des IRIS effectuée';

	-- b. Attribution des codes INSEE et noms de communes
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET id_commune = com.insee_com, nom_commune = com.nom
			FROM c_phenomenes.zt, commune_'||an_bdtopo||' AS com
			WHERE s2_2a_amc_lucie.id_iris = zt.id_iris
				AND zt.id_commune = com.insee_com
				AND s2_2a_amc_lucie.date_actu_cout_dmg = '''||an_fct_dmg||'''
				AND __util_to_snake_case(s2_2a_amc_lucie.territoire) = '''||__util_to_snake_case(nom_ter)||''''; -- condition ajoutée pour réduire le temps de calcul aux seules entités associées au territoire renseigné
		RAISE NOTICE 'Attribution des codes INSEE et noms de communes effectuée';

	-- c. Attribution des codes et noms des EPCI
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET id_epci = epci.code_siren, nom_epci = epci.nom
			FROM c_phenomenes.zt, epci_'||an_bdtopo||' AS epci
			WHERE s2_2a_amc_lucie.id_iris = zt.id_iris
				AND zt.id_epci = epci.code_siren
				AND s2_2a_amc_lucie.date_actu_cout_dmg = '''||an_fct_dmg||'''
				AND __util_to_snake_case(s2_2a_amc_lucie.territoire) = '''||__util_to_snake_case(nom_ter)||''''; -- condition ajoutée pour réduire le temps de calcul aux seules entités associées au territoire renseigné
		RAISE NOTICE 'Attribution des codes et noms des EPCI effectuée';

    --************************************************************************
	-- ÉTAPE 3 : RENOMMAGE DES TYPES D'ALÉA CONFORMÉMENT À LA NOMENCLATURE DES FONCTIONS DE DOMMAGES
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 3 : attribution d''un nom de type d''aléa conforme à la nomenclature des fonctions de dommages';
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET type_alea_fct_dmg =
				CASE
					WHEN type_alea LIKE ''%bordement%'' OR type_alea LIKE ''%fluvial%'' THEN ''fluvial''
					WHEN type_alea LIKE ''%ubmersi%'' OR type_alea LIKE ''%marin%'' THEN ''marin''
			END
			WHERE __util_to_snake_case(territoire) = '''||__util_to_snake_case(nom_ter)||'''
				AND __util_to_snake_case(type_alea) = '''||__util_to_snake_case(typ_alea)||'''
				AND __util_to_snake_case(code_occurrence) = '''||__util_to_snake_case(code_occ)||'''
				AND date_actu_cout_dmg = '''||an_fct_dmg||'''';

    --************************************************************************
	-- ÉTAPE 4 : ATTRIBUTION DE LA DURÉE DE SUBMERSION
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE 'Etape 4 : attribution de la durée de submersion. Vérification de l''existence d''une table Zf dans le schéma c_phenomenes';

    -- Vérification de l'existence d'une table Zf dans le schéma c_phenomenes
	IF EXISTS(
		SELECT *
		FROM c_phenomenes.zf
		WHERE territoire = ''||nom_ter||''
			AND type_alea = ''||typ_alea||''
			AND code_occurrence = ''||code_occ||''
	)
	THEN
	-- Si Zf calculé : attribution de la durée de submersion contenue dans Zf
	RAISE NOTICE 'Table Zf existante pour le territoire ''%''. Poursuite du traitement', nom_ter;
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET duree_subm = zf.duree_subm
			FROM c_phenomenes.zf
			WHERE __util_to_snake_case(zf.territoire) = ''' || __util_to_snake_case(nom_ter) || '''
				AND __util_to_snake_case(s2_2a_amc_lucie.territoire) = __util_to_snake_case(zf.territoire)
				AND __util_to_snake_case(zf.type_alea) = ''' || __util_to_snake_case(typ_alea) || '''
				AND __util_to_snake_case(s2_2a_amc_lucie.type_alea) = __util_to_snake_case(zf.type_alea)
				AND __util_to_snake_case(zf.code_occurrence) = ''' || __util_to_snake_case(code_occ) || '''
				AND __util_to_snake_case(s2_2a_amc_lucie.code_occurrence) = __util_to_snake_case(zf.code_occurrence)
				AND s2_2a_amc_lucie.date_actu_cout_dmg = '''|| an_fct_dmg ||'''';

	ELSE
	-- Si Zf non calculé : attribution d'une durée de submersion de manière arbitraire en fonction de la nature de l''aléa renseigné (proposition : <48h pour ruissellement/coulée d'eau boueuse et débordement de cours d'eau d'occurrence inférieure à 30 (crues fréquentes), >48h pour débordement de cours d'eau type fleuve hors crues fréquentes, >48h (hypothèse la plus pénalisante) dans les autres cas)
	RAISE NOTICE 'Aucune couche Zf n''est disponible pour le territoire ''%'' dans le schéma c_phenomenes. Attribution d''une durée de submersion arbitraire en fonction de la nature de l''aléa renseigné', nom_ter;
		EXECUTE '
			UPDATE p_indicateurs.s2_2a_amc_lucie
			SET duree_subm =
			CASE
				WHEN type_alea_fct_dmg = ''fluvial''
					AND (
						code_occurrence LIKE ''%Q2%''      -- nécessite d''avoir un nommage des codes d''occurrences "Qx" rigoureux
						OR code_occurrence LIKE ''%Q5%''   -- nécessite d''avoir un nommage des codes d''occurrences "Qx" rigoureux
						OR code_occurrence LIKE ''%Q10%''  -- nécessite d''avoir un nommage des codes d''occurrences "Qx" rigoureux
						OR code_occurrence LIKE ''%Q20%''  -- nécessite d''avoir un nommage des codes d''occurrences "Qx" rigoureux
						OR code_occurrence LIKE ''%Q30%''  -- nécessite d''avoir un nommage des codes d''occurrences "Qx" rigoureux
						)
					THEN ''<48h''
				ELSE ''>48h''
			END
			WHERE __util_to_snake_case(territoire) = ''' || __util_to_snake_case(nom_ter) || '''
				AND __util_to_snake_case(type_alea) = ''' || __util_to_snake_case(typ_alea) || '''
				AND __util_to_snake_case(code_occurrence) = ''' || __util_to_snake_case(code_occ) || '''
				AND date_actu_cout_dmg = '''|| an_fct_dmg ||'''';

	END IF;

	--************************************************************************
	-- ÉTAPE 5 : CALCUL POUR CHAQUE ENTITÉ DU COÛT DES DOMMAGES AU BÂTI (A), DU COÛT DES DOMMAGES AU MOBILIER (B), DU COÛT DES DOMMAGES AUX SOUS-SOLS (C) ET DU COÛT TOTAL DES DOMMAGES (D=A+B+C)
	--************************************************************************
	/* PRÉCISIONS :
	Le "type d'aléa" ("fluvial" ou "marin", ainsi qu'il est écrit dans les fonctions de dommages mises à disposition sur le site du ministère de la Transition écologique) est le premier paramètre d'entrée dans les fonctions de dommages.
	Selon le type d'enjeu, on a deux tableurs différents pour chaque type d'aléa, ou une différenciation du type d'aléa dans un champ `alea`.
	Dans l'écosystème AgiRisk, les tableurs des fonctions de dommages ont été retravaillés afin de ne disposer que d'une seule table par type d'enjeu avec toutes les valeurs utiles.
	Il y a donc discrimination sur le type d'aléa dans les scripts qui suivent, et donc autant de scripts qu'il existe de types d'aléa.
	Le deuxième paramètre d'entrée dans les fonctions de dommages est la durée de submersion. */

	RAISE NOTICE '';
	RAISE NOTICE 'Etape 5 : calcul du coût des dommages au bâti, au mobilier et aux sous-sols pour chaque logement identifié à l''étape 1, en fonction du type d''aléa, de la durée de submersion et de la hauteur d''eau';

	-- H(Zx)min
	EXECUTE '
		UPDATE p_indicateurs.s2_2a_amc_lucie
		SET 
			-- Dommages au bâti
			cout_min_dmg_bati =
			CASE
				WHEN s2_2a_amc_lucie.typo_acb = ''INDIVIDUEL SANS ETAGE'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.individuel_sans_etage)
				WHEN s2_2a_amc_lucie.typo_acb = ''INDIVIDUEL AVEC ETAGE'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.individuel_avec_etage)
				WHEN s2_2a_amc_lucie.typo_acb = ''COLLECTIF'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.logement_collectif)
				ELSE cout_min_dmg_bati
			END,
			
			-- Dommages au mobilier
			cout_min_dmg_mob =
			CASE
				WHEN s2_2a_amc_lucie.typo_acb = ''INDIVIDUEL SANS ETAGE'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.mobilier_individuel_sans_etage)
				WHEN s2_2a_amc_lucie.typo_acb = ''INDIVIDUEL AVEC ETAGE'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.mobilier_individuel_avec_etage)
				WHEN s2_2a_amc_lucie.typo_acb = ''COLLECTIF'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.mobilier_logement_collectif)
				ELSE cout_min_dmg_mob
			END,
			
			-- Dommages aux sous-sols
			cout_min_dmg_ssol =
			CASE
				WHEN s2_2a_amc_lucie.type_logt = ''MAISON'' THEN ROUND(s2_2a_amc_lucie.surf_ssol_alea * fct.sous_sol_individuel)
				WHEN s2_2a_amc_lucie.type_logt = ''APPARTEMENT'' THEN ROUND(s2_2a_amc_lucie.surf_ssol_alea * fct.sous_sol_collectif)
				ELSE cout_min_dmg_ssol
			END
			
		FROM r_inrae_amc.fct_dmg_logts_' || an_fct_dmg || ' AS fct
		WHERE
			fct.alea IN (''fluvial'', ''marin'')
			AND fct.alea = s2_2a_amc_lucie.type_alea_fct_dmg
			AND fct.duree_submersion IN (''<48h'',''>48h'')
			AND fct.duree_submersion = s2_2a_amc_lucie.duree_subm
			AND fct.unite_cout = ''surfacique''
			AND s2_2a_amc_lucie.loc_zx = ''In''
			AND s2_2a_amc_lucie.h_eau_min >= fct.h_eau_min
			AND s2_2a_amc_lucie.h_eau_min <= fct.h_eau_max
			AND __util_to_snake_case(s2_2a_amc_lucie.territoire) = ''' || __util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s2_2a_amc_lucie.type_alea) = ''' || __util_to_snake_case(typ_alea) || '''
			AND __util_to_snake_case(s2_2a_amc_lucie.code_occurrence) = ''' || __util_to_snake_case(code_occ) || '''
			AND s2_2a_amc_lucie.date_actu_cout_dmg = '''|| an_fct_dmg ||'''
		';

	-- H(Zx)max
	EXECUTE '
		UPDATE p_indicateurs.s2_2a_amc_lucie
		SET 
			-- Dommages au bâti
			cout_max_dmg_bati =
			CASE
				WHEN s2_2a_amc_lucie.typo_acb = ''INDIVIDUEL SANS ETAGE'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.individuel_sans_etage)
				WHEN s2_2a_amc_lucie.typo_acb = ''INDIVIDUEL AVEC ETAGE'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.individuel_avec_etage)
				WHEN s2_2a_amc_lucie.typo_acb = ''COLLECTIF'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.logement_collectif)
				ELSE cout_max_dmg_bati
			END,
			
			-- Dommages au mobilier
			cout_max_dmg_mob =
			CASE
				WHEN s2_2a_amc_lucie.typo_acb = ''INDIVIDUEL SANS ETAGE'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.mobilier_individuel_sans_etage)
				WHEN s2_2a_amc_lucie.typo_acb = ''INDIVIDUEL AVEC ETAGE'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.mobilier_individuel_avec_etage)
				WHEN s2_2a_amc_lucie.typo_acb = ''COLLECTIF'' THEN ROUND(s2_2a_amc_lucie.surf_rdc_rect_alea * fct.mobilier_logement_collectif)
				ELSE cout_max_dmg_mob
			END,
			
			-- Dommages aux sous-sols
			cout_max_dmg_ssol =
			CASE
				WHEN s2_2a_amc_lucie.type_logt = ''MAISON'' THEN ROUND(s2_2a_amc_lucie.surf_ssol_alea * fct.sous_sol_individuel)
				WHEN s2_2a_amc_lucie.type_logt = ''APPARTEMENT'' THEN ROUND(s2_2a_amc_lucie.surf_ssol_alea * fct.sous_sol_collectif)
				ELSE cout_max_dmg_ssol
			END
			
		FROM r_inrae_amc.fct_dmg_logts_' || an_fct_dmg || ' AS fct
		WHERE
			fct.alea IN (''fluvial'', ''marin'')
			AND fct.alea = s2_2a_amc_lucie.type_alea_fct_dmg
			AND fct.duree_submersion IN (''<48h'',''>48h'')
			AND fct.duree_submersion = s2_2a_amc_lucie.duree_subm
			AND fct.unite_cout = ''surfacique''
			AND s2_2a_amc_lucie.loc_zx = ''In''
			AND
				(
					(s2_2a_amc_lucie.h_eau_max < 999 AND s2_2a_amc_lucie.h_eau_max >= fct.h_eau_min AND s2_2a_amc_lucie.h_eau_max <= fct.h_eau_max)
				OR
					(fct.h_eau_max = 305 AND s2_2a_amc_lucie.h_eau_max = fct.h_eau_max)
				)
			AND __util_to_snake_case(s2_2a_amc_lucie.territoire) = ''' || __util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(s2_2a_amc_lucie.type_alea) = ''' || __util_to_snake_case(typ_alea) || '''
			AND __util_to_snake_case(s2_2a_amc_lucie.code_occurrence) = ''' || __util_to_snake_case(code_occ) || '''
			AND s2_2a_amc_lucie.date_actu_cout_dmg = '''|| an_fct_dmg ||'''
			';

    --************************************************************************
	-- ÉTAPE 6 : CALCUL DU COÛT TOTAL DES DOMMAGES
	--************************************************************************
	RAISE NOTICE 'Etape 6 : calcul du coût total des dommages pour chaque logement identifié à l''étape 1, en fonction du type d''aléa, de la durée de submersion et de la hauteur d''eau';
	
	EXECUTE '
		UPDATE p_indicateurs.s2_2a_amc_lucie
		SET
			cout_min_dmg_tot = cout_min_dmg_bati + cout_min_dmg_mob + cout_min_dmg_ssol,
			cout_max_dmg_tot = cout_max_dmg_bati + cout_max_dmg_mob + cout_max_dmg_ssol
		WHERE loc_zx = ''In''
			AND __util_to_snake_case(territoire) = ''' || __util_to_snake_case(nom_ter) || '''
			AND __util_to_snake_case(type_alea) = ''' || __util_to_snake_case(typ_alea) || '''
			AND __util_to_snake_case(code_occurrence) = ''' || __util_to_snake_case(code_occ) || '''
			AND date_actu_cout_dmg = '''|| an_fct_dmg ||'''';

	--************************************************************************
	-- Récupère le nombre d'entités ajoutées
	--************************************************************************
	GET DIAGNOSTICS c = row_count;

	--************************************************************************
	-- Conclusion
	--************************************************************************
	RAISE NOTICE '';
	RAISE NOTICE '====== FIN TRAITEMENT ======';
	RAISE NOTICE '[INFO] La table s2_2a_amc_lucie (montant des dommages aux logements en €%) a été mise à jour dans le schéma p_indicateurs pour le territoire ''%'' et l''aléa ''%'' - %', an_fct_dmg, nom_ter, typ_alea, code_occ;
	RAISE NOTICE '';
	RAISE NOTICE '====== RESULTATS ======';
	RAISE NOTICE '% entités ajoutées pour le territoire ''%'' dans p_indicateurs.s2_2a_amc_lucie', c, nom_ter;
	-- RAISE NOTICE 'Création de la vue "%"', 'p_indicateurs.s2_2a_amc_lucie_' || __util_to_snake_case(nom_ter);
	heure2 = clock_timestamp();
	RAISE NOTICE 'Fin du traitement : %', heure2;
	RAISE NOTICE 'Durée du traitement : %', CAST(heure2 as time)-CAST(heure1 as time);
	RAISE NOTICE '';

END;
$function$
