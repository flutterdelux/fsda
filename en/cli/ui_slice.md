# UI Slice

## Command Usage

Generate only UI template:

```bash
fsda gen-ui <slice> -f <feature> -m <module> -u <ui_code>
```

Generate sequence and UI in one command:

```bash
fsda gen-slice <slice> -f <feature> -m <module> -s <sequence_code> -u <ui_code>
```

Multi UI template in one gen-slice run:

```bash
fsda gen-slice <slice> -f <feature> -m <module> -s <sequence_code> -u pmi,dialog
```

## Supported UI Codes

| code | Type | Description |
|------|------|-------------|
| lsv | list vertical | ListView vertical for parent body |
| lsh | list horizontal | ListView horizontal as section |
| pag | list vertical pagination | ListView vertical with pagination for parent body |
| detail | detail view | Detail view for a specific item for parent body |
| sec | section | Basic section for grouping content |
| pmi | popup menu item | Popup menu item for item actions |
| dialog | dialog | Dialog for confirming an action on a specific item |
| form | form | Form for creating or editing an item |

## Manifest Behavior

Each UI brick provides `ui.yaml` with:

- `arb`: ARB JSON fragment to be injected into all module `.arb` files (idempotent)
- `export.ui`: export statements injected into feature barrel `// ui` section

Sequence manifest (`sequence.yaml`) no longer owns ARB injection.

## Output Convention

UI files are generated under feature UI boundary:

- `modules/<module>/lib/src/features/<feature>/ui/<slice>/...`
- shared widgets (if any): `modules/<module>/lib/src/features/<feature>/ui/shared/...`

After slice/UI generation, compose to app wrapper page with command type that matches the slice intent:

```bash
fsda compose-main <slice> -f <feature> -m <module> -a <app> -p <target_page>
fsda compose-form <slice> -f <feature> -m <module> -a <app> -p <target_page>
fsda compose-pag <slice> -f <feature> -m <module> -a <app> -p <target_page>
fsda compose-pmi <slice> -f <feature> -m <module> -a <app> -p <target_page>
fsda compose-sec <slice> -f <feature> -m <module> -a <app> -p <target_page>
```

Recommended mapping:

- retrieval/detail/list style: `compose-main`
- form mutation flow with form cubit: `compose-form`
- pagination retrieval: `compose-pag`
- popup menu action injection: `compose-pmi`
- section compose (provider auto-bootstrap + generated section method, placement remains manual): `compose-sec`