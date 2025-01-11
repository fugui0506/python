from models import config

config_data = config.BuildConfig.from_json({})

print(config_data.target.name)