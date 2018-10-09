package vdr.jonglisto.svdrp.client

import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode
import org.eclipse.xtend.lib.annotations.ToString
import java.net.Socket

@Accessors
@EqualsHashCode
@ToString
class Response {
  int code;
  Socket clientSocket
  List<String> lines = new ArrayList<String>()
}
