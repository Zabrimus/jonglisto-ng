//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert 
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Änderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren. 
// Generiert: 2018.10.22 um 06:00:08 PM CEST 
//


package vdr.jonglisto.configuration.jaxb.config;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlValue;


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
 *         &lt;element name="servername" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *         &lt;element name="directory"&gt;
 *           &lt;complexType&gt;
 *             &lt;simpleContent&gt;
 *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                 &lt;attribute name="dir" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *               &lt;/extension&gt;
 *             &lt;/simpleContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="configuredVdr"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="instance" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;simpleContent&gt;
 *                         &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                           &lt;attribute name="name" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                           &lt;attribute name="displayName" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                           &lt;attribute name="host" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                           &lt;attribute name="port" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="mac" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                           &lt;attribute name="osd2web" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                         &lt;/extension&gt;
 *                       &lt;/simpleContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                 &lt;/sequence&gt;
 *               &lt;/restriction&gt;
 *             &lt;/complexContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="jonglisto-plugin" minOccurs="0"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="allow" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;sequence&gt;
 *                             &lt;element name="command" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded" minOccurs="0"/&gt;
 *                           &lt;/sequence&gt;
 *                           &lt;attribute name="vdr" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                         &lt;/restriction&gt;
 *                       &lt;/complexContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                 &lt;/sequence&gt;
 *               &lt;/restriction&gt;
 *             &lt;/complexContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="epg"&gt;
 *           &lt;complexType&gt;
 *             &lt;simpleContent&gt;
 *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                 &lt;attribute name="ref" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                 &lt;attribute name="updateInterval" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *               &lt;/extension&gt;
 *             &lt;/simpleContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="channel"&gt;
 *           &lt;complexType&gt;
 *             &lt;simpleContent&gt;
 *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                 &lt;attribute name="ref" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                 &lt;attribute name="updateInterval" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *               &lt;/extension&gt;
 *             &lt;/simpleContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="epg2vdr"&gt;
 *           &lt;complexType&gt;
 *             &lt;simpleContent&gt;
 *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                 &lt;attribute name="host" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                 &lt;attribute name="port" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                 &lt;attribute name="username" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                 &lt;attribute name="password" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *                 &lt;attribute name="database" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *               &lt;/extension&gt;
 *             &lt;/simpleContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="svdrpPort" type="{http://www.w3.org/2001/XMLSchema}int" minOccurs="0"/&gt;
 *         &lt;element name="startDiscovery" type="{http://www.w3.org/2001/XMLSchema}boolean" minOccurs="0"/&gt;
 *         &lt;element name="timezone"&gt;
 *           &lt;complexType&gt;
 *             &lt;simpleContent&gt;
 *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                 &lt;attribute name="tz" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *               &lt;/extension&gt;
 *             &lt;/simpleContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="disableLogin"&gt;
 *           &lt;complexType&gt;
 *             &lt;simpleContent&gt;
 *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                 &lt;attribute name="urlUserParam" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
 *               &lt;/extension&gt;
 *             &lt;/simpleContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="scraper" minOccurs="0"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="images" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
 *                   &lt;element name="imagePath" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;sequence&gt;
 *                             &lt;element name="replace" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                             &lt;element name="to" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                           &lt;/sequence&gt;
 *                         &lt;/restriction&gt;
 *                       &lt;/complexContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                 &lt;/sequence&gt;
 *               &lt;/restriction&gt;
 *             &lt;/complexContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="epgTimeList"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="value" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded" minOccurs="0"/&gt;
 *                 &lt;/sequence&gt;
 *               &lt;/restriction&gt;
 *             &lt;/complexContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="svdrpCommandList"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="command" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded" minOccurs="0"/&gt;
 *                 &lt;/sequence&gt;
 *               &lt;/restriction&gt;
 *             &lt;/complexContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="epg-columns"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="series"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;sequence&gt;
 *                             &lt;element name="season"&gt;
 *                               &lt;complexType&gt;
 *                                 &lt;complexContent&gt;
 *                                   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                                     &lt;sequence&gt;
 *                                       &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                       &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
 *                                     &lt;/sequence&gt;
 *                                   &lt;/restriction&gt;
 *                                 &lt;/complexContent&gt;
 *                               &lt;/complexType&gt;
 *                             &lt;/element&gt;
 *                             &lt;element name="part"&gt;
 *                               &lt;complexType&gt;
 *                                 &lt;complexContent&gt;
 *                                   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                                     &lt;sequence&gt;
 *                                       &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                       &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
 *                                     &lt;/sequence&gt;
 *                                   &lt;/restriction&gt;
 *                                 &lt;/complexContent&gt;
 *                               &lt;/complexType&gt;
 *                             &lt;/element&gt;
 *                             &lt;element name="parts"&gt;
 *                               &lt;complexType&gt;
 *                                 &lt;complexContent&gt;
 *                                   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                                     &lt;sequence&gt;
 *                                       &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                       &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
 *                                     &lt;/sequence&gt;
 *                                   &lt;/restriction&gt;
 *                                 &lt;/complexContent&gt;
 *                               &lt;/complexType&gt;
 *                             &lt;/element&gt;
 *                           &lt;/sequence&gt;
 *                         &lt;/restriction&gt;
 *                       &lt;/complexContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="genre"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;sequence&gt;
 *                             &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                             &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
 *                           &lt;/sequence&gt;
 *                         &lt;/restriction&gt;
 *                       &lt;/complexContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="category"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;sequence&gt;
 *                             &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                             &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
 *                           &lt;/sequence&gt;
 *                         &lt;/restriction&gt;
 *                       &lt;/complexContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="custom-pattern"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;sequence&gt;
 *                             &lt;element name="custom" maxOccurs="unbounded" minOccurs="0"&gt;
 *                               &lt;complexType&gt;
 *                                 &lt;complexContent&gt;
 *                                   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                                     &lt;sequence&gt;
 *                                       &lt;element name="header" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                       &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                       &lt;element name="output" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                                     &lt;/sequence&gt;
 *                                   &lt;/restriction&gt;
 *                                 &lt;/complexContent&gt;
 *                               &lt;/complexType&gt;
 *                             &lt;/element&gt;
 *                           &lt;/sequence&gt;
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
    "servername",
    "directory",
    "configuredVdr",
    "jonglistoPlugin",
    "epg",
    "channel",
    "epg2Vdr",
    "svdrpPort",
    "startDiscovery",
    "timezone",
    "disableLogin",
    "scraper",
    "epgTimeList",
    "svdrpCommandList",
    "epgColumns"
})
@XmlRootElement(name = "jonglisto")
public class Jonglisto {

    protected String servername;
    @XmlElement(required = true)
    protected Jonglisto.Directory directory;
    @XmlElement(required = true)
    protected Jonglisto.ConfiguredVdr configuredVdr;
    @XmlElement(name = "jonglisto-plugin")
    protected Jonglisto.JonglistoPlugin jonglistoPlugin;
    @XmlElement(required = true)
    protected Jonglisto.Epg epg;
    @XmlElement(required = true)
    protected Jonglisto.Channel channel;
    @XmlElement(name = "epg2vdr", required = true)
    protected Jonglisto.Epg2Vdr epg2Vdr;
    protected Integer svdrpPort;
    protected Boolean startDiscovery;
    @XmlElement(required = true)
    protected Jonglisto.Timezone timezone;
    @XmlElement(required = true)
    protected Jonglisto.DisableLogin disableLogin;
    protected Jonglisto.Scraper scraper;
    @XmlElement(required = true)
    protected Jonglisto.EpgTimeList epgTimeList;
    @XmlElement(required = true)
    protected Jonglisto.SvdrpCommandList svdrpCommandList;
    @XmlElement(name = "epg-columns", required = true)
    protected Jonglisto.EpgColumns epgColumns;

    /**
     * Ruft den Wert der servername-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getServername() {
        return servername;
    }

    /**
     * Legt den Wert der servername-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setServername(String value) {
        this.servername = value;
    }

    /**
     * Ruft den Wert der directory-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.Directory }
     *     
     */
    public Jonglisto.Directory getDirectory() {
        return directory;
    }

    /**
     * Legt den Wert der directory-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.Directory }
     *     
     */
    public void setDirectory(Jonglisto.Directory value) {
        this.directory = value;
    }

    /**
     * Ruft den Wert der configuredVdr-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.ConfiguredVdr }
     *     
     */
    public Jonglisto.ConfiguredVdr getConfiguredVdr() {
        return configuredVdr;
    }

    /**
     * Legt den Wert der configuredVdr-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.ConfiguredVdr }
     *     
     */
    public void setConfiguredVdr(Jonglisto.ConfiguredVdr value) {
        this.configuredVdr = value;
    }

    /**
     * Ruft den Wert der jonglistoPlugin-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.JonglistoPlugin }
     *     
     */
    public Jonglisto.JonglistoPlugin getJonglistoPlugin() {
        return jonglistoPlugin;
    }

    /**
     * Legt den Wert der jonglistoPlugin-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.JonglistoPlugin }
     *     
     */
    public void setJonglistoPlugin(Jonglisto.JonglistoPlugin value) {
        this.jonglistoPlugin = value;
    }

    /**
     * Ruft den Wert der epg-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.Epg }
     *     
     */
    public Jonglisto.Epg getEpg() {
        return epg;
    }

    /**
     * Legt den Wert der epg-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.Epg }
     *     
     */
    public void setEpg(Jonglisto.Epg value) {
        this.epg = value;
    }

    /**
     * Ruft den Wert der channel-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.Channel }
     *     
     */
    public Jonglisto.Channel getChannel() {
        return channel;
    }

    /**
     * Legt den Wert der channel-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.Channel }
     *     
     */
    public void setChannel(Jonglisto.Channel value) {
        this.channel = value;
    }

    /**
     * Ruft den Wert der epg2Vdr-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.Epg2Vdr }
     *     
     */
    public Jonglisto.Epg2Vdr getEpg2Vdr() {
        return epg2Vdr;
    }

    /**
     * Legt den Wert der epg2Vdr-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.Epg2Vdr }
     *     
     */
    public void setEpg2Vdr(Jonglisto.Epg2Vdr value) {
        this.epg2Vdr = value;
    }

    /**
     * Ruft den Wert der svdrpPort-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getSvdrpPort() {
        return svdrpPort;
    }

    /**
     * Legt den Wert der svdrpPort-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setSvdrpPort(Integer value) {
        this.svdrpPort = value;
    }

    /**
     * Ruft den Wert der startDiscovery-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Boolean }
     *     
     */
    public Boolean isStartDiscovery() {
        return startDiscovery;
    }

    /**
     * Legt den Wert der startDiscovery-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Boolean }
     *     
     */
    public void setStartDiscovery(Boolean value) {
        this.startDiscovery = value;
    }

    /**
     * Ruft den Wert der timezone-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.Timezone }
     *     
     */
    public Jonglisto.Timezone getTimezone() {
        return timezone;
    }

    /**
     * Legt den Wert der timezone-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.Timezone }
     *     
     */
    public void setTimezone(Jonglisto.Timezone value) {
        this.timezone = value;
    }

    /**
     * Ruft den Wert der disableLogin-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.DisableLogin }
     *     
     */
    public Jonglisto.DisableLogin getDisableLogin() {
        return disableLogin;
    }

    /**
     * Legt den Wert der disableLogin-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.DisableLogin }
     *     
     */
    public void setDisableLogin(Jonglisto.DisableLogin value) {
        this.disableLogin = value;
    }

    /**
     * Ruft den Wert der scraper-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.Scraper }
     *     
     */
    public Jonglisto.Scraper getScraper() {
        return scraper;
    }

    /**
     * Legt den Wert der scraper-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.Scraper }
     *     
     */
    public void setScraper(Jonglisto.Scraper value) {
        this.scraper = value;
    }

    /**
     * Ruft den Wert der epgTimeList-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.EpgTimeList }
     *     
     */
    public Jonglisto.EpgTimeList getEpgTimeList() {
        return epgTimeList;
    }

    /**
     * Legt den Wert der epgTimeList-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.EpgTimeList }
     *     
     */
    public void setEpgTimeList(Jonglisto.EpgTimeList value) {
        this.epgTimeList = value;
    }

    /**
     * Ruft den Wert der svdrpCommandList-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.SvdrpCommandList }
     *     
     */
    public Jonglisto.SvdrpCommandList getSvdrpCommandList() {
        return svdrpCommandList;
    }

    /**
     * Legt den Wert der svdrpCommandList-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.SvdrpCommandList }
     *     
     */
    public void setSvdrpCommandList(Jonglisto.SvdrpCommandList value) {
        this.svdrpCommandList = value;
    }

    /**
     * Ruft den Wert der epgColumns-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Jonglisto.EpgColumns }
     *     
     */
    public Jonglisto.EpgColumns getEpgColumns() {
        return epgColumns;
    }

    /**
     * Legt den Wert der epgColumns-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Jonglisto.EpgColumns }
     *     
     */
    public void setEpgColumns(Jonglisto.EpgColumns value) {
        this.epgColumns = value;
    }


    /**
     * <p>Java-Klasse für anonymous complex type.
     * 
     * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
     * 
     * <pre>
     * &lt;complexType&gt;
     *   &lt;simpleContent&gt;
     *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *       &lt;attribute name="ref" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *       &lt;attribute name="updateInterval" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *     &lt;/extension&gt;
     *   &lt;/simpleContent&gt;
     * &lt;/complexType&gt;
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "value"
    })
    public static class Channel {

        @XmlValue
        protected String value;
        @XmlAttribute(name = "ref")
        protected String ref;
        @XmlAttribute(name = "updateInterval")
        protected Short updateInterval;

        /**
         * Ruft den Wert der value-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getValue() {
            return value;
        }

        /**
         * Legt den Wert der value-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setValue(String value) {
            this.value = value;
        }

        /**
         * Ruft den Wert der ref-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getRef() {
            return ref;
        }

        /**
         * Legt den Wert der ref-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setRef(String value) {
            this.ref = value;
        }

        /**
         * Ruft den Wert der updateInterval-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Short }
         *     
         */
        public Short getUpdateInterval() {
            return updateInterval;
        }

        /**
         * Legt den Wert der updateInterval-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Short }
         *     
         */
        public void setUpdateInterval(Short value) {
            this.updateInterval = value;
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
     *         &lt;element name="instance" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;simpleContent&gt;
     *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *                 &lt;attribute name="name" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *                 &lt;attribute name="displayName" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *                 &lt;attribute name="host" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *                 &lt;attribute name="port" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="mac" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *                 &lt;attribute name="osd2web" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *               &lt;/extension&gt;
     *             &lt;/simpleContent&gt;
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
        "instance"
    })
    public static class ConfiguredVdr {

        protected List<Jonglisto.ConfiguredVdr.Instance> instance;

        /**
         * Gets the value of the instance property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the instance property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getInstance().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Jonglisto.ConfiguredVdr.Instance }
         * 
         * 
         */
        public List<Jonglisto.ConfiguredVdr.Instance> getInstance() {
            if (instance == null) {
                instance = new ArrayList<Jonglisto.ConfiguredVdr.Instance>();
            }
            return this.instance;
        }


        /**
         * <p>Java-Klasse für anonymous complex type.
         * 
         * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
         * 
         * <pre>
         * &lt;complexType&gt;
         *   &lt;simpleContent&gt;
         *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
         *       &lt;attribute name="name" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
         *       &lt;attribute name="displayName" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
         *       &lt;attribute name="host" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
         *       &lt;attribute name="port" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="mac" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
         *       &lt;attribute name="osd2web" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
         *     &lt;/extension&gt;
         *   &lt;/simpleContent&gt;
         * &lt;/complexType&gt;
         * </pre>
         * 
         * 
         */
        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "value"
        })
        public static class Instance {

            @XmlValue
            protected String value;
            @XmlAttribute(name = "name")
            protected String name;
            @XmlAttribute(name = "displayName")
            protected String displayName;
            @XmlAttribute(name = "host")
            protected String host;
            @XmlAttribute(name = "port")
            protected Short port;
            @XmlAttribute(name = "mac")
            protected String mac;
            @XmlAttribute(name = "osd2web")
            protected String osd2Web;

            /**
             * Ruft den Wert der value-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getValue() {
                return value;
            }

            /**
             * Legt den Wert der value-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setValue(String value) {
                this.value = value;
            }

            /**
             * Ruft den Wert der name-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getName() {
                return name;
            }

            /**
             * Legt den Wert der name-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setName(String value) {
                this.name = value;
            }

            /**
             * Ruft den Wert der displayName-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getDisplayName() {
                return displayName;
            }

            /**
             * Legt den Wert der displayName-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setDisplayName(String value) {
                this.displayName = value;
            }

            /**
             * Ruft den Wert der host-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getHost() {
                return host;
            }

            /**
             * Legt den Wert der host-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setHost(String value) {
                this.host = value;
            }

            /**
             * Ruft den Wert der port-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getPort() {
                return port;
            }

            /**
             * Legt den Wert der port-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setPort(Short value) {
                this.port = value;
            }

            /**
             * Ruft den Wert der mac-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getMac() {
                return mac;
            }

            /**
             * Legt den Wert der mac-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setMac(String value) {
                this.mac = value;
            }

            /**
             * Ruft den Wert der osd2Web-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getOsd2Web() {
                return osd2Web;
            }

            /**
             * Legt den Wert der osd2Web-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setOsd2Web(String value) {
                this.osd2Web = value;
            }

        }

    }


    /**
     * <p>Java-Klasse für anonymous complex type.
     * 
     * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
     * 
     * <pre>
     * &lt;complexType&gt;
     *   &lt;simpleContent&gt;
     *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *       &lt;attribute name="dir" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *     &lt;/extension&gt;
     *   &lt;/simpleContent&gt;
     * &lt;/complexType&gt;
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "value"
    })
    public static class Directory {

        @XmlValue
        protected String value;
        @XmlAttribute(name = "dir")
        protected String dir;

        /**
         * Ruft den Wert der value-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getValue() {
            return value;
        }

        /**
         * Legt den Wert der value-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setValue(String value) {
            this.value = value;
        }

        /**
         * Ruft den Wert der dir-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getDir() {
            return dir;
        }

        /**
         * Legt den Wert der dir-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setDir(String value) {
            this.dir = value;
        }

    }


    /**
     * <p>Java-Klasse für anonymous complex type.
     * 
     * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
     * 
     * <pre>
     * &lt;complexType&gt;
     *   &lt;simpleContent&gt;
     *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *       &lt;attribute name="urlUserParam" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *     &lt;/extension&gt;
     *   &lt;/simpleContent&gt;
     * &lt;/complexType&gt;
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "value"
    })
    public static class DisableLogin {

        @XmlValue
        protected String value;
        @XmlAttribute(name = "urlUserParam")
        protected String urlUserParam;

        /**
         * Ruft den Wert der value-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getValue() {
            return value;
        }

        /**
         * Legt den Wert der value-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setValue(String value) {
            this.value = value;
        }

        /**
         * Ruft den Wert der urlUserParam-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getUrlUserParam() {
            return urlUserParam;
        }

        /**
         * Legt den Wert der urlUserParam-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setUrlUserParam(String value) {
            this.urlUserParam = value;
        }

    }


    /**
     * <p>Java-Klasse für anonymous complex type.
     * 
     * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
     * 
     * <pre>
     * &lt;complexType&gt;
     *   &lt;simpleContent&gt;
     *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *       &lt;attribute name="ref" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *       &lt;attribute name="updateInterval" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *     &lt;/extension&gt;
     *   &lt;/simpleContent&gt;
     * &lt;/complexType&gt;
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "value"
    })
    public static class Epg {

        @XmlValue
        protected String value;
        @XmlAttribute(name = "ref")
        protected String ref;
        @XmlAttribute(name = "updateInterval")
        protected Short updateInterval;

        /**
         * Ruft den Wert der value-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getValue() {
            return value;
        }

        /**
         * Legt den Wert der value-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setValue(String value) {
            this.value = value;
        }

        /**
         * Ruft den Wert der ref-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getRef() {
            return ref;
        }

        /**
         * Legt den Wert der ref-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setRef(String value) {
            this.ref = value;
        }

        /**
         * Ruft den Wert der updateInterval-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Short }
         *     
         */
        public Short getUpdateInterval() {
            return updateInterval;
        }

        /**
         * Legt den Wert der updateInterval-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Short }
         *     
         */
        public void setUpdateInterval(Short value) {
            this.updateInterval = value;
        }

    }


    /**
     * <p>Java-Klasse für anonymous complex type.
     * 
     * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
     * 
     * <pre>
     * &lt;complexType&gt;
     *   &lt;simpleContent&gt;
     *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *       &lt;attribute name="host" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *       &lt;attribute name="port" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *       &lt;attribute name="username" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *       &lt;attribute name="password" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *       &lt;attribute name="database" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *     &lt;/extension&gt;
     *   &lt;/simpleContent&gt;
     * &lt;/complexType&gt;
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "value"
    })
    public static class Epg2Vdr {

        @XmlValue
        protected String value;
        @XmlAttribute(name = "host")
        protected String host;
        @XmlAttribute(name = "port")
        protected Short port;
        @XmlAttribute(name = "username")
        protected String username;
        @XmlAttribute(name = "password")
        protected String password;
        @XmlAttribute(name = "database")
        protected String database;

        /**
         * Ruft den Wert der value-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getValue() {
            return value;
        }

        /**
         * Legt den Wert der value-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setValue(String value) {
            this.value = value;
        }

        /**
         * Ruft den Wert der host-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getHost() {
            return host;
        }

        /**
         * Legt den Wert der host-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setHost(String value) {
            this.host = value;
        }

        /**
         * Ruft den Wert der port-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Short }
         *     
         */
        public Short getPort() {
            return port;
        }

        /**
         * Legt den Wert der port-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Short }
         *     
         */
        public void setPort(Short value) {
            this.port = value;
        }

        /**
         * Ruft den Wert der username-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getUsername() {
            return username;
        }

        /**
         * Legt den Wert der username-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setUsername(String value) {
            this.username = value;
        }

        /**
         * Ruft den Wert der password-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getPassword() {
            return password;
        }

        /**
         * Legt den Wert der password-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setPassword(String value) {
            this.password = value;
        }

        /**
         * Ruft den Wert der database-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getDatabase() {
            return database;
        }

        /**
         * Legt den Wert der database-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setDatabase(String value) {
            this.database = value;
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
     *         &lt;element name="series"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;sequence&gt;
     *                   &lt;element name="season"&gt;
     *                     &lt;complexType&gt;
     *                       &lt;complexContent&gt;
     *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                           &lt;sequence&gt;
     *                             &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                             &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
     *                           &lt;/sequence&gt;
     *                         &lt;/restriction&gt;
     *                       &lt;/complexContent&gt;
     *                     &lt;/complexType&gt;
     *                   &lt;/element&gt;
     *                   &lt;element name="part"&gt;
     *                     &lt;complexType&gt;
     *                       &lt;complexContent&gt;
     *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                           &lt;sequence&gt;
     *                             &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                             &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
     *                           &lt;/sequence&gt;
     *                         &lt;/restriction&gt;
     *                       &lt;/complexContent&gt;
     *                     &lt;/complexType&gt;
     *                   &lt;/element&gt;
     *                   &lt;element name="parts"&gt;
     *                     &lt;complexType&gt;
     *                       &lt;complexContent&gt;
     *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                           &lt;sequence&gt;
     *                             &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                             &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
     *                           &lt;/sequence&gt;
     *                         &lt;/restriction&gt;
     *                       &lt;/complexContent&gt;
     *                     &lt;/complexType&gt;
     *                   &lt;/element&gt;
     *                 &lt;/sequence&gt;
     *               &lt;/restriction&gt;
     *             &lt;/complexContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="genre"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;sequence&gt;
     *                   &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                   &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
     *                 &lt;/sequence&gt;
     *               &lt;/restriction&gt;
     *             &lt;/complexContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="category"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;sequence&gt;
     *                   &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                   &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
     *                 &lt;/sequence&gt;
     *               &lt;/restriction&gt;
     *             &lt;/complexContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="custom-pattern"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;sequence&gt;
     *                   &lt;element name="custom" maxOccurs="unbounded" minOccurs="0"&gt;
     *                     &lt;complexType&gt;
     *                       &lt;complexContent&gt;
     *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                           &lt;sequence&gt;
     *                             &lt;element name="header" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                             &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                             &lt;element name="output" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                           &lt;/sequence&gt;
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
        "series",
        "genre",
        "category",
        "customPattern"
    })
    public static class EpgColumns {

        @XmlElement(required = true)
        protected Jonglisto.EpgColumns.Series series;
        @XmlElement(required = true)
        protected Jonglisto.EpgColumns.Genre genre;
        @XmlElement(required = true)
        protected Jonglisto.EpgColumns.Category category;
        @XmlElement(name = "custom-pattern", required = true)
        protected Jonglisto.EpgColumns.CustomPattern customPattern;

        /**
         * Ruft den Wert der series-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Jonglisto.EpgColumns.Series }
         *     
         */
        public Jonglisto.EpgColumns.Series getSeries() {
            return series;
        }

        /**
         * Legt den Wert der series-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Jonglisto.EpgColumns.Series }
         *     
         */
        public void setSeries(Jonglisto.EpgColumns.Series value) {
            this.series = value;
        }

        /**
         * Ruft den Wert der genre-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Jonglisto.EpgColumns.Genre }
         *     
         */
        public Jonglisto.EpgColumns.Genre getGenre() {
            return genre;
        }

        /**
         * Legt den Wert der genre-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Jonglisto.EpgColumns.Genre }
         *     
         */
        public void setGenre(Jonglisto.EpgColumns.Genre value) {
            this.genre = value;
        }

        /**
         * Ruft den Wert der category-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Jonglisto.EpgColumns.Category }
         *     
         */
        public Jonglisto.EpgColumns.Category getCategory() {
            return category;
        }

        /**
         * Legt den Wert der category-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Jonglisto.EpgColumns.Category }
         *     
         */
        public void setCategory(Jonglisto.EpgColumns.Category value) {
            this.category = value;
        }

        /**
         * Ruft den Wert der customPattern-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Jonglisto.EpgColumns.CustomPattern }
         *     
         */
        public Jonglisto.EpgColumns.CustomPattern getCustomPattern() {
            return customPattern;
        }

        /**
         * Legt den Wert der customPattern-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Jonglisto.EpgColumns.CustomPattern }
         *     
         */
        public void setCustomPattern(Jonglisto.EpgColumns.CustomPattern value) {
            this.customPattern = value;
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
         *         &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *         &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
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
            "pattern",
            "group"
        })
        public static class Category {

            @XmlElement(required = true)
            protected String pattern;
            protected byte group;

            /**
             * Ruft den Wert der pattern-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getPattern() {
                return pattern;
            }

            /**
             * Legt den Wert der pattern-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setPattern(String value) {
                this.pattern = value;
            }

            /**
             * Ruft den Wert der group-Eigenschaft ab.
             * 
             */
            public byte getGroup() {
                return group;
            }

            /**
             * Legt den Wert der group-Eigenschaft fest.
             * 
             */
            public void setGroup(byte value) {
                this.group = value;
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
         *         &lt;element name="custom" maxOccurs="unbounded" minOccurs="0"&gt;
         *           &lt;complexType&gt;
         *             &lt;complexContent&gt;
         *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
         *                 &lt;sequence&gt;
         *                   &lt;element name="header" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *                   &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *                   &lt;element name="output" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
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
            "custom"
        })
        public static class CustomPattern {

            protected List<Jonglisto.EpgColumns.CustomPattern.Custom> custom;

            /**
             * Gets the value of the custom property.
             * 
             * <p>
             * This accessor method returns a reference to the live list,
             * not a snapshot. Therefore any modification you make to the
             * returned list will be present inside the JAXB object.
             * This is why there is not a <CODE>set</CODE> method for the custom property.
             * 
             * <p>
             * For example, to add a new item, do as follows:
             * <pre>
             *    getCustom().add(newItem);
             * </pre>
             * 
             * 
             * <p>
             * Objects of the following type(s) are allowed in the list
             * {@link Jonglisto.EpgColumns.CustomPattern.Custom }
             * 
             * 
             */
            public List<Jonglisto.EpgColumns.CustomPattern.Custom> getCustom() {
                if (custom == null) {
                    custom = new ArrayList<Jonglisto.EpgColumns.CustomPattern.Custom>();
                }
                return this.custom;
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
             *         &lt;element name="header" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
             *         &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
             *         &lt;element name="output" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
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
                "header",
                "pattern",
                "output"
            })
            public static class Custom {

                @XmlElement(required = true)
                protected String header;
                @XmlElement(required = true)
                protected String pattern;
                @XmlElement(required = true)
                protected String output;

                /**
                 * Ruft den Wert der header-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getHeader() {
                    return header;
                }

                /**
                 * Legt den Wert der header-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setHeader(String value) {
                    this.header = value;
                }

                /**
                 * Ruft den Wert der pattern-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getPattern() {
                    return pattern;
                }

                /**
                 * Legt den Wert der pattern-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setPattern(String value) {
                    this.pattern = value;
                }

                /**
                 * Ruft den Wert der output-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getOutput() {
                    return output;
                }

                /**
                 * Legt den Wert der output-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setOutput(String value) {
                    this.output = value;
                }

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
         *         &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *         &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
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
            "pattern",
            "group"
        })
        public static class Genre {

            @XmlElement(required = true)
            protected String pattern;
            protected byte group;

            /**
             * Ruft den Wert der pattern-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getPattern() {
                return pattern;
            }

            /**
             * Legt den Wert der pattern-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setPattern(String value) {
                this.pattern = value;
            }

            /**
             * Ruft den Wert der group-Eigenschaft ab.
             * 
             */
            public byte getGroup() {
                return group;
            }

            /**
             * Legt den Wert der group-Eigenschaft fest.
             * 
             */
            public void setGroup(byte value) {
                this.group = value;
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
         *         &lt;element name="season"&gt;
         *           &lt;complexType&gt;
         *             &lt;complexContent&gt;
         *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
         *                 &lt;sequence&gt;
         *                   &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *                   &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
         *                 &lt;/sequence&gt;
         *               &lt;/restriction&gt;
         *             &lt;/complexContent&gt;
         *           &lt;/complexType&gt;
         *         &lt;/element&gt;
         *         &lt;element name="part"&gt;
         *           &lt;complexType&gt;
         *             &lt;complexContent&gt;
         *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
         *                 &lt;sequence&gt;
         *                   &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *                   &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
         *                 &lt;/sequence&gt;
         *               &lt;/restriction&gt;
         *             &lt;/complexContent&gt;
         *           &lt;/complexType&gt;
         *         &lt;/element&gt;
         *         &lt;element name="parts"&gt;
         *           &lt;complexType&gt;
         *             &lt;complexContent&gt;
         *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
         *                 &lt;sequence&gt;
         *                   &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *                   &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
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
            "season",
            "part",
            "parts"
        })
        public static class Series {

            @XmlElement(required = true)
            protected Jonglisto.EpgColumns.Series.Season season;
            @XmlElement(required = true)
            protected Jonglisto.EpgColumns.Series.Part part;
            @XmlElement(required = true)
            protected Jonglisto.EpgColumns.Series.Parts parts;

            /**
             * Ruft den Wert der season-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Jonglisto.EpgColumns.Series.Season }
             *     
             */
            public Jonglisto.EpgColumns.Series.Season getSeason() {
                return season;
            }

            /**
             * Legt den Wert der season-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Jonglisto.EpgColumns.Series.Season }
             *     
             */
            public void setSeason(Jonglisto.EpgColumns.Series.Season value) {
                this.season = value;
            }

            /**
             * Ruft den Wert der part-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Jonglisto.EpgColumns.Series.Part }
             *     
             */
            public Jonglisto.EpgColumns.Series.Part getPart() {
                return part;
            }

            /**
             * Legt den Wert der part-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Jonglisto.EpgColumns.Series.Part }
             *     
             */
            public void setPart(Jonglisto.EpgColumns.Series.Part value) {
                this.part = value;
            }

            /**
             * Ruft den Wert der parts-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Jonglisto.EpgColumns.Series.Parts }
             *     
             */
            public Jonglisto.EpgColumns.Series.Parts getParts() {
                return parts;
            }

            /**
             * Legt den Wert der parts-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Jonglisto.EpgColumns.Series.Parts }
             *     
             */
            public void setParts(Jonglisto.EpgColumns.Series.Parts value) {
                this.parts = value;
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
             *         &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
             *         &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
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
                "pattern",
                "group"
            })
            public static class Part {

                @XmlElement(required = true)
                protected String pattern;
                protected byte group;

                /**
                 * Ruft den Wert der pattern-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getPattern() {
                    return pattern;
                }

                /**
                 * Legt den Wert der pattern-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setPattern(String value) {
                    this.pattern = value;
                }

                /**
                 * Ruft den Wert der group-Eigenschaft ab.
                 * 
                 */
                public byte getGroup() {
                    return group;
                }

                /**
                 * Legt den Wert der group-Eigenschaft fest.
                 * 
                 */
                public void setGroup(byte value) {
                    this.group = value;
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
             *         &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
             *         &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
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
                "pattern",
                "group"
            })
            public static class Parts {

                @XmlElement(required = true)
                protected String pattern;
                protected byte group;

                /**
                 * Ruft den Wert der pattern-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getPattern() {
                    return pattern;
                }

                /**
                 * Legt den Wert der pattern-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setPattern(String value) {
                    this.pattern = value;
                }

                /**
                 * Ruft den Wert der group-Eigenschaft ab.
                 * 
                 */
                public byte getGroup() {
                    return group;
                }

                /**
                 * Legt den Wert der group-Eigenschaft fest.
                 * 
                 */
                public void setGroup(byte value) {
                    this.group = value;
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
             *         &lt;element name="pattern" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
             *         &lt;element name="group" type="{http://www.w3.org/2001/XMLSchema}byte"/&gt;
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
                "pattern",
                "group"
            })
            public static class Season {

                @XmlElement(required = true)
                protected String pattern;
                protected byte group;

                /**
                 * Ruft den Wert der pattern-Eigenschaft ab.
                 * 
                 * @return
                 *     possible object is
                 *     {@link String }
                 *     
                 */
                public String getPattern() {
                    return pattern;
                }

                /**
                 * Legt den Wert der pattern-Eigenschaft fest.
                 * 
                 * @param value
                 *     allowed object is
                 *     {@link String }
                 *     
                 */
                public void setPattern(String value) {
                    this.pattern = value;
                }

                /**
                 * Ruft den Wert der group-Eigenschaft ab.
                 * 
                 */
                public byte getGroup() {
                    return group;
                }

                /**
                 * Legt den Wert der group-Eigenschaft fest.
                 * 
                 */
                public void setGroup(byte value) {
                    this.group = value;
                }

            }

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
     *         &lt;element name="value" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded" minOccurs="0"/&gt;
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
        "value"
    })
    public static class EpgTimeList {

        protected List<String> value;

        /**
         * Gets the value of the value property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the value property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getValue().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link String }
         * 
         * 
         */
        public List<String> getValue() {
            if (value == null) {
                value = new ArrayList<String>();
            }
            return this.value;
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
     *         &lt;element name="allow" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;sequence&gt;
     *                   &lt;element name="command" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded" minOccurs="0"/&gt;
     *                 &lt;/sequence&gt;
     *                 &lt;attribute name="vdr" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
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
        "allow"
    })
    public static class JonglistoPlugin {

        protected List<Jonglisto.JonglistoPlugin.Allow> allow;

        /**
         * Gets the value of the allow property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the allow property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getAllow().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Jonglisto.JonglistoPlugin.Allow }
         * 
         * 
         */
        public List<Jonglisto.JonglistoPlugin.Allow> getAllow() {
            if (allow == null) {
                allow = new ArrayList<Jonglisto.JonglistoPlugin.Allow>();
            }
            return this.allow;
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
         *         &lt;element name="command" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded" minOccurs="0"/&gt;
         *       &lt;/sequence&gt;
         *       &lt;attribute name="vdr" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
         *     &lt;/restriction&gt;
         *   &lt;/complexContent&gt;
         * &lt;/complexType&gt;
         * </pre>
         * 
         * 
         */
        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "command"
        })
        public static class Allow {

            protected List<String> command;
            @XmlAttribute(name = "vdr")
            protected String vdr;

            /**
             * Gets the value of the command property.
             * 
             * <p>
             * This accessor method returns a reference to the live list,
             * not a snapshot. Therefore any modification you make to the
             * returned list will be present inside the JAXB object.
             * This is why there is not a <CODE>set</CODE> method for the command property.
             * 
             * <p>
             * For example, to add a new item, do as follows:
             * <pre>
             *    getCommand().add(newItem);
             * </pre>
             * 
             * 
             * <p>
             * Objects of the following type(s) are allowed in the list
             * {@link String }
             * 
             * 
             */
            public List<String> getCommand() {
                if (command == null) {
                    command = new ArrayList<String>();
                }
                return this.command;
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
     *         &lt;element name="images" type="{http://www.w3.org/2001/XMLSchema}boolean"/&gt;
     *         &lt;element name="imagePath" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;sequence&gt;
     *                   &lt;element name="replace" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                   &lt;element name="to" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
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
        "images",
        "imagePath"
    })
    public static class Scraper {

        protected boolean images;
        protected List<Jonglisto.Scraper.ImagePath> imagePath;

        /**
         * Ruft den Wert der images-Eigenschaft ab.
         * 
         */
        public boolean isImages() {
            return images;
        }

        /**
         * Legt den Wert der images-Eigenschaft fest.
         * 
         */
        public void setImages(boolean value) {
            this.images = value;
        }

        /**
         * Gets the value of the imagePath property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the imagePath property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getImagePath().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Jonglisto.Scraper.ImagePath }
         * 
         * 
         */
        public List<Jonglisto.Scraper.ImagePath> getImagePath() {
            if (imagePath == null) {
                imagePath = new ArrayList<Jonglisto.Scraper.ImagePath>();
            }
            return this.imagePath;
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
         *         &lt;element name="replace" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *         &lt;element name="to" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
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
            "replace",
            "to"
        })
        public static class ImagePath {

            @XmlElement(required = true)
            protected String replace;
            @XmlElement(required = true)
            protected String to;

            /**
             * Ruft den Wert der replace-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getReplace() {
                return replace;
            }

            /**
             * Legt den Wert der replace-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setReplace(String value) {
                this.replace = value;
            }

            /**
             * Ruft den Wert der to-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getTo() {
                return to;
            }

            /**
             * Legt den Wert der to-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setTo(String value) {
                this.to = value;
            }

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
     *         &lt;element name="command" type="{http://www.w3.org/2001/XMLSchema}string" maxOccurs="unbounded" minOccurs="0"/&gt;
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
        "command"
    })
    public static class SvdrpCommandList {

        protected List<String> command;

        /**
         * Gets the value of the command property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the command property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getCommand().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link String }
         * 
         * 
         */
        public List<String> getCommand() {
            if (command == null) {
                command = new ArrayList<String>();
            }
            return this.command;
        }

    }


    /**
     * <p>Java-Klasse für anonymous complex type.
     * 
     * <p>Das folgende Schemafragment gibt den erwarteten Content an, der in dieser Klasse enthalten ist.
     * 
     * <pre>
     * &lt;complexType&gt;
     *   &lt;simpleContent&gt;
     *     &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *       &lt;attribute name="tz" type="{http://www.w3.org/2001/XMLSchema}string" /&gt;
     *     &lt;/extension&gt;
     *   &lt;/simpleContent&gt;
     * &lt;/complexType&gt;
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "value"
    })
    public static class Timezone {

        @XmlValue
        protected String value;
        @XmlAttribute(name = "tz")
        protected String tz;

        /**
         * Ruft den Wert der value-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getValue() {
            return value;
        }

        /**
         * Legt den Wert der value-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setValue(String value) {
            this.value = value;
        }

        /**
         * Ruft den Wert der tz-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getTz() {
            return tz;
        }

        /**
         * Legt den Wert der tz-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setTz(String value) {
            this.tz = value;
        }

    }

}
