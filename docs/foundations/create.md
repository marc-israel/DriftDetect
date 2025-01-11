# Creating Your First TTP

To create a new TTP with DriftDetect, use the command shown below:

```bash
driftdetect create ttp path/to/ttp.yaml
```

Make sure that the path you choose is within an existing
[TTP repository](repositories.md), such as
[ForgeArmory](https://github.com/marc-israel/ForgeArmory), so that
DriftDetect will be able to find the supporting configuration files required to
execute your new TTP.

DriftDetect will create the specified file and populate it with a skeleton TTP YAML
configuration containing important metadata.

## Next Steps

Open your new YAML file in your favorite code editor and then check out our
guide to [Automating Attacker Actions with DriftDetect](actions.md) to start
building your TTP!
