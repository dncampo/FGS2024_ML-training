#!/bin/bash

# Creates the entity that holds the dataset metadata used to train
# the MLModel entity.


# Context Broker configuration
CB_HOST="http://localhost:1026"
CB_API_PATH="/ngsi-ld/v1/entities/"
FIWARE_SERVICE="HealthSkinAnalyzer"


# Create JSON payload
read -r -d '' PAYLOAD << EOM
{
  "id": "urn:ngsi-ld:Dataset:HAM10000",
  "type": "Dataset",
  "@context": [
    "https://smart-data-models.github.io/dataModel.DCAT-AP/context.jsonld",
    "https://raw.githubusercontent.com/smart-data-models/dataModel.DCAT-AP/master/context.jsonld"
  ],
  "title": [
    "HAM10000 Dataset: Human Against Machine with 10000 training images"
  ],
  "contactPoint": [
    "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/DBW86T"
  ],
  "distribution": [
    "urn:ngsi-ld:Distribution:HAM10000:1"
  ],
  "keyword": [
    "dermatology",
    "skin lesions",
    "dermatoscopic images",
    "medical imaging",
    "machine learning",
    "artificial intelligence"
  ],
  "publisher": "ViDIR Group, Department of Dermatology, Medical University of Vienna",
  "spatial": [
    {
      "type": "Polygon",
      "coordinates": [
        [
          [16.3, 48.1],
          [16.5, 48.1],
          [16.5, 48.3],
          [16.3, 48.3],
          [16.3, 48.1]
        ]
      ]
    }
  ],
  "temporal": [
    "2018-01-01T00:00:00Z/2018-12-31T23:59:59Z"
  ],
  "theme": [
    "Health",
    "Science and technology"
  ],
  "accessRights": "https://creativecommons.org/licenses/by-nc/4.0/",
  "creator": [
    "Philipp Tschandl",
    "Cliff Rosendahl",
    "Harald Kittler"
  ],
  "page": [
    "https://arxiv.org/abs/1803.10417"
  ],
  "accrualPeriodicity": "irregular",
  "hasVersion": [],
  "identifier": [
    "doi:10.7910/DVN/DBW86T"
  ],
  "isReferencedBy": [
    "https://doi.org/10.1038/sdata.2018.161"
  ],
  "isVersionOf": [],
  "landingPage": [
    "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/DBW86T"
  ],
  "language": [
    "EN"
  ],
  "provenance": [
    "Collected from multiple sources including the Department of Dermatology at the Medical University of Vienna, the skin cancer practice of Cliff Rosendahl in Queensland, and the Melanoma Unit of the Hospital Clínic de Barcelona."
  ],
  "qualifiedAttribution": [
    "urn:ngsi-ld:Attribution:HAM10000:1"
  ],
  "qualifiedRelation": [
    "urn:ngsi-ld:Relation:HAM10000:1"
  ],
  "relatedResource": [
    "https://doi.org/10.1038/sdata.2018.161"
  ],
  "issued": "2018-07-01T00:00:00Z",
  "sample": [],
  "spatialResolutionInMeters": 0.0001,
  "temporalResolution": [
    "P1Y"
  ],
  "Type": "Dataset",
  "version": "1.0",
  "versionNotes": [
    "Initial release of the HAM10000 dataset"
  ],
  wasGeneratedBy": {
  "type": "Text",
  "value": "ViDIR Group research project"
  }
}
EOM

# Send request to Context Broker
response=$(curl -s -o /dev/null -w "%{http_code}" \
  "${CB_HOST}${CB_API_PATH}" \
  -H "Content-Type: application/json" \
  -H "fiware-service: ${FIWARE_SERVICE}" \
  -H "fiware-servicepath: ${FIWARE_SERVICEPATH}" \
  -d "${PAYLOAD}")

# Check response
if [ "$response" -eq 201 ]; then
  echo "Entity created successfully"
elif [ "$response" -eq 204 ]; then
  echo "Entity updated successfully"
else
  echo "Error: HTTP status code $response"
fi
