package vdr.jonglisto.xtend.annotation

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.AbstractMethodProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

@Active(TraceLogProcessor)
@Target(ElementType.METHOD)
annotation TraceLog {
}

class TraceLogProcessor extends AbstractMethodProcessor
{
    override doTransform(MutableMethodDeclaration method, extension TransformationContext context) {
        val prefix = "internal_"

        method.declaringType.addMethod(prefix + method.simpleName) [ m |
            m.static = method.static
            m.visibility = Visibility.PRIVATE
            m.docComment = method.docComment
            m.exceptions = method.exceptions
            method.parameters.forEach[ p | m.addParameter(p.simpleName, p.type) ]
            m.body = method.body
            m.primarySourceElement = method
            m.returnType = method.returnType
        ]

        method.body = [
            val voidMethod = method.returnType === null || method.returnType.void

            '''
                try {
                    if (log.isTraceEnabled()) {
                        log.trace("«method.simpleName» start");
                    }

                    «IF (!voidMethod)»«method.returnType» ret =«ENDIF» «prefix + method.simpleName»(«method.parameters.map[simpleName].join(", ")»);

                    if (log.isTraceEnabled()) {
                        log.trace("«method.simpleName» end");
                    }

                    «IF (!voidMethod)»return ret;«ENDIF»
                } catch(Exception e) {
                    if (log.isTraceEnabled()) {
                        log.trace("«method.simpleName» ended with exception {}\n{}", e.getClass().getSimpleName(), e.getMessage());
                    }
                    throw e;
                }
            ''']
    }
}
