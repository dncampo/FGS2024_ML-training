import json
import requests


def send_entity_to_context_broker(entity: dict, context_broker_url = "http://orion:1026"):
    # Set the headers for the NGSI-LD API
    headers = {
        'Accept': 'application/ld+json', 
        'Content-Type': 'application/ld+json', 
        'fiware-service': 'HealthSkinAnalyzer' 
    }
    
    # Send the entity to the context broker
    try:
        response = requests.post(f'{context_broker_url}/ngsi-ld/v1/entities/', 
                                 data=json.dumps(entity), 
                                 headers=headers)
        
        # Check if the request was successful
        if response.status_code == 201:
            print("Entity created successfully.")
        else:
            # Handle different HTTP errors
            print(f"Failed to create entity. Status code: {response.status_code}")
            print(f"Error response: {response.text}")
    
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
        
        return response
