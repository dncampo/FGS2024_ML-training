#!/bin/bash

# Context Broker configuration
CB_HOST="http://localhost:1026"
CB_API_PATH="/ngsi-ld/v1/subscriptions/"
FIWARE_SERVICE="HealthSkinAnalyzer


# SUBSCRIPTION Ping --> TEST
# Function to create the subscription
create_subscription_Ping() {
    echo "Creating subscription for Ping test types..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H 'fiware-service: ${FIWARE_SERVICE}' \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:Subscription:Ping:002",
    "type": "Subscription",
    "description": "Subscription for Ping Test Messages",
    "entities": [
        {
            "type": "Ping"
        }
    ],
    "notification": {
        "endpoint": {
            "uri": "http://localhost:6001/ping",
            "accept": "application/json"
        },
        "format": "normalized",
        "attributes": ["*"]
    },
    "@context": [
        "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld"
    ]
}
EOF
}



# SUBSCRIPTION MLModel
# Function to create the subscription to MLModel entities
create_subscription_MLModel() {
    echo "Creating subscription for MLModel types..."
    curl -iX POST "${CB_URL}/ngsi-ld/v1/subscriptions/" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H 'fiware-service: HealthSkinAnalyzer' \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:SubscriptionQuery:MLModel:002",
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
            "accept": "application/json"
        },
        "format": "normalized",
        "attributes": ["*"]
    },
    "@context": [
        "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld"
    ]
}
EOF
}



# SUBSCRIPTION MLProcessing
# Function to create the subscription to MLProcessing entities
create_subscription_MLProcessing() {
    echo "Creating subscription for MLProcessing types..."
    curl -iX POST "${CB_URL}/ngsi-ld/v1/subscriptions/" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H 'fiware-service: HealthSkinAnalyzer' \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:SubscriptionQuery:MLProcessing:002",
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
            "accept": "application/json"
        },
        "format": "normalized",
        "attributes": ["*"]
    },
    "@context": [
        "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld"
    ]
}
EOF
}
