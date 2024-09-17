#!/bin/bash

# Context Broker configuration
CB_HOST="http://localhost:1026"
CB_API_PATH="v2/entities"
FIWARE_SERVICE="health"

# ENTITY MLModel --> Multiclass
# Function to create the MLModel Multiclass classifier entity
create_CNN_multiclass_model_entity() {
    echo "Creating MLModel entity..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:MLModel:SkinAnalyzer:multiclass",
    "type": "MLModel",
    "name": {
        "value": "SkinAnalyzer"
    },
    "description": {
        "value": "CNN Multiclass model for detecting melanoma and other skin anomalies in skin images"
    },
    "modelType": {
        "value": "CNN"
    },
    "baseModel": {
        "value": "ResNet50"
    },
    "refDataset": {
        "value": "Dataset:HAM10000"
    },
    "dataAugmentation": {
        "value": true
    },
    "precision": {
        "value": 0.84,
        "metadata": {
            "unitCode": {
                "value": "accuracy_score"
            }
        }
    },
    "batchSize": {
        "value": 32
    },
    "imageHeight": {
        "value": 90
    },
    "imageWidth": {
        "value": 120
    },
    "mlflowUri": {
        "value": "https://mlflow.lewagon.ai/"
    },
    "experimentName": {
        "value": "[dncampo] ResNet50 v1.0"
    },
    "bucketName": {
        "value": "ham10k-storage"
    },
    "region": {
        "value": "europe-west1"
    },
    "trainDataPath": {
        "value": "data/raw_data/HAM10000_metadata.csv"
    },
    "augmentDataPath": {
        "value": "data/raw_data/augment/mel/mel_augmented.csv"
    },
    "testDataPath": {
        "value": "data/raw_data/augment/mel/mel_test.csv"
    },
    "modelName": {
        "value": "ResNet50_multiclass_20220623_121940.h5"
    },
    "modelVersion": {
        "value": "v1"
    },
    "pythonVersion": {
        "value": "3.7"
    },
    "runtimeVersion": {
        "value": "2.7"
    }
}
EOF
}


# ENTITY MLModel --> Binary
# Function to create the MLModel Binary classifier entity
create_CNN_binary_model_entity() {
    echo "Creating MLModel entity..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:MLModel:SkinAnalyzer:binary",
    "type": "MLModel",
    "name": {
        "value": "SkinAnalyzer"
    },
    "description": {
        "value": "CNN Binary model for detecting melanoma in skin images"
    },
    "modelType": {
        "value": "CNN"
    },
    "baseModel": {
        "value": "ResNet50"
    },
    "refDataset": {
        "value": "Dataset:HAM10000"
    },
    "dataAugmentation": {
        "value": true
    },
    "precision": {
        "value": 0.96,
        "metadata": {
            "unitCode": {
                "value": "P1"
            }
        }
    },
    "batchSize": {
        "value": 32
    },
    "imageHeight": {
        "value": 90
    },
    "imageWidth": {
        "value": 120
    },
    "mlflowUri": {
        "value": "https://mlflow.lewagon.ai/"
    },
    "experimentName": {
        "value": "[dncampo] ResNet50 v1.0"
    },
    "bucketName": {
        "value": "ham10k-storage"
    },
    "region": {
        "value": "europe-west1"
    },
    "trainDataPath": {
        "value": "data/raw_data/HAM10000_metadata.csv"
    },
    "augmentDataPath": {
        "value": "data/raw_data/augment/mel/mel_augmented.csv"
    },
    "testDataPath": {
        "value": "data/raw_data/augment/mel/mel_test.csv"
    },
    "modelName": {
        "value": "ResNet50_finetuned_20220620_134553.h5"
    },
    "modelVersion": {
        "value": "v1"
    },
    "pythonVersion": {
        "value": "3.7"
    },
    "runtimeVersion": {
        "value": "2.7"
    }
}
EOF
}

create_CNN_multiclass_model_entity
create_CNN_binary_model_entity
