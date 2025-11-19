import sentry_sdk

sentry_sdk.init(
    dsn="https://8c0f4cc4ca3fe6a4cba0c94c3bfc6b03@o4510283871944704.ingest.us.sentry.io/4510283873517568",
    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/python/data-management/data-collected/ for more info
    send_default_pii=True,
)

division_by_zero = 1 / 0

