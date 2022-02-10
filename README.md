# Features
- Easily and quickly switch between factorio mods without copy pasting.
- Uses Windows folder junctions to switch between the folders.

# Requirements
- PowerShell 5.1 or higher

# Quick Start
1. Back up your Factorio folder just to be sure
2. Check out the repo
3. Copy the ps1 file to somewhere you want all your current mods to be stored and managed.
4. Run the ps1 file, specifying a mod name you want for the current mods:
    ```Powershell
    $ > factorio_mod_manager.ps1 -Mod my_modpack_name
    ```
5. `mods`, `saves`, and `scenarios` in AppData\Factorio will be moved into a newly created subfolder `modpacks` created next to the script. These folders will be created as the mod name that was specified to the script.

    For example:
        
        ```Powershell
        $ > factorio_mod_manager.ps1 -Mod my_modpack_name
        ```
    * Creates the following:
        
        ```
        - modpacks\
        - my_modpack_name\
            - mods\
            - my_mod
            - saves\
            - scenarios\
        ```
    * A junction will be created pointing to these folders inside `AppData\Factorio` which the game loads from.