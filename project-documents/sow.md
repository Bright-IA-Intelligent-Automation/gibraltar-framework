# Scope of Work (SOW)

## Document Control

| Field | Value |
|---|---|
| Company | Bright IA - Intelligent Automation |
| Job Number | JOB#BR26ROB18 |
| Project Name | Border Wall Finishing System Automation |
| Prepared By | Davide Pascucci |
| Version | Rev.A |
| Document ID | BRT-SOW-26001-13 |
| Issue Date | 03/09/2026 |
| Due Date | 08/15/2026 |
| Department | Engineering and Operations |

## Contacts

| Role | Name | Phone | Email |
|---|---|---|---|
| Bright Project Contact | Davide Pascucci | +1 (786) 717-8182 | davidp@brightiatx.com |
| Client Contact | Steven Morrow (Main GC) | 210-421-5049 | smorrow@surfaceprep.com |

## Scope Statement Purpose

This document defines the realization and automation of the Border Wall Finishing System for Gibraltar, a government contractor located at 3200 TX-29, Burnet, TX 78611.

## Project Background and Objectives

Bright IA and partner contractors are tasked with transforming manual operations into an automated finishing system for US border wall coating. The complete system is composed of:

- Monorail conveyor system
- Manual and automated sand-blasting systems (installed in parallel)
- Fence accumulation system
- IR heating system
- Two robotic painting booths
- Load and unload stations

## Bright IA Project Scope

Bright IA is responsible for:

- Automating the painting/coating booth
- Providing a SCADA/dashboard console to oversee the entire system

## Performance Requirements

The coating system shall support:

- 165 panels per 11-hour shift
- Two shifts per day

The coating system shall be designed to support:

- Up to 200 panels per 11-hour shift

Additional requirements:

- Coating mil requirement: 10 mil
- System shall tolerate approximately 4 in variability in welded assembly
- Distance from booth floor to parts: 4 ft 6 in

## Panel Sizes and Weights

Border wall panel lengths (change order):

- 32 ft panels
- 33 ft panels
- 34 ft panels

All panels are 8 ft wide.

Actual size tolerances:

- 32 ft panel actual size: 32 ft 2 in +/- 1 in
- 33 ft panel actual size: 33 ft 2 in +/- 1 in
- 34 ft panel actual size: 34 ft 2 in +/- 1 in

Panel weights:

| Tube Thickness | 32 ft (lb) | 33 ft (lb) | 34 ft (lb) |
|---|---:|---:|---:|
| 3/16 in | 4,408 | 4,522 | 4,636 |
| 1/4 in | 5,450 | 5,600 | 5,750 |

## Engineering and Design Scope

- Electrical and mechanical design for controls and robot cells
- Controls architecture (PLC, HMI, network)
- Safety system design (guarding, interlocks, E-stops)

## Controls and Automation Scope

- PLC and HMI programming for coating operations
- Robot programming for coating
- Fault handling, diagnostics, and recovery logic
- SCADA and dashboarding system with database
- Integration of Gibraltar-furnished coating equipment

## Installation and Commissioning Scope

- Electrical and controls checkout
- FAT and SAT support for coating system
- Commissioning, ramp-up, and production release (buyoff)

## Timetable and Schedule

The detailed schedule and Gantt are maintained in Avaza CRM. Target completion date for this project is 08/15/2026.

## Business Environment and Communication Protocol

The contractor and client shall work in close coordination and make shared decisions as project changes arise. Prompt communication from both parties is required for project success.

Only the following are considered valid project communications:

- Official client or contractor documents
- Email communications

The following are not considered valid or relevant project communications:

- Text messages
- Phone calls
- Non-recorded meetings

Critical project documents (including this SOW) must be returned, dated, and signed by a client representative before project start.

In case of changes to the original scope, contractor and client/end user will jointly determine the best technical and economical solution.

## Contractor Liability and Deliverables

The contractor is responsible for providing:

- Work cell equipment (machines, devices, material, parts)
- Labor
- FAT test or demonstration
- Startup and commissioning
- SAT, training, and documentation
- Safety system
- Warranties

The provided solution shall follow current industry best practices and applicable codes, regulations, and standards, including:

- ANSI
- NEMA
- IEEE
- ASME
- UL
- OSHA
- NFPA
- ISO

## Evaluation Criteria

Evaluation criteria are defined by this Scope of Work.

## Administrative Items

IN WITNESS WHEREOF, the parties hereto have caused this agreement to be executed by their duly authorized representatives as of the agreement date first above written.

## Signatures

| Party | Name | Title | Signature | Date |
|---|---|---|---|---|
| Bright IA - Intelligent Automation |  |  |  |  |
| Client (Authorized Representative) |  |  |  |  |

## Appendix A - Technical Assessment Report

### Company Information

- Company: Bright IIoT, LLC DBA Bright IA - Intelligent Automation
- Headquarters: 12509 N. Saginaw Blvd. 338, Fort Worth, TX 76179
- Legal address: 11056 Rock Chapel Dr., Haslet, TX 76052
- Website: https://brightiatx.com
- Telephone: 786-717-8182
- Assessment date: 02/10/2026

### Report Title

Border Wall Panel Coating Process - Motion vs. Stationary

### Project Overview

- Panel size: 33 ft x 14 ft with 5 deg tilt
- Geometry: 10 HSS 6x6x1/4 bollards (8 standard plus 2 tall), 45 deg mitered caps
- Structure: Flat 11GA steel sheathing with structural angles
- Coating target: 11 mil polyurea
- Robot concept: 3 Fanuc P-250iB/15 robots per side (can also be handled by regular industrial robots)
- Robot lead time: 6 weeks expedited
- Robot cost: $140,000 each

### Premise and Assumptions

These assumptions are based on prior painting experience in general applications and with this specific coating product from Bright IA and Fanuc America.

This analysis does not include the effects of:

- Compressed air quality
- Gun quality and reliability
- Nozzle size

Polyurea behavior is considered materially different from regular coating systems and is treated as a key process constraint.

### Why Motion Painting Is Problematic

#### 1) Tilt and Material Behavior

- 11 mil polyurea on 5 deg tilted surfaces tends to sag/run before cure
- Robots cannot reliably compensate in real time if material flow changes
- High probability of runs, drips, and uneven film build
- Fast cure behavior makes this highly sensitive

#### 2) Complex Geometry

- 10 bollard caps with 45 deg miters require multi-angle spray paths
- 4 sides per bollard (40 faces total) are hard to fully reach while tracking motion
- Structural angles, inside corners, gaps, and edges require precision coverage
- In motion mode, each feature effectively receives one pass opportunity

#### 3) Weld Coverage

- Limited ability to dwell on welds for proper penetration
- Corrosion-critical points may receive inadequate coating
- Constant conveyor speed reduces adaptive process control

#### 4) System Complexity and Cost

- Tracking/synchronization systems estimated at +$100K to +$200K
- Three robots must track moving panels simultaneously
- Programming and commissioning complexity increases
- Additional failure points reduce system robustness

#### 5) Quality Control During Cell Setup

- Coverage cannot be fully validated until the panel exits the booth
- Defects are identified only after cure
- Root-cause attribution by robot is more difficult

### Cycle Time Reality Check

Note: Estimate based on data from prior Bright IA polyurea projects.

| Metric | Motion | Stationary |
|---|---|---|
| Coating time per panel | 30-45 sec | 45-60 sec |
| Estimated defect rate | 35-50% | <5% |
| Rework time per defect | 3-5 min | Minimal |
| Total time per 100 panels | 155-325 min | 85-110 min |
| Equipment cost premium | +$100K to +$200K | $0 |

Stationary is estimated to be 2x to 3x faster in total production when rework is included and avoids the added tracking-system capital premium.

### Stationary Coating Advantages

- Better quality:
Bottom-to-top application can work with gravity, and robot paths can be optimized for tilt/twist compensation.
- Complete coverage:
Each robot can own an 11 ft zone and approach bollards/angles/edges from more effective fixed positions.
- Lower cost:
No tracking systems, simpler position-based programming, easier commissioning, and reduced waste.
- Better reliability:
Expected defect rates below 5%, easier troubleshooting, predictable throughput, and minimal rework.
- Faster total throughput:
45-60 sec coating with minimal rework vs. 30-45 sec coating with extensive rework.

### Key Risk Comparison

| Risk Factor | Motion | Stationary |
|---|---|---|
| Runs/sags on tilted surfaces | High risk | Low risk |
| Bollard cap coverage | High risk | Low risk |
| Weld penetration | Medium-high risk | Low risk |
| Overall defect rate | 35-50% | <5% |

### Bottom Line

For this application (5 deg tilt, complex geometry, and 11 mil polyurea), stationary coating is the recommended method based on quality, cost, and throughput.

- 2x to 3x faster total throughput when rework is included
- $100K to $200K lower equipment cost
- <5% defect rate vs. 35-50% for motion concept
- Better quality and reliability under project constraints

Estimated speed gains from motion painting (about 15-20 sec/panel) are outweighed by rework burden and defect-related downtime.

### Recommendation

Proceed with stationary coating using three-robot zone coverage (11 ft zones).

Given the aggressive project timeline and low margin for error, this approach is expected to provide the most reliable, efficient, and durable production result.

## Appendix B - Preliminary Interface Information Needed (03/04/2026)

This appendix tracks open technical interface items, owners, and current known answers.

| # | Interface Item | Owner | Current Status / Notes |
|---|---|---|---|
| 1 | Measure levels of the two polyurea components (totes vs. buffer tanks) | Gibraltar | Open |
| 2 | Control diaphragm pumps for transfer into reactors | Gibraltar | Open |
| 3 | Temperature/humidity sensors in kitchens (wall-mount type and signal type) | Gibraltar | Client will provide sensors; signal interface still needs confirmation (for example, 4-20 mA). |
| 4 | Painting reactors communication details for 6 reactors (preferred EtherNet/IP), plus brand/model/manuals/schematics | Gibraltar | Open |
| 5 | Spray guns: 3D models, automatic greasing actuation, wetting solution and storage/refill concept | Gibraltar | Open |
| 6 | Method to stop border walls at the two painting booths (initial concept pneumatic) | Rohner | Open |
| 7 | Central control station interface/handshake definition and signal list with graphics/tags | Multi-party | Interface list identified; detailed I/O and tag list still required. Allen-Bradley PLC platform confirmed. |
| 8 | Number and details of doors to secure/lock (planning total of 6) | Rohner | Door details received. |
| 9 | Additional border wall shapes/models to support (for example 35 ft slope and shorter version) | Gibraltar | Open |
| 10 | Height of panels from floor (defines riser height) | Gibson / Rohner | Answered: bottom of part is 4 ft 6 in above floor. |
| 11 | Planned process options and selection method (recipe, part number, job number, etc.) | Bright IA | Answered: use one job number with offsets and send to each robot. |
| 12 | How PLC determines part arrival at painting station | Rohner / Bright IA | Answered: combination approach (sensors/signals). Final signal map still required. |
| 13 | Conveyor/monorail control responsibility at painting station | Rohner | Answered: PLC does not control conveyor at station. |
| 14 | Need for part clamping/mechanical locking during painting | Rohner | Answered: no clamping required. |
| 15 | System-ready conditions required before paint cycle start (safety, I/O, robots, paint system, part present) | Gibraltar | Partially defined; required final signal list pending. |
| 16 | Paint system ready signals and communication method (temperature, humidity, level, pressure, ready, job loaded) | Gibraltar | In progress with Graco; final signal list pending. |
| 17 | Part removal sequence and required handshake signals after job complete | Rohner / Bright IA | Answered baseline: send "Job Complete / Station Clear" to conveyor system; full sequence detail pending confirmation. |

### Central Control Station Interfaces (Current)

- Painting booth control system: Bright IA
- Monorail conveyor system: Rohner
- Sandblasting unit: Gibson
- Loading and unloading: Rohner (manual at current stage)

### Priority Follow-Up Package (Recommended)

For commissioning readiness, request the following from each owner:

- Complete signal list (digital, analog, network tags) with data types and normal states
- Handshake sequence diagrams for start, run, fault, and release states
- Communication protocols and addressing standards (including EtherNet/IP assemblies where applicable)
- Equipment documentation (manuals, wiring diagrams, and communication maps)
- Mechanical interface constraints impacting control logic (stops, clearances, and safety interlocks)

---

End of Scope Statement
