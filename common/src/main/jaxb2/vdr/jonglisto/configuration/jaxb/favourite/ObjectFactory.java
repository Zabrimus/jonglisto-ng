//
// Diese Datei wurde mit der JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 generiert 
// Siehe <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Änderungen an dieser Datei gehen bei einer Neukompilierung des Quellschemas verloren. 
// Generiert: 2017.12.30 um 05:17:48 PM CET 
//


package vdr.jonglisto.configuration.jaxb.favourite;

import javax.xml.bind.annotation.XmlRegistry;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the vdr.jonglisto.configuration.jaxb.favourite package. 
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
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: vdr.jonglisto.configuration.jaxb.favourite
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link Favourites }
     * 
     */
    public Favourites createFavourites() {
        return new Favourites();
    }

    /**
     * Create an instance of {@link Favourites.Favourite }
     * 
     */
    public Favourites.Favourite createFavouritesFavourite() {
        return new Favourites.Favourite();
    }

}
