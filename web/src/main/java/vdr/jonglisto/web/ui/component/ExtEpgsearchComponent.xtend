package vdr.jonglisto.web.ui.component

import com.vaadin.icons.VaadinIcons
import com.vaadin.ui.Button
import com.vaadin.ui.Composite
import com.vaadin.ui.Grid
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.Notification
import com.vaadin.ui.Panel
import com.vaadin.ui.TextField
import com.vaadin.ui.VerticalLayout
import com.vaadin.ui.renderers.ComponentRenderer
import javax.inject.Inject
import vdr.jonglisto.configuration.jaxb.extepgsearch.Extepgsearch
import vdr.jonglisto.configuration.jaxb.extepgsearch.Extepgsearch.ComplexPattern
import vdr.jonglisto.configuration.jaxb.extepgsearch.Extepgsearch.SimplePattern
import vdr.jonglisto.delegate.Config
import vdr.jonglisto.delegate.Svdrp
import vdr.jonglisto.search.EpgSearch
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*

@Log("jonglisto.web")
class ExtEpgsearchComponent extends Composite {

    @Inject
    private Config config

    @Inject
    private Svdrp svdrp

    @Inject
    private Messages messages

    private EpgSearch epgSearch = EpgSearch.instance

    var Grid<Extepgsearch.SimplePattern> simpleGrid
    var Grid<Extepgsearch.ComplexPattern> complexGrid

    def showAll() {
        createLayout(null)
        return this
    }

    private def void createLayout(String user) {
        val root = new VerticalLayout()
        val root2 = new VerticalLayout()
        val root3 = new HorizontalLayout()

        // Simple regex panel
        val simplePanel = new Panel("Configured Regex Pattern (Parts)")
        val simpleLayout = new VerticalLayout()

        simpleLayout.createSimpleGrid

        simplePanel.content = simpleLayout

        // Complex regex panel
        val complexPanel = new Panel("Configured Regex Pattern")
        val complexLayout = new VerticalLayout()

        complexLayout.createComplexGrid

        complexPanel.content = complexLayout

        root2.addComponentsAndExpand(simplePanel)
        root2.addComponentsAndExpand(complexPanel)

        val saveButton = new Button("Save all") => [
            addClickListener(s | config.saveExtEpgSearch)
        ]

        val reloadButton = new Button("Reload") => [
            addClickListener(s | {
                config.loadExtEpgSearch
                simpleGrid.items = config.extEpgSearch.simplePattern
                complexGrid.items = config.extEpgSearch.complexPattern
            })
        ]

        root3.addComponent(saveButton)
        root3.addComponent(reloadButton)

        root.addComponent(root3)
        root.addComponentsAndExpand(root2)

        compositionRoot = root
    }

    def createSimpleGrid(VerticalLayout layout) {
        layout.setSizeFull

        horizontalLayout(layout) [
            button(it, "Add pattern") [
                addClickListener(click | {
                    val simple = new SimplePattern() => [
                        name = "<Name>"
                        pattern = "<new Pattern>"
                    ]

                    config.extEpgSearch.simplePattern.add(simple)
                    simpleGrid.items = config.extEpgSearch.simplePattern
                })
            ]
        ]

        simpleGrid = new Grid<Extepgsearch.SimplePattern>
        simpleGrid.setSizeFull

        simpleGrid.items = config.extEpgSearch.simplePattern

        simpleGrid.addColumn(p | p.name) //
            .setCaption(messages.configEpgsearchName) //
            .setEditorComponent(new TextField(), [ SimplePattern s, String b | s.name = b; epgSearch.reloadPattern ]) //
            .setEditable(true)
            .setId("NAME")

        simpleGrid.addColumn(p | p.pattern) //
            .setCaption(messages.configEpgsearchPattern) //
            .setExpandRatio(2)
            .setEditorComponent(new TextField(), [ SimplePattern s, String b | s.pattern = b; epgSearch.reloadPattern ]) //
            .setEditable(true)
            .setId("PATTERN")

        simpleGrid.addColumn(p | createSimpleButtons(p)) //
            .setRenderer(new ComponentRenderer)
            .setCaption("")
            .setId("ACTION")

        simpleGrid.editor.enabled = true

        layout.addComponentsAndExpand(simpleGrid)
    }

    def createComplexGrid(VerticalLayout layout) {
        layout.setSizeFull

        horizontalLayout(layout) [
            // Buttons
            button(it, "Add pattern") [
                addClickListener(click | {
                    val complex = new ComplexPattern() => [
                        name = "<Name>"
                        pattern = "<new Pattern>"
                    ]

                    config.extEpgSearch.complexPattern.add(complex)
                    complexGrid.items = config.extEpgSearch.complexPattern
                })
            ]
        ]

        complexGrid = new Grid<Extepgsearch.ComplexPattern>
        complexGrid.setSizeFull

        // grid.items = config.extEpgSearch.complexPattern
        complexGrid.items = config.extEpgSearch.complexPattern

        complexGrid.addColumn(p | p.name) //
            .setCaption(messages.configEpgsearchName) //
            .setEditorComponent(new TextField(), [ ComplexPattern s, String b | s.name = b; epgSearch.reloadPattern ]) //
            .setEditable(true)
            .setId("NAME")

        complexGrid.addColumn(p | p.pattern) //
            .setCaption(messages.configEpgsearchPattern) //
            .setExpandRatio(2)
            .setEditorComponent(new TextField(), [ ComplexPattern s, String b | s.pattern = b; epgSearch.reloadPattern ]) //
            .setEditable(true)
            .setId("PATTERN")

        complexGrid.addColumn(p | createComplexButtons(p)) //
            .setRenderer(new ComponentRenderer)
            .setCaption("")
            .setId("ACTION")

        complexGrid.editor.enabled = true

        complexGrid.items = config.extEpgSearch.complexPattern

        layout.addComponentsAndExpand(complexGrid)
    }

    def createComplexButtons(ComplexPattern pattern) {
        return createButtons(pattern.name, false)
    }

    def createSimpleButtons(SimplePattern pattern) {
        return createButtons(pattern.name, true)
    }

    private def createButtons(String patternName, boolean simple) {
        val layout = new HorizontalLayout

        val testButton = new Button("Test") => [
            icon = VaadinIcons.SEARCH

            addClickListener(s | {
                var String resultStr

                try {
                    var long size

                    val start = System.currentTimeMillis
                    if (simple) {
                        size = epgSearch.filterNamedPattern(patternName, svdrp.epg).size
                    } else {
                        size = epgSearch.filterCompletePattern(patternName, svdrp.epg).size
                    }
                    val end = System.currentTimeMillis

                    resultStr = "Found " + size + " EPG entries in " + ((end-start) / 1000) + " seconds."
                } catch (Exception e) {
                    resultStr = "Error: " + e.message
                }

                Notification.show("Ergebnis: " + resultStr)
            })
        ]

        val deleteButton = new Button("Delete") => [
            icon = VaadinIcons.TRASH

            addClickListener(s | {
                if (simple) {
                    val p = config.extEpgSearch.simplePattern.findFirst[t | t.name == patternName]
                    if (p !== null) {
                        config.extEpgSearch.simplePattern.remove(p)
                        simpleGrid.items = config.extEpgSearch.simplePattern
                    }
                } else {
                    val p = config.extEpgSearch.complexPattern.findFirst[t | t.name == patternName]
                    if (p !== null) {
                        config.extEpgSearch.complexPattern.remove(p)
                        complexGrid.items = config.extEpgSearch.complexPattern
                    }
                }

                epgSearch.reloadPattern
            })
        ]

        layout.addComponent(testButton)
        layout.addComponent(deleteButton)

        return layout
    }

}
