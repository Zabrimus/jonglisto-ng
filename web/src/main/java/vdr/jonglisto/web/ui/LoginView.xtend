package vdr.jonglisto.web.ui

import com.vaadin.annotations.Theme
import com.vaadin.navigator.View
import com.vaadin.navigator.ViewChangeListener.ViewChangeEvent
import com.vaadin.server.VaadinService
import com.vaadin.server.VaadinSession
import com.vaadin.ui.Alignment
import com.vaadin.ui.Button
import com.vaadin.ui.Label
import com.vaadin.ui.PasswordField
import com.vaadin.ui.TextField
import com.vaadin.ui.VerticalLayout
import java.util.Locale
import org.apache.shiro.SecurityUtils
import org.apache.shiro.authc.UsernamePasswordToken
import vdr.jonglisto.web.MainUI
import vdr.jonglisto.web.i18n.Messages
import vdr.jonglisto.xtend.annotation.Log

import static extension vdr.jonglisto.web.xtend.UIBuilder.*

@Theme("valo")
@Log
class LoginView extends VerticalLayout implements View {
    
    var TextField username = null
    var PasswordField password = null
    var Button loginButton = null
    var Label invalidPassword = null
    var Locale locale = null

    new(Locale locale) {
        this.locale = locale
        setSizeFull
        
        val messages = new Messages(locale)
        
        panel(messages.loginRequired) [
            setSizeUndefined
            componentAlignment = Alignment.MIDDLE_CENTER
        
            formLayoutPanel [
                setSizeUndefined
                margin = true
    
                username = textField(messages.loginUsername) [
                    focus
                ]
    
                password = passwordField(messages.loginPassword)
    
                loginButton = button(messages.loginLogin) [
                    addClickListener [
                        login
                    ]
                ]
    
                invalidPassword = label(messages.loginFailed) [
                    visible = false
                ]
            ]            
        ]
    }

    def login() {
        val currentUser = SecurityUtils.subject
        val token = new UsernamePasswordToken(username.value, password.value);

        try {
            currentUser.login(token);
            UI.navigator.navigateTo(MainUI.MAIN_VIEW)

            VaadinService.reinitializeSession(VaadinService.currentRequest);
            VaadinSession.current.locale = locale
        } catch(Exception e) {
            log.info(e.getMessage());
            username.value = ""
            password.value = ""
            invalidPassword.visible = true
        }
    }

    override enter(ViewChangeEvent event) {
        // do nothing
    }

}
