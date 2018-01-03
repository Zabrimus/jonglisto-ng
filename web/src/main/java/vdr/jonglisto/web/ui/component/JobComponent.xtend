package vdr.jonglisto.web.ui.component

import com.vaadin.ui.Composite
import com.vaadin.ui.Grid
import javax.inject.Inject
import org.apache.shiro.subject.Subject
import vdr.jonglisto.configuration.jaxb.jcron.Jcron.Jobs.Action
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log
class JobComponent extends Composite {
	
    @Inject
    private Config config

    @Inject
    private Messages messages
    
    def showAll() {
		createLayout(null)
		return this
	}
	
	def showUser(Subject subject) {
		createLayout(subject.principal as String)
		return this
	}
    
	private def void createLayout(String user) {
		val grid = new Grid

		grid.items = if (user !== null) config.jcron.jobs.filter[s | s.user == user].toList else config.jcron.jobs
        grid.setSizeFull

		grid.addColumn(job | job.user) //
			.setCaption("User") //
			.setId("USER") //
			.setMinimumWidthFromContent(true)
			
		grid.addColumn(job | job.time) //
			.setCaption("Time") //
			.setId("TIME") //
			.setMinimumWidthFromContent(true)
		
		grid.addColumn(job | createActionType(job.action)) //
			.setCaption("Type") //
			.setId("TYPE") //
			.setMinimumWidthFromContent(true)

		grid.addColumn(job | createScriptOrVdr(job.action)) //
			.setCaption("Script/VDR") //
			.setId("DEST") //
			.setMinimumWidthFromContent(true)

		grid.addColumn(job | createParameter(job.action)) //
			.setCaption("Parameter") //
			.setId("PARAM") //
			.setMinimumWidthFromContent(true)
			
		grid.addColumn(job | createActionButton(job.action)) //
			.setCaption("Action") //
			.setId("ACTION") //
			.setMinimumWidthFromContent(true)
		
    	val root = verticalLayout [
            horizontalLayout(it) [
            	// TODO: some buttons
            ]
            
            addComponentsAndExpand(grid)
		]
	
		compositionRoot = root	
	}
	
	private def createActionType(Action action) {
		if (action.shellAction !== null) {
			return "Shell script"
		} else if (action.vdrAction !== null) {
			switch (action.vdrAction.type) {
				case "switchChannel": return "Switch channel"
				case "osdMessage" : return "OSD message"
				case "svdrp" : return "SVDRP command"				
			}
		}
	}
	
	private def createScriptOrVdr(Action action) {
		if (action.shellAction !== null) {
			return action.shellAction.script
		} else if (action.vdrAction !== null) {
			return action.vdrAction.vdr
		}
	}
	
	private def createParameter(Action action) {
		if (action.shellAction !== null) {
			return action.shellAction.parameter
		} else if (action.vdrAction !== null) {
			return action.vdrAction.parameter
		}
	}	
	
	private def createActionButton(Action action) {
		// TODO: Implement something useful
		return null;		
	}	
}