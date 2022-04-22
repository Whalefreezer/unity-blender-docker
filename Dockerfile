FROM unityci/editor:2019.4.37f1-android-1.0

RUN apt-get update && apt-get install blender -y && rm -rf /var/lib/apt/lists/*
