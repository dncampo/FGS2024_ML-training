import streamlit as st
import requests
from PIL import Image
import io


def create_entity(image):
    import requests
import json
from datetime import datetime

def create_and_send_ml_observation(cb_url, model_name, model_version, accuracy, dataset_id):
    # Prepare the NGSI-LD entity
    entity = {
        "id": "urn:ngsi-ld:MLProcessing:001",
        "type": "MLProcessing",
        "refMLModel": "urn:ngsi-ld:MLModel:CNNSkinAnalyzer:multiclass:001",
        "modelName": {
            "type": "Property",
            "value": model_name
        },
        "modelVersion": {
            "type": "Property",
            "value": model_version
        },
        "accuracy": {
            "type": "Property",
            "value": accuracy,
            "unitCode": "P1"
        },
        "inferredDate": {
            "type": "Property",
            "value": {
                "@type": "DateTime",
                "@value": datetime.utcnow().isoformat() + "Z"
            }
        },
        "dataset": {
            "type": "Relationship",
            "object": f"urn:ngsi-ld:Dataset:{dataset_id}"
        },
        "@context": [
            "https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context.jsonld"
        ]
    }

    # Prepare the headers for the HTTP request
    headers = {
        "Content-Type": "application/ld+json",
        "Accept": "application/ld+json",
        "fiware-service": "HealthSkinAnalyzer",
    }

    # Send the POST request to create the entity
    response = requests.post(f"{cb_url}/ngsi-ld/v1/entities/", 
                             data=json.dumps(entity),
                             headers=headers)

    # Check the response
    if response.status_code >= 200:
        print("Entity created successfully")
        return response
    else:
        print(f"Failed to create entity. Status code: {response.status_code}")
        print(f"Response: {response.text}")
        response.raise_for_status()  # Raises an HTTPError for bad responses
        return False
    
    

def send_image_to_server(image):
    # Convert the file to bytes
    img_byte_arr = io.BytesIO()
    image.save(img_byte_arr, format='PNG')
    img_byte_arr = img_byte_arr.getvalue()

    try:
        cb_url = "http://127.0.0.1:1026"  # Replace with your Orion-LD Context Broker URL
        model_name = "CNN "
        model_version = "1.0.0"
        accuracy = 0.94
        dataset_id = "HAM10000"
        response = create_and_send_ml_observation(cb_url, model_name, model_version, accuracy, dataset_id)

        if response:
            print(response.json())

        # Send the image to the server
        # Replace 'http://your-server-url/analyze' with your actual server URL
        #response = requests.post('http://127.0.0.1:1026/ngsi-ld/v1/entities', files={'image': img_byte_arr}, timeout=10)
        #response = requests.get('http://127.0.0.1:1026/version', timeout=0.01)
        #return response.json()
    except requests.exceptions.RequestException as e:
        st.error(f"Error: Unable to connect to the server. {str(e)}")
        return None

# Set the title of the web app
st.title("Photo Upload and Analysis")

# Create a file uploader widget
uploaded_file = st.file_uploader("Choose a photo...", type=["jpg", "jpeg", "png"])



if uploaded_file is not None:
    # Display the uploaded image
    print("image path: ", uploaded_file)
    image = Image.open(uploaded_file)
    st.image(image, caption="Uploaded Image", use_column_width=True)
    
    # Create a button to trigger the analysis
    if st.button("Analyze Photo"):
        with st.spinner("Analyzing..."):
            result = send_image_to_server(image)
        
        if result:
            st.subheader("Analysis Result:")
            st.write(result)
        else:
            retry_button = st.button("Retry Analysis")
            if retry_button:
                with st.spinner("Retrying analysis..."):
                    result = send_image_to_server(image)
                if result:
                    st.subheader("Analysis Result:")
                    st.write(result)
                else:
                    st.error("Error: Unable to get response from the server after retry. Please check your connection and try again later.")
else:
    st.write("Please upload an image to analyze.")