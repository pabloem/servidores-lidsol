/*
saturador is a tool to saturate a network link to discover its capacity.

It is both a client and server tool, which supports TCP and HTTP connections
to test link capacity.

Usage:

	saturador [flags]
*/
package main

import (
	"flag"
	"fmt"
	"time"

	"github.com/tidwall/evio"
)

func runServer(port int) {
	fmt.Println("Running server on port", port)
	const tickDuration = 2 * time.Second
	var byteCounter int64 = 0
	var tickCounter int = 0
	var events evio.Events = evio.Events{
		Data: func(c evio.Conn, in []byte) (out []byte, action evio.Action) {
			byteCounter += int64(len(in))
			return in, evio.None
		},
		Tick: func() (delay time.Duration, action evio.Action) {
			fmt.Println("Time: ", tickDuration, " - Received", byteCounter/1e6, "MB - Throughput", byteCounter/1e6/int64(tickDuration.Seconds()), "MB/s")
			tickCounter++
			byteCounter = 0
			return tickDuration, evio.None
		},
	}

	evio.Serve(events, "tcp://0.0.0.0:"+fmt.Sprint(port))
}

func main() {
	var port int
	var duration string
	var http bool = false

	flag.IntVar(&port, "l", 8080, "Port to listen on. This is for the server.")
	flag.StringVar(&duration, "t", "10s", "Duration of the test")
	flag.BoolVar(&http, "http", false, "Use HTTP for the test")
	flag.Parse()

	runServer(port)
}
