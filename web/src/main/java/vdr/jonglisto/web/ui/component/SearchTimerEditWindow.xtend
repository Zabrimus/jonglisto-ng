package vdr.jonglisto.web.ui.component

import com.vaadin.server.UserError
import com.vaadin.ui.CheckBox
import com.vaadin.ui.ComboBox
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.RadioButtonGroup
import com.vaadin.ui.TextField
import com.vaadin.ui.TwinColSelect
import com.vaadin.ui.Window
import com.vaadin.ui.themes.ValoTheme
import java.util.ArrayList
import java.util.List
import java.util.stream.Collectors
import org.apache.commons.lang3.StringUtils
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.db.SearchTimerService
import vdr.jonglisto.db.VdrService
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.VDR
import vdr.jonglisto.svdrp.client.SvdrpClient
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static vdr.jonglisto.web.xtend.UIBuilder.*
import vdr.jonglisto.model.EpgdSearchTimer

@Log
class SearchTimerEditWindow extends Window {

    val Messages messages
    val service = new SearchTimerService
    val vdrService = new VdrService

    var List<VDR> allVdr

    private CheckBox repeatCheckBox
    private CheckBox repeatTitle
    private CheckBox repeatShortText
    private CheckBox repeatDescription
    private CheckBox beginCheckBox
    private TextField beginStart
    private TextField beginEnd
    private CheckBox beginMo
    private CheckBox beginTu
    private CheckBox beginWe
    private CheckBox beginTh
    private CheckBox beginFr
    private CheckBox beginSa
    private CheckBox beginSu
    private ComboBox<String> action
    private TextField name
    private CheckBox active
    private CheckBox vps
    private ComboBox<String> namingMode
    private TextField directory
    private TextField template
    private ComboBox<VDR> vdr
    private TextField priority
    private TextField lifetime
    private TextField expression
    private ComboBox<String> searchMode
    private CheckBox casesensitiv
    private TextField seriesTitle
    private TextField season
    private TextField part
    private TwinColSelect<String> genre
    private TwinColSelect<String> category
    private TextField year
    private RadioButtonGroup<String> channelInclude
    private TwinColSelect<Channel> channels
    private NativeSelect<String> format1
    private NativeSelect<String> format2
    private NativeSelect<String> format3
    private CheckBox searchTitle
    private CheckBox searchShortText
    private CheckBox searchDescription

    new(Messages messages, EpgdSearchTimer timer) {
        super()
        this.messages = messages
        closable = true
        modal = true
        width = "60%"
        center();

        createLayout(timer)
    }

    def createLayout(EpgdSearchTimer timer) {
        caption = createCaption(timer)

        val tab1 = verticalLayout [
            horizontalLayout(it) [
                action = comboBox(it, #[messages.searchtimerRecord, messages.searchtimerChangeChannel, messages.searchtimerSearch]) [
                    caption = messages.searchtimerAction
                    emptySelectionAllowed = false
                ]

                name = textField(it, messages.searchtimerName) [
                    placeholder = messages.searchtimerName
                    width = "20em"
                ]
            ]

            horizontalLayout(it) [
                active = checkbox(it, messages.searchtimerActive) [
                ]

                vps = checkbox(it, "VPS") [
                ]
            ]


            horizontalLayout(it) [
                namingMode = comboBox(it, #["VDR", "Auto", "Constabel", "Serie", "Kategorisiert", "Usermode", "Template"]) [
                    caption = messages.searchtimerFilename
                    emptySelectionAllowed = false
                ]

                template = textField(it, messages.searchtimerTemplate) [
                    placeholder = messages.searchtimerTemplate
                    width = "20em"
                    enabled = false
                ]

                directory = textField(it, messages.searchtimerDirectory) [
                    placeholder = messages.searchtimerDirectory
                    width = "20em"
                ]
            ]

            vdr = comboBoxVdr(it, createVdrNames()) [
                 caption = messages.searchtimerVdr
                 itemCaptionGenerator = [it.name]
                 emptySelectionAllowed = false
                 width = "20em"
            ]

            horizontalLayout(it) [
                priority = textField(it, messages.searchtimerPriority) [
                    placeholder = "50"
                    maxLength = 2
                    width = "3em"
                ]

                lifetime = textField(it, messages.searchtimerLifetime) [
                    placeholder = "50"
                    maxLength = 2
                    width = "3em"
                ]
            ]

            horizontalLayout(it) [
                expression = textField(it, messages.searchtimerExpression) [
                    placeholder = messages.searchtimerExpression
                    width="20em"
                ]

                searchMode = comboBox(it, #[messages.searchtimerExact, messages.searchtimerRegex, messages.searchtimerPattern, messages.searchtimerContains]) [
                    caption = ""
                    emptySelectionAllowed = false
                    width="15em"
                ]
            ]

            horizontalLayout(it) [
                searchTitle = checkbox(it, messages.searchtimerTitle) [
                ]

                searchShortText = checkbox(it, messages.searchtimerShorttext) [
                ]

                searchDescription = checkbox(it, messages.searchtimerDescription) [
                ]
            ]

            casesensitiv = checkbox(it, messages.searchtimerCasesensitiv) [
            ]
        ]

        val tab2 = verticalLayout[
            horizontalLayout(it) [
                seriesTitle = textField(it, messages.searchtimerSeriesTitle) [
                    placeholder = messages.searchtimerSeriesTitle
                ]

                season = textField(it, messages.searchtimerSeason) [
                    placeholder = messages.searchtimerSeason
                ]

                part = textField(it, messages.searchtimerPart) [
                    placeholder = messages.searchtimerPart
                ]
            ]

            horizontalLayout(it) [
                genre = twinColSelect(it, messages.searchtimerGenre) [
                    items = service.genres
                ]

                category = twinColSelect(it, messages.searchtimerCategory) [
                    items = service.categories
                ]
            ]

            year = textField(it, messages.searchtimerYear) [
                placeholder = messages.searchtimerYear
            ]


            horizontalLayout(it)[
                repeatCheckBox = checkbox(it, messages.searchtimerAvoidRepeating) [
                    addValueChangeListener(s | {
                        repeatTitle.enabled = s.value
                        repeatShortText.enabled = s.value
                        repeatDescription.enabled = s.value

                        if (!s.value) {
                            repeatTitle.value = false
                            repeatShortText.value = false
                            repeatDescription.value = false
                        }
                    })
                    value = false
                ]

                repeatTitle = checkbox(it, messages.searchtimerTitle) [
                    enabled = false
                ]

                repeatShortText = checkbox(it, messages.searchtimerShorttext) [
                    enabled = false
                ]

                repeatDescription = checkbox(it, messages.searchtimerDescription) [
                    enabled = false
                ]
            ]
        ]

        val tab3 = verticalLayout[
            channelInclude = radioButtonGroup(it, "") [
                items = #[messages.searchtimerChannelInclude, messages.searchtimerChannelExclude]
                styleName = ValoTheme.OPTIONGROUP_HORIZONTAL
                selectedItem = messages.searchtimerChannelInclude
            ]

            channels = twinColSelect(it, "") [
                items = SvdrpClient.get.channels
                setItemCaptionGenerator(it | it.name)
            ]

            label(it, messages.searchtimerStreamFormat)

            horizontalLayout(it) [
                format1 = nativeSelect(it) [
                    caption = "1."
                    items = #["HD", "SD", "3D"]
                ]

                format2 = nativeSelect(it) [
                    caption = "2."
                    items = #["HD", "SD", "3D"]
                ]

                format3 = nativeSelect(it) [
                    caption = "3."
                    items = #["HD", "SD", "3D"]
                ]
            ]
        ]

        val tab4 = verticalLayout[
            beginCheckBox = checkbox(it, messages.searchtimerStart) [
                addValueChangeListener(s | {
                    beginStart.enabled = s.value
                    beginEnd.enabled = s.value
                    beginMo.enabled = s.value
                    beginTu.enabled = s.value
                    beginWe.enabled = s.value
                    beginTh.enabled = s.value
                    beginFr.enabled = s.value
                    beginSa.enabled = s.value
                    beginSu.enabled = s.value

                    if (!s.value) {
                        beginStart.value = ""
                        beginEnd.value = ""
                        beginMo.value = false
                        beginTu.value = false
                        beginWe.value = false
                        beginTh.value = false
                        beginFr.value = false
                        beginSa.value = false
                        beginSu.value = false
                    }
                })
                value = false
            ]

            horizontalLayout(it) [
                beginStart = textField(it, messages.searchtimerStartStart) [
                    placeholder = messages.searchtimerStartStart
                    enabled = false
                ]

                beginEnd = textField(it, messages.searchtimerStartEnd) [
                    placeholder = messages.searchtimerStartEnd
                    enabled = false
                ]
            ]

            horizontalLayout(it) [
                beginMo = checkbox(it, messages.searchtimerStartMonday) [
                    enabled = false
                ]

                beginTu = checkbox(it, messages.searchtimerStartTuesday) [
                    enabled = false
                ]

                beginWe = checkbox(it, messages.searchtimerStartWednesday) [
                    enabled = false
                ]

                beginTh = checkbox(it, messages.searchtimerStartThursday) [
                    enabled = false
                ]

                beginFr = checkbox(it, messages.searchtimerStartFriday) [
                    enabled = false
                ]

                beginSa = checkbox(it, messages.searchtimerStartSaturday) [
                    enabled = false
                ]

                beginSu = checkbox(it, messages.searchtimerStartSunday) [
                    enabled = false
                ]
            ]
        ]

        val tabsheet = tabsheet[
            addTab(tab1, messages.searchtimerConfiguration)
            addTab(tab2, messages.searchtimerExtended)
            addTab(tab3, messages.searchtimerChannels)
            addTab(tab4, messages.searchtimerStart)

            addStyleName(ValoTheme.TABSHEET_FRAMED);
            addStyleName(ValoTheme.TABSHEET_PADDED_TABBAR);
        ]

        val mainLayout = verticalLayout[
            addComponent(tabsheet)

            cssLayout(it) [
                width = "100%"
                button(it, messages.searchtimerSave) [
                    it.addClickListener(s | {
                        if (saveTimer(timer)) {
                            close
                        }
                    })
                ]

                button(it, messages.searchtimerCancel) [
                    it.addClickListener(s | {
                        close
                    })
                ]
            ]
        ]

        setContent(mainLayout)

        fillTimerValues(timer)
    }

    private def createCaption(EpgdSearchTimer timer) {
        return  messages.searchtimerEdit
    }

    private def fillTimerValues(EpgdSearchTimer timer) {
        name.value = timer.name ?: ""
        active.value = timer.active ?: 0 == 1
        vps.value = timer.vps ?: 0 == 1

        repeatCheckBox.value = timer.repeatfields ?: 0 > 0
        if (repeatCheckBox.value) {
            repeatTitle.value  = getBitFlag(1, timer.repeatfields)
            repeatShortText.value = getBitFlag(2, timer.repeatfields)
            repeatDescription.value = getBitFlag(4, timer.repeatfields)
        }

        searchTitle.value  = getBitFlag(1, timer.searchfields)
        searchShortText.value = getBitFlag(2, timer.searchfields)
        searchDescription.value = getBitFlag(4, timer.searchfields)

        if ((timer.weekdays !== null && timer.weekdays > 0) || (timer.starttime !== null && timer.starttime > 0) || (timer.endtime !== null && timer.endtime > 0) || (StringUtils.isNotEmpty(timer.nextdays) && (Integer.parseInt(timer.nextdays) > 0))) {
            beginCheckBox.value = true
            if (timer.starttime !== null) {
                beginStart.value = String.format("%02d:%02d", timer.starttime / 100, timer.starttime % 100)
            }

            if (timer.endtime !== null) {
                beginEnd.value = String.format("%02d:%02d", timer.endtime / 100, timer.endtime % 100)
            }

            beginMo.value = getBitFlag(1, timer.weekdays)
            beginTu.value = getBitFlag(2, timer.weekdays)
            beginWe.value = getBitFlag(4, timer.weekdays)
            beginTh.value = getBitFlag(8, timer.weekdays)
            beginFr.value = getBitFlag(16, timer.weekdays)
            beginSa.value = getBitFlag(32, timer.weekdays)
            beginSu.value = getBitFlag(64, timer.weekdays)

            // TODO: implement private String nextdays => Form and setter/getter
        }

        priority.value = if (timer.priority !== null && timer.priority > 0) String.valueOf(timer.priority) else "50"
        lifetime.value = if (timer.lifetime !== null && timer.lifetime > 0) String.valueOf(timer.lifetime) else "50"

        seriesTitle.value = timer.episodename ?: ""
        season.value = timer.season ?: ""
        part.value = timer.seasonpart ?: ""

        year.value = if (timer.year !== null && timer.year > 0) String.valueOf(timer.year) else ""

        expression.value = timer.expression ?: ""
        directory.value = timer.directory ?: ""
        casesensitiv.value = timer.casesensitiv !== null && timer.casesensitiv > 0

        if (StringUtils.isNotEmpty(timer.genre)) {
            genre.select(timer.genre.split(",").stream.map(s | StringUtils.removeEnd(StringUtils.removeStart(s, "'"), "'")).collect(Collectors.toList()))
        }

        if (StringUtils.isNotEmpty(timer.category)) {
            category.select(timer.category.split(",").stream.map(s | StringUtils.removeEnd(StringUtils.removeStart(s, "'"), "'")).collect(Collectors.toList()))
        }

        if (StringUtils.isNotEmpty(timer.channelIds)) {
            channels.select(timer.channelIds.split(",").stream.map(s | SvdrpClient.get.getChannel(s)).collect(Collectors.toList()))
        }

        if (timer.chexclude == '0') {
            channelInclude.selectedItem = messages.searchtimerChannelInclude
        } else {
            channelInclude.selectedItem = messages.searchtimerChannelExclude
        }

        if (StringUtils.isNotEmpty(timer.chformat)) {
            val splitted = timer.chformat.split(",").filter[s | StringUtils.isNotEmpty(s)].toList

            format1.selectedItem = splitted.get(0)

            if (splitted.length >= 2) {
                format2.selectedItem = splitted.get(1)
            }

            if (splitted.length >= 3) {
                format3.selectedItem = splitted.get(2)
            }
        }

        switch (timer.type) {
            case 'R': action.selectedItem = messages.searchtimerRecord
            case 'V': action.selectedItem = messages.searchtimerChangeChannel
            case 'S': action.selectedItem = messages.searchtimerSearch
        }

        if (StringUtils.isNotEmpty(timer.template)) {
            template.value = timer.template
        }

        switch (timer.searchmode) {
            case 1: searchMode.selectedItem = messages.searchtimerExact
            case 2: searchMode.selectedItem = messages.searchtimerRegex
            case 3: searchMode.selectedItem = messages.searchtimerPattern
            case 4: searchMode.selectedItem = messages.searchtimerContains
        }

        switch (timer.namingmode) {
            case 0: namingMode.selectedItem = "VDR"
            case 1: namingMode.selectedItem = "Auto"
            case 2: namingMode.selectedItem = "Constabel"
            case 3: namingMode.selectedItem = "Serie"
            case 4: namingMode.selectedItem = "Kategorisiert"
            case 5: namingMode.selectedItem = "Usermode"
            case 6: {
                  namingMode.selectedItem = "Template"
                  template.enabled = true
            }
        }

        vdr.selectedItem = allVdr.stream.filter(s | s.ip == timer.ip && s.port == timer.svdrp).findFirst.get
    }

    private def getBitFlag(int idx, Integer field) {
        if (field === null) {
            return false
        }

        return field.bitwiseAnd(idx) > 0
    }

    private def setBitFlag(boolean value, int idx, Integer field) {
        var f = field

        if (f === null) {
            f = 0
        }

        if (value) {
            return f.bitwiseOr(idx)
        } else {
            return f.bitwiseAnd(idx.bitwiseNot)
        }
    }

    private def createVdrNames() {
        val resultVdr = new ArrayList<VDR>

        resultVdr.add(new VDR("Auto", null, null))

        vdrService.configuredVdr.stream.forEach[ v |
            val vdr = Configuration.get.findVdr(v.ip, v.port)
            if (vdr.isPresent && vdr.get.name != v.name) {
                v.name = vdr.get.name + " (" + v.name + ")"
            }

            resultVdr.add(v)
        ]

        allVdr = resultVdr

        return resultVdr
    }

    private def parseTime(TextField field) {
        try {
            val splitted = field.value.split(":")
            return Long.valueOf(splitted.get(0)) * 100 + Long.valueOf(splitted.get(1))
        } catch(Exception e) {
            field.setComponentError(new UserError("wrong format!"));
            return -1
        }
    }

    private def saveTimer(EpgdSearchTimer timer) {
        var checkResult = true

        // check some values
        if (StringUtils.isEmpty(name.value)) {
            name.setComponentError(new UserError("empty!"));
            checkResult = false
        } else {
            name.componentError = null
        }

        if (StringUtils.isEmpty(expression.value)) {
            expression.setComponentError(new UserError("empty!"));
            checkResult = false
        } else {
            expression.componentError = null
        }

        try {
            if (StringUtils.isNotEmpty(priority.value)) {
                val p = Integer.parseInt(priority.value)
                if (p < 1 || p > 99) {
                    throw new Exception()
                }
            }
        } catch (Exception e) {
            priority.setComponentError(new UserError("> 0 and <= 99"));
            checkResult = false
        }
        priority.componentError = null

        try {
            if (StringUtils.isNotEmpty(lifetime.value)) {
                val p = Integer.parseInt(lifetime.value)
                if (p < 1 || p > 99) {
                    throw new Exception()
                }
            }
        } catch (Exception e) {
            lifetime.setComponentError(new UserError("> 0 and <= 99"));
            checkResult = false
        }
        lifetime.componentError = null

        if (!checkResult) {
            return checkResult
        }

        if (repeatCheckBox.value) {
            timer.repeatfields = setBitFlag(repeatTitle.value, 1, timer.repeatfields)
            timer.repeatfields = setBitFlag(repeatShortText.value, 2, timer.repeatfields)
            timer.repeatfields = setBitFlag(repeatDescription.value, 4, timer.repeatfields)
        } else {
            timer.repeatfields = 0
        }

        if (beginCheckBox.value) {
            if (StringUtils.isNotEmpty(beginStart.value)) {
                val r = parseTime(beginStart)
                if (r == -1) {
                    return false
                }

                timer.starttime = r
            }

            if (StringUtils.isNotEmpty(beginEnd.value)) {
                val r = parseTime(beginEnd)
                if (r == -1) {
                    return false
                }

                timer.endtime = r
            }

            timer.weekdays = setBitFlag(beginMo.value, 1, timer.weekdays)
            timer.weekdays = setBitFlag(beginTu.value, 2, timer.weekdays)
            timer.weekdays = setBitFlag(beginWe.value, 4, timer.weekdays)
            timer.weekdays = setBitFlag(beginTh.value, 8, timer.weekdays)
            timer.weekdays = setBitFlag(beginFr.value, 16, timer.weekdays)
            timer.weekdays = setBitFlag(beginSa.value, 32, timer.weekdays)
            timer.weekdays = setBitFlag(beginSu.value, 64, timer.weekdays)
        } else {
            timer.starttime = null
            timer.endtime = null
            timer.weekdays = null
        }

        switch (action.selectedItem.get) {
            case messages.searchtimerRecord: timer.type = 'R'
            case messages.searchtimerChangeChannel: timer.type = 'V'
            case messages.searchtimerSearch: timer.type = 'S'
        }

        timer.name = name.value
        timer.active = if (active.value) 1 else 0
        timer.vps = if (vps.value) 1 else 0
        timer.directory = directory.value
        timer.template = template.value

        timer.priority = if (StringUtils.isNotEmpty(priority.value)) Integer.parseInt(priority.value) else null
        timer.lifetime = if (StringUtils.isNotEmpty(lifetime.value)) Integer.parseInt(lifetime.value) else null

        timer.expression = expression.value
        timer.casesensitiv = if(casesensitiv.value) 1 else null

        timer.searchfields = setBitFlag(searchTitle.value, 1, timer.searchfields)
        timer.searchfields = setBitFlag(searchShortText.value, 2, timer.searchfields)
        timer.searchfields = setBitFlag(searchDescription.value, 4, timer.searchfields)

        timer.episodename = if (StringUtils.isNotEmpty(seriesTitle.value)) seriesTitle.value else null
        timer.season = if (StringUtils.isNotEmpty(season.value)) season.value else null
        timer.seasonpart = if (StringUtils.isNotEmpty(part.value)) part.value else null
        timer.year = if (StringUtils.isNotEmpty(year.value)) Integer.parseInt(year.value) else null

        switch (namingMode.selectedItem.get) {
            case "VDR":             timer.namingmode = 0
            case "Auto":            timer.namingmode = 1
            case "Constabel":       timer.namingmode = 2
            case "Serie":           timer.namingmode = 3
            case "Kategorisiert":   timer.namingmode = 4
            case "Usermode":        timer.namingmode = 5
            case "Template": {
                  timer.namingmode = 6
                  timer.template = template.value
            }
        }

        if (vdr.selectedItem.get.name == "Auto") {
            timer.vdruuid = "any"
        } else {
            timer.vdruuid = vdr.selectedItem.get.uuid
        }

        switch (searchMode.selectedItem.get) {
            case messages.searchtimerExact: timer.searchmode = 1
            case messages.searchtimerRegex: timer.searchmode = 2
            case messages.searchtimerPattern: timer.searchmode = 3
            case messages.searchtimerContains: timer.searchmode = 4
        }

        val format = #[format1.value, format2.value, format3.value].stream().filter(s | StringUtils.isNotEmpty(s)).collect(Collectors.joining(","))
        if (StringUtils.isNotEmpty(format)) {
            timer.chformat = format
        } else {
            timer.chformat = null
        }

        timer.genre = genre.selectedItems.stream.filter(s | StringUtils.isNotEmpty(s)).map(s | "'" + s + "'").collect(Collectors.joining(","))
        timer.category = category.selectedItems.stream.filter(s | StringUtils.isNotEmpty(s)).map(s | "'" + s + "'").collect(Collectors.joining(","))

        if (channels.selectedItems.size > 0) {
            if (channelInclude.value == messages.searchtimerChannelInclude) {
                timer.chexclude = '0'
            } else {
                timer.chexclude = '1'
            }
            timer.channelIds = channels.selectedItems.stream.map(s | s.id).collect(Collectors.joining(","))
        } else {
            timer.channelIds = null
        }

        service.save(timer)

        return checkResult
    }
}
