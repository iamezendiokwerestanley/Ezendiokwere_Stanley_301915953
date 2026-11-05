// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("ticket_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("ticket_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "entry",
                    "exit"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "validation_event"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "event_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("ticket_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "entry",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "validation_event",
            "key": {
                "event_id": 501
            },
            "snapshot": {
                "event_id": 501,
                "ticket_id": 401,
                "station_id": 101,
                "event_time": "2026-06-01T08:15:00Z",
                "event_type": "entry",
                "device_id": "gate-central-01"
            }
        },
        "embedded": {
            "station": [
                {
                    "key": {
                        "station_id": 101
                    },
                    "snapshot": {
                        "station_id": 101,
                        "station_name": "Central",
                        "zone": 1,
                        "opened_on": "2020-01-15"
                    },
                    "via": [
                        "validation_event.station_id → station"
                    ]
                }
            ]
        },
        "references": {
            "ticket": [
                {
                    "key": {
                        "ticket_id": 401
                    },
                    "via": [
                        "validation_event.ticket_id → ticket"
                    ]
                }
            ]
        },
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "exit",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "validation_event",
            "key": {
                "event_id": 501
            },
            "snapshot": {
                "event_id": 501,
                "ticket_id": 401,
                "station_id": 101,
                "event_time": "2026-06-01T08:15:00Z",
                "event_type": "entry",
                "device_id": "gate-central-01"
            }
        },
        "embedded": {
            "station": [
                {
                    "key": {
                        "station_id": 101
                    },
                    "snapshot": {
                        "station_id": 101,
                        "station_name": "Central",
                        "zone": 1,
                        "opened_on": "2020-01-15"
                    },
                    "via": [
                        "validation_event.station_id → station"
                    ]
                }
            ]
        },
        "references": {
            "ticket": [
                {
                    "key": {
                        "ticket_id": 401
                    },
                    "via": [
                        "validation_event.ticket_id → ticket"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "validation_event",
                    "key": {
                        "event_id": 501
                    },
                    "field": "device_id",
                    "value": "gate-central-01"
                }
            ],
            "examples": {
                "fare_adjustment": "illustrative fare_adjustment"
            }
        }
    }
]));
  await db.getCollection("ticket_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("ticket_events").find({"eventType":"entry"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("ticket_events").find({"source.key.event_id":501}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("ticket_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("ticket_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("ticket_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "entry",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "validation_event",
        "key": {
            "event_id": 501
        },
        "snapshot": {
            "event_id": 501,
            "ticket_id": 401,
            "station_id": 101,
            "event_time": "2026-06-01T08:15:00Z",
            "event_type": "entry",
            "device_id": "gate-central-01"
        }
    },
    "embedded": {
        "station": [
            {
                "key": {
                    "station_id": 101
                },
                "snapshot": {
                    "station_id": 101,
                    "station_name": "Central",
                    "zone": 1,
                    "opened_on": "2020-01-15"
                },
                "via": [
                    "validation_event.station_id → station"
                ]
            }
        ]
    },
    "references": {
        "ticket": [
            {
                "key": {
                    "ticket_id": 401
                },
                "via": [
                    "validation_event.ticket_id → ticket"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("ticket_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "entry",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "validation_event",
        "key": {
            "event_id": 501
        },
        "snapshot": {
            "event_id": 501,
            "ticket_id": 401,
            "station_id": 101,
            "event_time": "2026-06-01T08:15:00Z",
            "event_type": "entry",
            "device_id": "gate-central-01"
        }
    },
    "embedded": {
        "station": [
            {
                "key": {
                    "station_id": 101
                },
                "snapshot": {
                    "station_id": 101,
                    "station_name": "Central",
                    "zone": 1,
                    "opened_on": "2020-01-15"
                },
                "via": [
                    "validation_event.station_id → station"
                ]
            }
        ]
    },
    "references": {
        "ticket": [
            {
                "key": {
                    "ticket_id": 401
                },
                "via": [
                    "validation_event.ticket_id → ticket"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("ticket_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
