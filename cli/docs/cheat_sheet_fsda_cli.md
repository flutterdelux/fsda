# Cheat Sheet FSDA CLI


## create

Create a new workspace

```bash
fsda init <workspace_name>
```

&nbsp;

## init

Initialize packages and infra packages in the current workspace

```bash
fsda init
```

&nbsp;

## list

### 1. packages

View all template packages except infra packages

```bash
fsda list packages
```

### 2. infra

View all template infra packages

```bash
fsda list infra
```

&nbsp;

## add

### 1. package

Add a template package to the current workspace

```bash
fsda add package <package_name>
```

### 2. infra

Add a template infra package

```bash
fsda add package infra_<infra_name>
```

or 

```bash
fsda add infra infra_<infra_name>
```

or 

```bash
fsda add infra <infra_name>
```

&nbsp;

## gen

### 1. app

Generate a new app

```bash
fsda gen app --app <app_name>
```

or 

```bash
fsda gen a -a <app_name>
```


### 2. module

Generate a new module

```bash
fsda gen module --module <module_name>
```

or 

```bash
fsda gen m -m <module_name>
```

### 3. feature

Generate a new feature to the specified module

```bash
fsda gen feature --module <module_name> --feature <feature_name>
```

or 

```bash
fsda gen f -m <module_name> -f <feature_name>
```

### 4. slice

not implemented yet

expected usage:

```bash
fsda gen slice --module <module_name> --feature <feature_name> --slice <slice_name> --sequence <sequence_code> --method <method_name>
```

or 

```bash
fsda gen s -m <module_name> -f <feature_name> -s <slice_name> -c <sequence_code> -d <method_name>
```

&nbsp;

## reg

not implemented yet

expected usage:

### 1. module

```bash
fsda reg module --module <module_name> --app <app_name>
```

or 

```bash
fsda reg m -m <module_name> -a <app_name>
```

### 2. slice

```bash
fsda reg slice --app <app_name> --module <module_name> --feature <feature_name> --slice <slice_name> --sequence <sequence_code> --method <method_name>
```

or 

```bash
fsda reg s -a <app_name> -m <module_name> -f <feature_name> -s <slice_name> -c <sequence_code> -d <method_name>
```