#!/bin/bash

# Context Broker configuration
CB_HOST="http://localhost:1026"
CB_API_PATH="v2/subscriptions"
FIWARE_SERVICE="health"

# Function to create the subscription for Ping test types
create_subscription_Ping() {
    echo "Creating subscription for Ping test types..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -H 'fiware-servicepath: /' \
        -d @- <<EOF
{
    "description": "Subscription for Ping Test Messages",
    "subject": {
        "entities": [
            {
                "idPattern": ".*",
                "type": "Ping"
            }
        ]
    },
    "notification": {
        "http": {
            "url": "http://fiware-draco:5050/v2/notify"
        },
        "attrs": ["*"]
    }
}
EOF
}

# Function to create the subscription for MLModel entities
create_subscription_MLModel() {
    echo "Creating subscription for MLModel types..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -d @- <<EOF
{
    "description": "Subscription for MLModel entities",
    "subject": {
        "entities": [
            {
                "idPattern": ".*",
                "type": "MLModel"
            }
        ]
    },
    "notification": {
        "http": {
            "url": "http://fiware-draco:5050/v2/notify"
        },
        "attrs": ["*"]
    }
}
EOF
}

# Function to create the subscription for MLProcessing entities
create_subscription_MLProcessing() {
    echo "Creating subscription for MLProcessing types..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -d @- <<EOF
{
    "description": "Subscription for MLProcessing entities",
    "subject": {
        "entities": [
            {
                "idPattern": ".*",
                "type": "MLProcessing"
            }
        ]
    },
    "notification": {
        "http": {
            "url": "http://fiware-draco:5050/v2/notify"
        },
        "attrs": ["*"]
    },
    "throttling": 5
}
EOF
}

create_subscription_Ping
create_subscription_MLModel
create_subscription_MLProcessing
