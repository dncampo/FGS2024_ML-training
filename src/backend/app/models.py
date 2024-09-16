import numpy as np
import tensorflow.keras.models as tfkm


def load_models():
    print("loading models: ")
    model_bin_96 = tfkm.load_model('/ml-models/ResNet50_finetuned_20220620_134553.h5')
    print("Binary model loaded.")
    model_cat_84 = tfkm.load_model('/ml-models/ResNet50_multiclass_20220623_121940.h5')
    print("Categorical model loaded.")

    return model_bin_96, model_cat_84
