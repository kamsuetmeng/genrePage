<cfcomponent output="false" hint="T_GAME_MSTR" extends="ies_ng8.model.BaseModel">
	<cffunction name="init"returntype="any" access="public" output="false">

		<cfset super.init()>
		<cfset this.tableName = application.T_GAME_MSTR>
		<cfset this.primaryKey = "GAMEID">
		<cfset this.autoIncrement = true>
		<cfset addField("GAMEID", "", "GAMEID", "Integer", "Game ID", 39, true,true)>
		<cfset addField("GAMECODE", "", "GAMECODE", "VarChar", "Game Code", 100, true,false)>
		
		<cfset addField("GAMEDESC","","GAMEDESC","VarChar","Game Description",200,true,false)>
		<cfset addField("CREATEDBY","","G.CREATEDBY","SYSTEM","Created By",10,false,false)>
		<cfset addField("CREATEDDATETIME","","G.CREATEDDATETIME","SYSDATE","Created Date/Time",6,false,false)>
		<cfset addField("UPDATEDBY","","G.UPDATEDBY","SYSTEM","Last Updated By",10,false,false)>
		<cfset addField("UPDATEDDATETIME","","G.UPDATEDDATETIME","SYSDATE","Last Updated Date/Time",6,false,false)>
		<cfset addField("RECSTATUS","","G.RECSTATUS","Integer","Rec Status",2,true,false)>
		<cfset addField("STATUS","","STATUS","VarChar","Status",1,true,false)>
		<cfset a = ["Active", "A"]>
		<cfset b = ["Inactive", "I"]>	
		<cfset status = [a,b]>
		<cfset getField("STATUS").setEncodedValues(status)>

		<cfreturn this>
	</cffunction>

	<cffunction name="getSearchQuery" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
		<cfoutput>
		FROM #this.tableName#
		WHERE RECSTATUS = 1
		#SQLFilter("StringPair", "GAMECODE")#
		#SQLFilter("like", "GAMEDESC")#
		<cfif getField("STATUS").getValue() eq "A" or getField("STATUS").getValue() eq "I">
		   	AND STATUS IN ('#getField("STATUS").getValue()#')
		</cfif>
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>

	<cffunction name="gameCodeLookup" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
		<cfoutput>
		FROM #this.tableName# G
		WHERE RECSTATUS = 1
		#formatFilter("eq", "G.GAMECODE", "G.GAMECODE", false, key)#

		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>
	
	<cffunction name="gameCodeLookup_active" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
		<cfoutput>
		FROM #this.tableName#
		WHERE RECSTATUS = 1
		AND STATUS = 'A'
		#formatFilter("like", "GAMECODE", "GAMECODE", false, key)#				
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>
	
	<cffunction name="gameDescLookup" returntype="string" access="public" output="false">
		<cfsavecontent variable="content">
		<cfoutput>
		FROM #this.tableName#
		WHERE RECSTATUS = 1
		#formatFilter("like", "GAMEDESC", "GAMEDESC", false, key)#
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn content>
	</cffunction>

	<cffunction name="editQuery" returntype="string" access="public" output="false">
		<cfargument name="key" required="yes" type="any">
		
		<cfsavecontent variable="content">
		<cfoutput>
		FROM #this.tableName#  G
		WHERE G.GAMEID = '#key#'		
		</cfoutput>
		</cfsavecontent>

		<cfreturn content>
	</cffunction>	
	
	<cffunction name="checkDuplicate" returntype="boolean" access="public" output="false">
		<cfargument name="key" type="string" required="yes">
		
		<cfquery name="checkDuplication" datasource="#this.source.ds#">
			SELECT GAMECODE 
			FROM #this.tableName# G
			WHERE upper(G.GAMECODE) = '#ucase(key)#'
			AND G.RECSTATUS = 1
		</cfquery>
		
		<cfif checkDuplication.recordCount gt 0>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction> 

</cfcomponent>
