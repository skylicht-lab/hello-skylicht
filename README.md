# hello-skylicht

This is an example project for integrating [Skylicht Engine](https://github.com/skylicht-lab/skylicht-engine) into another project.

[![Build status](https://github.com/skylicht-lab/hello-skylicht/workflows/build/badge.svg)](https://github.com/skylicht-lab/hello-skylicht/actions?workflow=build)

## How build

### Step 1
You need to clone and build Skylich Engine first.
```Shell
C:\>git clone https://github.com/skylicht-lab/skylicht-engine.git
```

And build the engine

```Shell
C:\skylicht-engine>cmake -S . -B ./PrjVisualStudio -G "Visual Studio 17 2022" -A x64 -DINSTALL_LIBS=ON
C:\skylicht-engine>cmake --build ./PrjVisualStudio --target install --config Release
```

### Step 2

Clone this project

```Shell
C:\>git clone https://github.com/skylicht-lab/hello-skylicht.git
```

Copy 2 folders (cmake and include) from folder build result C:\skylicht-engine\InstallLibs to this project

```Shell
C:\hello-skylicht>md InstallLibs
C:\hello-skylicht>xcopy C:\skylicht-engine\InstallLibs\cmake InstallLibs /E
C:\hello-skylicht>xcopy C:\skylicht-engine\InstallLibs\include InstallLibs /E
```
### Step 3

Build project

```Shell
C:\hello-skylicht>cmake -S . -B ./PrjVisualStudio -G "Visual Studio 17 2022" -A x64
C:\hello-skylicht>cmake --build ./PrjVisualStudio --config %BUILD_TYPE%
```

You can see the Github workflow for more details