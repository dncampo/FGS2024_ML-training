import time
import json

def create_skin_analyzer_inference_entity(filename: str, results: dict, model_type: str) -> dict:
    # Generate timestamp in seconds since the EPOCH
    timestamp = int(time.time())
    model_type_entity = f"urn:ngsi-ld:MLModel:SkinAnalyzer:{model_type}"
    
    # Construct the entity ID in the format: "urn:ngsi-ld:SkinAnalizerInference:YYYY:ZZZ"
    entity_id = f"urn:ngsi-ld:MLProcessing:{filename}:{timestamp}"
    
    # If the results contain a "message" field with a JSON string, load it as a dictionary
    if "message" in results and isinstance(results["message"], str):
        try:
            # Convert the "message" field from a JSON string to a dictionary
            results["message"] = json.loads(results["message"])
        except json.JSONDecodeError:
            # If the message is not valid JSON, leave it as a string
            pass

    # Create the NGSI v2 entity
    entity = {
        "id": entity_id,
        "type": "MLProcessing",
        "refMLModel": {
            "value": model_type_entity
        },
        "filename": {
            "value": filename
        },
        "results": {
            "value": results
        }
    }
    
    # Return the entity as a JSON object
    print(":.......********* {entity} *********.......:")
    return entity


# # Example usage
# filename = "image123"
# results = {"melanoma": 0.85, "nevus": 0.10, "seborrheic keratosis": 0.05}
# entity = create_skin_analyzer_inference(filename, results)

# # Print the entity in JSON format
# print(json.dumps(entity, indent=2))
