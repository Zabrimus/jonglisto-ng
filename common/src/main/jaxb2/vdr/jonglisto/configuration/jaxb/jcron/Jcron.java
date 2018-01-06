//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert 
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Änderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren. 
// Generiert: 2018.01.05 um 10:34:39 PM CET 
//


package vdr.jonglisto.configuration.jaxb.jcron;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java-Klasse für anonymous complex type.
 * 
 * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
 * 
 * <pre>
 * &lt;complexType&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="jobs" maxOccurs="unbounded" minOccurs="0"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                   &lt;element name="active" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
 *                   &lt;element name="user" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                   &lt;element name="time" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                   &lt;element name="action"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;choice&gt;
 *                             &lt;element name="vdrAction"&gt;
 *                               &lt;complexType&gt;
 *                                 &lt;complexContent&gt;
 *                                   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                                     &lt;sequence&gt;
 *                                       &lt;element name="type"&gt;
 *                                         &lt;simpleType&gt;
 *                                           &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *                                             &lt;enumeration value="switchChannel"/&gt;
 *                                             &lt;enumeration value="osdMessage"/&gt;
 *                                             &lt;enumeration value="svdrp"/&gt;
 *                                           &lt;/restriction&gt;
 *                                         &lt;/simpleType&gt;
 *                                       &lt;/element&gt;
 *                                       &lt;element name="vdr" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                       &lt;element name="parameter" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                     &lt;/sequence&gt;
 *                                   &lt;/restriction&gt;
 *                                 &lt;/complexContent&gt;
 *                               &lt;/complexType&gt;
 *                             &lt;/element&gt;
 *                             &lt;element name="shellAction"&gt;
 *                               &lt;complexType&gt;
 *                                 &lt;complexContent&gt;
 *                                   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                                     &lt;sequence&gt;
 *                                       &lt;element name="script" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                       &lt;element name="parameter" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                                     &lt;/sequence&gt;
 *                                   &lt;/restriction&gt;
 *                                 &lt;/complexContent&gt;
 *                               &lt;/complexType&gt;
 *                             &lt;/element&gt;
 *                           &lt;/choice&gt;
 *                         &lt;/restriction&gt;
 *                       &lt;/complexContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                 &lt;/sequence&gt;
 *               &lt;/restriction&gt;
 *             &lt;/complexContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "jobs"
})
@XmlRootElement(name = "jcron")
public class Jcron {

    protected List<Jcron.Jobs> jobs;

    /**
     * Gets the value of the jobs property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the jobs property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getJobs().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Jcron.Jobs }
     * 
     * 
     */
    public List<Jcron.Jobs> getJobs() {
        if (jobs == null) {
            jobs = new ArrayList<Jcron.Jobs>();
        }
        return this.jobs;
    }


    /**
     * <p>Java-Klasse für anonymous complex type.
     * 
     * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
     * 
     * <pre>
     * &lt;complexType&gt;
     *   &lt;complexContent&gt;
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *       &lt;sequence&gt;
     *         &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *         &lt;element name="active" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
     *         &lt;element name="user" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *         &lt;element name="time" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *         &lt;element name="action"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;choice&gt;
     *                   &lt;element name="vdrAction"&gt;
     *                     &lt;complexType&gt;
     *                       &lt;complexContent&gt;
     *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                           &lt;sequence&gt;
     *                             &lt;element name="type"&gt;
     *                               &lt;simpleType&gt;
     *                                 &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
     *                                   &lt;enumeration value="switchChannel"/&gt;
     *                                   &lt;enumeration value="osdMessage"/&gt;
     *                                   &lt;enumeration value="svdrp"/&gt;
     *                                 &lt;/restriction&gt;
     *                               &lt;/simpleType&gt;
     *                             &lt;/element&gt;
     *                             &lt;element name="vdr" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                             &lt;element name="parameter" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                           &lt;/sequence&gt;
     *                         &lt;/restriction&gt;
     *                       &lt;/complexContent&gt;
     *                     &lt;/complexType&gt;
     *                   &lt;/element&gt;
     *                   &lt;element name="shellAction"&gt;
     *                     &lt;complexType&gt;
     *                       &lt;complexContent&gt;
     *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                           &lt;sequence&gt;
     *                             &lt;element name="script" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                             &lt;element name="parameter" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *                           &lt;/sequence&gt;
     *                         &lt;/restriction&gt;
     *                       &lt;/complexContent&gt;
     *                     &lt;/complexType&gt;
     *                   &lt;/element&gt;
     *                 &lt;/choice&gt;
     *               &lt;/restriction&gt;
     *             &lt;/complexContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *       &lt;/sequence&gt;
     *     &lt;/restriction&gt;
     *   &lt;/complexContent&gt;
     * &lt;/complexType&gt;
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "id",
        "active",
        "user",
        "time",
        "action"
    })
    public static class Jobs {

        @XmlElement(required = true)
        protected String id;
        protected boolean active;
        @XmlElement(required = true)
        protected String user;
        @XmlElement(required = true)
        protected String time;
        @XmlElement(required = true)
        protected Jcron.Jobs.Action action;

        /**
         * Ruft den Wert der id-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getId() {
            return id;
        }

        /**
         * Legt den Wert der id-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setId(String value) {
            this.id = value;
        }

        /**
         * Ruft den Wert der active-Eigenschaft ab.
         * 
         */
        public boolean isActive() {
            return active;
        }

        /**
         * Legt den Wert der active-Eigenschaft fest.
         * 
         */
        public void setActive(boolean value) {
            this.active = value;
        }

        /**
         * Ruft den Wert der user-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getUser() {
            return user;
        }

        /**
         * Legt den Wert der user-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setUser(String value) {
            this.user = value;
        }

        /**
         * Ruft den Wert der time-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getTime() {
            return time;
        }

        /**
         * Legt den Wert der time-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setTime(String value) {
            this.time = value;
        }

        /**
         * Ruft den Wert der action-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Jcron.Jobs.Action }
         *     
         */
        public Jcron.Jobs.Action getAction() {
            return action;
        }

        /**
         * Legt den Wert der action-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Jcron.Jobs.Action }
         *     
         */
        public void setAction(Jcron.Jobs.Action value) {
            this.action = value;
        }


        /**
         * <p>Java-Klasse für anonymous complex type.
         * 
         * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
         * 
         * <pre>
         * &lt;complexType&gt;
         *   &lt;complexContent&gt;
         *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
         *       &lt;choice&gt;
         *         &lt;element name="vdrAction"&gt;
         *           &lt;complexType&gt;
         *             &lt;complexContent&gt;
         *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
         *                 &lt;sequence&gt;
         *                   &lt;element name="type"&gt;
         *                     &lt;simpleType&gt;
         *                       &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
         *                         &lt;enumeration value="switchChannel"/&gt;
         *                         &lt;enumeration value="osdMessage"/&gt;
         *                         &lt;enumeration value="svdrp"/&gt;
         *                       &lt;/restriction&gt;
         *                     &lt;/simpleType&gt;
         *                   &lt;/element&gt;
         *                   &lt;element name="vdr" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *                   &lt;element name="parameter" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *                 &lt;/sequence&gt;
         *               &lt;/restriction&gt;
         *             &lt;/complexContent&gt;
         *           &lt;/complexType&gt;
         *         &lt;/element&gt;
         *         &lt;element name="shellAction"&gt;
         *           &lt;complexType&gt;
         *             &lt;complexContent&gt;
         *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
         *                 &lt;sequence&gt;
         *                   &lt;element name="script" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *                   &lt;element name="parameter" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
         *                 &lt;/sequence&gt;
         *               &lt;/restriction&gt;
         *             &lt;/complexContent&gt;
         *           &lt;/complexType&gt;
         *         &lt;/element&gt;
         *       &lt;/choice&gt;
         *     &lt;/restriction&gt;
         *   &lt;/complexContent&gt;
         * &lt;/complexType&gt;
         * </pre>
         * 
         * 
         */
        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "vdrAction",
            "shellAction"
        })
        public static class Action {

            protected Jcron.Jobs.Action.VdrAction vdrAction;
            protected Jcron.Jobs.Action.ShellAction shellAction;

            /**
             * Ruft den Wert der vdrAction-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Jcron.Jobs.Action.VdrAction }
             *     
             */
            public Jcron.Jobs.Action.VdrAction getVdrAction() {
                return vdrAction;
            }

            /**
             * Legt den Wert der vdrAction-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Jcron.Jobs.Action.VdrAction }
             *     
             */
            public void setVdrAction(Jcron.Jobs.Action.VdrAction value) {
                this.vdrAction = value;
            }

            /**
             * Ruft den Wert der shellAction-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Jcron.Jobs.Action.ShellAction }
             *     
             */
            public Jcron.Jobs.Action.ShellAction getShellAction() {
                return shellAction;
            }

            /**
             * Legt den Wert der shellAction-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Jcron.Jobs.Action.ShellAction }
             *     
             */
            public void setShellAction(Jcron.Jobs.Action.ShellAction value) {
                this.shellAction = value;
            }


            /**
             * <p>Java-Klasse für anonymous complex type.
             * 
             * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
             * 
             * <pre>
             * &lt;complexType&gt;
             *   &lt;complexContent&gt;
             *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
             *       &lt;sequence&gt;
             *         &lt;element name="script" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
             *         &lt;element name="parameter" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
             *       &lt;/sequence&gt;
             *     &lt;/restriction&gt;
             *   &lt;/complexContent&gt;
             * &lt;/complexType&gt;
             * </pre>
             * 
             * 
             */
            @XmlAccessorType(XmlAccessType.FIELD)
            @XmlType(name = "", propOrder = {
                "script",
                "parameter"
            })
            public static class ShellAction {

                @XmlElement(required = true)
                protected String script;
                protected String parameter;

                /**
                 * Ruft den Wert der script-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getScript() {
                    return script;
                }

                /**
                 * Legt den Wert der script-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setScript(String value) {
                    this.script = value;
                }

                /**
                 * Ruft den Wert der parameter-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getParameter() {
                    return parameter;
                }

                /**
                 * Legt den Wert der parameter-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setParameter(String value) {
                    this.parameter = value;
                }

            }


            /**
             * <p>Java-Klasse für anonymous complex type.
             * 
             * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
             * 
             * <pre>
             * &lt;complexType&gt;
             *   &lt;complexContent&gt;
             *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
             *       &lt;sequence&gt;
             *         &lt;element name="type"&gt;
             *           &lt;simpleType&gt;
             *             &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
             *               &lt;enumeration value="switchChannel"/&gt;
             *               &lt;enumeration value="osdMessage"/&gt;
             *               &lt;enumeration value="svdrp"/&gt;
             *             &lt;/restriction&gt;
             *           &lt;/simpleType&gt;
             *         &lt;/element&gt;
             *         &lt;element name="vdr" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
             *         &lt;element name="parameter" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
             *       &lt;/sequence&gt;
             *     &lt;/restriction&gt;
             *   &lt;/complexContent&gt;
             * &lt;/complexType&gt;
             * </pre>
             * 
             * 
             */
            @XmlAccessorType(XmlAccessType.FIELD)
            @XmlType(name = "", propOrder = {
                "type",
                "vdr",
                "parameter"
            })
            public static class VdrAction {

                @XmlElement(required = true)
                protected String type;
                @XmlElement(required = true)
                protected String vdr;
                @XmlElement(required = true)
                protected String parameter;

                /**
                 * Ruft den Wert der type-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getType() {
                    return type;
                }

                /**
                 * Legt den Wert der type-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setType(String value) {
                    this.type = value;
                }

                /**
                 * Ruft den Wert der vdr-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getVdr() {
                    return vdr;
                }

                /**
                 * Legt den Wert der vdr-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setVdr(String value) {
                    this.vdr = value;
                }

                /**
                 * Ruft den Wert der parameter-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getParameter() {
                    return parameter;
                }

                /**
                 * Legt den Wert der parameter-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setParameter(String value) {
                    this.parameter = value;
                }

            }

        }

    }

}
