package vdr.jonglisto.search

import java.util.HashMap
import java.util.List
import java.util.stream.Collectors
import jregex.Pattern
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.Epg

class EpgSearch {

    final static Logger log = LoggerFactory.getLogger("jonglisto.search");

    static Configuration config = Configuration.instance
    static EpgSearch instance = new EpgSearch

    val namedPattern = new HashMap<String, String>
    val completePattern = new HashMap<String, String>

    private new() {
        reloadPattern
    }

    static def EpgSearch getInstance() {
        return instance
    }

    def void reloadPattern() {
        log.debug("reload epgsearch pattern")

        namedPattern.clear
        completePattern.clear

        val simple = config.extEpgSearch.simplePattern
        val complex = config.extEpgSearch.complexPattern

        simple.forEach(s | addNamedPattern(s.name, s.pattern))
        complex.forEach(s | addCompletePattern(s.name, s.pattern))
    }

    def getAllNamedPattern() {
        return namedPattern
    }

    def getAllCompletePattern() {
        return completePattern
    }

    def String getNamedPattern(String name) {
        return namedPattern.get(name)
    }

    def void addNamedPattern(String name, String patternStr) {

        if (name !== null) {
            namedPattern.put("#" + name, patternStr)
        }
    }

    def String addCompletePattern(String name, String patternStr) {
        if (name !== null) {
        }

        val repl = new Pattern("^(.*)\\((#.*?)\\)(.*)$");

        var resultStr = patternStr

        var found = true

        while (found) {
            val m = repl.matcher(resultStr)

            if (m.find) {
                val replace = getNamedPattern(m.group(2))

                if (replace === null) {
                    throw new PatternNotFound(m.group(2).substring(1))
                }

                resultStr = (new StringBuilder(m.group(1)) //
                                   .append("(") //
                                   .append(getNamedPattern(m.group(2))) //
                                   .append(")") //
                                   .append(m.group(3)) //
                             ).toString
            } else {
                found = false
            }
        }

        // test pattern
        try {
            new Pattern(resultStr)
        } catch (Exception e) {
            throw new InvalidPattern(resultStr)
        }

        completePattern.put(name, resultStr)

        return resultStr
    }

    def List<Epg> filterNamedPattern(String name, List<Epg> list) {
        var patStr = namedPattern.get(name)

        if (patStr === null) {
            patStr = namedPattern.get("#" + name)
            if (patStr === null) {
                // name not found
                throw new NameNotFoundException(name)
            }
        }

        return filterEpg(patStr, list, true, true, true)
    }

    def List<Epg> filterNamedPattern(String name, List<Epg> list, boolean searchInTitle, boolean searchInShortText, boolean searchInDescription) {
        var patStr = namedPattern.get(name)

        if (patStr === null) {
            patStr = namedPattern.get("#" + name)
            if (patStr === null) {
                // name not found
                throw new NameNotFoundException(name)
            }
        }

        return filterEpg(patStr, list, searchInTitle, searchInShortText, searchInDescription)
    }

    def List<Epg> filterCompletePattern(String name, List<Epg> list) {
        var patStr = completePattern.get(name)

        if (patStr === null) {
            patStr = completePattern.get("#" + name)
            if (patStr === null) {
                // name not found
                throw new NameNotFoundException(name)
            }
        }

        return filterEpg(patStr, list, true, true, true)
    }

    def List<Epg> filterCompletePattern(String name, List<Epg> list, boolean searchInTitle, boolean searchInShortText, boolean searchInDescription) {
        var patStr = completePattern.get(name)

        if (patStr === null) {
            patStr = completePattern.get("#" + name)
            if (patStr === null) {
                // name not found
                throw new NameNotFoundException(name)
            }
        }

        return filterEpg(patStr, list, searchInTitle, searchInShortText, searchInDescription)
    }

    private def List<Epg> filterEpg(String patStr, List<Epg> list, boolean title, boolean shortText, boolean description) {
        val pattern = new Pattern(patStr)

        return list.stream.filter(s | {
            if (title && s.title !== null && pattern.matcher(s.title).find) {
                return true
            } else if (shortText && s.shortText !== null && pattern.matcher(s.shortText).find) {
                return true
            } else if (description && s.description !== null && pattern.matcher(s.description).find) {
                return true
            }

            return false
        }).collect(Collectors.toList)
    }
}

@SuppressWarnings("serial")
class NameNotFoundException extends RuntimeException {
    new(String message) {
        super("Name not found: " + message)
    }
}

@SuppressWarnings("serial")
class InvalidPattern extends RuntimeException {
    new(String message) {
        super("Invalid pattern: " + message)
    }
}

@SuppressWarnings("serial")
class PatternNotFound extends RuntimeException {
    new(String message) {
        super("Pattern '" + message + "' not found")
    }
}
