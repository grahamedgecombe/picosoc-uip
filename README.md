# PicoSoC uIP port

## Introduction

A port of [uIP 0.9][uip09] (a minimal TCP/IP stack and web server) to
[PicoSoC][picosoc] (a [RISC-V][riscv] SoC for the [iCE40][ice40] [HX8K breakout
board][ice40-hx8k-breakout] based on the [PicoRV32][picorv32] CPU). It uses SLIP
to send IP packets over the serial port to the host computer.

## Dependencies

* [arachne-pnr][arachne-pnr]
* [GNU RISC-V toolchain][riscv-gnu]
* [GNU Make][make]
* [Project IceStorm][icestorm]
* [Yosys][yosys]

## Building and testing

Run `git submodule update --init` to clone a patched copy of PicoSoC. The
changes are minimal: the size of the SRAM was bumped to 8 KiB and the frequency
was bumped to 24 MHz.

Configure the jumpers on the breakout board for flash programming and then run
`make flash`.

Run the following commands to create the SLIP interface:

    slattach -L -p slip -s 57600 /dev/ttyUSB1 &
    ip addr add 192.168.0.1 peer 192.168.0.2 dev sl0
    ip link set mtu 1500 up dev sl0

The path to the serial port may vary depending on your system.

Pinging the board should then work:

    $ ping -c 4 192.168.0.2
    PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
    64 bytes from 192.168.0.2: icmp_seq=1 ttl=64 time=55.1 ms
    64 bytes from 192.168.0.2: icmp_seq=2 ttl=64 time=61.8 ms
    64 bytes from 192.168.0.2: icmp_seq=3 ttl=64 time=52.1 ms
    64 bytes from 192.168.0.2: icmp_seq=4 ttl=64 time=58.8 ms

    --- 192.168.0.2 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3004ms
    rtt min/avg/max/mdev = 52.120/56.990/61.844/3.682 ms
    $

as should fetching a page from the web server:

	$ curl http://192.168.0.2
	<html>
	<head><title>uIP web server test page</title></head>

	<frameset cols="*" rows="120,*" frameborder="no">
	  <frame src="control.html">
	  <frame src="about.html" name="main">
	</frameset>

	<noframes>
	<body>
	Your browser must support frames
	</body>
	</noframes>
	</html>
	$

If you're brave you can also try visiting `http://192.168.0.2` in your web
browser. This doesn't seem to work as well as `curl` - I think it's because
modern web browsers send lots of headers.

After a few tries you should see the index page:

![uIP index page](https://raw.githubusercontent.com/grahamedgecombe/picosoc-uip/master/screenshot.png)

The "CGI" pages don't work. I'm not sure why - I suspect that the PicoSoC isn't
fast enough to keep up, or perhaps there's a bug somewhere in uIP's web server
(the C code is rather old and crufy!)

[arachne-pnr]: https://github.com/cseed/arachne-pnr
[ice40-hx8k-breakout]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/iCE40HX8KBreakoutBoard.aspx
[ice40]: http://www.latticesemi.com/Products/FPGAandCPLD/iCE40.aspx
[icestorm]: http://www.clifford.at/icestorm/
[make]: https://www.gnu.org/software/make/
[picorv32]: https://github.com/cliffordwolf/picorv32
[picosoc]: https://github.com/cliffordwolf/picorv32/tree/master/picosoc
[riscv-gnu]: https://github.com/riscv/riscv-gnu-toolchain
[riscv]: https://riscv.org/risc-v-isa/
[uip09]: https://github.com/adamdunkels/uip/tree/uip-0-9
[yosys]: http://www.clifford.at/yosys/
