#!/bin/bash


# Context Broker configuration
CB_HOST="http://localhost:1026"
CB_API_PATH="/ngsi-ld/v1/entities/"
FIWARE_SERVICE="HealthSkinAnalyzer

# ENTITY MLModel --> Multiclass
# Function to create the MLModel Multiclass classifier entity
# This entity describes all the metadata of the trained model such as:
# Algorithm, dataset, data augmentation, precision, batch size, image dimensions, MLflow URI, experiment name, bucket name, region, paths to train, augment and test data, model name, model version... 
create_CNN_multiclass_model_entity() {
    echo "Creating MLModel entity..."
    curl -iX POST "${CB_URL}/${CB_API_PATH}" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H 'fiware-service: ${FIWARE_SERVICE}' \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:MLModel:CNNSkinAnalyzer:multiclass:001",
    "type": "MLModel",
    "name": {
        "type": "Property",
        "value": "CNNSkinAnalyzer Multiclass"
    },
    "description": {
        "type": "Property",
        "value": "CNN Multiclass model for detecting melanoma and other skin anomalies in skin images"
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
        "type": "Relationship",
        "object": "urn:ngsi-ld:Distribution:HAM10000:1"
    },
    "dataAugmentation": {
        "type": "Property",
        "value": true
    },
    "precision": {
        "type": "Property",
        "value": 0.84,
        "unitCode": "accuracy_score"
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
        "value": "[dncampo] ResNet50 v1.0"
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
        "value": "ResNet50_multiclass_20220623_121940.h5"
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
        "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld",
        "https://raw.githubusercontent.com/smart-data-models/dataModel.MachineLearning/master/context.jsonld"
    ]
}
EOF
}



# ENTITY MLModel --> Binary
# Function to create the MLModel Binary classifier entity
# This entity describes all the metadata of the trained model such as:
# Algorithm, dataset, data augmentation, precision, batch size, image dimensions, MLflow URI, experiment name, bucket name, region, paths to train, augment and test data, model name, model version... 
create_CNN_binary_model_entity() {
    echo "Creating MLModel entity..."
    curl -iX POST "${CB_URL}/ngsi-ld/v1/entities/" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H 'fiware-service: HealthSkinAnalyzer' \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:MLModel:CNNSkinAnalyzer:binary:001",
    "type": "MLModel",
    "name": {
        "type": "Property",
        "value": "CNNSkinAnalyzer Binary"
    },
    "description": {
        "type": "Property",
        "value": "CNN Binary model for detecting melanoma in skin images"
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
        "type": "Relationship",
        "object": "urn:ngsi-ld:Distribution:HAM10000:1"
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
        "value": "[dncampo] ResNet50 v1.0"
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
        "value": "ResNet50_finetuned_20220620_134553.h5"
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
        "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld",
        "https://raw.githubusercontent.com/smart-data-models/dataModel.MachineLearning/master/context.jsonld"
    ]
}
EOF
}