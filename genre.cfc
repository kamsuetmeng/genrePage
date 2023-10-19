<!---
	Date			Developer		Remarks
	09 Aug 2018		Mel				SST Enhancement
--->
<cfcomponent output="false"	implements="ies_ng8.interface.iWebPage, ies_ng8.interface.iAjax" extends="ies_ng8.controller.REST">
	<cffunction name="init" access="public" returntype="any" output="no">
		<cfscript>
			// constructor
			super.init();

			return this;
		</cfscript>
	</cffunction>

	<!--- iWebPage implementation --->
	<cffunction name="outputPage" output="false">
		<cfargument name="action" type="string" required="yes" />
		<cfargument name="js" type="ies_ng8.lib.Javascript" required="yes" />
		<cfargument name="style" type="ies_ng8.lib.Css" required="yes" />
		<cfswitch expression="#action#">
			<cfcase value="search">
				<cfreturn searchPage(js, style)>

			</cfcase>

			<cfcase value="add">
				<cfreturn addPage(js, style)>
			</cfcase>

			<cfcase value="edit">
				<cfreturn editPage(js, style)>
			</cfcase>

			<cfcase value="revisionSearch">
				<cfreturn revisionSearchPage(js, style)>
			</cfcase>

			<cfcase value="revisionEdit">
				<cfreturn revisionEditPage(js, style)>
			</cfcase>

			<cfdefaultcase>
				<cfreturn searchPage(js, style)>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="addPage" output="false" access="private" returntype="string">
		<cfargument name="js" type="ies_ng8.lib.Javascript" required="yes" />
		<cfargument name="style" type="ies_ng8.lib.Css" required="yes" />
		<cfset model = createObject('component', 'model.system.gmModel').init()>
		<cfset datasource = createObject('component', 'ies_ng8.lib.DataSource').init(model.fields)>
		<cfset view = createObject('component', 'view.system.gmEditView').init(js, style, 'Genre Master|Add', datasource, 'system/genre', 'add')>

		<cfreturn view.out()>
	</cffunction>

	<cffunction name="editPage" output="false" access="private" returntype="string">
		
		<cfargument name="js" type="ies_ng8.lib.Javascript" required="yes" />
		<cfargument name="style" type="ies_ng8.lib.Css" required="yes" />

		<cfset var view = "">
		<cfset var datasource = "">
		<cfset model = createObject('component', 'model.system.gmModel').init()>

		<cfif isDefined("url.id")>
			<cfset isLoaded = model.load(key="ID", value=url.id , fieldList="GENREID,GENRECODE,GENREDESC, STATUS,RECSTATUS,CREATEDBY, CREATEDDATETIME,UPDATEDBY, UPDATEDDATETIME",customQuery=model.editQuery(url.id))>
		</cfif>

		<cfif not isLoaded>
			<cfthrow message="#application.message.getSystemMessage(8000)#" errorcode="8000">
		</cfif>

		<cfset datasource = createObject('component', 'ies_ng8.lib.DataSource').init(model.fields)>
		<cfset view = createObject('component', 'view.system.gmEditView').init(js, style, 'Genre Master|Edit', datasource, 'system/genre', 'edit')>

		<cfset content = view.out()>
		<cfreturn content>
	</cffunction>

	<cffunction name="searchPage" output="false" access="private" returntype="string">
		<cfargument name="js" type="ies_ng8.lib.Javascript" required="yes" />
		<cfargument name="style" type="ies_ng8.lib.Css" required="yes" />
		<cfset var link = createObject('component', 'ies_ng8.lib.LinkGenerator').init()>
		<cfset var model = createObject('component', 'model.system.gmModel').init()>
		<cfset var datasource = createObject('component', 'ies_ng8.lib.DataSource').init(model.fields)>
		<cfset var view = createObject('component', 'view.system.gmSearchView').init(js, style, "genre | Search", link.generate("ajax", "system/genre", "search"), datasource, "system/genre")>
		<cfset content = view.out()>
		<cfreturn content>
	</cffunction>

	<cffunction name="revisionSearchPage" output="false" access="private" returntype="string">
		<cfargument name="js" type="ies_ng8.lib.Javascript" required="yes" />
		<cfargument name="style" type="ies_ng8.lib.Css" required="yes" />

		<cfset var view = "">
		<cfset var datasource = "">
		<cfset var model = createObject('component', 'model.system.gmModel').init()>

		<cfset datasource = createObject('component', 'ies_ng8.lib.DataSource').init(model.fields)>

		<!--- <cfset view = createObject('component', 'view.system.gmRevEditView').init(js, style, 'Genre Master|View', datasource, 'system/genre', 'spRevDetails')> --->

		<cfset content = view.out()>
		<cfreturn content>
	</cffunction>

	<cffunction name="revisionEditPage" output="false" access="private" returntype="string">
		<cfargument name="js" type="ies_ng8.lib.Javascript" required="yes" />
		<cfargument name="style" type="ies_ng8.lib.Css" required="yes" />

		<cfset var view = "">
		<cfset var datasource = "">
		<cfset var model = createObject('component', 'model.system.gmModel').init()>
		<cfif isDefined("url.id")>
			<cfset isLoaded = model.load(key="ID", value=url.id , customQuery=model.editQuery(url.id,url.rev))>
		
		</cfif>

		<!--- <cfif isDefined("url.genreid")>
			<cfset isLoaded = model.load(key="GENREID", value=url.genreid , fieldList="GENREID, GENRECODE,GENREDESC, STATUS,RECSTATUS,CREATEDBY,CREATEDDATETIME,UPDATEDBY,UPDATEDDATETIME", customQuery=model.editQuery(url.genreid,url.rev))>
		</cfif> --->


		<cfif not isLoaded>
			<cfthrow message="#application.message.getSystemMessage(8000)#" errorcode="8000">
		</cfif>


		<cfset datasource = createObject('component', 'ies_ng8.lib.DataSource').init(model.fields)>
		<cfset view = createObject('component', 'view.gmRevEditView2').init(js, style, 'Genre Master|Edit', datasource, 'system/genre', 'edit')>

		<cfset content = view.out()>
		<cfreturn content>
	</cffunction>

	<!--- iAjax implementation --->
	<cffunction name="getAjax" output="false">
		<cfargument name="action" type="string" required="yes" />
		<cfargument name="ajax" type="ies_ng8.lib.AjaxHelper" required="yes" />

		<cfscript>
			switch (action) {
				case "GenreCodeLookUp":
					model = createObject('component', 'model.system.gmModel').init();
					return ajax.runQuery(model, "GENRECODE,GENREDESC", model.GenreCodeLookUp());
				case "GameCodeLookUp":
					model = createObject('component', 'model.system.gModel').init();
					return ajax.runQuery(model, "GAMECODE,GAMEDESC", model.GameCodeLookUp());
				
				case "Grid":
					model = createObject('component', 'model.system.gmDtlModel').init();
					return ajax.runQuery(model, "GENREDTLID, GENREID, GAMEID,RECSTATUS,CREATEDBY, CREATEDDATETIME,UPDATEDBY, UPDATEDDATETIME,STATUS", model.Grid());
				case "activeGrid":
					model = createObject('component', 'model.system.gmDtlModel').init();
					return ajax.runQuery(model, "GENREDTLID,GAMECODE,GAMEDESC,CREATEDBY,CREATEDDATETIME", model.activeGrid('#GENREID#'));

				// case "activeGrid":
				// 	model = createObject('component', 'model.system.gmDtlDModel').init();
				// 	return ajax.runQuery(model, "GAMECODE,GAMEDESC,CREATEDBY,CREATEDDATETIME", model.activeGrid());
				case "inactiveGrid":
					model = createObject('component', 'model.system.gmDtlModel').init();
					return ajax.runQuery(model, "GENREDTLID,GAMECODE,GAMEDESC,CREATEDBY,CREATEDDATETIME", model.inactiveGrid('#GENREID#'));
				case "deleteDetails":
					return deleteDetails(ajax);
				case "add":
					if (this.acl.hasAccess(this.acl.ACLADD) eq false){
					return aclmessage(ajax);
				}
				else
				{
					return addRecord(ajax);
				}
				case "Save":
				if (this.acl.hasAccess(this.acl.ACLADD) eq false){
					return aclmessage(ajax);
				}
				else
				{
					return addRecord(ajax);
				}
			
				case "SaveEdit":
				if (this.acl.hasAccess(this.acl.ACLEDIT) eq false){
					return aclmessage(ajax);
				}
				else
				{
					return saveRecord(ajax);
				}
				case "edit":
					return saveRecord(ajax);
				case "search":
					return searchRecord(ajax);
				
				default:
					return super.getAjax(action, ajax);
			}
		</cfscript>
	</cffunction>

	<cffunction name="searchRecord" output="false" access="private" returntype="any">

		<cfargument name="ajax" type="ies_ng8.lib.AjaxHelper" required="no" />
		 	
		<cfscript>
			
			model = createObject('component', 'model.system.gmModel').init();
			model.loadURLData();

			return ajax.runQuery(model, "GENRECODE,GENREDESC,STATUS",model.getSearchQuery());

		</cfscript>

	</cffunction>

	<cffunction name="addRecord" output="false" access="private" returntype="any">
		<cfset  model = createObject('component', 'model.system.gmModel').init()>
		
		<cfset  model2 = createObject('component', 'model.system.gmDtlModel').init()>
		

		<cfset model.loadURLData()>
		
		<cfset result = executeWithTransaction(execFunc=addRecordDetails, model=model,model2=model2)>

		<cfset application.messageStore.addMessage(9368,['Genre'])>
		<cfset msg = application.messageStore.getLatestMessage()>
		<cfset returnValue = application.message.EncodeMessage(msg[1], msg[2])>
		<cfset returnValue = model.setOutputFieldValues(returnValue)>
		<cfset returnValue.INSERTID = result>
		<cfreturn application.stdlib.serializeJSON(returnValue)>
	</cffunction>

	<cffunction name="addRecordDetails" output="false" access="private" returntype="any">
		<cfargument name="model" type="model.system.gmModel" required="yes">
		<cfargument name="model2" type="model.system.gmDtlModel" required="yes">

		<cfif model.checkDuplicate(trim(model.getField("GENRECODE").getValue()))EQ true>
			<cfthrow message="Genre Code already exist in system">
		</cfif>

		<cfset model.getField("GENRECODE").setValue("#uCase(Evaluate("GENRECODE"))#")>
		<cfset model.getField("GENREDESC").setValue("#Evaluate('GENREDESC')#")>

		<cfset model.getField("STATUS").setValue('#Evaluate('STATUS')#')>
		<cfset model.getField("RECSTATUS").setValue('1')>
		<cfset new_genre = model.insertRecord("GENREID,GENRECODE,GENREDESC,STATUS,RECSTATUS,CREATEDBY,CREATEDDATETIME", "T_GENRE_MSTR")>
		<cfreturn new_genre />
		<!--- <cfif model2.checkDuplicate(trim(model2.getField("GAMECODE").getValue()))EQ true>
			<cfthrow message="Game Code already exist in system">
		</cfif>

		<cfset model2.getField("GAMEID").setValue(Evaluate("GAMEID"))>
		<cfset new_genre2 = model2.insertRecord("GENREDTLID, GENREID, GAMEID,RECSTATUS,CREATEDBY, CREATEDDATIME,UPDATEDBY, UPDATEDDATETIME,STATUS", "T_GENRE_DTL")>
		<cfreturn new_genre2 /> --->
		<cfif isDefined("Page_activeGrid_rows")>
			<cfloop index = "k" from = "#Page_activeGrid_startRows#" to = "#Page_activeGrid_rows#">
				<cfif Evaluate("GAMECODE_#k#") eq 1>
					<cfthrow message="GAME CODE cannot duplicate upon save.">
				</cfif>

						<cfset model2.getField("CREATEDEDDATETIME").setValue(LSDateFormat(Evaluate("UPDATEDDATETIME_#k#")),"dd/mm/yyyy")>
						<cfset model2.getField("UPDATEDDATETIME").setValue(LSDateFormat(Evaluate("UPDATEDDATETIME_#k#")),"dd/mm/yyyy")>
						<cfset model2.getField("GAMEID").setValue(#newRecord#)>
						<cfset model2.getField("RECSTATUS").setValue("1")>

						<cfset model2.updateEffEnd(#model2.getField("UPDATEDDATETIME").getValue()#,newRecord)>
						<cfset model2.insertRecord("GENREDTLID, GENREID, GAMEID,RECSTATUS,CREATEDBY, CREATEDDATIME,UPDATEDBY, UPDATEDDATETIME,STATUS")>
			</cfloop>
		</cfif>

		<cfreturn newRecord>
	</cffunction>

	<cffunction name="saveRecord" output="false" access="private" returntype="any">
		<cfset var model = createObject('component', 'model.system.gmModel').init()>
		<cfset var model2 = createObject('component', 'model.system.gmDtlModel').init()>
		<cfset model.loadURLData()>

		<cfset result = executeWithTransaction(execFunc=saveRecordDetails, model=model,model2=model2)>
		<cfset model.load( customQuery=model.editQuery(form.pk), fieldList="GENREDESC,STATUS,UPDATEDDATETIME,UPDATEDBY")>

		<cfset application.messageStore.addMessage(9296,['Genre Code'])>
		<cfset msg = application.messageStore.getLatestMessage()>
		<cfset returnValue = application.message.EncodeMessage(msg[1], msg[2])>
		<cfset returnValue = model.setOutputFieldValues(returnValue)>
		<cfreturn application.stdlib.serializeJSON(returnValue)>
	</cffunction>

	<cffunction name="saveRecordDetails" output="false" access="private" returntype="any">
		<cfargument name="model" type="model.system.gmModel" required="yes">
		<cfargument name="model2" type="model.system.gmDtlModel" required="yes">

		<cfset model.getField("GENRECODE").setValue('#trim(UCASE(GENRECODE))#')>
		<cfset model.getField("GENREDESC").setValue(GENREDESC)>
		<!--- <cfset model.getField("STARTDATE").setValue(LSDateFormat(STARTDATE,"mm/dd/yyyy"))>
		<cfset model.getField("ENDDATE").setValue(LSDateFormat(ENDDATE,"mm/dd/yyyy"))>--->
		<cfset model.getField("STATUS").setValue(STATUS)>
			
		<cfset fieldsToUpdate = "GENREDESC,STATUS,UPDATEDBY,UPDATEDDATETIME">

		<!---START: FOR REVISION HISTORY --->
		<cfset isChange = model.checkIsChange(model.getField("GENRECODE").getValue(),model.getField("GENREDESC").getValue(),model.getField("STATUS").getValue())>

		<cfif isDefined("Page_activeGrid_rows")>
			<cfset isChangeDtl = model2.checkIsChange(model.getField("GAMECODE").getValue(),#Page_activeGrid_rows#)>
		<cfelse>
			<cfset isChangeDtl = model2.checkIsChange(model.getField("GAMECODE").getValue(),-1)>
		</cfif>

		<!--- Either one that is true (changed) perform insert to revision history--->
		<cfif isChange eq true or isChangeDtl eq true>
			<cfset model.updateRev(model.getField("GENRECODE").getValue())>
			<cfset model2.updateRevDtl(model.getField("GAMECODE").getValue())>
		</cfif>
		<!---END: FOR REVISION HISTORY --->
		<cfset recordUpdate = model.updateRecord(primaryKey="GAMEID",fieldsToUpdate=fieldsToUpdate,noupper="true")>
	</cffunction>

	<!--- START : DELETE GRID RECORDS --->
	<cffunction name="deleteDetails" output="false" access="private" returntype="any">
		<cfargument name="ajax" type="ies_ng8.lib.AjaxHelper" required="no" />
		<cfset var model = createObject('component', 'model.system.gmDtlModel').init()>

		<cfloop list="#deleteList#" index="i">
			<cfif i NEQ "on">
				<cfset model.load(key="GENREDTLID",
					value=i,fieldList="GENREDTLID",
					tablename="T_GENRE_DTL")>
					<cfif model.checkCurrentDate(model.getField("GENREDTLID").getValue()) eq true>
						<cfthrow message="Active Effective date cannot be delete.">
					<cfelseif model.checkPastDate(model.getField("GENREDTLID").getValue()) eq true>
						<cfthrow message="Past Records cannot be deleted.">
					</cfif>
			</cfif>
		</cfloop>

		<cfloop list="#deleteList#" index="j">
			<cfif j NEQ "on">
				<cfset model.load(key="GENREDTLID",
					value=j,fieldList="GENREDTLID",
					tablename="T_GENRE_DTL")>

					<cfset executeWithTransaction(execFunc=deleteRecordDetails, model=model)>
			</cfif>
		</cfloop>

		<cfset application.messageStore.addMessage(9006)>
		<cfset msg = application.messageStore.getLatestMessage()>
		<cfset returnValue = application.message.EncodeMessage(msg[1], msg[2])>
		<cfreturn application.stdlib.serializeJSON(returnValue)>
	</cffunction>

	<cffunction name="deleteRecordDetails" output="false" access="private" returntype="void">
		<cfargument name="model" type="any" required="yes">

		<cfset value = model.getField("GENREDTLID").getValue()>
		<cfset model.getField("RECSTATUS").setValue('0')>

		<cfset fieldsToUpdate = "RECSTATUS,UPDAEDBY,UPDATEDDATETIME">
		<cfset recordUpdate = model.updateRecord(primaryKey="GENREDTLID",fieldsToUpdate=fieldsToUpdate)>
	</cffunction>
	<!--- END : DELETE GRID RECORDS --->

	
</cfcomponent>
