---
name: gibraltor-srs
description: 'Update or review Software Requirements Specification (SRS) documents for scope alignment, ownership boundaries, and requirement traceability. Use when revising in-scope/out-of-scope statements, subsystem interfaces, responsibility notes, open items, and revision history after project scope changes.'
argument-hint: 'Describe the SRS change request and affected scope items'
user-invocable: true
disable-model-invocation: false
---

# Gibraltar SRS Scope Update Workflow

## What This Skill Produces

This skill updates an SRS to reflect approved scope changes while keeping requirement intent consistent and auditable.

Expected outputs:
- Revised scope section (in scope, out of scope, ownership notes)
- Updated affected sections (system overview, interfaces, open items, assumptions where needed)
- Removal of obsolete subsystem references
- Revision history entry documenting the scope update
- A concise validation summary of what changed

## When to Use

Use this skill when:
- Scope ownership changes between internal team and external vendors
- A subsystem is removed from scope and all references must be cleaned up
- Integration responsibility changes (for example: robot-to-PLC signal exchange)
- You need an SRS update that is internally consistent and traceable

Trigger phrases:
- "Update SRS scope"
- "Move ABB programming to external vendor"
- "Remove subsystem from scope"
- "Align SRS with new ownership"
- "Revise open items and revision history"

## Procedure

1. Capture the change request.
- Extract explicit scope deltas (added scope, removed scope, unchanged scope).
- Extract ownership deltas (who programs, who integrates, who interfaces).
- Preserve exact nouns used by stakeholders where possible.

2. Locate scope-sensitive sections.
- Read sections typically impacted: Purpose, Scope, System Overview, Interface Requirements, Open Items, Revision History.
- Mark all references to removed or re-owned subsystems.

3. Apply primary scope edits.
- Update "In scope" list with currently included systems.
- Update "Out of scope" list with transferred responsibilities.
- Add a short responsibility note if ownership boundaries can be misunderstood.

4. Propagate downstream consistency edits.
- System Overview: remove obsolete subsystem lines and add new integration statements.
- Interface/Open Items: replace old owners and counterparties with current parties.
- Keep unaffected functional requirements unchanged unless directly contradicted.

5. Remove stale terminology.
- Search for legacy terms (removed subsystems, old vendors, deprecated activities).
- Replace or delete remaining references to avoid conflicting interpretation.

6. Record audit trail.
- Add a revision history row with date and concise description of scope deltas.
- Keep previous revisions intact.

7. Validate completion criteria.
- No remaining references to removed scope items.
- External vendor programming vs integrator responsibilities are explicit.
- Ignition scope statements remain consistent with intended unchanged scope.
- Open items and interface statements reference correct counterparties.
- Document reads coherently end-to-end after edits.

## Decision Points

- If ownership is ambiguous:
Add a dedicated "Responsibility note" section in Scope.

- If removed subsystems still affect KPI or alarm wording:
Keep metric intent, but adjust data-source wording to active interfaces only.

- If multiple sections conflict after edits:
Prioritize Scope section as source of truth, then harmonize downstream sections.

## Quality Checks

- Requirement integrity: No accidental changes to unaffected functional requirements.
- Terminology integrity: subsystem and vendor names are used consistently.
- Traceability integrity: revision history explicitly states what changed and why.
- Readability: updates are concise and unambiguous for FAT/SAT interpretation.

## Example Prompts

- /gibraltor-srs Update this SRS: ABB robot programming is external vendor; Bright IA owns ABB-PLC signal integration; remove sand blasting and loading/unloading from scope.
- /gibraltor-srs Review this SRS for scope consistency and list exact edits needed before FAT.
- /gibraltor-srs Apply scope deltas from latest SOW and update revision history.
