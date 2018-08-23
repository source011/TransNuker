import sys
import os
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir))

# Vars
namn=sys.argv[1]
torrent=sys.argv[2]
ratio=sys.argv[3]
seedTid=sys.argv[4]
uploaded=sys.argv[5]
size=sys.argv[6]
from discordWebhooks import Webhook, Attachment, Field

url = "" # Discord webhook url
wh = Webhook(url, " ", namn + " - Transmission Nuker")

at = Attachment(author_name = " ", color = "#ADFF2F", title = "[Torrent deleted!]")

field = Field("Who's torrent?", namn, False)
at.addField(field)
field = Field("Seeding time", seedTid, True)
at.addField(field)
field = Field("Ratio", ratio, True)
at.addField(field)
field = Field("Total size", size, True)
at.addField(field)
field = Field("Total uploaded", uploaded, True)
at.addField(field)
field = Field("Torrent name", torrent, False)
at.addField(field)

wh.addAttachment(at)
wh.post()
