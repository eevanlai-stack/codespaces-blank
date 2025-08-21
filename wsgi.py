from app import app as application

# Gunicorn entrypoint expects `application`
app = application
