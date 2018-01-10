//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert 
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Änderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren. 
// Generiert: 2018.01.09 um 06:12:21 PM CET 
//


package vdr.jonglisto.configuration.jaxb.jcron;

import javax.xml.bind.annotation.XmlRegistry;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the vdr.jonglisto.configuration.jaxb.jcron package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {


    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: vdr.jonglisto.configuration.jaxb.jcron
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link Jcron }
     * 
     */
    public Jcron createJcron() {
        return new Jcron();
    }

    /**
     * Create an instance of {@link Jcron.Jobs }
     * 
     */
    public Jcron.Jobs createJcronJobs() {
        return new Jcron.Jobs();
    }

    /**
     * Create an instance of {@link Jcron.Jobs.Action }
     * 
     */
    public Jcron.Jobs.Action createJcronJobsAction() {
        return new Jcron.Jobs.Action();
    }

    /**
     * Create an instance of {@link Jcron.Jobs.Action.VdrAction }
     * 
     */
    public Jcron.Jobs.Action.VdrAction createJcronJobsActionVdrAction() {
        return new Jcron.Jobs.Action.VdrAction();
    }

    /**
     * Create an instance of {@link Jcron.Jobs.Action.ShellAction }
     * 
     */
    public Jcron.Jobs.Action.ShellAction createJcronJobsActionShellAction() {
        return new Jcron.Jobs.Action.ShellAction();
    }

}
