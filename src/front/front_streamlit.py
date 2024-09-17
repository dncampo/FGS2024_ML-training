import streamlit as st
import requests
import json
from io import BytesIO

# Define the backend and NGSI-LD context broker URLs
BACKEND_URL = 'http://localhost:5905/cb-inference/'
NGSI_LD_BROKER_URL = 'http://localhost:1026/ngsi-ld/v1/entities'

# Function to query the NGSI-LD Context Broker for the inference result
def get_inference_result(entity_id):
    headers = {
        'Accept': 'application/ld+json',
        'Content-Type': 'application/ld+json',
        'fiware-service': 'health'
    }
    response = requests.get(f"{NGSI_LD_BROKER_URL}/{entity_id}", headers=headers)
    if response.status_code == 200:
        entity = response.json()
        prediction = entity.get('prediction', {}).get('value', None)
        return prediction
    else:
        st.error("Error fetching inference result from NGSI-LD Context Broker.")
        return None

# Streamlit app UI
st.title('Image Evaluation App')

uploaded_file = st.file_uploader("Choose an image...", type=['png', 'jpg', 'jpeg'])

if uploaded_file is not None:
    # Display the uploaded image
    st.image(uploaded_file, caption='Uploaded Image', use_column_width=True)

    if st.button('Evaluate Image'):
        # Send the image to the backend for evaluation
        #files = {'image': uploaded_file.getvalue()}
        print(uploaded_file.name)
        files = "holaaaa"
        response = requests.post(BACKEND_URL, json={'filename': uploaded_file.name})

        if response.ok:
            result = response.json()[1] #response.json()
            
            print("Result from backend:")
            print(result)
            print("===============")
            entity_id = result.get('id')

            # Optionally, wait for the NGSI-LD Context Broker to be updated
            st.write(f"Waiting for inference result of ID: {entity_id} from NGSI-LD Context Broker...")

            # Poll the NGSI-LD Context Broker for the result
            prediction = None
            import time
            timeout = 6  # seconds
            poll_interval = 2  # seconds
            start_time = time.time()
            while (time.time() - start_time) < timeout:
                prediction = get_inference_result(id)
                if prediction is not None:
                    break
                time.sleep(poll_interval)

            if prediction:
                st.success(f"Inference Result: {prediction}")
            else:
                st.error("Inference result not available from the context broker.")
                st.info(f"I only have the result from the backend: {result}")
        else:
            st.error("Error sending image to backend.")
            print(response)
