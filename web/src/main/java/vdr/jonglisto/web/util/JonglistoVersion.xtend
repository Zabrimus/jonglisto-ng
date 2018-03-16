package vdr.jonglisto.web.util

import java.io.BufferedReader
import java.io.InputStreamReader

import static extension vdr.jonglisto.util.Utils.*

class JonglistoVersion {

    static String version = "<unknown>"

    new() {
        try {
            val in = JonglistoVersion.getResourceAsStream("/META-INF/version.txt")

            using(new BufferedReader(new InputStreamReader(in))) [
                version = lines().findFirst.get.trim
            ]
        } catch (Exception e) {
            e.printStackTrace
            version = "unable to find version.txt"
        }
    }

    def getVersion() {
        version
    }
}
