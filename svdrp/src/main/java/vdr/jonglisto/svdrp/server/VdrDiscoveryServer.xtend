package vdr.jonglisto.svdrp.server

import io.netty.bootstrap.Bootstrap
import io.netty.channel.AbstractChannel
import io.netty.channel.ChannelFuture
import io.netty.channel.ChannelHandlerContext
import io.netty.channel.ChannelOption
import io.netty.channel.EventLoopGroup
import io.netty.channel.SimpleChannelInboundHandler
import io.netty.channel.epoll.Epoll
import io.netty.channel.epoll.EpollDatagramChannel
import io.netty.channel.epoll.EpollEventLoopGroup
import io.netty.channel.nio.NioEventLoopGroup
import io.netty.channel.socket.DatagramPacket
import io.netty.channel.socket.nio.NioDatagramChannel
import io.netty.channel.unix.UnixChannelOption
import io.netty.util.CharsetUtil
import vdr.jonglisto.model.VDR

class VdrDiscoveryServer implements Runnable {
    var int PORT = 6419

    val EventLoopGroup group
    val Class<? extends AbstractChannel> channel
    var ChannelFuture channelFuture

    new(int threads) {
        var ioThreads = threads

        // use threads only if Epoll (native) is available
        if (!Epoll.isAvailable()) {
            ioThreads = 1;
        }

        if (Epoll.isAvailable()) {
            group = new EpollEventLoopGroup(ioThreads)
            channel = EpollDatagramChannel
        } else {
            group = new NioEventLoopGroup(ioThreads)
            channel = NioDatagramChannel
        }
    }

    def void stop() {
        if (channelFuture !== null) {
            channelFuture.channel.close
        }
    }

    override run() {
        try {
            val bootstrap = new Bootstrap();
            bootstrap.group(group) //
                .channel(channel).option(ChannelOption.SO_BROADCAST, true)

            if (Epoll.isAvailable()) {
                bootstrap.option(UnixChannelOption.SO_REUSEPORT, true);
                bootstrap.option(UnixChannelOption.SO_REUSEADDR, true);
            }

            bootstrap.handler(new DiscoveryServerHandler());

            channelFuture = bootstrap.bind(PORT) //
                                .sync() //
                                .channel() //
                                .closeFuture() //
                                .await();
        } finally {
            group.shutdownGracefully();
        }
    }
}

class DiscoveryServerHandler extends SimpleChannelInboundHandler<DatagramPacket> {

    val handler = new DiscoveryHandler

    override void channelRead0(ChannelHandlerContext ctx, DatagramPacket packet) throws Exception {
        val request = packet.content().toString(CharsetUtil.UTF_8)
        val VDR response = handler.process(packet.sender.address.hostAddress, request)

        // TODO: Do something useful with the response!
    }

    override void channelReadComplete(ChannelHandlerContext ctx) {
        ctx.flush();
    }

    override void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        cause.printStackTrace();
    }
}
