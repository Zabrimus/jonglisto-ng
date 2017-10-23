package vdr.jonglisto.util

import java.io.BufferedReader
import java.io.InputStream
import java.io.InputStreamReader
import java.util.ArrayList
import java.util.List

class ClasspathFileReader {

    def static readStringList(String file) {
        return ClasspathFileReader.getResourceAsStream(file).readFromInputStream
    }

    private static def List<String> readFromInputStream(InputStream inputStream) {
        val result = new ArrayList<String>()

        val br = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
        var String line

        while ((line = br.readLine()) !== null) {
            result.add(line)
        }

        return result
    }
}
