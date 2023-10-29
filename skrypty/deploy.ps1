function handle_error {
    param ($msg)
    Write-Output ("Błąd: " + $msg)
    exit 1
}

git submodule update --init --recursive
if ($LASTEXITCODE -ne 0) { handle_error "Nie udało się zaktualizować podmodułów" }

Set-Location chatbot-ui -ErrorAction SilentlyContinue
if ($? -eq $false) { handle_error "Nie udało się wejść do katalogu chatbot-ui" }
git checkout projekt-markus
if ($LASTEXITCODE -ne 0) { handle_error "Nie udało się przełączyć na gałąź projekt-markus" }
docker build -t chatgpt-ui .
if ($LASTEXITCODE -ne 0) { handle_error "Nie udało się zbudować obrazu dockerowego dla chatgpt-ui" }
Set-Location ..

Set-Location LocalAI -ErrorAction SilentlyContinue
if ($? -eq $false) { handle_error "Nie udało się wejść do katalogu LocalAI" }
git checkout projekt-markus
if ($LASTEXITCODE -ne 0) { handle_error "Nie udało się przełączyć na gałąź projekt-markus" }

Invoke-WebRequest -Uri "https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF/resolve/main/llama-2-13b-chat.Q5_K_M.gguf" -OutFile "./models/llama-2-13b-chat.Q5_K_M.gguf"
if ($LASTEXITCODE -ne 0) { handle_error "Nie udało się pobrać llama-2-13b-chat model" }

Invoke-WebRequest -Uri "https://huggingface.co/TheBloke/Luna-AI-Llama2-Uncensored-GGUF/resolve/main/luna-ai-llama2-uncensored.Q4_K_M.gguf" -OutFile "./models/luna-ai-llama2-uncensored.Q4_K_M.gguf"
if ($LASTEXITCODE -ne 0) { handle_error "Nie udało się pobrać luna-ai-llama2-uncensored model" }

Invoke-WebRequest -Uri "https://huggingface.co/ggerganov/whisper.cpp/blob/main/ggml-large-q5_0.bin" -OutFile "./models/whisper-large-q5.bin"
if ($LASTEXITCODE -ne 0) { handle_error "Nie udało się pobrać whisper-large-q5 model" }

docker-compose up -d --pull always
if ($LASTEXITCODE -ne 0) { handle_error "Nie udało się uruchomić docker-compose" }

Write-Output "Operacje zakończone pomyślnie!"
