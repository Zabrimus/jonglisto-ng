package vdr.jonglisto.svdrp.client

import io.netty.bootstrap.Bootstrap
import io.netty.buffer.Unpooled
import io.netty.channel.AbstractChannel
import io.netty.channel.Channel
import io.netty.channel.ChannelOption
import io.netty.channel.EventLoopGroup
import io.netty.channel.epoll.Epoll
import io.netty.channel.epoll.EpollDatagramChannel
import io.netty.channel.epoll.EpollEventLoopGroup
import io.netty.channel.nio.NioEventLoopGroup
import io.netty.channel.socket.DatagramPacket
import io.netty.channel.socket.nio.NioDatagramChannel
import io.netty.channel.unix.UnixChannelOption
import io.netty.util.CharsetUtil
import io.netty.util.internal.SocketUtils
import vdr.jonglisto.configuration.Configuration
import vdr.jonglisto.svdrp.server.DiscoveryServerHandler

class VdrDiscoveryClient {
    static VdrDiscoveryClient instance = new VdrDiscoveryClient

    var int PORT = 6419

    val EventLoopGroup group
    val Class<? extends AbstractChannel> channel

    val Channel sendChannel;

    private new() {
        if (Epoll.isAvailable()) {
            group = new EpollEventLoopGroup(1)
            channel = EpollDatagramChannel
        } else {
            group = new NioEventLoopGroup(1)
            channel = NioDatagramChannel
        }

        val bootstrap = new Bootstrap();
        bootstrap.group(group).channel(channel).option(ChannelOption.SO_BROADCAST, true).handler(new DiscoveryServerHandler());

        if (Epoll.isAvailable()) {
            bootstrap.option(UnixChannelOption.SO_REUSEPORT, true)
        }

        sendChannel = bootstrap.bind(0).sync().channel();
    }

    def stop() {
        group.shutdownGracefully();
    }

    def sendDiscovery() {
        sendChannel.writeAndFlush(
            new DatagramPacket(
                Unpooled.copiedBuffer("SVDRP:discover name:jonglisto port:" + Configuration.instance.svdrpServerPort +
                    " vdrversion:20400 apiversion:20400 timeout:300", CharsetUtil.UTF_8),
                SocketUtils.socketAddress("255.255.255.255", PORT))).sync()
    }

    static def getInstance() {
        return instance
    }

}
