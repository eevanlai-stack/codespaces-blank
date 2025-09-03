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

### Deploy to Fly.io (free tier)

1. Create app and set token
```bash
brew install flyctl # or see docs for your OS
flyctl auth signup || flyctl auth login
flyctl launch --no-deploy # choose existing Dockerfile, set app name
```

2. Configure secrets (as needed)
```bash
flyctl secrets set FLASK_ENV=production
# If using a database: flyctl secrets set DATABASE_URL=...
```

3. Deploy
```bash
flyctl deploy --remote-only
```

4. GitHub Actions (optional)
- Add `FLY_API_TOKEN` in your repo Settings → Secrets → Actions
- Push to `main`/`master` to trigger `.github/workflows/deploy.yml`

App will be reachable at the URL shown by:
```bash
flyctl status
flyctl open
```

### Example requests
```bash
curl http://localhost:8000/gps
curl -X POST http://localhost:8000/epf -H 'Content-Type: application/json' -d '{"salary":5000}'
```
