//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert 
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Änderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren. 
// Generiert: 2018.01.26 um 09:59:13 PM CET 
//


package vdr.jonglisto.configuration.jaxb.scraper;

import javax.xml.bind.annotation.XmlRegistry;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the vdr.jonglisto.configuration.jaxb.scraper package. 
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
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: vdr.jonglisto.configuration.jaxb.scraper
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link Scraper }
     * 
     */
    public Scraper createScraper() {
        return new Scraper();
    }

    /**
     * Create an instance of {@link Scraper.Movie }
     * 
     */
    public Scraper.Movie createScraperMovie() {
        return new Scraper.Movie();
    }

    /**
     * Create an instance of {@link Scraper.Series }
     * 
     */
    public Scraper.Series createScraperSeries() {
        return new Scraper.Series();
    }

    /**
     * Create an instance of {@link Scraper.Movie.Actor }
     * 
     */
    public Scraper.Movie.Actor createScraperMovieActor() {
        return new Scraper.Movie.Actor();
    }

    /**
     * Create an instance of {@link Scraper.Movie.Fanart }
     * 
     */
    public Scraper.Movie.Fanart createScraperMovieFanart() {
        return new Scraper.Movie.Fanart();
    }

    /**
     * Create an instance of {@link Scraper.Movie.Poster }
     * 
     */
    public Scraper.Movie.Poster createScraperMoviePoster() {
        return new Scraper.Movie.Poster();
    }

    /**
     * Create an instance of {@link Scraper.Series.Poster }
     * 
     */
    public Scraper.Series.Poster createScraperSeriesPoster() {
        return new Scraper.Series.Poster();
    }

    /**
     * Create an instance of {@link Scraper.Series.Banner }
     * 
     */
    public Scraper.Series.Banner createScraperSeriesBanner() {
        return new Scraper.Series.Banner();
    }

    /**
     * Create an instance of {@link Scraper.Series.Fanart }
     * 
     */
    public Scraper.Series.Fanart createScraperSeriesFanart() {
        return new Scraper.Series.Fanart();
    }

    /**
     * Create an instance of {@link Scraper.Series.SeasonPoster }
     * 
     */
    public Scraper.Series.SeasonPoster createScraperSeriesSeasonPoster() {
        return new Scraper.Series.SeasonPoster();
    }

    /**
     * Create an instance of {@link Scraper.Series.Actor }
     * 
     */
    public Scraper.Series.Actor createScraperSeriesActor() {
        return new Scraper.Series.Actor();
    }

    /**
     * Create an instance of {@link Scraper.Series.Episode }
     * 
     */
    public Scraper.Series.Episode createScraperSeriesEpisode() {
        return new Scraper.Series.Episode();
    }

}
