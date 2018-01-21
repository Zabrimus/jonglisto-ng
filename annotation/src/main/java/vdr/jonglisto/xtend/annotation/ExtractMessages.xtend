/**
 * Copied from https://github.com/oehme/xtend-contrib
 * Thanks to Stefan Oehme
 * License: https://github.com/oehme/xtend-contrib/blob/master/LICENSE
 *
 *
 * I need a slightly modified version, because i want a central property file with all messages
 */

package vdr.jonglisto.xtend.annotation

import com.google.common.base.CaseFormat
import com.google.common.collect.Iterators
import java.lang.annotation.ElementType
import java.lang.annotation.Target
import java.text.DateFormat
import java.text.Format
import java.text.MessageFormat
import java.text.NumberFormat
import java.util.Date
import java.util.Locale
import java.util.PropertyResourceBundle
import java.util.ResourceBundle
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility
import org.eclipse.xtend.lib.macro.services.TypeReferenceProvider

/**
 * Generates a statically typed facade in front of Java ResourceBundles.
 *
 * When annotated on a class called 'MyMessages' it will look for a file called 'MyMessages.properties' in the same
 * directory. For each message key it will create
 * <ul>
 * <li>- a static constant that contains the name of that key</li>
 * <li>- a method that takes as many parameters as the corresponding message has and returns the formatted, localized String</li>
 * </ul>
 * The generated class will have a constructor that takes a Locale and then returns messages in that language using the default
 * ResourceBundle lookup mechanism.
 */
@Target(ElementType.TYPE)
@Active(ExtractMessagesProcessor)
annotation ExtractMessages {
}

class ExtractMessagesProcessor extends AbstractClassProcessor {

    override doTransform(MutableClassDeclaration cls, extension TransformationContext context) {
        val bundleField = cls.addField("bundle") [
            type = ResourceBundle.newTypeReference
            final = false
            primarySourceElement = cls
        ]

        cls.addConstructor [
            body = '''
                this.bundle = «ResourceBundle».getBundle("«cls.qualifiedName»");
            '''
            bundleField.markAsInitializedBy(it)
            primarySourceElement = cls
        ]

        cls.addConstructor [
            addParameter("locale", Locale.newTypeReference)
            body = '''
                this.bundle = «ResourceBundle».getBundle("«cls.qualifiedName»", locale);
            '''
            bundleField.markAsInitializedBy(it)
            primarySourceElement = cls
        ]

        cls.addMethod("changeLocale") [
            addParameter("locale", Locale.newTypeReference)
            body = '''
                this.bundle = «ResourceBundle».getBundle("«cls.qualifiedName»", locale);
            '''
            docComment = "Change the default locale"
            primarySourceElement = cls
        ]

        cls.addMethod("getLocaleLanguage") [
            returnType = string
            body = '''
                return this.bundle.getLocale().getLanguage();
            '''
            docComment = "Returns the current locale"
            primarySourceElement = cls
        ]

        cls.addMethod("getMessage") [
            addParameter("key", string)
            returnType = string
            body = '''
                return bundle.getString(key);
            '''
            docComment = "Returns the raw message String for further processing"
            primarySourceElement = cls
        ]

        val propertyFile = cls.compilationUnit.filePath.parent.append(cls.simpleName + ".properties")
        if (!propertyFile.exists) {
            cls.addError('''Property file «propertyFile» does not exist''')
            return
        }
        val resourceBundle = new PropertyResourceBundle(propertyFile.contentsAsStream)

        Iterators.forEnumeration(resourceBundle.keys).forEach [ key |
            val pattern = resourceBundle.getString(key)
            cls.addField(key.toUpperCase)[
                type = string
                visibility = Visibility.PUBLIC
                final = true
                static = true
                docComment = pattern
                primarySourceElement = cls
                initializer = '''"«key»"'''
            ]
            val patternVariables = new MessageFormat(pattern).formats
            cls.addMethod(key.keyToMethodName) [
                patternVariables.forEach [ patternVariable, index |
                    addParameter("arg" + index, patternVariable.argumentType(context))
                ]
                returnType = string
                docComment = pattern
                primarySourceElement = cls
                body = '''
                    «IF (patternVariables.length > 0)»
                    «String» pattern = bundle.getString(«key.toUpperCase»);
                    «MessageFormat» format = new «MessageFormat»(pattern);
                    return format.format(new «Object»[]{«parameters.join(", ")[simpleName]»});
                    «ELSE»
                    return bundle.getString(«key.toUpperCase»);
                    «ENDIF»
                '''
            ]
        ]
    }

    def keyToMethodName(String key) {
        CaseFormat.UPPER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, key).toFirstLower
    }

    def argumentType(Format format, extension TypeReferenceProvider typeRefs) {
        switch format {
            NumberFormat: Number.newTypeReference
            DateFormat: Date.newTypeReference
            default: object
        }
    }
}
