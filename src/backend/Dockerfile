FROM python:3.8-slim-bullseye

WORKDIR /backend
COPY ./src/backend/requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt
COPY ./src/backend/app /backend/app

VOLUME ["/ml-models", "/data-test"]

EXPOSE 5905

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "5905" , "--reload"]