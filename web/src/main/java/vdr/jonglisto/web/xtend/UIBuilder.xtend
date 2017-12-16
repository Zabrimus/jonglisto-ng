package vdr.jonglisto.web.xtend

import com.vaadin.server.Resource
import com.vaadin.ui.Button
import com.vaadin.ui.CheckBox
import com.vaadin.ui.ComboBox
import com.vaadin.ui.ComponentContainer
import com.vaadin.ui.CssLayout
import com.vaadin.ui.DateField
import com.vaadin.ui.FormLayout
import com.vaadin.ui.HorizontalLayout
import com.vaadin.ui.Label
import com.vaadin.ui.Layout
import com.vaadin.ui.ListSelect
import com.vaadin.ui.MenuBar
import com.vaadin.ui.MenuBar.Command
import com.vaadin.ui.MenuBar.MenuItem
import com.vaadin.ui.NativeSelect
import com.vaadin.ui.Panel
import com.vaadin.ui.PasswordField
import com.vaadin.ui.ProgressBar
import com.vaadin.ui.RadioButtonGroup
import com.vaadin.ui.TabSheet
import com.vaadin.ui.TextArea
import com.vaadin.ui.TextField
import com.vaadin.ui.TwinColSelect
import com.vaadin.ui.VerticalLayout
import java.util.List
import vdr.jonglisto.model.Channel
import vdr.jonglisto.model.VDR

class UIBuilder {

    static def label(ComponentContainer it, String str) {
        val that = new Label(str)
        it.addComponent(that)
        return that
    }

    static def label(ComponentContainer it, String str, (Label)=>void initializer) {
        val that = new Label(str)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def formLayout(ComponentContainer it, (FormLayout)=>void initializer) {
        val that = new FormLayout
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def formLayoutPanel(Panel it, (FormLayout)=>void initializer) {
        val that = new FormLayout
        it.content = that
        that.init(initializer)
        return that
    }

    static def verticalLayout(ComponentContainer it, (VerticalLayout)=>void initializer) {
        val that = new VerticalLayout
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def verticalLayout((VerticalLayout)=>void initializer) {
        val that = new VerticalLayout
        that.init(initializer)
        return that
    }

    static def verticalLayout(Layout it, (VerticalLayout)=>void initializer) {
        val that = new VerticalLayout
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def verticalLayout(Panel it, (VerticalLayout)=>void initializer) {
        val that = new VerticalLayout
        it.content = that
        that.init(initializer)
        return that
    }

    static def horizontalLayout(ComponentContainer it, (HorizontalLayout)=>void initializer) {
        val that = new HorizontalLayout
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def horizontalLayout(Panel it, (HorizontalLayout)=>void initializer) {
        val that = new HorizontalLayout
        it.content = that
        that.init(initializer)
        return that
    }

    static def cssLayout(ComponentContainer it, (CssLayout)=>void initializer) {
        val that = new CssLayout
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def cssLayout((CssLayout)=>void initializer) {
        val that = new CssLayout
        that.init(initializer)
        return that
    }

    static def tabsheet((TabSheet)=>void initializer) {
        val that = new TabSheet
        that.init(initializer)
        return that
    }

    static def progressBar(ComponentContainer it, Float value, (ProgressBar)=>void initializer) {
        val that = new ProgressBar(value)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def progressBar(ComponentContainer it, Float value) {
        val that = new ProgressBar(value)
        it.addComponent(that)
        return that
    }

    static def textField(ComponentContainer it, String str) {
        val that = new TextField(str)
        it.addComponent(that)
        return that
    }

    static def textField(ComponentContainer it, String str, (TextField)=>void initializer) {
        val that = new TextField(str)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def textArea(ComponentContainer it, String caption, String str, (TextArea)=>void initializer) {
        val that = new TextArea(caption)
        if (str !== null) {
            that.value = str
        }
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def dateField(ComponentContainer it, String str, (DateField)=>void initializer) {
        val that = new DateField(str)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def passwordField(ComponentContainer it, String str) {
        val that = new PasswordField(str)
        it.addComponent(that)
        return that
    }

    static def passwordField(ComponentContainer it, String str, (PasswordField)=>void initializer) {
        val that = new PasswordField(str)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def checkbox(ComponentContainer it, String str, (CheckBox)=>void initializer) {
        val that = new CheckBox(str)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def radioButtonGroup(ComponentContainer it, String str, (RadioButtonGroup<String>)=>void initializer) {
        val that = new RadioButtonGroup<String>(str)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def <T> twinColSelect(ComponentContainer it, String str, (TwinColSelect<T>)=>void initializer) {
        val that = new TwinColSelect<T>(str)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def button(ComponentContainer it, String str, (Button)=>void initializer) {
        val that = new Button(str)
        that.init(initializer)
        it.addComponent(that)
        return that
    }

    static def vbutton(String str, (Button)=>void initializer) {
        val that = new Button(str)
        that.init(initializer)
        return that
    }

    static def panel(ComponentContainer it, String str, (Panel)=>void initializer) {
        val that = new Panel(str)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def panel(ComponentContainer it, (Panel)=>void initializer) {
        val that = new Panel
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def menuBar(ComponentContainer it, (MenuBar)=>void initializer) {
        val that = new MenuBar
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def menuItem(MenuBar it, String label) {
        val newItem = it.addItem(label, null, null)
        return newItem
    }

    static def menuItem(MenuBar it, String label, Command command) {
        val newItem = it.addItem(label, null, command)
        return newItem
    }

    static def menuItem(MenuBar it, String label, Resource icon, Command command) {
        val newItem = it.addItem(label, icon, command)
        return newItem
    }

    static def menuItem(MenuItem it, String label, Command command) {
        val newItem = it.addItem(label, null, command)
        return newItem
    }

    static def comboBox(ComponentContainer it, List<String> items, (ComboBox<String>)=>void initializer) {
        val that = new ComboBox
        that.items = items;
        if (items.size > 0) {
            that.selectedItem = items.get(0)
        }
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def comboBoxVdr(ComponentContainer it, List<VDR> items, (ComboBox<VDR>)=>void initializer) {
        val that = new ComboBox
        that.items = items;
        if (items.size > 0) {
            that.selectedItem = items.get(0)
        }
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def comboBoxChannel(ComponentContainer it, List<Channel> items, (ComboBox<Channel>)=>void initializer) {
        val that = new ComboBox
        that.items = items;
        that.selectedItem = items.get(0)
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def dateField(ComponentContainer it, (DateField)=>void initializer) {
        val that = new DateField
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def nativeSelect(ComponentContainer it, (NativeSelect<String>)=>void initializer) {
        val that = new NativeSelect
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def nativeChannelSelect(ComponentContainer it, (NativeSelect<Channel>)=>void initializer) {
        val that = new NativeSelect
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def listSelect(ComponentContainer it, (ListSelect<String>)=>void initializer) {
        val that = new ListSelect
        it.addComponent(that)
        that.init(initializer)
        return that
    }

    static def private <T> T init(T obj, (T)=>void init) {
        init?.apply(obj)
        return obj
    }
}
