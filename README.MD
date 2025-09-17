# Intro

In order to minimize code duplication and ensure that code changes are replicated across all environments the code is structured as follows (not everything is shown):

-> indicates a symbolic link

```
├── README.MD
├── development
│   ├── main.tf -> ../main.tf
│   ├── terraform.tfvars
│   └── variables.tf -> ../variables.tf
├── testing
│   ├── main.tf -> ../main.tf
│   ├── terraform.tfvars
│   └── variables.tf -> ../variables.tf
├── main.tf
└── variables.tf
```

In short, you can modify main in any environment and the changes will be in all other environments as you are effectively writing only to source of the symlink, e.g. main.tf in the root directory of the repo.

Note that this will not work in Windows **unless** you enable symlinks in the OS and git, see [below](#enable-symlinks-in-windows) for details on how to do this.

There are other ways of minimizing code duplication that are perhaps more common, e.g. terragrunt, workspaces, modules, etc.

In Linux, and I'm writing this from WSL, symbolic links work out of the box and avoid the extra overhead of terragrunt, are more transparent than workspaces and are easier to maintain than using a sort of environment module to wrap everything.


# Pre-Requisites

- terraform (>=1.0)
- Linux 

As mentioned in the intro, this can be made to work with Windows by enabling symlinks in Windows and Git but using WSL is the easier choice if using Windows.

# Design Choices

There are some compromises made given the nature of the task, namely an exercise, e.g. mostly everything is a in single file or using local state, these are deemed as acceptable compromises.

## Structure

I have assumed that the storage accounts form part of a single deployment per environment and that they are used to enforce better data separation over say, each client getting a directory in a storage account, thus there is a single resource group per environment that holds all resources.

## Locals vs variables

I have used a clients local variable rather than a variable.  This has some pros and cons.

The main pro is that it allows very DRY code, write it once and it magically applies to all environments. Furthermore, if there are differences in the environments, locals allow the use of dynamic expressions so can use different values depending on the environment for instance, there are limits to this where the variability is too much to try to capture it with dynamic expressions.

The main con is that you lose variable validation, which forces it down on the stack, e.g. the resources, in this case I feel this is a reasonable compromise.

## Storage Account Settings

There are a myriad settings that could be modified, I have chosen to use a very standard definition, which given the nature of the exercise it seems appropriate.

Storage accounts are globally unique thus it is not possible to guarantee particular naming pattern, which is why I've added an id property to allow uniqueness. For the purposes of this exercise this is just a field but it could be a random value.

# Enable Symlinks in Windows

##  Enable Developer Mode
Start a cmd prompt/terminal as an administrator
Run: ```REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"```
Run: ```DISM /Online /Add-Capability /CapabilityName:Tools.DeveloperMode.Core~~~~0.0.1.0```
Profit!!!
## Enable Symbolic links in Git
If you want to set this globally, run ```git config --global core.symlinks true```
If, on the other hand, you just want to do it locally for the relevant repository then you need to run this: ```git config core.symlinks true```

Note that if you DO NOT set this globally you will need to run the local command in every repository that uses symbolic links.
