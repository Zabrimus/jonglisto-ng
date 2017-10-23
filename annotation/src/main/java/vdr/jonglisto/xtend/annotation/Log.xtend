package vdr.jonglisto.xtend.annotation

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration

@Active(LogProcessor)
annotation Log {
}

class LogProcessor extends AbstractClassProcessor {

    override doTransform(MutableClassDeclaration clazz, extension TransformationContext context) {
        clazz.addField("log") [
            static = true
            final = true            
            type = Logger.newTypeReference
            initializer = '''«LoggerFactory».getLogger("«clazz.qualifiedName»")'''            
        ]
    }
}