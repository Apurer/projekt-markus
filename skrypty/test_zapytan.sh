#!/bin/bash

url="http://localhost:8080/v1/completions"
payload='{"model": "luna-llama2", "prompt": "def dodajLiczby(a, b) {"}'
total_requests=10
total_time=0

for i in $(seq 1 $total_requests); do
    response_time=$(curl -X POST -H "Content-Type: application/json" -d "$payload" -o /dev/null -s -w "%{time_total}" $url)
    total_time=$(echo $total_time + $response_time | bc)
    echo "Czas odpowiedzi dla żądania $i: $response_time sekundy"
done

average_time=$(echo "scale=4; $total_time / $total_requests" | bc)
echo "Średni czas odpowiedzi dla $total_requests żądań: $average_time sekundy"
