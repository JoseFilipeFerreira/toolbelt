# Control MEO router with Telnet

- Connect
```
telnet 192.169.1.254
```

- IP
```
/lan/dhcp/show
/lan/dhcp/clear-leases --ip-address=...
```

- Static Lease
```
/lan/static-lease/show
/lan/static-lease/create --group-name=<...> --ip=<...> --mac=<...>
```

