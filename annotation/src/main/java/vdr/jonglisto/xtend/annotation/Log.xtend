package vdr.jonglisto.xtend.annotation

import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.slf4j.Logger
import org.slf4j.LoggerFactory

@Active(LogProcessor)
annotation Log {
    val String value
}

class LogProcessor extends AbstractClassProcessor {

    def Class<?> getAnnotationType() { Log }

    override doTransform(MutableClassDeclaration clazz, extension TransformationContext context) {
        val annotation = clazz.annotations.filter [ annotationTypeDeclaration.qualifiedName == annotationType.name ].findFirst[true]
        val value = annotation.getStringValue('value');

        clazz.addField("log") [
            static = true
            final = true
            type = Logger.newTypeReference
            initializer = '''«LoggerFactory».getLogger("«value»")'''
        ]
    }
}
