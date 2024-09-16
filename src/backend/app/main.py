import os
from typing import List, Dict
from datetime import datetime
import json
from PIL import Image
import numpy as np
import tensorflow.keras.models as tfkm

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn

from app.models import load_models
from app.entity import create_skin_analyzer_inference_entity
from app.send import send_entity_to_context_broker
from app.helper import get_n_highest_clases


class FilenameModel(BaseModel):
    filename: str

class Inference(BaseModel):
    model_id: str
    prediction: float
    features: Dict[str, float]
    
class Ping(BaseModel):
    message: str
    
    
app = FastAPI()

# In-memory storage for inferences
inferences = []

# Just load the models once and forever
model_binary, model_categorical = load_models()
print("-----> Models loaded <-----")


@app.post("/ping/")
async def receive_ping(ping: Ping):
    ping_with_timestamp = {
        "timestamp": datetime.now().isoformat(),
        **ping.dict()
    }
    return {
            "status": "ping received - thank you!", 
            "message": json.dumps(ping_with_timestamp)
        }


@app.post("/inference/")
async def receive_inference(inference: Inference):
    inference_with_timestamp = {
        "timestamp": datetime.now().isoformat(),
        **inference.dict()
    }
    inferences.append(inference_with_timestamp)
    return {"status": "success", "message": "Inference received - thank you!"}


@app.post("/cb-inference/")
async def receive_cb_inference(inference: FilenameModel):
    inference_with_timestamp = {
        "timestamp": datetime.now().isoformat(),
        **inference.dict()
    }
    inferences.append(inference_with_timestamp)
    print(f"Received observation: {inference_with_timestamp}")
    print(f"Filenale received: {inference_with_timestamp['filename']}")
    
    
    # load image
    os_path = os.path.join("/data-test", inference_with_timestamp['filename'])
    image = Image.open(os_path)
    image = image.resize((120,90))
    image_np = np.array(image)
    image_np = np.expand_dims(image_np, 0)
    # call binary model
    binary_result = model_binary.predict(image_np)[0]
    
    to_return = {
        "entity_id": ""
    }
    bin_res = {
        "result": "binary", 
        "value": {
            "Melanoma": str(binary_result[0])
        }
    }
    if binary_result >= 0.60:
        # inform results from binary model, melanoma detected
        to_return = {"status": "success", "message": json.dumps(bin_res)}

    else:
        # call categorical model
        categorical_result = model_categorical.predict(image_np)[0]
        result_cat = {
            'Actinic Keratoses / Intrapithelial Carcinoma': categorical_result[0],
            'Basal Cell Carcinoma ': categorical_result[1],
            'Benign Keratosis ': categorical_result[2],
            'Dermatofibroma ': categorical_result[3],
            'Melanoma ': categorical_result[4],
            'Melanocytic Nevi ': categorical_result[5],
            'Vascula skin lesion ': categorical_result[6]
        }
        n_highest = get_n_highest_clases(result=result_cat, n=7)
        n_highest_values = [str(result_cat.get(key)) for key in n_highest]
        n_highest_zip = zip(n_highest, n_highest_values)
        result_cat_sorted = {}
        for i in range(7):
            result_cat_sorted[n_highest[i].strip()] = str(n_highest_values[i])

        print(f"highest keys are: {n_highest}")
        print(f"highest values are: {n_highest_values}")
        print(f"highest values are zip: {n_highest_zip}")
        # inform results from categorical model
        to_return = {
            "status": "success", 
            "message": json.dumps({
                "result": "categorical", 
                "value": result_cat_sorted
                })
            }

    # create entity to send to context broker
    entity_to_CB = create_skin_analyzer_inference_entity(inference_with_timestamp['filename'], to_return)
    response_CB = send_entity_to_context_broker(entity_to_CB)
    return to_return, entity_to_CB, response_CB


@app.get("/inferences/")
async def get_inferences():
    return inferences

@app.get("/")
async def root():
    return {"message": "Welcome to the ML Inference API"}

@app.get("/health")
async def health():
    return {"status": "ok"}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5905)
    