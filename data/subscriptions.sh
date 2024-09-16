#!/bin/bash

# Context Broker configuration
CB_HOST="http://localhost:1026"
CB_API_PATH="ngsi-ld/v1/subscriptions/"
FIWARE_SERVICE="health"

# Function to create the subscription
create_subscription_Ping() {
    echo "Creating subscription for Ping test types..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:Subscription:Ping",
    "type": "Subscription",
    "description": "Subscription for Ping Test Messages",
    "entities": [
        {
            "type": "Ping"
        }
    ],
    "notification": {
        "endpoint": {
            "uri": "http://localhost:5905/ping/",
            "accept": "application/json"
        },
        "format": "normalized",
        "attributes": ["*"]
    },
    "@context": [
        "https://raw.githubusercontent.com/smart-data-models/dataModel.MachineLearning/master/context.jsonld"
    ]
}
EOF
}



# SUBSCRIPTION MLModel
# Function to create the subscription to MLModel entities
create_subscription_MLModel() {
    echo "Creating subscription for MLModel types..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:SubscriptionQuery:MLModel",
    "type": "Subscription",
    "description": "Subscription for MLModel entities",
    "entities": [
        {
            "type": "MLModel"
        }
    ],
    "notification": {
        "endpoint": {
            "uri": "http://fiware-cygnus:5050/notify",
            "accept": "application/ld+json"
        },
        "format": "normalized",
        "attributes": ["*"]
    },
    "@context": [
        "https://raw.githubusercontent.com/smart-data-models/dataModel.MachineLearning/master/context.jsonld"
    ]
}
EOF
}



# SUBSCRIPTION MLProcessing
# Function to create the subscription to MLProcessing entities
create_subscription_MLProcessing() {
    echo "Creating subscription for MLProcessing types..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:SubscriptionQuery:MLProcessing",
    "type": "Subscription",
    "description": "Subscription for MLProcessing entities",
    "entities": [
        {
            "type": "MLProcessing"
        }
    ],
    "notification": {
        "endpoint": {
            "uri": "http://fiware-cygnus:5050/notify",
            "accept": "application/ld+json"
        },
        "format": "normalized",
        "attributes": ["*"]
    },
        "@context": [
            "https://raw.githubusercontent.com/smart-data-models/dataModel.MachineLearning/master/context.jsonld"
        ]
}
EOF
}

create_subscription_Ping
create_subscription_MLModel
create_subscription_MLProcessing
