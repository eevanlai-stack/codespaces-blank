## Flask Payroll/HR Backend

Endpoints include GPS mock, EPF, PERKESO, PCB, clock-in, attendance, payroll, advance, profile, chat, translate.

### Prerequisites
- Python 3.11+

### Setup
```bash
python -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

### Run (development)
```bash
python app.py
```
Server: http://localhost:8000/healthz

### Run (production)
```bash
gunicorn -b 0.0.0.0:8000 wsgi:app --workers 2 --threads 4
```

### Docker
```bash
docker build -t payroll-backend .
docker run -p 8000:8000 payroll-backend
```

### Example requests
```bash
curl http://localhost:8000/gps
curl -X POST http://localhost:8000/epf -H 'Content-Type: application/json' -d '{"salary":5000}'
```
