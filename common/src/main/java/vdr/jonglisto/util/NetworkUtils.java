package vdr.jonglisto.util;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vdr.jonglisto.model.VDR;

public class NetworkUtils {

    private final static Logger log = LoggerFactory.getLogger("vdr.jonglisto.util.NetworkUtils");

    public static void sendWol(VDR vdr) {
        if ((vdr == null) || (vdr.getMac() == null)) {
            // ignore this request due to missing MAC
            return;
        }

        // check MAC and extract parts
        byte[] macBytes = new byte[6];
        String[] hex = vdr.getMac().split("(\\:|\\-)");
        if (hex.length != 6) {
            log.warn("Invalid MAC address: {}", vdr.getMac());
            return;
        }

        try {
            for (int i = 0; i < 6; i++) {
                macBytes[i] = (byte) Integer.parseInt(hex[i], 16);
            }
        } catch (NumberFormatException e) {
            log.warn("Invalid MAC address: {}", vdr.getMac());
            return;
        }

        // create the magic packet
        byte[] bytes = new byte[6 + 16 * macBytes.length];
        for (int i = 0; i < 6; i++) {
            bytes[i] = (byte) 0xff;
        }
        for (int i = 6; i < bytes.length; i += macBytes.length) {
            System.arraycopy(macBytes, 0, bytes, i, macBytes.length);
        }

        // try to find the broadcast addresses and send magic packet
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface networkInterface = interfaces.nextElement();
                if (networkInterface.isLoopback())
                    continue;

                for (InterfaceAddress interfaceAddress : networkInterface.getInterfaceAddresses()) {
                    InetAddress broadcast = interfaceAddress.getBroadcast();
                    if (broadcast == null)
                        continue;

                    // send magic packet to broadcast address
                    DatagramPacket packet = new DatagramPacket(bytes, bytes.length, broadcast, 9);
                    DatagramSocket socket = new DatagramSocket();
                    socket.send(packet);
                    socket.close();
                }
            }
        } catch (IOException e) {
            // i'm unsure what to do
            log.warn("Unable to send WOL packet to broadcase address");
        }
    }

}
