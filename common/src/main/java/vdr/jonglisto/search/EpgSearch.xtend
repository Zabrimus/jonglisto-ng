package vdr.jonglisto.search

import java.util.HashMap
import java.util.List
import java.util.stream.Collectors
import jregex.Pattern
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.Epg
import vdr.jonglisto.xtend.annotation.Log

@Log("jonglisto.search")
class EpgSearch {

    private static Configuration config = Configuration.instance
    private static EpgSearch instance = new EpgSearch

    val namedPattern = new HashMap<String, String>
    val completePattern = new HashMap<String, String>

    private new() {
        reloadPattern
    }

    public static def EpgSearch getInstance() {
        return instance
    }

    public def void reloadPattern() {
        namedPattern.clear
        completePattern.clear

        val simple = config.extEpgSearch.simplePattern
        val complex = config.extEpgSearch.complexPattern

        simple.forEach(s | addNamedPattern(s.name, s.pattern))
        complex.forEach(s | addCompletePattern(s.name, s.pattern))
    }

    public def getAllNamedPattern() {
        return namedPattern
    }

    public def getAllCompletePattern() {
        return completePattern
    }

    public def String getNamedPattern(String name) {
        return namedPattern.get(name)
    }

    public def void addNamedPattern(String name, String patternStr) {

        if (name !== null) {
            namedPattern.put("#" + name, patternStr)
        }
    }

    public def String addCompletePattern(String name, String patternStr) {
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

    public def List<Epg> filterNamedPattern(String name, List<Epg> list) {
        var patStr = namedPattern.get(name)

        println("Named Pattern: " + namedPattern)

        if (patStr === null) {
            patStr = namedPattern.get("#" + name)
            if (patStr === null) {
                // name not found
                throw new NameNotFoundException(name)
            }
        }

        return filterEpg(patStr, list, true, true, true)
    }

    public def List<Epg> filterNamedPattern(String name, List<Epg> list, boolean searchInTitle, boolean searchInShortText, boolean searchInDescription) {
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

    public def List<Epg> filterCompletePattern(String name, List<Epg> list) {
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

    public def List<Epg> filterCompletePattern(String name, List<Epg> list, boolean searchInTitle, boolean searchInShortText, boolean searchInDescription) {
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

class NameNotFoundException extends RuntimeException {
    new(String message) {
        super("Name not found: " + message)
    }
}

class InvalidPattern extends RuntimeException {
    new(String message) {
        super("Invalid pattern: " + message)
    }
}

class PatternNotFound extends RuntimeException {
    new(String message) {
        super("Pattern '" + message + "' not found")
    }
}
