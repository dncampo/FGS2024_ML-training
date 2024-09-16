#!/bin/bash


# Context Broker configuration
CB_HOST=http://localhost:1026
CB_API_PATH=ngsi-ld/v1/entities/
FIWARE_SERVICE=health

# ENTITY MLModel --> Multiclass
# Function to create the MLModel Multiclass classifier entity
# This entity describes all the metadata of the trained model such as:
# Algorithm, dataset, data augmentation, precision, batch size, image dimensions, MLflow URI, experiment name, bucket name, region, paths to train, augment and test data, model name, model version... 
create_test_MLProcessing_entity() {
    echo "Creating MLProcessing_ entity..."
    curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
        -H 'Content-Type: application/ld+json' \
        -H 'Accept: application/ld+json' \
        -H "fiware-service: ${FIWARE_SERVICE}" \
        -d @- <<EOF
{
    "id": "urn:ngsi-ld:MLProcessing:test:003",
    "type": "MLProcessing",
    "refMLModel": {
        "type": "Relationship",
        "object": "urn:ngsi-ld:MLModel:SkinAnalyzer:multiclass"
    },
    "@context": [
        "https://raw.githubusercontent.com/smart-data-models/dataModel.MachineLearning/master/context.jsonld"
    ]
}
EOF
}


create_test_MLProcessing_entity