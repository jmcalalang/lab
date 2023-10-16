{
    "class": "AS3",
    "action": "{{ action }}",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.43.0",
        "id": "BIG-IP-Common-Tenant",
        "Common": {
            "class": "Tenant",
            "Shared": {
                "class": "Application",
                "template": "shared",
                "Proxy_Protocol_iRule": {
                    "remark": "Used for F5 IngressLink",
                    "class": "iRule",
                    "iRule": {
                        "base64": "d2hlbiBTRVJWRVJfQ09OTkVDVEVEIHsgVENQOjpyZXNwb25kICJQUk9YWSBUQ1BbSVA6OnZlcnNpb25dIFtJUDo6Y2xpZW50X2FkZHJdIFtjbGllbnRzaWRlIHtJUDo6bG9jYWxfYWRkcn1dIFtUQ1A6OmNsaWVudF9wb3J0XSBbY2xpZW50c2lkZSB7VENQOjpsb2NhbF9wb3J0fV1cclxuIiB9"
                    }
                },
                "BIG-IP_Health_rule": {
                    "remark": "BIG-IP health status page",
                    "class": "iRule",
                    "iRule": {
                        "base64": "d2hlbiBIVFRQX1JFUVVFU1QgewogIGlmIHsgW0hUVFA6OnVyaV0gZW5kc193aXRoICIvaGVhbHRoIiB9IHsKICAgICBIVFRQOjpyZXNwb25kIDIwMCBjb250ZW50ICIKICAgICAgPGh0bWw+CiAgICAgICAgIDxoZWFkPgogICAgICAgICAgICA8dGl0bGU+SGVhbHRoIFBhZ2U8L3RpdGxlPgogICAgICAgICA8L2hlYWQ+CiAgICAgICAgIDxib2R5PgogICAgICAgICAgICBUaGUgQklHLUlQIGlzIGF2YWlsYWJsZS4gPGJyLz4KICAgICAgICAgICAgVmlydHVhbCBOYW1lOiBbdmlydHVhbF0gPGJyLz4KICAgICAgICAgICAgVmlydHVhbCBJUDogW0lQOjpsb2NhbF9hZGRyXSA8YnIvPgogICAgICAgICA8L2JvZHk+CiAgICAgIDwvaHRtbD4KICAgICAgIgogfQp9"
                    }
                },
                "BIG-IP_Maintenance_Page_rule": {
                    "remark": "Maintenance page",
                    "class": "iRule",
                    "iRule": {
                        "base64": "d2hlbiBIVFRQX1JFUVVFU1QgewogICAgSFRUUDo6cmVzcG9uZCAyMDAgY29udGVudCB7CiAgICAgICAgPGh0bWw+CgogICAgICAgIDxoZWFkPgogICAgICAgIDx0aXRsZT5CbG9ja2VkIFBhZ2U8L3RpdGxlPgogICAgICAgIDwvaGVhZD4KCiAgICAgICAgPGJvZHk+CiAgICAgICAgV2UgYXJlIHNvcnJ5LCBidXQgdGhlIHNpdGUgeW91IGFyZSBsb29raW5nIGZvciBpcyBjdXJyZW50bHkgdW5kZXIgTWFpbnRlbmFuY2U8YnI+CiAgICAgICAgSWYgeW91IGZlZWwgeW91IGhhdmUgcmVhY2hlZCB0aGlzIHBhZ2UgaW4gZXJyb3IsIHBsZWFzZSB0cnkgYWdhaW4uIFRoYW5rcyBmb3IgY29taW5nIQogICAgICAgIDwvYm9keT4KCiAgICAgICAgPC9odG1sPgogICAgICAgIH0gbm9zZXJ2ZXIgQ2FjaGUtQ29udHJvbCBuby1jYWNoZSBDb25uZWN0aW9uIENsb3NlCiAgICB9"
                    }
                },
                "mTLS_specific_uri_rule": {
                    "remark": "mTLS on a specific URI",
                    "class": "iRule",
                    "iRule": {
                        "base64": "d2hlbiBDTElFTlRTU0xfQ0xJRU5UQ0VSVCB7CiAgICBIVFRQOjpyZWxlYXNlCiAgICBpZiB7IFtTU0w6OmNlcnQgY291bnRdIDwgMSB9IHsKICAgICAgICByZWplY3QKICAgIH0KfQoKd2hlbiBIVFRQX1JFUVVFU1QgewogICAgbG9nIGxvY2FsMC4gIkNsaWVudCBbSVA6OmNsaWVudF9hZGRyXTpbVENQOjpjbGllbnRfcG9ydF0gLT4gW0hUVFA6Omhvc3RdW0hUVFA6OnVyaV0iCiAgICBpZiB7IFtIVFRQOjp1cmldIGNvbnRhaW5zIFtzdHJpbmcgdG9sb3dlciAiL3VyaS13aXRoLW10bHMuaHRtbCJdIH0gewogICAgICAgIGlmIHsgW1NTTDo6Y2VydCBjb3VudF0gPD0gMCB9IHsKICAgICAgICAgICAgSFRUUDo6Y29sbGVjdAogICAgICAgICAgICBTU0w6OmF1dGhlbnRpY2F0ZSBhbHdheXMKICAgICAgICAgICAgU1NMOjphdXRoZW50aWNhdGUgZGVwdGggOQogICAgICAgICAgICBTU0w6OmNlcnQgbW9kZSByZXF1aXJlCiAgICAgICAgICAgIFNTTDo6cmVuZWdvdGlhdGUKICAgICAgICB9CiAgICB9Cn0KCndoZW4gSFRUUF9SRVFVRVNUX1NFTkQgewogICAgbG9nIGxvY2FsMC4gIlNlcnZlciBbSVA6OnNlcnZlcl9hZGRyXTpbVENQOjpzZXJ2ZXJfcG9ydF0gLT4gW0hUVFA6Omhvc3RdW0hUVFA6OnVyaV0iCiAgICBjbGllbnRzaWRlIHsKICAgICAgICBpZiB7IFtTU0w6OmNlcnQgY291bnRdID4gMCB9IHsKICAgICAgICAgICAgSFRUUDo6aGVhZGVyIGluc2VydCAiWC1TU0wtU2Vzc2lvbi1JRCIgICAgICAgIFtTU0w6OnNlc3Npb25pZF0KICAgICAgICAgICAgSFRUUDo6aGVhZGVyIGluc2VydCAiWC1TU0wtQ2xpZW50LUNlcnQtU3RhdHVzIiAgICBbWDUwOTo6dmVyaWZ5X2NlcnRfZXJyb3Jfc3RyaW5nIFtTU0w6OnZlcmlmeV9yZXN1bHRdXQogICAgICAgICAgICBIVFRQOjpoZWFkZXIgaW5zZXJ0ICJYLVNTTC1DbGllbnQtQ2VydC1TdWJqZWN0IiAgIFtYNTA5OjpzdWJqZWN0IFtTU0w6OmNlcnQgMF1dCiAgICAgICAgICAgIEhUVFA6OmhlYWRlciBpbnNlcnQgIlgtU1NMLUNsaWVudC1DZXJ0LUlzc3VlciIgICAgW1g1MDk6Omlzc3VlciBbU1NMOjpjZXJ0IDBdXQogICAgICAgIH0KICAgIH0KfQo="
                    }
                },
                "APM_server_list_from_AD_rule": {
                    "remark": "APM Server list from AD",
                    "class": "iRule",
                    "iRule": {
                        "base64": "IyBDcmVhdGVkIGJ5IEpvbiBDYWxhbGFuZyAoam9uQGY1LmNvbSksIHRoaXMgaXJ1bGUgaXMgbm90IHN1cHBvcnRlZCBieSBmNSBuZXR3b3Jrcy4KIyBUaGlzIGlydWxlIGlzIHVzZWQgdG8gY29uc3VtZSBhIGxpc3QgZnJvbSBhbiBBY3RpdmUgRGlyZWN0b3J5IGF0dHJpYnV0ZSBhbmQgdHVybiBpdAojIGludG8gYSBsaXN0IGZvciB0aGUgdXNlciB0byBjb25zdW1lLCBsZXR0aW5nIHRoZW0gY2hvb3NlIGEgZGVzdGluYXRpb24gZm9yIHRoZWlyCiMgcmRwIHNlc3Npb24uIFRoZSBvcmlnaW5hbCBsaXN0IGlzIHN0b3JlZCBpbiBBRCwgbm8gc3BlY2lhbCBjaGFyYWN0b3JzIGFyZSBuZWVkZWQKIyBhcyBBUE0gd2lsbCBhdXRvbWF0aWNhbGx5IHBsYWNlIGEgInwiIG9uIGEgbGlzdCB2YXJpYWJsZSBmcm9tIEFELiB0aGUgbGlzdCBpbmRleCBpcwojIHNldCBhdCAxMCBiZWxvdywgaG93ZXZlciBpdCBjYW4gYmUgYXMgbG9uZyBvciBzaG9ydCBhcyBuZWVkZWQgdG8gcmVwcmVzZW50IHRoZSBBRCBsaXN0CiMgdGhlIGNvcnJvbGF0aW5nIGxpc3QgbmVlZHMgdG8gYmUgYWRkZWQgdG8gYSBjdXN0b21pc2VkIGxvZ29uIHBhZ2Ugd2hpY2ggd2lsbCBjb250YWluCiMgdGhlIHNhbWUgdmFyaWFibGUgbmFtZXMKCiMgZXhhbXBsZSBBRCBhdHRyaWJ1dGUgaXMgcHVsbGVkIGludG8gInNlc3Npb24uYWQubGFzdC5hdHRyLm90aGVyTG9naW5Xb3Jrc3RhdGlvbnMiIHdpdGggYSBxdWVyeQojIHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0MCBpcyBkeW5hbWljYWxseSBwb3B1bGF0ZWQgYW5kIHBsYWNlZCBiYWNrIGludG8gdGhlIHNlc3Npb24gZm9yIHVzZQoKd2hlbiBBQ0NFU1NfUE9MSUNZX0FHRU5UX0VWRU5UIHsKICAgIHNldCBzZXJ2ZXJsaXN0IFtBQ0NFU1M6OnNlc3Npb24gZGF0YSBnZXQgInNlc3Npb24uYWQubGFzdC5hdHRyLm90aGVyTG9naW5Xb3Jrc3RhdGlvbnMiXQogICAgc2V0IGZpZWxkcyBbc3BsaXQgJHNlcnZlcmxpc3QgInwiXQogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0MCAiW2xpbmRleCAkZmllbGRzIDBdIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0MSAiW2xpbmRleCAkZmllbGRzIDFdIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0MiAiW2xpbmRleCAkZmllbGRzIDJdIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0MyAiW2xpbmRleCAkZmllbGRzIDNdIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0NCAiW2xpbmRleCAkZmllbGRzIDRdIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0NSAiW2xpbmRleCAkZmllbGRzIDVdIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0NiAiW2xpbmRleCAkZmllbGRzIDZdIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0NyAiW2xpbmRleCAkZmllbGRzIDddIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0OCAiW2xpbmRleCAkZmllbGRzIDhdIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0OSAiW2xpbmRleCAkZmllbGRzIDldIgogICAgQUNDRVNTOjpzZXNzaW9uIGRhdGEgc2V0IHNlc3Npb24ubG9nb24udGVtcC5zZXJ2ZXJsaXN0MCAiW2xpbmRleCAkZmllbGRzIDEwXSIKICAgICMgbG9nZ2luZyBkaXNhYmxlZCBieSBkZWZhdWx0CiAgICAjICBsb2cgbG9jYWwwLiBbbGluZGV4ICRmaWVsZHMgM10KfQo="
                    }
                },
                "traffic_duplication_rule": {
                    "remark": "Traffic Duplication iRule",
                    "class": "iRule",
                    "iRule": {
                        "base64": "IyBpUnVsZSBjb21lcyB3aXRoIG5vIHN1cHBvcnQuIFRvIHNlbmQgdHJhZmZpYyBhdCBhIHBvb2wgY2hhbmdlIHRoZSAiUE9PTCBOQU1FIEdPRVMgSEVSRSIKIyB0byB0aGUgY29ycmVjdCBwYXRoLgoKd2hlbiBSVUxFX0lOSVQgewogICAgIyBMb2cgZGVidWcgbG9jYWxseSB0byAvdmFyL2xvZy9sdG0/IDE9eWVzLCAwPW5vCiAgICBzZXQgc3RhdGljOjpoc2xfZGVidWcgMQogICAgIyBQb29sIG5hbWUgdG8gY2xvbmUgcmVxdWVzdHMgdG8KICAgIHNldCBzdGF0aWM6OmhzbF9wb29sICJQT09MIE5BTUUgR09FUyBIRVJFIgp9Cgp3aGVuIENMSUVOVF9BQ0NFUFRFRCB7CiAgICBpZiB7W2FjdGl2ZV9tZW1iZXJzICRzdGF0aWM6OmhzbF9wb29sXT09MH17CiAgICAgICAgbG9nICJbSVA6OmNsaWVudF9hZGRyXTpbVENQOjpjbGllbnRfcG9ydF06IFt2aXJ0dWFsIG5hbWVdICRzdGF0aWM6OmhzbF9wb29sIGRvd24sIG5vdCBsb2dnaW5nIgogICAgICAgIHNldCBieXBhc3MgMQogICAgICAgIHJldHVybgogICAgfSBlbHNlIHsKICAgICAgICBzZXQgYnlwYXNzIDAKICAgIH0KICAgIHNldCBoc2wgW0hTTDo6b3BlbiAtcHJvdG8gVENQIC1wb29sICRzdGF0aWM6OmhzbF9wb29sXQogICAgaWYgeyRzdGF0aWM6OmhzbF9kZWJ1Z317bG9nIGxvY2FsMC4gIltJUDo6Y2xpZW50X2FkZHJdOltUQ1A6OmNsaWVudF9wb3J0XTogTmV3IGhzbCBoYW5kbGU6ICRoc2wifQoKfQp3aGVuIEhUVFBfUkVRVUVTVCB7CiAgICAjIElmIHRoZSBIU0wgcG9vbCBpcyBkb3duLCBkbyBub3QgcnVuIG1vcmUgY29kZSBoZXJlCiAgICBpZiB7JGJ5cGFzc317CiAgICAgICAgcmV0dXJuCiAgICB9CiAgICAjIEluc2VydCBhbiBYRkYgaGVhZGVyIGlmIG9uZSBpcyBub3QgaW5zZXJ0ZWQgYWxyZWFkeSBzbyB0aGUgY2xpZW50IElQIGNhbiBiZSB0cmFja2VkIGZvciB0aGUgZHVwbGljYXRlZCB0cmFmZmljCiAgICBIVFRQOjpoZWFkZXIgaW5zZXJ0IFgtRm9yd2FyZGVkLUZvciBbSVA6OmNsaWVudF9hZGRyXQogICAgIyBDaGVjayBmb3IgUE9TVCByZXF1ZXN0cwogICAgaWYge1tIVFRQOjptZXRob2RdIGVxICJQT1NUIn17CiAgICAgICAgIyBDaGVjayBmb3IgQ29udGVudC1MZW5ndGggYmV0d2VlbiAxYiBhbmQgMU1iCiAgICAgICAgaWYgeyBbSFRUUDo6aGVhZGVyIENvbnRlbnQtTGVuZ3RoXSA+PSAxIGFuZCBbSFRUUDo6aGVhZGVyIENvbnRlbnQtTGVuZ3RoXSA8IDEwNDg1NzYgfXsKICAgICAgICAgICAgSFRUUDo6Y29sbGVjdCBbSFRUUDo6aGVhZGVyIENvbnRlbnQtTGVuZ3RoXQogICAgICAgIH0gZWxzZWlmIHtbSFRUUDo6aGVhZGVyIENvbnRlbnQtTGVuZ3RoXSA9PSAwfXsKICAgICAgICAgICAgIyBQT1NUIHdpdGggMCBjb250ZW50LWxlbmd0aCwgc28ganVzdCBzZW5kIHRoZSBoZWFkZXJzCiAgICAgICAgICAgIEhTTDo6c2VuZCAkaHNsICJbSFRUUDo6cmVxdWVzdF1cbiIKICAgICAgICAgICAgaWYgeyRzdGF0aWM6OmhzbF9kZWJ1Z317bG9nIGxvY2FsMC4gIltJUDo6Y2xpZW50X2FkZHJdOltUQ1A6OmNsaWVudF9wb3J0XTogU2VuZGluZyBbSFRUUDo6cmVxdWVzdF0ifQogICAgICAgIH0KICAgIH0gZWxzZSB7CiAgICAgICAgIyBSZXF1ZXN0IHdpdGggbm8gcGF5bG9hZCwgc28gc2VuZCBqdXN0IHRoZSBIVFRQIGhlYWRlcnMgdG8gdGhlIGNsb25lIHBvb2wKICAgICAgICBIU0w6OnNlbmQgJGhzbCAiW0hUVFA6OnJlcXVlc3RdXG4iCiAgICAgICAgaWYgeyRzdGF0aWM6OmhzbF9kZWJ1Z317bG9nIGxvY2FsMC4gIltJUDo6Y2xpZW50X2FkZHJdOltUQ1A6OmNsaWVudF9wb3J0XTogU2VuZGluZyBbSFRUUDo6cmVxdWVzdF0ifQogICAgfQp9Cgp3aGVuIEhUVFBfUkVRVUVTVF9EQVRBIHsKICAgICMgVGhlIHBhcnNlciBkb2VzIG5vdCBhbGxvdyBIVFRQOjpyZXF1ZXN0IGluIHRoaXMgZXZlbnQsIGJ1dCBpdCB3b3JrcwogICAgc2V0IHJlcXVlc3RfY21kICJIVFRQOjpyZXF1ZXN0IgogICAgaWYgeyRzdGF0aWM6OmhzbF9kZWJ1Z317bG9nIGxvY2FsMC4gIltJUDo6Y2xpZW50X2FkZHJdOltUQ1A6OmNsaWVudF9wb3J0XTogQ29sbGVjdGVkIFtIVFRQOjpwYXlsb2FkIGxlbmd0aF0gYnl0ZXMsXAogICAgICAgIHNlbmRpbmcgW2V4cHIge1tzdHJpbmcgbGVuZ3RoIFtldmFsICRyZXF1ZXN0X2NtZF1dICsgW0hUVFA6OnBheWxvYWQgbGVuZ3RoXX1dIGJ5dGVzIHRvdGFsIn0KICAgIEhTTDo6c2VuZCAkaHNsICJbZXZhbCAkcmVxdWVzdF9jbWRdW0hUVFA6OnBheWxvYWRdXG5mIgp9"
                    }
                },
                "telemetry_local": {
                    "remark": "Only required when TS is a local listener",
                    "class": "Service_TCP",
                    "virtualAddresses": [
                        "255.255.255.254"
                    ],
                    "virtualPort": 6514,
                    "iRules": [
                        "telemetry_local_rule"
                    ]
                },
                "telemetry_local_rule": {
                    "remark": "Required for TS local listener",
                    "class": "iRule",
                    "iRule": {
                        "base64": "d2hlbiBDTElFTlRfQUNDRVBURUQge25vZGUgMTI3LjAuMC4xIDY1MTR9"
                    }
                },
                "telemetry_local_pool": {
                    "class": "Pool",
                    "members": [
                        {
                            "enable": true,
                            "serverAddresses": [
                                "255.255.255.254"
                            ],
                            "servicePort": 6514
                        }
                    ],
                    "monitors": [
                        {
                            "bigip": "/Common/tcp"
                        }
                    ]
                },
                "telemetry_hsl": {
                    "class": "Log_Destination",
                    "type": "remote-high-speed-log",
                    "protocol": "tcp",
                    "pool": {
                        "use": "telemetry_local_pool"
                    }
                },
                "telemetry_formatted": {
                    "class": "Log_Destination",
                    "type": "splunk",
                    "forwardTo": {
                        "use": "telemetry_hsl"
                    }
                },
                "telemetry_publisher": {
                    "class": "Log_Publisher",
                    "destinations": [
                        {
                            "use": "telemetry_formatted"
                        }
                    ]
                },
                "telemetry_traffic_log_profile": {
                    "class": "Traffic_Log_Profile",
                    "requestSettings": {
                        "requestEnabled": true,
                        "requestProtocol": "mds-tcp",
                        "requestPool": {
                            "use": "telemetry_local_pool"
                        },
                        "requestTemplate": "event_source=\"request_logging\",hostname=\"$BIGIP_HOSTNAME\",bigip_blade_id=\"$BIGIP_BLADE_ID\",bigip_cached=\"$BIGIP_CACHED\",bigip_hostname=\"$BIGIP_HOSTNAME\",client_ip=\"$CLIENT_IP\",client_port=\"$CLIENT_PORT\",date_d=\"$DATE_D\",date_day=\"$DATE_DAY\",date_dd=\"$DATE_DD\",date_dy=\"$DATE_DY\",event_timestamp=\"$DATE_HTTP\",date_mm=\"$DATE_MM\",date_mon=\"$DATE_MON\",date_month=\"$DATE_MONTH\",date_ncsa=\"$DATE_NCSA\",date_yy=\"$DATE_YY\",date_yyyy=\"$DATE_YYYY\",http_class=\"$HTTP_CLASS\",http_keepalive=\"$HTTP_KEEPALIVE\",http_method=\"$HTTP_METHOD\",http_path=\"$HTTP_PATH\",http_query=\"$HTTP_QUERY\",http_request=\"$HTTP_REQUEST\",http_statcode=\"$HTTP_STATCODE\",http_status=\"$HTTP_STATUS\",http_uri=\"$HTTP_URI\",http_version=\"$HTTP_VERSION\",ncsa_combined=\"$NCSA_COMBINED\",ncsa_common=\"$NCSA_COMMON\",response_msecs=\"$RESPONSE_MSECS\",response_size=\"$RESPONSE_SIZE\",response_usecs=\"$RESPONSE_USECS\",server_ip=\"$SERVER_IP\",server_port=\"$SERVER_PORT\",snat_ip=\"$SNAT_IP\",snat_port=\"$SNAT_PORT\",time_ampm=\"$TIME_AMPM\",time_h12=\"$TIME_H12\",time_hrs=\"$TIME_HRS\",time_hh12=\"$TIME_HH12\",time_hms=\"$TIME_HMS\",time_hh24=\"$TIME_HH24\",time_mm=\"$TIME_MM\",time_msecs=\"$TIME_MSECS\",time_offset=\"$TIME_OFFSET\",time_ss=\"$TIME_SS\",time_unix=\"$TIME_UNIX\",time_usecs=\"$TIME_USECS\",time_zone=\"$TIME_ZONE\",virtual_ip=\"$VIRTUAL_IP\",virtual_name=\"$VIRTUAL_NAME\",virtual_pool_name=\"$VIRTUAL_POOL_NAME\",virtual_port=\"$VIRTUAL_PORT\",virtual_snatpool_name=\"$VIRTUAL_SNATPOOL_NAME\",wam_application_nam=\"$WAM_APPLICATION_NAM\",wam_x_wa_info=\"$WAM_X_WA_INFO\",null=\"$NULL\""
                    }
                },
                "telemetry_security_log_profile": {
                    "class": "Security_Log_Profile",
                    "application": {
                        "localStorage": false,
                        "remoteStorage": "splunk",
                        "protocol": "tcp",
                        "servers": [
                            {
                                "address": "255.255.255.254",
                                "port": "6514"
                            }
                        ],
                        "storageFilter": {
                            "requestType": "all"
                        }
                    }
                },
                "secLogRemote": {
                    "class": "Security_Log_Profile",
                    "application": {
                        "facility": "local3",
                        "storageFilter": {
                            "requestType": "illegal-including-staged-signatures",
                            "responseCodes": [
                                "404",
                                "201"
                            ],
                            "protocols": [
                                "http"
                            ],
                            "httpMethods": [
                                "PATCH",
                                "DELETE"
                            ],
                            "requestContains": {
                                "searchIn": "search-in-request",
                                "value": "The new value"
                            },
                            "loginResults": [
                                "login-result-unknown"
                            ]
                        },
                        "storageFormat": {
                            "fields": [
                                "attack_type",
                                "avr_id",
                                "headers",
                                "is_truncated"
                            ],
                            "delimiter": "."
                        },
                        "localStorage": false,
                        "maxEntryLength": "10k",
                        "protocol": "udp",
                        "remoteStorage": "remote",
                        "reportAnomaliesEnabled": true,
                        "servers": [
                            {
                                "address": "9.8.7.6",
                                "port": "9876"
                            }
                        ]
                    }
                },
                "GSLB_Monitor_HTTPS": {
                    "class": "GSLB_Monitor",
                    "monitorType": "https",
                    "send": "GET /",
                    "receive": "",
                    "ciphers": "DEFAULT:!EXPORT"
                },
                "GSLB_Monitor_HTTP": {
                    "class": "GSLB_Monitor",
                    "monitorType": "http",
                    "send": "GET /",
                    "receive": "",
                    "ciphers": "DEFAULT:!EXPORT"
                },
                "GSLB_Monitor_KIC": {
                    "class": "GSLB_Monitor",
                    "monitorType": "https",
                    "send": "GET /status HTTP/1.1\r\nHost: kubernetes.calalang.net\r\nConnection: Close\r\n",
                    "receive": "",
                    "ciphers": "DEFAULT:!EXPORT"
                },
                "GSLB_Data_Center_Azure": {
                    "class": "GSLB_Data_Center"
                },
                "calalang-azure-0": {
                    "class": "GSLB_Server",
                    "dataCenter": {
                        "use": "GSLB_Data_Center_Azure"
                    },
                    "devices": [
                        {
                            "address": "10.0.2.4"
                        }
                    ],
                    "monitors": [
                        {
                            "bigip": "/Common/bigip"
                        }
                    ],
                    "virtualServerDiscoveryMode": "enabled",
                    "exposeRouteDomainsEnabled": true
                },
                "generic-server-0": {
                    "class": "GSLB_Server",
                    "serverType": "generic-host",
                    "dataCenter": {
                        "use": "GSLB_Data_Center_Azure"
                    },
                    "devices": [
                        {
                            "address": "20.83.83.110"
                        }
                    ],
                    "monitors": [
                        {
                            "use": "GSLB_Monitor_KIC"
                        }
                    ],
                    "virtualServers": [
                        {
                            "address": "20.83.83.110",
                            "port": 443,
                            "monitors": [
                                {
                                    "use": "GSLB_Monitor_KIC"
                                }
                            ]
                        }
                    ]
                },
                "http-as3": {
                    "class": "Service_HTTP",
                    "remark": "F5XC Traffic Discovery Virtual",
                    "virtualAddresses": [
                        "255.255.255.254"
                    ],
                    "virtualPort": 9000,
                    "layer4": "tcp",
                    "policyEndpoint": "endpoint-f5-distributed-cloud-discovery",
                    "pool": {
                        "use": "pool-f5-distributed-cloud-discovery"
                    },
                    "profileTCP": "normal",
                    "profileHTTP": "basic",
                    "persistenceMethods": [
                        "cookie"
                    ]
                },
                "endpoint-f5-distributed-cloud-discovery": {
                    "class": "Endpoint_Policy",
                    "rules": [
                        {
                            "name": "forward_to_pool",
                            "conditions": [
                                {
                                    "type": "httpUri",
                                    "path": {
                                        "operand": "contains",
                                        "values": [
                                            "/"
                                        ]
                                    }
                                }
                            ],
                            "actions": [
                                {
                                    "type": "httpHeader",
                                    "event": "request",
                                    "replace": {
                                        "name": "Host",
                                        "value": "discovery.calalang.net"
                                    }
                                }
                            ]
                        }
                    ]
                },
                "pool-f5-distributed-cloud-discovery": {
                    "class": "Pool",
                    "monitors": [
                        "tcp"
                    ],
                    "members": [
                        {
                            "servicePort": 80,
                            "addressDiscovery": "fqdn",
                            "autoPopulate": true,
                            "hostname": "discovery.calalang.net"
                        }
                    ]
                },
                "clone-pool-f5-distributed-cloud-discovery": {
                    "class": "Pool",
                    "members": [
                        {
                            "serverAddresses": [
                                "255.255.255.254"
                            ],
                            "servicePort": 9000
                        }
                    ],
                    "monitors": [
                        "tcp"
                    ]
                }
            }
        }
    }
}