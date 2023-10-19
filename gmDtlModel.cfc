<cfcomponent output="false" hint="T_GENRE_DTL" extends="ies_ng8.model.BaseModel">
	<cffunction name="init"returntype="any" access="public" output="false">

		<cfset super.init()>
		<cfset this.tableName = "T_GENRE_DTL">
		<cfset this.primaryKey = "GENREDTLID">
		<cfset this.autoIncrement = true>
		
		<cfset addField("GENREDTLID", "", "GDTL.GENREDTLID", "Integer", "GENREDTLID", 39, true, false)>
		<cfset addField("GENREID", "", "GDTL.GENREID", "Integer", "GENREID", 39, true, true)>
		<cfset addField("GAMEID", "", "GDTL.GAMEID", "Integer", "GAMEID", 39, true, false)>
		<cfset addField("RECSTATUS", "", "GDTL.RECSTATUS", "VarChar", "RECSTATUS", 2, true, false)>
		<cfset addField("CREATEDBY", "", "GDTL.CREATEDBY", "SYSTEM", "Created By", 10, false, true)>
		<cfset addField("CREATEDDATETIME", "", "GDTL.CREATEDDATETIME", "SYSDATE", "Created Date Time", 11, false, true)>
		<cfset addField("UPDATEDBY", "", "GDTL.UPDATEDBY", "SYSTEM", "Updated By", 10, true, false)>
		<cfset addField("UPDATEDDATETIME", "", "GDTL.UPDATEDDATETIME", "SYSDATE", "Updated Date Time", 11, true, false)>
		<cfset addField("STATUS","","GDTL.STATUS","VarChar","Status",1,true,true)>
		
		<cfset this.tableName2 = application.T_GAME_MSTR>
		<cfset addField("GAMECODE", "", "G.GAMECODE", "VarChar", "Game Code", 100, true,false)>
		<cfset addField("GAMEDESC","","G.GAMEDESC","VarChar","Game Description",200,false, true)>

		<cfreturn this>	
	</cffunction>


	<!--- START: GRID SETUP --->
	<cffunction name="Grid" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
			<cfoutput>
				FROM T_GENRE_DTL GDTL
				INNER JOIN T_GAME_MSTR G ON GDTL.GAMEID = G.GAMEID
				<cfif isDefined("GAMEID")>
					WHERE G.GAMEID = '#GAMEID#'
				<cfelse>
					WHERE G.GAMEID IS NULL
				</cfif>
				AND GDTL.RECSTATUS = '1'
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>

	<cffunction name="activeGrid" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
			<cfoutput>
				FROM T_GENRE_DTL GDTL
				INNER JOIN T_GAME_MSTR G ON GDTL.GAMEID = G.GAMEID
				<!--- <cfif isDefined("GENREID")> --->
					WHERE GDTL.GENREID = '#GENREID#'
				<!--- <cfelse>
					WHERE GDTL.GENREID IS NULL
				</cfif> --->
				AND GDTL.STATUS = 'A'
			</cfoutput>

		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>

	<cffunction name="inactiveGrid" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
			<cfoutput>
				FROM T_GENRE_DTL GDTL
				INNER JOIN T_GAME_MSTR G ON GDTL.GAMEID = G.GAMEID
				<cfif isDefined("GAMEID")>
					WHERE G.GAMEID = '#GAMEID#'
				<cfelse>
					WHERE G.GAMEID IS NULL
				</cfif>
				AND GDTL.STATUS = 'I'
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>

	<cffunction name="getGenreID" returntype ="any" access="public" output="false" >
		<cfargument name="code" required="yes" type="any">
		<cfquery name="GENREID">
		SELECT GENREID
		FROM T_GENRE_MSTR
		WHERE GENRECODE ='#code#'
	</cfquery>
	</cffunction>

	<cffunction name="updateEffEnd" returntype="void" access="public" output="false">
		<cfargument name="key1" required="yes" type="any">
		<cfargument name="key2" required="yes" type="any">

		
		<cfquery name="getDtlIdRev" datasource="#this.source.ds#">
			SELECT GENREDTLID,CREATEDDATETIME
			FROM T_GENRE_DTL GDTL
			WHERE UPPER(GAMEID) = '#UCASE(key2)#'
			-- -- AND (
			-- -- 	(CREATEDDATETIME <= TO_DATE('#key1#','DD/MM/YYYY') 
			-- 	AND UPDATEDDATETIME >= TO_DATE('#key1#','DD/MM/YYYY')) 
			-- 	OR  (CREATEDDATETIME <= TO_DATE('#key1#','DD/MM/YYYY')
			--  AND UPDATEDDATETIME IS NULL)
			-- -- 	)
			-- AND UPDATEDDATETIME IS NULL
		</cfquery>

		<cfif getDtlIdRev.recordcount GT 0>
			<cfset ttdate = "">
			<cfset tempdate = #dateFormat(getDtlIdRev.CREATEDDATETIME, "dd/mm/yyyy")#>
			<cfset UPDATEDDATETIME = #DateFormat(DateAdd("d", -1, "#key1#"), 'dd/mm/yyyy')#>

			<cfif UPDATEDDATETIME LTE tempdate>
				<cfset ttdate = "#tempdate#">
			<cfelse>
				<cfset ttdate = "#UPDATEDDATETIME#">
			</cfif>

			<cfquery name="updateDuty" datasource="#this.source.ds#">
				UPDATE T_GENRE_DTL 
				SET CREATEDDATETIME = TO_DATE('#ttdate#','DD/MM/YYYY')
				WHERE GENREDTLID = '#getDtlIdRev.GENREDTLID#'
			</cfquery>

		</cfif>
	</cffunction> 
<!--- 
	<cffunction name="checkCurrentDate" returntype="string" access="public" output="false">
		<cfargument name="key1" required="yes" type="any">
	
		<cfset date_now = #DateFormat(now(), 'dd/mm/yyyy')#>

		<cfquery name="getId" datasource="#this.source.ds#">
			SELECT GENREDTLID
			FROM T_GENRE_DTL
			WHERE GENREDTLID = '#key1#'
			AND (
				(CREATEDDATIME <= TO_DATE('#date_now#','DD/MM/YYYY') AND UPDATEDDATETIME >= TO_DATE('#date_now#','DD/MM/YYYY')) OR  (CREATEDDATIME <= TO_DATE('#date_now#','DD/MM/YYYY') AND UPDATEDDATETIME IS NULL)
				)
		</cfquery>
		<cfif getId.recordcount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>

	</cffunction>

	 <cffunction name="checkPastDate" returntype="string" access="public" output="false">
		<cfargument name="key1" required="yes" type="any">
	
		<cfset date_now = #DateFormat(now(), 'dd/mm/yyyy')#>

		<cfquery name="getId" datasource="#this.source.ds#">
			SELECT GENREDTLID
			FROM T_GENRE_DTL
			WHERE TAXCODEDTLID = '#key1#'
			AND ((UPDATEDDATETIME <= TO_DATE('#date_now#','DD/MM/YYYY'))
			OR  (CREATEDDATIME <= TO_DATE('#date_now#','DD/MM/YYYY') 
			AND UPDATEDDATETIME IS NULL))
		</cfquery>

		<cfif getId.recordcount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>  --->

	 <cffunction name="checkIsChange" returntype="string" access="public" output="false">
		<cfargument name="gamecode" required="yes" type="any">
		<cfargument name="recno" required="yes" type="any">

		<cfquery name="queryGetRev" datasource="#this.source.ds#">
			SELECT GENREDTLID
			FROM T_GENRE_DTL GDTL
			WHERE UPPER(GAMEID) = '#trim(UCASE(gameid))#'
		</cfquery>

		<cfset isChange = false>
		<cfset recnoNew = #recno# + 1>

		<cfif #queryGetRev.recordcount# neq #recnoNew#>
			<cfset isChange = true>
		</cfif>
		
		<cfreturn isChange> 
	</cffunction>

	<cffunction name="updateRevDtl" returntype="string" access="public" output="false">
		<cfargument name="gamecode" required="yes" type="any">
		 <cfquery name="qryRevNo" datasource="#this.source.ds#">	
			SELECT GENREID
			FROM(
				SELECT GENREID,GENRECODE
				FROM T_GENRE_MSTR
				WHERE UPPER(GENREID) = '#UCASE(GENREID)#'
				ORDER BY GENRECODE DESC
			)Q1
			WHERE rownum = 1
		</cfquery>  


		<cfquery name="selectDtl" datasource="#this.source.ds#">
			SELECT GDTL.GENREDTLID, GDTL.GENREID, GDTL.GAMEID,GDTL.RECSTATUS,GDTL.CREATEDBY, GDTL.CREATEDDATETIME,GDTL.UPDATEDBY, GDTL.UPDATEDDATETIME,GDTL.STATUS
			FROM T_GENRE_DTL GDTL
			WHERE UPPER(GDTL.DTLGAMEID) = '#UCASE(gameid)#'
		</cfquery>

		 <cfloop query="selectDtl">
			<cfquery name="queryUpdate" datasource="#this.source.ds#">
				INSERT INTO T_GENRE_DTL GDTL(
				GDTL.DTLGENREDTLID, GDTL.DTLGENREID, GDTL.DTLGAMEID,GDTL.DTLRECSTATUS,GDTL.DTLCREATEDBY, GDTL.DTLCREATEDDATETIME,GDTL.DTLUPDATEDBY, GDTL.DTLUPDATEDDATETIME,GDTL.DTLSTATUS
				)
				VALUES(
				'#selectDtl.GENREDTLID#',
				<cfif #selectDtl.GENREID# neq "">'#selectDtl.GENREID#'<cfelse>null</cfif>,
				<cfif #selectDtl.GAMEID# neq "">'#selectDtl.GAMEID#'<cfelse>null</cfif>,
				<cfif #selectDtl.RECSTATUS# neq "">'#selectDtl.RECSTATUS#'<cfelse>null</cfif>,
				<cfif #selectDtl.CREATEDBY# neq "">'#selectDtl.CREATEDBY#'<cfelse>null</cfif>,
				<cfif #selectDtl.CREATEDDATETIME# neq "">'#DateFormat(selectDtl.CREATEDDATETIME,"dd/mmm/yyyy")#'<cfelse>null</cfif>,
				'#session.userid#',
				current_timestamp,
				<cfif #selectDtl.STATUS# neq "">'#selectDtl.STATUS#'<cfelse>null</cfif>
				)
				
			</cfquery>
		</cfloop> 
	</cffunction>
</cfcomponent>
