import streamlit as st
import requests
import json
from io import BytesIO

# Define the backend and NGSI-LD context broker URLs
BACKEND_URL = 'http://localhost:5905/cb-inference/'
NGSI_V2_BROKER_URL = 'http://localhost:1026/v2/entities'

# Function to query the NGSI-LD Context Broker for the inference result
def get_inference_result(entity_id):
    print("Entity id: ", entity_id)
    headers = {
        'fiware-service': 'health'
    }
    url = f"{NGSI_V2_BROKER_URL}/{entity_id}"
    print("URL: ", url)
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        print("--------------------------- response.status_code == 200")
        entity = response.json()
        return entity
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
            entity_id = result['id']

            # Optionally, wait for the NGSI-LD Context Broker to be updated
            st.write(f"Waiting for inference result of ID: '{entity_id}' from NGSI-V2 Context Broker...")

            # Poll the NGSI-LD Context Broker for the result
            entity_CB = None
            import time
            timeout = 6  # seconds
            poll_interval = 2  # seconds
            start_time = time.time()
            while (time.time() - start_time) < timeout:
                entity_CB = get_inference_result(entity_id)
                if entity_CB is not None:
                    break
                time.sleep(poll_interval)
            # Set initial font size
            initial_font_size = 28  # Starting font size for the first element
            decrement_value = 4  # Font size decrement for each subsequent element

            if entity_CB:
                prediction = entity_CB.get('results', {}).get('value', None).get('message', None).get('value', None)
                if len(prediction) == 1:
                    #melanoma detected
                    st.error(f"Prediction: Melanoma detected {float(prediction['Melanoma'])*100:.2f}%")
                else:
                    st.success(f"Prediction: NOT a Melanoma")
                    # Iterate over the dictionary, adjusting the font size
                for i, (key, value) in enumerate(prediction.items()):
                    # Calculate the font size based on iteration
                    font_size = max(initial_font_size - i * decrement_value, 12)  # Prevent font size from becoming too small
                    st.markdown(f"<p style='font-size:{font_size}px'>{key}: {float(value)*100:.2f}%</p>", unsafe_allow_html=True)
                
                st.info(f"Context Broker entity: '{entity_id}'")
                st.json(entity_CB, expanded=True)
    
                
            else:
                st.error("Inference result not available from the context broker.")
                st.info(f"I only have the result from the backend: {result}")
        else:
            st.error("Error sending image to backend.")
            print(response)
