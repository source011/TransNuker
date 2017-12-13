import sys
import os
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.pardir))

# Set arguments to variables
namn=sys.argv[1]
torrent=sys.argv[2]
ratio=sys.argv[3]
seedTid=sys.argv[4]

from discordWebhooks import Webhook, Attachment, Field

url = "https://discordapp.com/api/webhooks/390099149259014146/uc_ETPrurZB4pQeW9QQcr9I-hdC9YEWf2OwgII07wHVO8ZDWliMmuonVJ62za7Vd2f6o" # Discord API url
wh = Webhook(url, " ", namn + " - Transmission Nuker")

at = Attachment(author_name = " ", color = "#ADFF2F", title = "[Torrent deleted!]")

field = Field("Who's torrent?", namn, False)
at.addField(field)
field = Field("Seeding time", seedTid, True)
at.addField(field)
field = Field("Ratio", ratio, True)
at.addField(field)
field = Field("Torrent name", torrent, False)
at.addField(field)

wh.addAttachment(at)

# Another message type
#at = Attachment(author_name = "", color = "#ADFF2F", title = "")
#wh.addAttachment(at)

wh.post()
