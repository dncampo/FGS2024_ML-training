# Context Broker configuration
CB_HOST="http://localhost:1026"
CB_API_PATH="ngsi-ld/v1/entities/"
FIWARE_SERVICE="health"

curl -iX POST "${CB_HOST}/${CB_API_PATH}" \
    -H 'Content-Type: application/ld+json' \
    -H 'Accept: application/ld+json' \
    -H "fiware-service: ${FIWARE_SERVICE}" \
    -d @- <<EOF
{
  "id": "urn:ngsi-ld:Dataset:HAM10000",
  "type": "Dataset",
  "title": {
    "type": "Property",
    "value": "HAM10000 Dataset - Human Against Machine with 10000 training images"
  },
  "contactPoint": {
    "type": "Property",
    "value": "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/DBW86T"
  },
  "keyword": {
    "type": "Property",
    "value": [
      "dermatology",
      "skin lesions",
      "dermatoscopic images",
      "medical imaging",
      "machine learning",
      "artificial intelligence"
    ]
  },
  "publisher": {
    "type": "Property",
    "value": "ViDIR Group, Department of Dermatology, Medical University of Vienna"
  },
  "theme": {
    "type": "Property",
    "value": [
      "Health",
      "Science and technology"
    ]
  },
  "accessRights": {
    "type": "Property",
    "value": "https://creativecommons.org/licenses/by-nc/4.0/"
  },
  "creator": {
    "type": "Property",
    "value": [
      "Philipp Tschandl",
      "Cliff Rosendahl",
      "Harald Kittler"
    ]
  },
  "page": {
    "type": "Property",
    "value": [
      "https://arxiv.org/abs/1803.10417"
    ]
  },
  "accrualPeriodicity": {
    "type": "Property",
    "value": "irregular"
  },
  "identifier": {
    "type": "Property",
    "value": [
      "doi:10.7910/DVN/DBW86T"
    ]
  },
  "isReferencedBy": {
    "type": "Property",
    "value": [
      "https://doi.org/10.1038/sdata.2018.161"
    ]
  },
  "landingPage": {
    "type": "Property",
    "value": [
      "https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/DBW86T"
    ]
  },
  "language": {
    "type": "Property",
    "value": [
      "EN"
    ]
  },
  "provenance": {
    "type": "Property",
    "value": [
      "Collected from multiple sources including the Department of Dermatology at the Medical University of Vienna, the skin cancer practice of Cliff Rosendahl in Queensland, and the Melanoma Unit of the Hospital Clínic de Barcelona."
    ]
  },
  "relatedResource": {
    "type": "Property",
    "value": [
      "https://doi.org/10.1038/sdata.2018.161"
    ]
  },
  "issued": {
    "type": "Property",
    "value": "2018-07-01T00:00:00Z"
  },
  "spatialResolutionInMeters": {
    "type": "Property",
    "value": 0.0001
  },
  "temporalResolution": {
    "type": "Property",
    "value": [
      "P1Y"
    ]
  },
  "version": {
    "type": "Property",
    "value": "1.0"
  },
  "versionNotes": {
    "type": "Property",
    "value": [
      "Initial release of the HAM10000 dataset"
    ]
  },
  "wasGeneratedBy": {
    "type": "Property",
    "value": "ViDIR Group research project"
  },
  "@context": [
    "https://raw.githubusercontent.com/smart-data-models/dataModel.DCAT-AP/master/context.jsonld"
  ]
}
EOF
