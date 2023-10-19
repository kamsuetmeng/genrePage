<cfcomponent output="false" hint="T_GENRE_MSTR" extends="ies_ng8.model.BaseModel">
	<cffunction name="init"returntype="any" access="public" output="false">

		<cfset super.init()>
		<cfset this.tableName = application.T_GENRE_MSTR>
		
		
		<cfset this.primaryKey = "GENREID">
		<cfset this.autoIncrement = false>

		<cfset addField("GENREID", "", "GM.GENREID", "Integer", "Genre ID", 39, true, true)>
		<cfset addField("GENRECODE", "", "GM.GENRECODE", "VarChar", "Genre Code", 100, true, false)>
		<cfset addField("GENREDESC", "", "GM.GENREDESC", "VarChar", "Genre Description", 200, true, false)>
		<!--- <cfset addField("GAMECODE", "", "GAMECODE", "VarChar", "Game Code", 100, true,false)> --->
		<cfset addField("STATUS", "", "GM.STATUS", "VarChar", "Status", 1, true, false)>
		<cfset a = ["Active", "A"]>
		<cfset b = ["Inactive", "I"]>
		<cfset status = [a,b]>
		<cfset getField("STATUS").setEncodedValues(status)>

		<cfset addField("RECSTATUS", "", "GM.RECSTATUS", "VarChar", "RECSTATUS", 1, true, true)>
		<cfset c = ["1"]>
		<cfset d = ["0"]>
		<cfset recstatus = [c,d]>
		<cfset getField("RECSTATUS").setEncodedValues(recstatus)>


		<cfset addField("CREATEDBY","","GM.CREATEDBY","SYSTEM","Created By",10,true,false)>
		<cfset addField("CREATEDDATETIME","","GM.CREATEDDATETIME","SYSDATE","Created Date/Time",6,true,false)>
		<cfset addField("UPDATEDBY","","GM.UPDATEDBY","SYSTEM","Last Updated By",10,false,false)>
		<cfset addField("UPDATEDDATETIME","","GM.UPDATEDDATETIME","SYSDATE","Last Updated Date/Time",6,false,false)>
		
		<cfset this.tableName2 = application.T_GAME_MSTR>
		<cfset addField("GGAMEID", "", "G.GAMEID", "Integer", "Game ID", 39, true,true)>
		<cfset addField("GGAMECODE", "", "G.GAMECODE", "VarChar", "Game Code", 100, true,false)>
		<cfset addField("GGAMEDESC","","G.GAMEDESC","VarChar","Game Description",200,true,false)>
		<cfset addField("GCREATEDBY","","G.CREATEDBY","SYSTEM","Created By",10,false,false)>
		<cfset addField("GCREATEDDATETIME","","G.CREATEDDATETIME","SYSDATE","Created Date/Time",6,false,false)>
		<cfset addField("GUPDATEDBY","","G.UPDATEDBY","SYSTEM","Last Updated By",10,false,false)>
		<cfset addField("GUPDATEDDATETIME","","G.UPDATEDDATETIME","SYSDATE","Last Updated Date/Time",6,false,false)>
		<cfset addField("GRECSTATUS","","G.RECSTATUS","Integer","Rec Status",2,true,false)>
		<cfset addField("GSTATUS","","G.STATUS","VarChar","Status",1,true,false)>
		<cfset a = ["Active", "A"]>
		<cfset b = ["Inactive", "I"]>	
		<cfset status = [a,b]>
		<cfset getField("GSTATUS").setEncodedValues(status)>



		<cfset this.tableName3 = application.T_GENRE_DTL>
		<cfset addField("GDTLGENREDTLID", "", "GDTL.GENREDTLID", "Integer", "GENREDTLID", 39, true, false)>
		<cfset addField("GDTLGENREID", "", "GDTL.GENREID", "Integer", "GENREID", 39, true, false)>
		<cfset addField("GDTLGAMEID", "", "GDTL.GAMEID", "Integer", "GAMEID", 39, true, false)>
		<!--- <cfset addField("RECSTATUS", "", "GDTL.RECSTATUS", "VarChar", "RECSTATUS", 2, true, false)>
		<cfset addField("CREATEDBY", "", "GDTL.CREATEDBY", "SYSTEM", "Created By", 10, true, false)>
		<cfset addField("CREATEDDATETIME", "", "GDTL.CREATEDDATETIME", "Date", "Created Date Time", 11, false, false)>
		<cfset addField("UPDATEDBY", "", "GDTL.UPDATEDBY", "SYSTEM", "Updated By", 10, true, false)>
		<cfset addField("UPDATEDDATETIME", "", "GDTL.UPDATEDDATETIME", "Date", "Updated Date Time", 11, true, false)>
		<cfset addField("STATUS","","STATUS","VarChar","Status",1,true,true)>
		 --->

		<cfreturn this>
	</cffunction>

	<cffunction name="getSearchQuery" returntype="string" access="public" output="false">

		<cfsavecontent variable="content">
			<cfoutput>
				FROM T_GENRE_MSTR GM
				WHERE 1=1
				#SQLFilter("Stringpair", "GENRECODE")#
				#SQLFilter("like", "GENREDESC")#
				<!--- #SQLFilter("ilike", "GMSTATUS")# --->
				<cfif LEN(trim(getField("STATUS").getValue())) GT 0>
					AND STATUS IN (#ListQualify(getField("STATUS").getValue(), "'")#)
				<cfelse>
					AND STATUS IS NULL
				</cfif> 

			</cfoutput>
		</cfsavecontent>

		<cfreturn content>
	</cffunction>

	<cffunction name="editQuery" returntype="string" access="public" output="false">
		<cfargument name="key" required="yes" type="any">
		<cfsavecontent variable="content">
			<cfoutput>
				FROM T_GENRE_MSTR GM 
				INNER JOIN T_GENRE_DTL GDTL ON GM.GENREID = GDTL.GENREID
				INNER JOIN T_GAME_MSTR G ON GDTL.GAMEID = G.GAMEID
				WHERE
				GM.GENREID =  GDTL.GENREID

			</cfoutput>
		</cfsavecontent>

		<cfreturn content>
	</cffunction>
	
	<cffunction name="checkDuplicate" returntype="boolean" access="public" output="false">

		<cfargument name="key" required="yes" type="any">
		<cfquery name="checkDuplicateGenreCode" datasource="#this.source.ds#">
			SELECT GM.GENRECODE
			FROM #this.tableName# GM
			WHERE UPPER(GM.GENRECODE) = '#UCASE(key)#' 

		</cfquery>
		<cfdump var="#checkDuplicateGenreCode#" output="C:\dump\b.html" format="html">
		<!--- <cfthrow message="#checkDuplicateGenreCode.recordcount#"> --->
		<cfif checkDuplicateGenreCode.recordcount GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<!--- START LOOK UP --->
	<cffunction name="GenreCodeLookUp" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
			<cfoutput>
				FROM #this.tableName# GM
				WHERE 1=1
				#formatFilter("eq", "GM.GENRECODE", "GM.GENRECODE", false, key)#
				AND STATUS = 'A'
				AND RECSTATUS = '1'
				
			</cfoutput>
		</cfsavecontent>
		<cfreturn content>
	</cffunction>
<!--- 
	<cffunction name="GenreCodeLookUp" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
			<cfoutput>
				FROM #this.tableName#
				WHERE 1=1
				#formatFilter("eq", "GENRECODE", "GENRECODE", false, key)#
				AND STATUS = 'A'
			</cfoutput>
		</cfsavecontent>
		<cfreturn content>
	</cffunction> --->

	<cffunction name="updateRev" returntype="string" access="public" output="false">
		<cfargument name="genrecode" required="yes" type="any">
		<cfthrow message="1">
		<cfquery name="insertRev" datasource="#this.source.ds#">
			INSERT INTO T_GENRE_MSTR GM
			(
			GM.GENREID, GM.GENRECODE,GM.GENREDESC, GM.STATUS,GM.RECSTATUS,GM.CREATEDBY, GM.CREATEDDATETIME,GM.UPDATEDBY, GM.UPDATEDDATETIME

			)
			SELECT GDTL.GENREDTLID, GDTL.GENREID, GDTL.GAMEID,GDTL.RECSTATUS,GDTL.CREATEDBY, GDTL.CREATEDDATETIME,GDTL.UPDATEDBY, GDTL.UPDATEDDATETIME,GDTL.STATUS,#newRev#,'#session.userid#',current_timestamp
			FROM T_GENRE_DTL GDTL
			WHERE GDTL.GENREID = '#trim(GENREID)#'

		</cfquery>

	</cffunction>

	<cffunction name="GameCodeLookUp" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
			<cfoutput>
				FROM #this.tableName# GM
				WHERE RECSTATUS= 1
				#formatFilter("like", "GAMECODE", "GAMECODE", false, key)#
				<!--- AND STATUS ='A'--->
			</cfoutput>
		</cfsavecontent>
		<cfreturn content>
	</cffunction>
	<!--- END LOOK UP --->


	<!--- <cffunction name="customInsertTaxMatrix" access="public" output="false">
		<cfargument name="key" required="yes" type="any">

		<!--- <cfset set1 = "Y,Y,Y,Y,SUPPLY">
		<cfset set2 = "Y,Y,Y,Y,PURCHASE">
		<cfset set3 = "Y,Y,Y,N,SUPPLY">
		<cfset set4 = "Y,Y,Y,N,PURCHASE">
		<cfset set5 = "Y,Y,N,N,SUPPLY">
		<cfset set6 = "Y,Y,N,N,PURCHASE">
		<cfset set7 = "Y,N,N,N,SUPPLY">
		<cfset set8 = "Y,N,N,N,PURCHASE">
		<cfset set9 = "Y,N,Y,N,SUPPLY">
		<cfset set10 = "Y,N,Y,N,PURCHASE">
		<cfset set11 = "Y,N,N,Y,SUPPLY">
		<cfset set12 = "Y,N,N,Y,PURCHASE">
		<cfset set13 = "Y,Y,N,Y,SUPPLY">
		<cfset set14 = "Y,Y,N,Y,PURCHASE">
		<cfset set15 = "Y,N,Y,Y,SUPPLY">
		<cfset set16 = "Y,N,Y,Y,PURCHASE">
		<cfset set17 = "N,Y,N,N,SUPPLY">
		<cfset set18 = "N,Y,N,N,PURCHASE">
		<cfset set19 = "N,N,Y,N,SUPPLY">
		<cfset set20 = "N,N,Y,N,PURCHASE">
		<cfset set21 = "N,N,N,N,SUPPLY">
		<cfset set22 = "N,N,N,N,PURCHASE">
		<cfset set23 = "N,Y,Y,N,SUPPLY">
		<cfset set24 = "N,Y,Y,N,PURCHASE">
		<cfset set25 = "N,Y,Y,Y,SUPPLY">
		<cfset set26 = "N,Y,Y,Y,PURCHASE">
		<cfset set27 = "N,N,Y,Y,SUPPLY">
		<cfset set28 = "N,N,Y,Y,PURCHASE">
		<cfset set29 = "N,N,N,Y,SUPPLY">
		<cfset set30 = "N,N,N,Y,PURCHASE">
		<cfset set31 = "N,Y,N,Y,SUPPLY">
		<cfset set32 = "N,Y,N,Y,PURCHASE">

		<cfset list = ArrayNew(1)>
		<cfset ArrayAppend(list, "Y,Y,Y,Y,SUPPLY")>
		<cfset ArrayAppend(list, "Y,Y,Y,Y,PURCHASE")>
		<cfset ArrayAppend(list, "Y,Y,Y,N,SUPPLY")>
		<cfset ArrayAppend(list, "Y,Y,Y,N,PURCHASE")>
		<cfset ArrayAppend(list, "Y,Y,N,N,SUPPLY")>
		<cfset ArrayAppend(list, "Y,Y,N,N,PURCHASE")>
		<cfset ArrayAppend(list, "Y,N,N,N,SUPPLY")>
		<cfset ArrayAppend(list, "Y,N,N,N,PURCHASE")>
		<cfset ArrayAppend(list, "Y,N,Y,N,SUPPLY")>
		<cfset ArrayAppend(list, "Y,N,Y,N,PURCHASE")>
		<cfset ArrayAppend(list, "Y,N,N,Y,SUPPLY")>
		<cfset ArrayAppend(list, "Y,N,N,Y,PURCHASE")>
		<cfset ArrayAppend(list, "Y,Y,N,Y,SUPPLY")>
		<cfset ArrayAppend(list, "Y,Y,N,Y,PURCHASE")>
		<cfset ArrayAppend(list, "Y,N,Y,Y,SUPPLY")>
		<cfset ArrayAppend(list, "Y,N,Y,Y,PURCHASE")>
		<cfset ArrayAppend(list, "N,Y,N,N,SUPPLY")>
		<cfset ArrayAppend(list, "N,Y,N,N,PURCHASE")>
		<cfset ArrayAppend(list, "N,N,Y,N,SUPPLY")>
		<cfset ArrayAppend(list, "N,N,Y,N,PURCHASE")>
		<cfset ArrayAppend(list, "N,N,N,N,SUPPLY")>
		<cfset ArrayAppend(list, "N,N,N,N,PURCHASE")>
		<cfset ArrayAppend(list, "N,Y,Y,N,SUPPLY")>
		<cfset ArrayAppend(list, "N,Y,Y,N,PURCHASE")>
		<cfset ArrayAppend(list, "N,Y,Y,Y,SUPPLY")>
		<cfset ArrayAppend(list, "N,Y,Y,Y,PURCHASE")>
		<cfset ArrayAppend(list, "N,N,Y,Y,SUPPLY")>
		<cfset ArrayAppend(list, "N,N,Y,Y,PURCHASE")>
		<cfset ArrayAppend(list, "N,N,N,Y,SUPPLY")>
		<cfset ArrayAppend(list, "N,N,N,Y,PURCHASE")>
		<cfset ArrayAppend(list, "N,Y,N,Y,SUPPLY")>
		<cfset ArrayAppend(list, "N,Y,N,Y,PURCHASE")> --->

		<cfloop from="1" to="32" index="i" step="1">
			<cfquery name="qInsertDtl" datasource="#this.source.ds#">
				INSERT INTO T_GENRE_DTL (GENREDTLID, GENREID, GAMEID, RECSTATUS, CREATEDBY, CREATEDDATIME,UPDATEDBY, STATUS)
				VALUES (
					'#trim(UCASE(key))#',
					'#trim(UCASE(key))#',
					'#trim(UCASE(key))#',
					'#ListGetAt(list[i],1)#',
					'#ListGetAt(list[i],2)#',
					 STATUS ="A","I",
					'#trim(session.userid)#',
					current_timeStamp,
					'#ListGetAt(list[i],5)#'
				)
			</cfquery>
		</cfloop>
	</cffunction> --->
	
</cfcomponent>
