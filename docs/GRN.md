# GRN

(pronounced like `grin`)

an API written in Go using [Gornir](https://nornir.tech/gornir/), augmented by [scrapligo](https://github.com/scrapli/scrapligo), and [Net/HTTP](https://pkg.go.dev/net/http) to scrape the output of show commands and return result as JSON. it's like `nrf`, but in Go.

> Gornir is a pluggable framework with inventory management to help operate collections of devices. It's similar to nornir but in golang.

 `scrapligo` was chosen for its support of `textfsm` templates.

> scrapligo -- scrap(e c)li (but in go!) -- is a Go library focused on connecting to devices, specifically network
> devices (routers/switches/firewalls/etc.) via SSH and NETCONF.
