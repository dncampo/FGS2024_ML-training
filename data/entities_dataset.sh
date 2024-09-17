curl -iX POST "http://localhost:1026/v2/entities" \
-H 'Content-Type: application/json' \
-H "fiware-service: health" \
-d @- <<EOF
{
  "id": "urn:ngsi-ld:Dataset:HAM10000",
  "type": "Dataset",
  "title": {
    "value": "HAM10000 Dataset - Human Against Machine with 10000 training images"
  },
  "contactPoint": {
    "value": "https://dataverse.harvard.edu/dataset.xhtml?persistentId%3Ddoi:10.7910/DVN/DBW86T"
  },
  "keyword": {
    "value": "dermatology, skin lesions, dermatoscopic images, medical imaging, machine learning, artificial intelligence"
  },
  "publisher": {
    "value": "ViDIR Group, Department of Dermatology, Medical University of Vienna"
  },
  "theme": {
    "value": "Health, Science and technology"
  },
  "accessRights": {
    "value": "https://creativecommons.org/licenses/by-nc/4.0/"
  },
  "creator": {
    "value": "Philipp Tschandl, Cliff Rosendahl, Harald Kittler"
  },
  "page": {
    "value": "https://arxiv.org/abs/1803.10417"
  },
  "accrualPeriodicity": {
    "value": "irregular"
  },
  "identifier": {
    "value": "doi:10.7910/DVN/DBW86T"
  },
  "isReferencedBy": {
    "value": "https://doi.org/10.1038/sdata.2018.161"
  },
  "landingPage": {
    "value": "https://dataverse.harvard.edu/dataset.xhtml?persistentId%3Ddoi:10.7910/DVN/DBW86T"
  },
  "language": {
    "value": "EN"
  },
  "provenance": {
    "value": "Collected from multiple sources including the Department of Dermatology at the Medical University of Vienna, the skin cancer practice of Cliff Rosendahl in Queensland, and the Melanoma Unit of the Hospital Clínic de Barcelona."
  },
  "relatedResource": {
    "value": "https://doi.org/10.1038/sdata.2018.161"
  },
  "issued": {
    "value": "2018-07-01T00:00:00Z"
  },
  "spatialResolutionInMeters": {
    "value": 0.0001
  },
  "temporalResolution": {
    "value": "P1Y"
  },
  "version": {
    "value": "1.0"
  },
  "versionNotes": {
    "value": "Initial release of the HAM10000 dataset"
  },
  "wasGeneratedBy": {
    "value": "ViDIR Group research project"
  }
}
EOF
