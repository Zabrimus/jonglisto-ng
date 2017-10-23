package vdr.jonglisto.xtend.annotation

import java.lang.annotation.ElementType
import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.RegisterGlobalsContext
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.ClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

@Target(ElementType.TYPE)
@Active(CallExtractInterfaceProcessor)
annotation ExtractInterface {
    String interfaceName
}

class CallExtractInterfaceProcessor extends AbstractClassProcessor {
    
    def Class<?> getAnnotationType() { ExtractInterface }
    
    override doRegisterGlobals(ClassDeclaration annotatedClass, RegisterGlobalsContext context) {
        context.registerInterface(annotatedClass.interfaceName)
    }

    def getInterfaceName(ClassDeclaration annotatedClass) {
        val anno = annotatedClass.annotations.filter [ annotationTypeDeclaration.qualifiedName == annotationType.name ].findFirst[true]
        anno.getValue('interfaceName') as String
    }
     
    override doTransform(MutableClassDeclaration annotatedClass, extension TransformationContext context) {
        val interfaceType = findInterface(annotatedClass.interfaceName)
        interfaceType.primarySourceElement = annotatedClass
        // add the interface to the list of implemented interfaces
        annotatedClass.implementedInterfaces = annotatedClass.implementedInterfaces + #[interfaceType.newTypeReference]
        
        // add the public methods to the interface
        for (method : annotatedClass.declaredMethods) {
            if (method.visibility == Visibility.PUBLIC) {                
                interfaceType.addMethod(method.simpleName) [
                    docComment = method.docComment
                    returnType = method.returnType
                    for (p : method.parameters) {
                        addParameter(p.simpleName, p.type)
                    }
                    exceptions = method.exceptions
                    primarySourceElement = method           
                ]
            }
        }
    }
    
}