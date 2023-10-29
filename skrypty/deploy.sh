#!/bin/bash

handle_error() {
    echo "Błąd: $1"
    exit 1
}

git submodule update --init --recursive || handle_error "Nie udało się zaktualizować podmodułów"

cd chatbot-ui || handle_error "Nie udało się wejść do katalogu chatbot-ui"
git checkout projekt-markus || handle_error "Nie udało się przełączyć na gałąź projekt-markus"
docker build -t chatgpt-ui . || handle_error "Nie udało się zbudować obrazu dockerowego dla chatgpt-ui"
cd ..

cd LocalAI || handle_error "Nie udało się wejść do katalogu LocalAI"
git checkout projekt-markus || handle_error "Nie udało się przełączyć na gałąź projekt-markus"

curl -L "https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/resolve/main/llama-2-13b-chat.Q5_K_M.gguf" -o ./models/llama-2-13b-chat.Q5_K_M.gguf || handle_error "Nie udało się pobrać llama-2-13b-chat model"
curl -L "https://huggingface.co/TheBloke/Luna-AI-Llama2-Uncensored-GGUF/resolve/main/luna-ai-llama2-uncensored.Q4_K_M.gguf" -o ./models/luna-ai-llama2-uncensored.Q4_K_M.gguf || handle_error "Nie udało się pobrać luna-ai-llama2-uncensored model"
curl -L "https://huggingface.co/ggerganov/whisper.cpp/blob/main/ggml-large-q5_0.bin" -o ./models/whisper-large-q5.bin || handle_error "Nie udało się pobrać whisper-large-q5 model"

docker-compose up -d --pull always || handle_error "Nie udało się uruchomić docker-compose"

echo "Operacje zakończone pomyślnie!"