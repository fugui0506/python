class Config:
    def __init__(self, **kwargs):
        self.name: str = kwargs.get("name", "")
        self.flutter_name: str = kwargs.get("flutter_name", "")
        self.title: str = kwargs.get("title", "")
        self.package: str = kwargs.get("package", "")
        self.version: str = kwargs.get("version", "")
        self.team: str = kwargs.get("team", "")
        self.profile: str = kwargs.get("profile", "")
        self.signing: str = kwargs.get("signing", "")
        self.path: str = kwargs.get("path", "")
        self.shorebird_id: str = kwargs.get("shorebird_id", "")

    def to_json(self):
        return self.__dict__
    
class BuildConfig:
    def __init__(self, target: dict, project: dict):
        self.target = Config(**target)
        self.project = Config(**project)

    @staticmethod
    def from_json(json_data):
        return BuildConfig(json_data['target'], json_data['project'])

    def to_json(self):
        return {"target": self.target.to_json(), "project": self.project.to_json()}