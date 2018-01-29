//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert 
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Änderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren. 
// Generiert: 2018.01.26 um 09:59:13 PM CET 
//


package vdr.jonglisto.configuration.jaxb.scraper;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.XmlValue;
import javax.xml.datatype.XMLGregorianCalendar;


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
 *         &lt;element name="series" minOccurs="0"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
 *                   &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="overview" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="firstAired" type="{http://www.w3.org/2001/XMLSchema}date" minOccurs="0"/&gt;
 *                   &lt;element name="network" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="status" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="rating" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
 *                   &lt;element name="poster" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;simpleContent&gt;
 *                         &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/extension&gt;
 *                       &lt;/simpleContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="banner" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;simpleContent&gt;
 *                         &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/extension&gt;
 *                       &lt;/simpleContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="fanart" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;simpleContent&gt;
 *                         &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/extension&gt;
 *                       &lt;/simpleContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="seasonPoster" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;simpleContent&gt;
 *                         &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/extension&gt;
 *                       &lt;/simpleContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="actor" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;sequence&gt;
 *                             &lt;element name="path" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                             &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                             &lt;element name="role" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                           &lt;/sequence&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/restriction&gt;
 *                       &lt;/complexContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="episode" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;simpleContent&gt;
 *                         &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/extension&gt;
 *                       &lt;/simpleContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                 &lt;/sequence&gt;
 *               &lt;/restriction&gt;
 *             &lt;/complexContent&gt;
 *           &lt;/complexType&gt;
 *         &lt;/element&gt;
 *         &lt;element name="movie" minOccurs="0"&gt;
 *           &lt;complexType&gt;
 *             &lt;complexContent&gt;
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                 &lt;sequence&gt;
 *                   &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
 *                   &lt;element name="adult" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
 *                   &lt;element name="budget" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
 *                   &lt;element name="genre" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="homepage" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="originalTitle" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="overview" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="popularity" type="{http://www.w3.org/2001/XMLSchema}float" minOccurs="0"/&gt;
 *                   &lt;element name="releaseDate" type="{http://www.w3.org/2001/XMLSchema}date" minOccurs="0"/&gt;
 *                   &lt;element name="revenue" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
 *                   &lt;element name="runtime" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
 *                   &lt;element name="tagline" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="title" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
 *                   &lt;element name="voteAverage" type="{http://www.w3.org/2001/XMLSchema}float" minOccurs="0"/&gt;
 *                   &lt;element name="actor" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;complexContent&gt;
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *                           &lt;sequence&gt;
 *                             &lt;element name="path" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                             &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                             &lt;element name="role" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *                           &lt;/sequence&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/restriction&gt;
 *                       &lt;/complexContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="fanart" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;simpleContent&gt;
 *                         &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/extension&gt;
 *                       &lt;/simpleContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
 *                   &lt;element name="poster" maxOccurs="unbounded" minOccurs="0"&gt;
 *                     &lt;complexType&gt;
 *                       &lt;simpleContent&gt;
 *                         &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
 *                           &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                           &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
 *                         &lt;/extension&gt;
 *                       &lt;/simpleContent&gt;
 *                     &lt;/complexType&gt;
 *                   &lt;/element&gt;
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
    "series",
    "movie"
})
@XmlRootElement(name = "scraper")
public class Scraper {

    protected Scraper.Series series;
    protected Scraper.Movie movie;

    /**
     * Ruft den Wert der series-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Scraper.Series }
     *     
     */
    public Scraper.Series getSeries() {
        return series;
    }

    /**
     * Legt den Wert der series-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Scraper.Series }
     *     
     */
    public void setSeries(Scraper.Series value) {
        this.series = value;
    }

    /**
     * Ruft den Wert der movie-Eigenschaft ab.
     * 
     * @return
     *     possible object is
     *     {@link Scraper.Movie }
     *     
     */
    public Scraper.Movie getMovie() {
        return movie;
    }

    /**
     * Legt den Wert der movie-Eigenschaft fest.
     * 
     * @param value
     *     allowed object is
     *     {@link Scraper.Movie }
     *     
     */
    public void setMovie(Scraper.Movie value) {
        this.movie = value;
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
     *         &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
     *         &lt;element name="adult" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
     *         &lt;element name="budget" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
     *         &lt;element name="genre" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="homepage" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="originalTitle" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="overview" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="popularity" type="{http://www.w3.org/2001/XMLSchema}float" minOccurs="0"/&gt;
     *         &lt;element name="releaseDate" type="{http://www.w3.org/2001/XMLSchema}date" minOccurs="0"/&gt;
     *         &lt;element name="revenue" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
     *         &lt;element name="runtime" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
     *         &lt;element name="tagline" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="title" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="voteAverage" type="{http://www.w3.org/2001/XMLSchema}float" minOccurs="0"/&gt;
     *         &lt;element name="actor" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;sequence&gt;
     *                   &lt;element name="path" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                   &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                   &lt;element name="role" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                 &lt;/sequence&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *               &lt;/restriction&gt;
     *             &lt;/complexContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="fanart" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;simpleContent&gt;
     *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *               &lt;/extension&gt;
     *             &lt;/simpleContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="poster" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;simpleContent&gt;
     *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        "id",
        "adult",
        "budget",
        "genre",
        "homepage",
        "originalTitle",
        "overview",
        "popularity",
        "releaseDate",
        "revenue",
        "runtime",
        "tagline",
        "title",
        "voteAverage",
        "actor",
        "fanart",
        "poster"
    })
    public static class Movie {

        protected int id;
        protected Byte adult;
        protected Byte budget;
        protected String genre;
        protected String homepage;
        protected String originalTitle;
        protected String overview;
        protected Float popularity;
        @XmlSchemaType(name = "date")
        protected XMLGregorianCalendar releaseDate;
        protected Byte revenue;
        protected Byte runtime;
        protected String tagline;
        protected String title;
        protected Float voteAverage;
        protected List<Scraper.Movie.Actor> actor;
        protected List<Scraper.Movie.Fanart> fanart;
        protected List<Scraper.Movie.Poster> poster;

        /**
         * Ruft den Wert der id-Eigenschaft ab.
         * 
         */
        public int getId() {
            return id;
        }

        /**
         * Legt den Wert der id-Eigenschaft fest.
         * 
         */
        public void setId(int value) {
            this.id = value;
        }

        /**
         * Ruft den Wert der adult-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Byte }
         *     
         */
        public Byte getAdult() {
            return adult;
        }

        /**
         * Legt den Wert der adult-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Byte }
         *     
         */
        public void setAdult(Byte value) {
            this.adult = value;
        }

        /**
         * Ruft den Wert der budget-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Byte }
         *     
         */
        public Byte getBudget() {
            return budget;
        }

        /**
         * Legt den Wert der budget-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Byte }
         *     
         */
        public void setBudget(Byte value) {
            this.budget = value;
        }

        /**
         * Ruft den Wert der genre-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getGenre() {
            return genre;
        }

        /**
         * Legt den Wert der genre-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setGenre(String value) {
            this.genre = value;
        }

        /**
         * Ruft den Wert der homepage-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getHomepage() {
            return homepage;
        }

        /**
         * Legt den Wert der homepage-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setHomepage(String value) {
            this.homepage = value;
        }

        /**
         * Ruft den Wert der originalTitle-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getOriginalTitle() {
            return originalTitle;
        }

        /**
         * Legt den Wert der originalTitle-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setOriginalTitle(String value) {
            this.originalTitle = value;
        }

        /**
         * Ruft den Wert der overview-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getOverview() {
            return overview;
        }

        /**
         * Legt den Wert der overview-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setOverview(String value) {
            this.overview = value;
        }

        /**
         * Ruft den Wert der popularity-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Float }
         *     
         */
        public Float getPopularity() {
            return popularity;
        }

        /**
         * Legt den Wert der popularity-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Float }
         *     
         */
        public void setPopularity(Float value) {
            this.popularity = value;
        }

        /**
         * Ruft den Wert der releaseDate-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link XMLGregorianCalendar }
         *     
         */
        public XMLGregorianCalendar getReleaseDate() {
            return releaseDate;
        }

        /**
         * Legt den Wert der releaseDate-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link XMLGregorianCalendar }
         *     
         */
        public void setReleaseDate(XMLGregorianCalendar value) {
            this.releaseDate = value;
        }

        /**
         * Ruft den Wert der revenue-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Byte }
         *     
         */
        public Byte getRevenue() {
            return revenue;
        }

        /**
         * Legt den Wert der revenue-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Byte }
         *     
         */
        public void setRevenue(Byte value) {
            this.revenue = value;
        }

        /**
         * Ruft den Wert der runtime-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Byte }
         *     
         */
        public Byte getRuntime() {
            return runtime;
        }

        /**
         * Legt den Wert der runtime-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Byte }
         *     
         */
        public void setRuntime(Byte value) {
            this.runtime = value;
        }

        /**
         * Ruft den Wert der tagline-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getTagline() {
            return tagline;
        }

        /**
         * Legt den Wert der tagline-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setTagline(String value) {
            this.tagline = value;
        }

        /**
         * Ruft den Wert der title-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getTitle() {
            return title;
        }

        /**
         * Legt den Wert der title-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setTitle(String value) {
            this.title = value;
        }

        /**
         * Ruft den Wert der voteAverage-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Float }
         *     
         */
        public Float getVoteAverage() {
            return voteAverage;
        }

        /**
         * Legt den Wert der voteAverage-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Float }
         *     
         */
        public void setVoteAverage(Float value) {
            this.voteAverage = value;
        }

        /**
         * Gets the value of the actor property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the actor property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getActor().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Scraper.Movie.Actor }
         * 
         * 
         */
        public List<Scraper.Movie.Actor> getActor() {
            if (actor == null) {
                actor = new ArrayList<Scraper.Movie.Actor>();
            }
            return this.actor;
        }

        /**
         * Gets the value of the fanart property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the fanart property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getFanart().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Scraper.Movie.Fanart }
         * 
         * 
         */
        public List<Scraper.Movie.Fanart> getFanart() {
            if (fanart == null) {
                fanart = new ArrayList<Scraper.Movie.Fanart>();
            }
            return this.fanart;
        }

        /**
         * Gets the value of the poster property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the poster property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getPoster().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Scraper.Movie.Poster }
         * 
         * 
         */
        public List<Scraper.Movie.Poster> getPoster() {
            if (poster == null) {
                poster = new ArrayList<Scraper.Movie.Poster>();
            }
            return this.poster;
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
         *         &lt;element name="path" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *         &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *         &lt;element name="role" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *       &lt;/sequence&gt;
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *     &lt;/restriction&gt;
         *   &lt;/complexContent&gt;
         * &lt;/complexType&gt;
         * </pre>
         * 
         * 
         */
        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "path",
            "name",
            "role"
        })
        public static class Actor {

            @XmlElement(required = true)
            protected String path;
            @XmlElement(required = true)
            protected String name;
            @XmlElement(required = true)
            protected String role;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

            /**
             * Ruft den Wert der path-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getPath() {
                return path;
            }

            /**
             * Legt den Wert der path-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setPath(String value) {
                this.path = value;
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
             * Ruft den Wert der role-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getRole() {
                return role;
            }

            /**
             * Legt den Wert der role-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setRole(String value) {
                this.role = value;
            }

            /**
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
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
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        public static class Fanart {

            @XmlValue
            protected String value;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

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
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
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
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        public static class Poster {

            @XmlValue
            protected String value;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

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
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
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
     *         &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
     *         &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="overview" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="firstAired" type="{http://www.w3.org/2001/XMLSchema}date" minOccurs="0"/&gt;
     *         &lt;element name="network" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="status" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/&gt;
     *         &lt;element name="rating" type="{http://www.w3.org/2001/XMLSchema}byte" minOccurs="0"/&gt;
     *         &lt;element name="poster" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;simpleContent&gt;
     *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *               &lt;/extension&gt;
     *             &lt;/simpleContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="banner" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;simpleContent&gt;
     *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *               &lt;/extension&gt;
     *             &lt;/simpleContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="fanart" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;simpleContent&gt;
     *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *               &lt;/extension&gt;
     *             &lt;/simpleContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="seasonPoster" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;simpleContent&gt;
     *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *               &lt;/extension&gt;
     *             &lt;/simpleContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="actor" maxOccurs="unbounded" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;complexContent&gt;
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
     *                 &lt;sequence&gt;
     *                   &lt;element name="path" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                   &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                   &lt;element name="role" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
     *                 &lt;/sequence&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *               &lt;/restriction&gt;
     *             &lt;/complexContent&gt;
     *           &lt;/complexType&gt;
     *         &lt;/element&gt;
     *         &lt;element name="episode" minOccurs="0"&gt;
     *           &lt;complexType&gt;
     *             &lt;simpleContent&gt;
     *               &lt;extension base="&lt;http://www.w3.org/2001/XMLSchema&gt;string"&gt;
     *                 &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
     *                 &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        "id",
        "name",
        "overview",
        "firstAired",
        "network",
        "status",
        "rating",
        "poster",
        "banner",
        "fanart",
        "seasonPoster",
        "actor",
        "episode"
    })
    public static class Series {

        protected int id;
        protected String name;
        protected String overview;
        @XmlSchemaType(name = "date")
        protected XMLGregorianCalendar firstAired;
        protected String network;
        protected String status;
        protected Byte rating;
        protected List<Scraper.Series.Poster> poster;
        protected List<Scraper.Series.Banner> banner;
        protected List<Scraper.Series.Fanart> fanart;
        protected Scraper.Series.SeasonPoster seasonPoster;
        protected List<Scraper.Series.Actor> actor;
        protected Scraper.Series.Episode episode;

        /**
         * Ruft den Wert der id-Eigenschaft ab.
         * 
         */
        public int getId() {
            return id;
        }

        /**
         * Legt den Wert der id-Eigenschaft fest.
         * 
         */
        public void setId(int value) {
            this.id = value;
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
         * Ruft den Wert der overview-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getOverview() {
            return overview;
        }

        /**
         * Legt den Wert der overview-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setOverview(String value) {
            this.overview = value;
        }

        /**
         * Ruft den Wert der firstAired-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link XMLGregorianCalendar }
         *     
         */
        public XMLGregorianCalendar getFirstAired() {
            return firstAired;
        }

        /**
         * Legt den Wert der firstAired-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link XMLGregorianCalendar }
         *     
         */
        public void setFirstAired(XMLGregorianCalendar value) {
            this.firstAired = value;
        }

        /**
         * Ruft den Wert der network-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getNetwork() {
            return network;
        }

        /**
         * Legt den Wert der network-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setNetwork(String value) {
            this.network = value;
        }

        /**
         * Ruft den Wert der status-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getStatus() {
            return status;
        }

        /**
         * Legt den Wert der status-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setStatus(String value) {
            this.status = value;
        }

        /**
         * Ruft den Wert der rating-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Byte }
         *     
         */
        public Byte getRating() {
            return rating;
        }

        /**
         * Legt den Wert der rating-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Byte }
         *     
         */
        public void setRating(Byte value) {
            this.rating = value;
        }

        /**
         * Gets the value of the poster property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the poster property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getPoster().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Scraper.Series.Poster }
         * 
         * 
         */
        public List<Scraper.Series.Poster> getPoster() {
            if (poster == null) {
                poster = new ArrayList<Scraper.Series.Poster>();
            }
            return this.poster;
        }

        /**
         * Gets the value of the banner property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the banner property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getBanner().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Scraper.Series.Banner }
         * 
         * 
         */
        public List<Scraper.Series.Banner> getBanner() {
            if (banner == null) {
                banner = new ArrayList<Scraper.Series.Banner>();
            }
            return this.banner;
        }

        /**
         * Gets the value of the fanart property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the fanart property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getFanart().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Scraper.Series.Fanart }
         * 
         * 
         */
        public List<Scraper.Series.Fanart> getFanart() {
            if (fanart == null) {
                fanart = new ArrayList<Scraper.Series.Fanart>();
            }
            return this.fanart;
        }

        /**
         * Ruft den Wert der seasonPoster-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Scraper.Series.SeasonPoster }
         *     
         */
        public Scraper.Series.SeasonPoster getSeasonPoster() {
            return seasonPoster;
        }

        /**
         * Legt den Wert der seasonPoster-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Scraper.Series.SeasonPoster }
         *     
         */
        public void setSeasonPoster(Scraper.Series.SeasonPoster value) {
            this.seasonPoster = value;
        }

        /**
         * Gets the value of the actor property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the actor property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getActor().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link Scraper.Series.Actor }
         * 
         * 
         */
        public List<Scraper.Series.Actor> getActor() {
            if (actor == null) {
                actor = new ArrayList<Scraper.Series.Actor>();
            }
            return this.actor;
        }

        /**
         * Ruft den Wert der episode-Eigenschaft ab.
         * 
         * @return
         *     possible object is
         *     {@link Scraper.Series.Episode }
         *     
         */
        public Scraper.Series.Episode getEpisode() {
            return episode;
        }

        /**
         * Legt den Wert der episode-Eigenschaft fest.
         * 
         * @param value
         *     allowed object is
         *     {@link Scraper.Series.Episode }
         *     
         */
        public void setEpisode(Scraper.Series.Episode value) {
            this.episode = value;
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
         *         &lt;element name="path" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *         &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *         &lt;element name="role" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
         *       &lt;/sequence&gt;
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *     &lt;/restriction&gt;
         *   &lt;/complexContent&gt;
         * &lt;/complexType&gt;
         * </pre>
         * 
         * 
         */
        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "path",
            "name",
            "role"
        })
        public static class Actor {

            @XmlElement(required = true)
            protected String path;
            @XmlElement(required = true)
            protected String name;
            @XmlElement(required = true)
            protected String role;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

            /**
             * Ruft den Wert der path-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getPath() {
                return path;
            }

            /**
             * Legt den Wert der path-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setPath(String value) {
                this.path = value;
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
             * Ruft den Wert der role-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getRole() {
                return role;
            }

            /**
             * Legt den Wert der role-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setRole(String value) {
                this.role = value;
            }

            /**
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
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
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        public static class Banner {

            @XmlValue
            protected String value;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

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
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
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
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        public static class Episode {

            @XmlValue
            protected String value;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

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
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
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
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        public static class Fanart {

            @XmlValue
            protected String value;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

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
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
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
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        public static class Poster {

            @XmlValue
            protected String value;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

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
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
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
         *       &lt;attribute name="height" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
         *       &lt;attribute name="width" type="{http://www.w3.org/2001/XMLSchema}short" /&gt;
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
        public static class SeasonPoster {

            @XmlValue
            protected String value;
            @XmlAttribute(name = "height")
            protected Short height;
            @XmlAttribute(name = "width")
            protected Short width;

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
             * Ruft den Wert der height-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getHeight() {
                return height;
            }

            /**
             * Legt den Wert der height-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setHeight(Short value) {
                this.height = value;
            }

            /**
             * Ruft den Wert der width-Eigenschaft ab.
             * 
             * @return
             *     possible object is
             *     {@link Short }
             *     
             */
            public Short getWidth() {
                return width;
            }

            /**
             * Legt den Wert der width-Eigenschaft fest.
             * 
             * @param value
             *     allowed object is
             *     {@link Short }
             *     
             */
            public void setWidth(Short value) {
                this.width = value;
            }

        }

    }

}
