//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert 
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Änderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren. 
// Generiert: 2018.02.25 um 01:05:07 PM CET 
//


package vdr.jonglisto.configuration.jaxb.remote;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
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
 *       &lt;sequence maxOccurs="unbounded"&gt;
 *         &lt;element name="button"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="key" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded"/&gt;
 *                   &lt;element name="style" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;choice&gt;
 *                     &lt;element name="icon" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                     &lt;element name="label" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                   &lt;/choice&gt;
 *                 &lt;/sequence&gt;
 *                 &lt;attribute name="row" use="required" type="{http://www.w3.org/2001/XMLSchema}unsignedByte" /&gt;
 *                 &lt;attribute name="column" use="required" type="{http://www.w3.org/2001/XMLSchema}unsignedByte" /&gt;
 *               &lt;/restriction&gt;
 *             &lt;/complexContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *       &lt;/sequence&gt;
 *       &lt;attribute name="colorRow" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "button"
})
@XmlRootElement(name = "remote")
public class Remote {

    @XmlElement(required = true)
    protected List<Remote.Button> button;
    @XmlAttribute(name = "colorRow")
    protected Short colorRow;

    /**
     * Gets the value of the button property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the button property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getButton().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Remote.Button }
     * 
     * 
     */
    public List<Remote.Button> getButton() {
        if (button == null) {
            button = new ArrayList<Remote.Button>();
        }
        return this.button;
    }

    /**
     * Ruft den Wert der colorRow-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Short }
     *     
     */
    public Short getColorRow() {
        return colorRow;
    }

    /**
     * Legt den Wert der colorRow-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Short }
     *     
     */
    public void setColorRow(Short value) {
        this.colorRow = value;
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
     *         &lt;element name="key" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded"/&gt;
     *         &lt;element name="style" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;choice&gt;
     *           &lt;element name="icon" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *           &lt;element name="label" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *         &lt;/choice&gt;
     *       &lt;/sequence&gt;
     *       &lt;attribute name="row" use="required" type="{http://www.w3.org/2001/XMLSchema}unsignedByte" /&gt;
     *       &lt;attribute name="column" use="required" type="{http://www.w3.org/2001/XMLSchema}unsignedByte" /&gt;
     *     &lt;/restriction&gt;
     *   &lt;/complexContent&gt;
     * &lt;/complexType&gt;
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "key",
        "style",
        "icon",
        "label"
    })
    public static class Button {

        @XmlElement(required = true)
        protected List<String> key;
        protected String style;
        protected String icon;
        protected String label;
        @XmlAttribute(name = "row", required = true)
        @XmlSchemaType(name = "unsignedByte")
        protected short row;
        @XmlAttribute(name = "column", required = true)
        @XmlSchemaType(name = "unsignedByte")
        protected short column;

        /**
         * Gets the value of the key property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the key property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getKey().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link String }
         * 
         * 
         */
        public List<String> getKey() {
            if (key == null) {
                key = new ArrayList<String>();
            }
            return this.key;
        }

        /**
         * Ruft den Wert der style-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getStyle() {
            return style;
        }

        /**
         * Legt den Wert der style-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setStyle(String value) {
            this.style = value;
        }

        /**
         * Ruft den Wert der icon-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getIcon() {
            return icon;
        }

        /**
         * Legt den Wert der icon-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setIcon(String value) {
            this.icon = value;
        }

        /**
         * Ruft den Wert der label-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getLabel() {
            return label;
        }

        /**
         * Legt den Wert der label-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setLabel(String value) {
            this.label = value;
        }

        /**
         * Ruft den Wert der row-Eigenschaft ab.
         * 
         */
        public short getRow() {
            return row;
        }

        /**
         * Legt den Wert der row-Eigenschaft fest.
         * 
         */
        public void setRow(short value) {
            this.row = value;
        }

        /**
         * Ruft den Wert der column-Eigenschaft ab.
         * 
         */
        public short getColumn() {
            return column;
        }

        /**
         * Legt den Wert der column-Eigenschaft fest.
         * 
         */
        public void setColumn(short value) {
            this.column = value;
        }

    }

}
