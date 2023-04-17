# Namecheap DNS using ddclient

1. install `ddclient`

2. edit the config file at `/etc/ddclient/ddclient.conf`:
```ini
use=web, web=dynamicdns.park-your-domain.com/getip
protocol=namecheap
server=dynamicdns.park-your-domain.com
login=yourdomain.com
password=your dynamic dns password
yourhost
```
> [source](https://www.namecheap.com/support/knowledgebase/article.aspx/583/11/how-do-i-configure-ddclient/)

3. start ddclient
