#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "OrchestrPay"

# --- 1. Stop previous ---
echo ""
echo "🧹 Stopping containers..."
docker compose down --remove-orphans 2>/dev/null || true

# --- 2. Build and start everything ---
echo ""
echo "Starting services..."
docker compose up --build -d

# --- 3. Wait for payment-orchestrator ---
echo ""
echo "Waiting"
timeout=180
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if docker compose logs payment-orchestrator 2>/dev/null | grep -q "Started PaymentOrchestratorApplication"; then
        echo "✅ Payment Orchestrator is running!"
        break
    fi
    sleep 5
    elapsed=$((elapsed + 5))
    echo "   ...waiting ($elapsed/${timeout}s)"
done

if [ $elapsed -ge $timeout ]; then
    echo "⚠️  Orchestrator may still be starting."
fi

# --- 4. Show status ---
echo "  Services started"
