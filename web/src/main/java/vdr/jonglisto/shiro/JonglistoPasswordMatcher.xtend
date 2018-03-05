package vdr.jonglisto.shiro

import org.apache.shiro.authc.credential.PasswordMatcher
import org.apache.shiro.authc.AuthenticationToken
import org.apache.shiro.authc.AuthenticationInfo
import vdr.jonglisto.configuration.Configuration

class JonglistoPasswordMatcher extends PasswordMatcher {

    override boolean doCredentialsMatch(AuthenticationToken token, AuthenticationInfo info) {
        if (Configuration.instance.loginUserUrlParam === null) {
            // delegate to default implementation
            return super.doCredentialsMatch(token, info)
        } else {
            return true;
        }
    }
}
