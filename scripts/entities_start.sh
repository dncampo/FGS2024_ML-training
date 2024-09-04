#!/bin/bash

# Set the Context Broker URL
CB_URL="http://localhost:1026"  # Replace with your actual Context Broker URL

# Function to create the MLModel entity
create_ml_model_entity() {
    echo "Creating MLModel entity..."
    curl -iX POST "${CB_URL}/ngsi-ld/v1/entities/" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H 'fiware-service: HealthSkinAnalyzer' \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:MLModel:CNNSkinAnalyzer:multiclass:001",
    "type": "MLModel",
    "name": {
        "type": "Property",
        "value": "CNNSkinAnalyzer"
    },
    "description": {
        "type": "Property",
        "value": "CNN model for detecting melanoma in skin images"
    },
    "modelType": {
        "type": "Property",
        "value": "CNN"
    },
    "baseModel": {
        "type": "Property",
        "value": "ResNet50"
    },
    "dataset": {
        "type": "Property",
        "value": "HAM10000"
    },
    "dataAugmentation": {
        "type": "Property",
        "value": true
    },
    "precision": {
        "type": "Property",
        "value": 0.96,
        "unitCode": "P1"
    },
    "batchSize": {
        "type": "Property",
        "value": 32
    },
    "imageHeight": {
        "type": "Property",
        "value": 90
    },
    "imageWidth": {
        "type": "Property",
        "value": 120
    },
    "mlflowUri": {
        "type": "Property",
        "value": "https://mlflow.lewagon.ai/"
    },
    "experimentName": {
        "type": "Property",
        "value": "[FR] [Nice] [abdielrt,dncampo] Computer Vision v1.0"
    },
    "bucketName": {
        "type": "Property",
        "value": "ham10k-storage"
    },
    "region": {
        "type": "Property",
        "value": "europe-west1"
    },
    "trainDataPath": {
        "type": "Property",
        "value": "data/raw_data/HAM10000_metadata.csv"
    },
    "augmentDataPath": {
        "type": "Property",
        "value": "data/raw_data/augment/mel/mel_augmented.csv"
    },
    "testDataPath": {
        "type": "Property",
        "value": "data/raw_data/augment/mel/mel_test.csv"
    },
    "modelName": {
        "type": "Property",
        "value": "ResNet50_multiclass"
    },
    "modelVersion": {
        "type": "Property",
        "value": "v1"
    },
    "pythonVersion": {
        "type": "Property",
        "value": "3.7"
    },
    "runtimeVersion": {
        "type": "Property",
        "value": "2.7"
    },
    "@context": [
        "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld"
    ]
}
EOF
}

# Function to create the subscription
create_subscription() {
    echo "Creating subscription for MLProcessing types..."
    curl -iX POST "${CB_URL}/ngsi-ld/v1/subscriptions/" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H 'fiware-service: HealthSkinAnalyzer' \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:Subscription:MLProcessing001",
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

# Main execution
echo "Starting entity and subscription creation..."

create_ml_model_entity
create_subscription

echo "Entity and subscription creation completed."
