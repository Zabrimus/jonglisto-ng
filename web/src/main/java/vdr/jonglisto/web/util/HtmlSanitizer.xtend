package vdr.jonglisto.web.util

import org.owasp.html.Sanitizers

class HtmlSanitizer {
   static val policy = Sanitizers.FORMATTING;
   
   static def clean(String str) {
       return policy.sanitize(str)
   }
}
