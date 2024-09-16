import time
import json

def create_skin_analyzer_inference_entity(filename: str, results: dict) -> dict:
    # Generate timestamp in seconds since the EPOCH
    timestamp = int(time.time())
    
    # Construct the entity ID in the format: "urn:ngsi-ld:SkinAnalizerInference:YYYY:ZZZ"
    entity_id = f"urn:ngsi-ld:MLProcessing:{filename}:{timestamp}"
    
    # Create the NGSI-LD entity
    entity = {
        "id": entity_id,
        "type": "MLProcessing",
        "refMLModel": {
            "type": "Property",
            "value": "CNNSkinAnalyzer:multiclass"
        },
        "filename": {
            "type": "Property",
            "value": filename
        },
        "results": {
            "type": "Property",
            "value": results
        },
        "@context": [
            "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld",
            "https://raw.githubusercontent.com/smart-data-models/dataModel.MachineLearning/master/context.jsonld"
        ]
    }
    
    # Return the entity as a JSON object
    return entity


# # Example usage
# filename = "image123"
# results = {"melanoma": 0.85, "nevus": 0.10, "seborrheic keratosis": 0.05}
# entity = create_skin_analyzer_inference(filename, results)

# # Print the entity in JSON format
# print(json.dumps(entity, indent=2))
