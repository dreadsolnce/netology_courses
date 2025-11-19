import sentry_sdk

sentry_sdk.init (
  dsn="https://6ab1af6883b6b2c718b4d7474827e708@o4510283871944704.ingest.us.sentry.io/4510283903205376",
  environment="development",
  release="1.0"
)

if __name__ == "__main__":
    division_zero = 1 / 0
