package vdr.jonglisto.web.util

import java.util.List
import java.util.stream.Collectors
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.model.Recording
import vdr.jonglisto.model.TreeRecording
import vdr.jonglisto.svdrp.client.SvdrpClient

class RecordingUtil {

    public static def getTreeRecording(List<Recording> list) {
        val treeRecording = new TreeRecording("Video")

        addRecFolders(treeRecording, null, list)

        if (treeRecording.children !== null) {
            val length = treeRecording.children.stream().map(l | l.length).reduce(p1, p2| p1 + p2)
            if (length.isPresent) {
                treeRecording.length = length.get
            }

            val childCount = treeRecording.children.stream().map(l | l.childCount).reduce(p1, p2| p1 + p2)
            if (childCount.isPresent) {
                treeRecording.childCount = childCount.get
            }

            val newCount = treeRecording.children.stream().map(l | l.newCount).reduce(p1, p2| p1 + p2)
            if (newCount.isPresent) {
                treeRecording.newCount = newCount.get
            }
        }

        return #[treeRecording]
    }

    private static def void addRecFolders(TreeRecording treeRecording, TreeRecording parent, List<Recording> childs) {
        // split the list into recordings and folders
        val folders = childs.stream.filter(s | s.path.indexOf("~") != -1).collect(Collectors.toList()).sortBy[s | s.path.toLowerCase]
        val recs = childs.stream.filter(s | s.path.indexOf("~") == -1).collect(Collectors.toList()).sortBy[s | s.path.toLowerCase]

        // add folder
        if (folders.size > 0) {
            val recordingsInFolder = folders.stream() //
                .map(m | {
                        val idx = m.path.indexOf("~")
                        if (idx != -1) {
                            m.folder = m.path.substring(0, idx)
                            m.path = m.path.substring(idx + 1)
                        }
                        return m
                    })
                .collect(Collectors.groupingBy([m | m.folder], Collectors.toList()));

            recordingsInFolder.keySet.sort.forEach[s | {
                val newFolder = new TreeRecording(s)
                val ch = recordingsInFolder.get(s)

                if (parent === null) {
                    treeRecording.children.add(newFolder)
                } else {
                    parent.children.add(newFolder)
                }

                addRecFolders(treeRecording, newFolder, ch)

                newFolder.length = newFolder.children.stream().map(l | l.length).reduce(p1, p2| p1 + p2).get
                newFolder.childCount = newFolder.children.stream().map(l | l.childCount).reduce(p1, p2| p1 + p2).get
                newFolder.newCount = newFolder.children.stream().map(l | l.newCount).reduce(p1, p2| p1 + p2).get
            }]
        }

        // add recordings
        recs.stream.forEach(r | {
            val tr = new TreeRecording(r.path) => [recording = r; folder = false; childCount = 1; newCount = if (r.seen) 0 else 1; length = r.length]

            if (parent === null) {
                treeRecording.children.add(tr)
            } else {
                parent.children.add(tr)
            }
        })
    }

    public static def void main(String[] argv) {
        val Configuration config = Configuration.instance
        val SvdrpClient svdrp = SvdrpClient.instance
        val vdr = config.getVdr("Robert")

        val recList = svdrp.getRecordings(vdr)
        getTreeRecording(recList)
    }
}
